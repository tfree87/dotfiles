!/bin/sh
# Install Adobe Digital Editions using WINE

export WINEPREFIX="~/.wine32"

WINEARCH=win32
winecfg
winetricks -q adobe_diged4
