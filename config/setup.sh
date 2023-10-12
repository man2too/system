echo "installing packages..."
#installing needed packages
sudo pacman -Syu firefox neofetch kitty polybar rofi pulsemixer bashtop emacs discord steam unzip unrar man feh
nvidia-utils nvidia-settings linux-headers linux-zen-headers usbimager gparted libreoffice mypaint picom wine-staging ffmpeg gcc clang cmake mesa mesa-utils nemo

#rcreating aliases
alias --save cpi="ssh pi@192.168.178.59"
alias --save log="vim ~/files/log.md"
alias --save vs="vsodium"
alias --save xmap="setxkbmap -option caps:ctrl_modifier"

#creating private directory and files
mkdir -p ~/pictures/wallpaper
mkdir ~/pictures/sch
mkdir ~/files
touch ~/files/log.md

#creating config directorys
mkdir -p ~/.config/kitty
mkdir -p ~/.config/picom
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/.emacs.d

#moving config files
mv ~/system/config/main.png ~/pictures/wallpaper
mv ~/system/config/kitty.conf ~/.config/kitty/
mv ~/system/config/init.el ~/.emacs.d/
mv ~/system/config/picom.conf ~/.config/
mv ~/system/config/launch.sh ~/.config/polybar/
mv ~/system/config/config.ini ~/.config/polybar/
mv ~/system/config/config.rasi ~/.config/rofi/
sudo mv ~/system/config/bspwmrc ~/.config/bspwm/
sudo mv ~/system/config/sxhkdrc ~/.config/sxhkd/
