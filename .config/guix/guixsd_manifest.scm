;; This "manifest" file can be passed to 'guix package -m' to reproduce
;; the content of your profile.  This is "symbolic": it only specifies
;; package names.  To reproduce the exact same profile, you also need to
;; capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(specifications->manifest
 (list

;; Software Development

"geany"
"git"
"glade"
"gnome-builder"
"go"
"python"
"python-black"

;; Docker

"containerd"
"docker"
"docker-cli"

;; Email

"gnupg"
"icedove"
"isync"
"pinentry"

;; Emacs 

"emacs-all-the-icons"
"emacs-all-the-icons-completion"
"emacs-all-the-icons-dired"
"emacs-all-the-icons-ibuffer"
"emacs-benchmark-init"
"emacs-guix"
"emacs-org-roam"
"emacs-pdf-tools"
"emacs-pgtk-native-comp"
"emacs-vterm"
"mu"

;; EXWM

"brightnessctl"
"alsa-utils"
"emacs-desktop-environment"
"numlockx"
"pasystray"
"scrot"
"slock"
"wmctrl"
"xsettingsd"

;; Finance

"ledger"
"gnucash"
"speedcrunch"

;; Fonts

"font-adobe-source-code-pro"
"font-adobe-source-serif-pro"
"font-adobe-source-serif-pro"
"font-awesome"
"font-bitstream-vera"
"font-blackfoundry-inria"
"font-borg-sans-mono"
"font-comic-neue"
"font-cormorant"
"font-dejavu"
"font-dosis"
"font-fantasque-sans"
"font-fira-code"
"font-fira-mono"
"font-fira-sans"
"font-go"
"font-google-roboto"
"font-juliamono"
"font-lato"
"font-liberation"
"font-liberation"
"font-libertinus"
"font-linuxlibertine"
"font-mononoki"
"font-montserrat"

;; Fun

"stellarium"

;; Gnome

"gnome-tweaks"
"pavucontrol"
"gnome-shell-extensions"
"gnome-shell-extension-topicons-redux"
"gnome-shell-extension-burn-my-windows"
"gnome-shell-extension-dash-to-panel"
"gnome-shell-extension-gsconnect"
"gnome-shell-extension-just-perfection"

;; Images and Image Editing

"flameshot"
"gimp"
"inkscape"

;; Media

"audacity"
"beets"
"calibre"
"handbrake"
"mplayer"
"mpv"
"obs"
"openshot"
"picard"
"vlc"
"youtube-dl"

;; Office/Publishing/Writing

"biber"
"evince"
"gnuplot"
"libreoffice"
"pandoc"
"pdfarranger"
"plantuml"
"scribus"
"texlive"
"xournalpp"

;; Other

"gramps"
"python-qrcode"
"barcode"

;; Spell Checking

"hunspell"
"hunspell-dict-en-us"

;; System Tools/Utilities

"baobab"
"clamav"
"curl"
"dbxfs"
"filezilla"
"fish"
"flatpak"
"gparted"
"gpick"
"htop"
"lshw"
"openssh"
"rclone"
"transmission"
"trash-cli"
"unzip"

;; Web Browsing

"firefox"
"nyxt"
"ungoogled-chromium"

;; WINE

"wine"
"winetricks"

))
