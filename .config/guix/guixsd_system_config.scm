(use-modules (gnu)
             (nongnu packages linux))

(use-service-modules cups
                     desktop
                     docker
                     mcron
                     networking
                     ssh
                     xorg)

(use-package-modules base
                     bash
                     shells)

;; mcron job definitions

(define garbage-collector-job
  ;; Collect garbage 5 minutes after midnight every day.
  ;; Ensure that 10GB is available on disk (-F 10G)
  ;; Remove any generations older than 6 months (-d 6m)
  #~(job "5 0 * * *"            ;Vixie cron syntax
         "guix gc -d 6m -F 10G"))

(define updatedb-job
  ;; Run 'updatedb' at 3AM every day.
  #~(job '(next-hour '(3))
         (lambda ()
           (execl (string-append #$findutils "/bin/updatedb")
                  "updatedb"
                  "--prunepaths=/tmp /var/tmp /gnu/store"))))

;; Declare operating system

(operating-system
 (kernel linux)
 (firmware (list linux-firmware))
 (locale "en_US.utf8")
 (timezone "America/Indiana/Indianapolis")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "guixsd")
 (users (cons* (user-account
                (name "thomas")
                (comment "Thomas Freeman")
                (group "users")
                (home-directory "/home/thomas")
                (shell (file-append fish "/bin/fish"))
                (supplementary-groups '("audio"
                                        "cdrom"
                                        "docker"
                                        "lp"
                                        "netdev"
                                        "video"
                                        "wheel")))
               (user-account
                (name "monique")
                (comment "Monique Freeman")
                (group "users")
                (home-directory "/home/monique")
                (shell (file-append fish "/bin/fish"))
                (supplementary-groups '("audio"
                                        "cdrom"
                                        "lp"
                                        "netdev"
                                        "video")))
               %base-user-accounts))
 (packages
  (append
   (list (specification->package "emacs-pgtk-native-comp")
         (specification->package "emacs-exwm")
         (specification->package
          "emacs-desktop-environment")
         (specification->package "nss-certs"))
   %base-packages))
 (services
  (append
   (list (cons
          (simple-service 'my-cron-jobs
                          mcron-service-type
                          (list garbage-collector-job
                                updatedb-job))
          %base-services)
         (service docker-service-type)
         (service gnome-desktop-service-type)
         (service gnome-keyring-service-type)
         (service cups-service-type)
         (set-xorg-configuration
          (xorg-configuration
           (keyboard-layout keyboard-layout))))
   %desktop-services))
 (bootloader
  (bootloader-configuration
   (bootloader grub-efi-bootloader)
   (targets (list "/boot/efi"))
   (keyboard-layout keyboard-layout)))
 (mapped-devices
  (list (mapped-device
         (source
          (uuid "0268e314-a1b5-417c-b5ea-b1e58715b8d9"))
         (target "cryptroot")
         (type luks-device-mapping))))
 (file-systems
  (cons* (file-system
          (mount-point "/")
          (device "/dev/mapper/cryptroot")
          (type "ext4")
          (dependencies mapped-devices))
         (file-system
          (mount-point "/boot/efi")
          (device (uuid "0ECB-F24F" 'fat32))
          (type "vfat"))
         %base-file-systems))
 (swap-devices
  (list
   (swap-space
    (target "/swapfile")
    (dependencies (filter (file-system-mount-point-predicate "/")
                          file-systems))))))
