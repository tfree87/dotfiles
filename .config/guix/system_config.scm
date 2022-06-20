(use-modules (gnu) (nongnu packages linux))

(use-service-modules
 cups
 desktop
 networking
 ssh
 xorg)
(use-package-modules bash shells)

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
                (supplementary-groups
                 '("wheel" "netdev" "audio" "video" "cdrom")))
               (user-account
                (name "monique")
                (comment "Monique Freeman")
                (group "users")
                (home-directory "/home/monique")
                (shell (file-append fish "/bin/fish"))
                (supplementary-groups
                 '("netdev" "audio" "video" "cdrom")))
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
   (list (service gnome-desktop-service-type)
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
