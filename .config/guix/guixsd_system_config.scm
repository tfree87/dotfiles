(use-modules (gnu)
             (gnu services mcron)
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
  ;; Collect garbage at noon every Saturday.
  ;; Ensure that 10GB is available on disk (-F 10G)
  ;; Remove any generations older than 6 months (-d 6m)
  #~(job "0 12 * * 6"
         "guix gc -d 6m -F 10G"))

(define updatedb-job
  ;; Run 'updatedb' 15 minutes past the hour every 3 hours
  #~(job "15 */3 * * *"
         "updatedb --prunepaths=/tmp /var/tmp /gnu/store"))

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
   (map specification->package
        '("emacs-pgtk-native-comp"
          "emacs-exwm"
          "emacs-desktop-environment"
          "nss-certs"

          ;; Utilities
          
          "trash-cli"
          "htop"
          "stow"
          "unzip"

          ;; Fonts
          
          "font-adobe-source-code-pro"
          "font-adobe-source-han-sans"
          "font-adobe-source-sans-pro"
          "font-adobe-source-serif-pro"
          "font-adobe100dpi"
          "font-adobe75dpi"
          "font-anonymous-pro"
          "font-anonymous-pro-minus"
          "font-awesome"
          "font-bitstream-vera"
          "font-blackfoundry-inria"
          "font-cns11643"
          "font-cns11643-swjz"
          "font-comic-neue"
          "font-culmus"
          "font-dec-misc"
          "font-dejavu"
          "font-dosis"
          "font-dseg"
          "font-fantasque-sans"
          "font-fira-code"
          "font-fira-mono"
          "font-fira-sans"
          "font-fontna-yasashisa-antique"
          "font-gnu-freefont"
          "font-gnu-unifont"
          "font-go"
          "font-google-material-design-icons"
          "font-google-noto"
          "font-google-roboto"
          "font-hack"
          "font-hermit"
          "font-ibm-plex"
          "font-inconsolata"
          "font-iosevka"
          "font-iosevka-aile"
          "font-iosevka-etoile"
          "font-iosevka-slab"
          "font-iosevka-term"
          "font-iosevka-term-slab"
          "font-ipa-mj-mincho"
          "font-isas-misc"
          "font-jetbrains-mono"
          "font-lato"
          "font-liberation"
          "font-linuxlibertine"
          "font-lohit"
          "font-meera-inimai"
          "font-micro-misc"
          "font-misc-cyrillic"
          "font-misc-ethiopic"
          "font-misc-misc"
          "font-mononoki"
          "font-mplus-testflight"
          "font-mutt-misc"
          "font-public-sans"
          "font-rachana"
          "font-sarasa-gothic"
          "font-schumacher-misc"
          "font-sil-andika"
          "font-sil-charis"
          "font-sil-gentium"
          "font-sony-misc"
          "font-sun-misc"
          "font-tamzen"
          "font-terminus"
          "font-tex-gyre"
          "font-un"
          "font-util"
          "font-vazir"
          "font-wqy-microhei"
          "font-wqy-zenhei"
          "font-xfree86-type1"
          ))
   %base-packages))
 (services
  (append
   (list (service
          mcron-service-type
          (mcron-configuration
           (jobs
            (list garbage-collector-job))))
         (service docker-service-type)
         (service gnome-desktop-service-type)
         (service gnome-keyring-service-type)
         (service cups-service-type)
         (service
          openssh-service-type
          (openssh-configuration
           (x11-forwarding? #t)
           (permit-root-login #f)))
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
