#!/bin/bash

############################################################################################################################################

# Fedora i3-gaps installer sysoply.pl Paweł Pietryszak 2021

############################################################################################################################################

# Echo colors
magenta=`tput setaf 5`
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`

# Sudo timeout
echo "${green}${bold}SETTING SUDO TIMEOUT FOR 60 MINUTES FOR THE INSTALLATION PURPOSES${reset}"
sudo bash -c 'echo "
Defaults        env_reset,timestamp_timeout=60" >>  /etc/sudoers'

# Polish time locale
echo "${green}${bold}SETTING POLISH TIME AND DATE FORMAT${reset}"
sudo bash -c 'echo "
LC_NUMERIC=pl_PL.UTF-8
LC_TIME=pl_PL.UTF-8
LC_MONETARY=pl_PL.UTF-8
LC_PAPER=pl_PL.UTF-8
LC_MEASUREMENT=pl_PL.UTF-8" >> /etc/locale.conf'

# DNF settings
echo "${green}${bold}SETTING DNF FOR FASTER DOWNLOAD PACKETS${reset}"
sudo bash -c 'echo "fastestmirror=True
deltarpm=True
max_parallel_downloads=10
defaultyes=True" >> /etc/dnf/dnf.conf'
sudo sed -i 's/installonly_limit=3/installonly_limit=2/g' /etc/dnf/dnf.conf

# Update system
echo "${green}${bold}UPDATE SYSTEM. IT'S TAKE TIME. PLEASE WAIT!${reset}"
sudo dnf -y upgrade 

# RPM Fusion - extra repo for apps not provided by Fedora or RH free and nonfree
echo "${green}${bold}ADDING RPM FUSION REPOSITORIUM FOR APPS NOT PROVIDED BY FEDORA${reset}"
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 

# Add RPM Fusion to Gnome Software
echo "${green}${bold}ADDING RPM FUSION REPOSITORIUM TO SOFTWARE SHOP${reset}"
sudo dnf groupupdate -y core 

# Add multimedia codecs
echo "${green}${bold}ADDING MULTIMEDIA CODECS${reset}"
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin 
sudo dnf groupupdate -y  sound-and-video 

# Audio and Video plugins
echo "${green}${bold}ADDING AUDIO AND VIDEO PLUGINS${reset}"
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel 
sudo dnf install -y lame\* --exclude=lame-devel 
sudo dnf group upgrade -y --with-optional Multimedia 

# DVD codecs
echo "${green}${bold}ADDING DVD CODECS${reset}"
sudo dnf install -y rpmfusion-free-release-tainted 
sudo dnf install -y libdvdcss 

# Nonfree firmawre 
echo "${green}${bold}ADDING NONFREE FIRMWARE${reset}"
sudo dnf install -y rpmfusion-nonfree-release-tainted 
sudo dnf install -y \*-firmware 

# Intel multimedia codecs
echo "${green}${bold}ADDING INTEL VIDEO ACCELERATION API${reset}"
sudo dnf install -y intel-media-driver 
sudo dnf install -y libva-intel-driver 

# Codecs 
echo "${green}${bold}ADDING FFMPEG CODECS${reset}"
sudo dnf install -y ffmpeg 

# Mpv
echo "${green}${bold}INSTALLING MPV. VIDEO APP${reset}"
sudo dnf install -y mpv 

# Neovim
echo "${green}${bold}INSTALLING NEOVIM${reset}"
sudo dnf install -y neovim python3-neovim 
sudo bash -c 'echo "EDITOR=nvim" >> /etc/environment'

# Nodejs for neovim plugins
echo "${green}${bold}INSTALLING NODEJS FOR VIM PLUGINS${reset}"
sudo dnf install -y nodejs 

# Vim-plug
echo "${green}${bold}INSTALLING VIM-PLUG. VIM PLUGINS INSTALLER${reset}"
sh -c 'curl -sSfLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 

# Bat - new cat ;)
echo "${green}${bold}INSTALLING BAT. BETTER CAT COMMAND${reset}"
sudo dnf install -y bat 

# Ripgrep
echo "${green}${bold}INSTALLING RIPGREP. NEW REPLECMENT FOR GREP${reset}"
sudo dnf install -y ripgrep 

# Most = man pager
echo "${green}${bold}INSTALLING MOST. BETTER MAN HIGHLIGHTING${reset}"
sudo dnf install -y most 

# Neofetch
echo "${green}${bold}INSTALLING NEOFETCH. SYSTEM INFO IN TERMINAL ${reset}"
sudo dnf install -y neofetch 

# Htop
echo "${green}${bold}INSTALLING HTOP. BETTER TOP COMMAND${reset}"
sudo dnf install -y htop 

# Bpytop
echo "${green}${bold}INSTALLING BTOP. TOP WITH MOUSE SUPPORT${reset}"
sudo dnf install -y bpytop 

# Nnn
echo "${green}${bold}INSTALLING NNN. FILE MANAGER IN TERMINAL${reset}"
sudo dnf install -y nnn 

# Thunderbird
echo "${green}${bold}INSTALLING THUNDERBIRD. MAIL CLIENT${reset}"
sudo dnf install -y thunderbird 

# Gimp
echo "${green}${bold}INSTALLING GIMP. GRAPHICS APP${reset}"
sudo dnf install -y gimp 

# Flameshot
echo "${green}${bold}INSTALLING FLAMESHOT. SCREENSHOTS APP${reset}"
sudo dnf install -y flameshot 
mkdir ~/Pictures/screenshots

# Libreoffice
echo "${green}${bold}INSTALLING LIBREOFFICE${reset}"
sudo dnf install -y libreoffice

# ClamAV
echo "${green}${bold}INSTALLING CLAMAV. BEST LINUX ANTIVIRUS${reset}"
sudo dnf install -y clamav clamd clamav-update clamtk 
sudo setsebool -P antivirus_can_scan_system 1
sudo systemctl stop clamav-freshclam
sudo freshclam 
sudo freshclam 
sudo systemctl start clamav-freshclam 
sudo systemctl enable clamav-freshclam 

# Firewalld GUI
echo "${green}${bold}INSTALLING FIREWALL GUI${reset}"
sudo dnf install -y firewall-config 

# Timeshift
echo "${green}${bold}INSTALLING TIMESHIFT. BACKUP TOOL${reset}"
sudo dnf install -y timeshift 

# Terminator - terminal for vm
echo "${green}${bold}INSTALLING TERMINATOR. TERMINAL FOR VIRTUALMASHINE${reset}"
sudo dnf install -y terminator 

# Kitty - terminal for pc
echo "${green}${bold}INSTALLING KITTY. TERMINAL FOR PC${reset}"
sudo dnf install -y kitty 

# Transsmision
echo "${green}${bold}INSTALLING TRANSMISSION. TORRENT APP${reset}"
sudo dnf install -y transmission 

# Redshift
echo "${green}${bold}INSTALLING REDSHIFT. ADJUST THE COLOR TEMPERATURE OF SCREEN${reset}"
sudo dnf install -y redshift-gtk 

# Kernel headers
echo "${green}${bold}INSTALLING KERNEL HEADERS. IT'S TAKE A TIME. PLEASE WAIT!${reset}"
sudo dnf install -y "kernel-devel-$(uname -r)" 
sudo dnf install -y dkms 

# Virtualbox
echo "${green}${bold}INSTALLING VIRTUALBOX${reset}"
sudo dnf install -y VirtualBox akmod-VirtualBox 
sudo akmods 
sudo systemctl restart vboxdrv  
lsmod  | grep -i vbox 
sudo usermod -a -G vboxusers $USER   
sudo modprobe vboxdrv

# Virtualbox extensions pack
echo "${green}${bold}INSTALLING VIRTUALBOX EXTENSION PACK${reset}"
cd ~/.gc
mkdir -p VirtualBox
cd VirtualBox
LatestVirtualBoxVersion=$(wget -qO - https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT) && wget "https://download.virtualbox.org/virtualbox/${LatestVirtualBoxVersion}/Oracle_VM_VirtualBox_Extension_Pack-${LatestVirtualBoxVersion}.vbox-extpack" &&
yes | sudo VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${LatestVirtualBoxVersion}.vbox-extpack &&
cd

# Virtualbox NAT Network nad Host-only Network
echo "${green}${bold}ADDING VIRTUALBOX NAT AND HOST-ONLY NETWORKS${reset}"
VBoxManage natnetwork add --netname NatNetwork --network "10.0.2.0/24" --enable 
VBoxManage hostonlyif create 

# Virt-manager for KVM
echo "${green}${bold}INSTALLING VIRT MANAGER FOR KVM${reset}"
sudo dnf group install -y --with-optional virtualization 
sudo systemctl start libvirtd
sudo systemctl enable libvirtd 
sudo usermod -a -G libvirt $USER 

# TeamViewer
echo "${green}${bold}INSTALLING TEAMVIEWER${reset}"
cd ~/.gc
wget -q https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm 
sudo dnf -y install ./teamviewer.x86_64.rpm 
rm teamviewer.x86_64.rpm
cd

# VSCode
echo "${green}${bold}INSTALLING VSCODE. CODING APP FROM MICROSOFT${reset}"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' 
sudo dnf -y check-upgrade 
sudo dnf install -y code 

# VSCode plugins
echo "${green}${bold}INSTALLING VSCODE PLUGINS${reset}"
# AI-assisted development etension
code --install-extension visualstudioexptteam.vscodeintellicode 

# Code formatter 
code --install-extension esbenp.prettier-vscode

# Python extension
code --install-extension ms-python.python  

# Ansible extensions
code --install-extension redhat.vscode-xml 
code --install-extension redhat.vscode-yaml 

# Docker extension
code --install-extension ms-azuretools.vscode-docker 

# Git extension
code --install-extension eamodio.gitlens

# Bookmarks extension    
code --install-extension alefragnani.Bookmarks

# Terraform extension
code --install-extension hashicorp.terraform

# Vim Script language extension
code --install-extension xadillax.viml

# Highlight web colors extension
code --install-extension naumovs.color-highlight

# Support for .desktop files extension
code --install-extension nico-castell.linux-desktop-file

# Rofi theme language support extension
code --install-extension dlasagno.rasi

# Syntax definition for the i3wm configuration file extension
code --install-extension dcasella.i3

# Themes
code --install-extension sainnhe.gruvbox-material
code --install-extension jonathanharty.gruvbox-material-icon-theme

# Galcularor - calulator
sudo dnf install -y galculator

# Perl for fzf, Rust, Python pip
echo "${green}${bold}INSTALLING PERL, RUST. POPULAR PROGRAMMING LANGUAGES IN LINUX. FOR APPS USED IN SYSTEM${reset}"
sudo dnf install -y perl 
sudo dnf install -y rust cargo 

# Python pip, meson
echo "${green}${bold}INSTALLING PHP PIP, MESON, CMAKE, JQ. BUILD SYSTEM FOR APPS${reset}"
sudo dnf install -y python3-pip 
sudo dnf install -y meson 
sudo dnf install -y cmake 
sudo dnf install -y jq 

# Xfce polkit for password popups
sudo dnf install -y xfce-polkit

# 7zip
echo "${green}${bold}INSTALLING 7ZIP. ARCHIVE APP${reset}"
sudo dnf install -y p7zip p7zip-plugins 

# Thunar archive plugin
echo "${green}${bold}INSTALLING THUNAR FILE MANAGER A ARCHIVE PLUGIN${reset}"
sudo dnf install -y thunar-archive-plugin file-roller

# Bluez for bluetooth 
echo "${green}${bold}INSTALLING BLUEZ. BLUETOOTH PROTOCOL STACK FOR LINUX${reset}"
sudo dnf -y install bluez bluez-tools 
# bluetoothctl discoverable on 

# Blueman for bluetooth applet
echo "${green}${bold}INSTALLING BLUEMAN. BLUETOOTH APPLET${reset}"
sudo dnf install -y blueman 

# KDE connect for bluetooth connection with android phone
sudo dnf install -y sudo dnf install kde-connect

# Firewall rule for kde-connect
sudo firewall-cmd --permanent --zone=public --add-service=kdeconnect
sudo firewall-cmd --reload

# Scrcpy for android phone screen sharing when connected by usb and usb-debbuging is enabled
sudo dnf copr enable -y zeno/scrcpy
sudo dnf install -y scrcpy

# Playerctl for control media with keyboard
sudo dnf install -y playerctl

# Bash aliases for user
echo "${green}${bold}ADING BASH ALIASES FOR USER${reset}"
bash -c 'echo "
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi">> ~/.bashrc'

# Bash aliases for sudo/root
echo "${green}${bold}ADDING BASH ALIASES TO ROOT USER${reset}"
sudo bash -c 'echo "
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi">> ~/.bashrc'

# ZSH 
echo "${green}${bold}INSTALLING ZSH. UNIX SHELL WITH NEW FUTURES${reset}"
sudo dnf install -y util-linux-user 
sudo dnf install -y sqlite zsh 
sudo chsh -s $(which zsh) $USER 

# FZF
echo "${green}${bold}INSTALLING FZF. COMMAND LINE FUZY FINDER ${reset}"
cd .gc
git clone --quiet --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 
yes | ~/.fzf/install 
cd

# Oh-my-zsh
echo "${green}${bold}INSTALLING OH MY ZSH. FRAMEWORK FOR ZSH${reset}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 

# Oh-my-zsh plugins
echo "${green}${bold}ADDING ZSH PLUGINS${reset}"
git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 
git clone --quiet https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 

# Powerlevel10k zsh
echo "${green}${bold}INSTALLING POWERLEVEL10K. ZSH THEME${reset}"
cd ~/.gc
git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 

# Fonts 
echo "${green}${bold}ADDING FONTS TO SYSTEM ${reset}"
sudo dnf install -y powerline-fonts 
sudo dnf install -y cabextract xorg-x11-font-utils 
cd ~/.gc
git clone --quiet https://github.com/pietryszak/fonts.git 
cd fonts
sudo dnf install -y msttcore-fonts-installer-2.6-1.noarch.rpm 
mkdir -p ~/.local/share/fonts
cp feather.ttf ~/.local/share/fonts
cp iosevka_nerd_font.ttf ~/.local/share/fonts
cp MesloLGS* ~/.local/share/fonts/
cp weathericons-regular-webfont.ttf ~/.local/share/fonts
fc-cache -fv >> ~/.gc/fedora-installer/install-log
cd

# i3-gaps
echo "${green}${bold}INSTALLING I3-GAPS${reset}"
sudo dnf remove -y i3
sudo dnf install -y libxcb-devel xcb-util-keysyms-devel xcb-util-devel xcb-util-wm-devel xcb-util-xrm-devel yajl-devel libXrandr-devel startup-notification-devel libev-devel xcb-util-cursor-devel libXinerama-devel libxkbcommon-devel libxkbcommon-x11-devel pcre-devel pango-devel git gcc automake asciidoc xmlto 
sudo dnf install -y i3status-config libconfuse perl-AnyEvent perl-AnyEvent-I3 perl-JSON-XS perl-Types-Serialiser perl-common-sense xorg-x11-fonts-misc dmenu i3lock i3status perl-Guard perl-Task-Weaken pulseaudio-utils 
sudo dnf copr enable -y fuhrmann/i3-gaps 
sudo dnf install -y i3-gaps 

# i3-wifi applet
echo "${green}${bold}INSTALLING I3 WIFI APPLET${reset}"
sudo dnf install -y network-manager-applet 

# i3-volume applet
echo "${green}${bold}INSTALLING I3 VOLUME APPLET${reset}"
sudo dnf install -y volumeicon 

# i3 screen saver extension for X 
echo "${green}${bold}INSTALLING I3 SCREEN SAVER${reset}"
sudo dnf install -y xss-lock 

# Arandr -screen layout
echo "${green}${bold}INSTALLING ARANDR. XRANDR GUI${reset}"
sudo dnf install -y arandr 

# Polybar - i3 statusbar
echo "${green}${bold}INSTALLING POLYBAR. I3 BAR${reset}"
sudo dnf install -y polybar 

# Yad for polybar calendar
echo "${green}${bold}INSTALLING I3 CALENDAR APPLET${reset}"
sudo dnf install -y yad 

# Feh for i3 wallpapers
echo "${green}${bold}INSTALLING I3 WALLPAPER APP${reset}"
sudo dnf install -y feh 

# Rofi menu for i3
echo "${green}${bold}INSTALLING ROFI. I3 MENU${reset}"
sudo dnf install -y rofi 

# Picom for 13  compositor for X
echo "${green}${bold}INSTALLING PICOM. I3 WINDOWS COMPOSITOR${reset}"
sudo dnf install -y picom 

# Dunst i3 notifications
echo "${green}${bold}INSTALLING DUNST. I3 NOTIFICATIONS${reset}"
sudo dnf install -y dunst 

# Numlockx for i3 - numlock on at startup
echo "${green}${bold}INSTALLING NUMLOCKX. NUMLOCK ON AT STARTUP OF SYSTEM${reset}"
sudo dnf install -y numlockx 

# Polybar Spotify 
echo "${green}${bold}INSTALLING POLYBAR SPOTIFY APPLET${reset}"
cd ~/.gc
git clone --quiet https://github.com/Jvanrhijn/polybar-spotify.git 
cd

# Gnome-polkit - dispaly popup fot password for sudo 
echo "${green}${bold}INSTALLING GNOME POLKIT. POPUP WITH PASSWORD OF SUDO${reset}"
sudo dnf install -y polkit-gnome 

# Dropbox
echo "${green}${bold}INSTALLING DROPBOX${reset}"
sudo dnf install -y dropbox 

# Vivaldi browser
echo "${green}${bold}INSTALLING VIVALDI BROWSER${reset}"
sudo dnf config-manager --add-repo https://repo.vivaldi.com/archive/vivaldi-fedora.repo  
sudo dnf install -y vivaldi-stable

# Firefox as second browser
sudo dnf install -y firefox

# Solaar logitech devices control app
sudo dnf install -y solaar

############ FLATPKACKS #####################

# Flathub
echo "${green}${bold}INSTALLING FLATHUB. FLATPAK SOFTWARE SHOP${reset}"
sudo dnf install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 

# Ferdi messenging app
sudo sudo flatpak install -y --noninteractive flathub com.getferdi.Ferdi

# Spotify
echo "${green}${bold}INSTALLING SPOTIFY${reset}"
sudo sudo flatpak install -y --noninteractive flathub com.spotify.Client 

# Github desktop
echo "${green}${bold}INSTALLING GITHUB DESKTOP APP${reset}"
sudo flatpak install -y --noninteractive flathub io.github.shiftey.Desktop 

# Tick Tick 
sudo sudo flatpak install -y --noninteractive flathub com.ticktick.TickTick

# Joplin
echo "${green}${bold}INSTALLING JOPLIN. NOTING APP${reset}"
sudo flatpak install -y --noninteractive flathub net.cozic.joplin_desktop 
mkdir -p ~/.config/joplin-desktop/plugins
cd ~/.config/joplin-desktop/plugins
wget -q https://github.com/joplin/plugins/raw/master/plugins/ylc395.betterMarkdownViewer/plugin.jpl -O ylc395.betterMarkdownViewer.jpl  
wget -q https://github.com/joplin/plugins/raw/master/plugins/com.eliasvsimon.email-note/plugin.jpl -O com.eliasvsimon.email-note.jpl 
wget -q https://github.com/joplin/plugins/raw/master/plugins/com.lki.homenote/plugin.jpl -O com.lki.homenote.jpl 
wget -q https://github.com/joplin/plugins/raw/master/plugins/joplin.plugin.note.tabs/plugin.jpl -O joplin.plugin.note.tabs.jpl 
wget -q https://github.com/joplin/plugins/raw/master/plugins/joplin.plugin.benji.persistentLayout/plugin.jpl -O joplin.plugin.benji.persistentLayout.jpl 
cd

# GTK Gruvbox theme
echo "${green}${bold}INSTALLING GRUVBOX THEME${reset}"
cd ~/.gc
git clone --quiet https://github.com/pietryszak/gruvbox-material-gtk.git 
cd gruvbox-material-gtk
mkdir -p ~/.local/share/themes/
cp -r themes/* ~/.local/share/themes/
mkdir -p ~/.themes
cp -r themes/* ~/.themes
sudo cp -r themes/* /usr/share/themes/
cd
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --env=GTK_THEME=Gruvbox-Material-Dark
sudo bash -c 'echo "GTK_THEME=Gruvbox-Material-Dark" >> /etc/environment'

# QT5 apps theme
echo "${green}${bold}SET QT5 APPS THEME${reset}"
sudo dnf install -y qt5ct 
sudo bash -c 'echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment'
sudo dnf install -y qt5-qtstyleplugins 

# Papirus gtk icons for gruvbox 
echo "${green}${bold}SET GTK ICONS${reset}"
cd ~/.gc
sudo wget -qO- https://git.io/papirus-icon-theme-install | sh 

# Papirus hardcoded icons
sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/home:SmartFinn:hardcode-tray/Fedora_35/home:SmartFinn:hardcode-tray.repo -y
sudo dnf install -y hardcode-tray
sudo -E hardcode-tray --apply --conversion-tool RSVGConvert --size 22 --theme Papirus

# Papirus folders
echo "${green}${bold}SET FOLDERS COLORS${reset}"
wget -qO- https://git.io/papirus-folders-install | sh 
papirus-folders -C brown --theme Papirus-Dark 
cd

# GTK theme
echo "${green}${bold}SETTING DARK GTK THEME${reset}"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "Gruvbox-Material-Dark"

# Sensors
echo "${green}${bold}INSTALLING SENSORS APP AND FINDING ALL SENSORS IN SYSEM. IT'S TAKE A TIME. PLEASE WAIT!${reset}"
sudo dnf install -y lm_sensors 
yes | sudo sensors-detect 

# My dotfiles
echo "${green}${bold}COPY ALL MY DOTFILES TO PROPER FOLDERS${reset}"
cd ~/.gc
git clone --quiet https://github.com/pietryszak/dotfiles.git 
cd

# Copy bat config to proper folder
cp -r ~/.gc/dotfiles/bat ~/.config

# Copy Code config to proper folder
cp -r ~/.gc/dotfiles/Code/settings.json ~/.config/Code/User/

# Copy htop config to proper folder 
cp -r ~/.gc/dotfiles/htop ~/.config

# Copy neofetch config to proper folder
cp -r ~/.gc/dotfiles/neofetch ~/.config

# Copy nvim config to proper folder
cp -r ~/.gc/dotfiles/nvim ~/.config

# Copy VirtualBox config to proper folder 
cp -r ~/.gc/dotfiles/VirtualBox ~/.config
chmod +x ~/.config/VirtualBox/update.sh

# Copy zsh sripts to proper folder
cp -r ~/.gc/dotfiles/zsh/scripts/* ~/.oh-my-zsh/custom

# Copy zshrc config to proper folder
cp -r ~/.gc/dotfiles/zsh/.zshrc ~/

# Copy powerlevel10k config to proper folder
cp -r ~/.gc/dotfiles/zsh/.p10k.zsh ~/

# Copy terminator config to proper folder
cp -r ~/.gc/dotfiles/terminator/ ~/.config

# Copy kitty config to proper folder
cp -r ~/.gc/dotfiles/kitty/ ~/.config

# Copy TeamViewer config to proper folder
cp -r ~/.gc/dotfiles/teamviewer/ ~/.config

# Copy Redshift config to proper folder
cp -r ~/.gc/dotfiles/redshift/ ~/.config

# Copy Joplin config to proper folder
cp -r ~/.gc/dotfiles/joplin/* ~/.config/joplin-desktop

# Copy bash_aliases to user folder
cp -r ~/.gc/dotfiles/bashrc/.bash_aliases ~/ 

# Copy bash_aliases to sudo/root folder
sudo cp -r ~/.gc/dotfiles/bashrc/.bash_aliases /root  

# Copy qt5ct config to to proper folder
cp -r ~/.gc/dotfiles/qt5ct ~/.config

# Copy gtk config to to proper folder
cp ~/.gc/dotfiles/gtk/.gtkrc-2.0 ~
mkdir ~/.config/gtk-3.0/
cp ~/.gc/dotfiles/gtk/settings.ini ~/.config/gtk-3.0/

# Copy arandr config to to proper folder
mkdir ~/.screenlayout
cp -r ~/.gc/dotfiles/screenlayout/pc/* ~/.screenlayout
chmod +x ~/.screenlayout/*

# Copy shortcuts list to proper folder
cp -r ~/.gc/dotfiles/shortcuts ~/.config

# Copy i3 config to to proper folder
cp -r ~/.gc/dotfiles/i3 ~/.config
rm ~/.config/i3/scripts/vmware-workspaces

# Copy polybar config to to proper folder
cp -r ~/.gc/dotfiles/polybar ~/.config
chmod +x ~/.config/polybar/cuts/scripts/launcher.sh
chmod +x ~/.config/polybar/cuts/scripts/powermenu.sh
chmod +x ~/.config/polybar/scripts/*
cp ~/.gc/polybar-spotify/spotify_status.py ~/.config/polybar/scripts/
sed -i -e '/play_pause/s/25B6/F909/' ~/.config/polybar/scripts/spotify_status.py 
sed -i -e '/play_pause/s/23F8/F8E3/' ~/.config/polybar/scripts/spotify_status.py 

# Copy volumeicon config to to proper folder
cp -r ~/.gc/dotfiles/volumeicon/* ~/.config/volumeicon

# Copy bpytop config to to proper folder
mkdir  ~/.config/bpytop/
cp -r ~/.gc/dotfiles/bpytop/* ~/.config/bpytop/

# Copy update script to to proper folder
mkdir ~/.scripts
cp -r ~/.gc/dotfiles/update/* ~/.scripts
chmod +x ~/.scripts/update.sh

# Copy lightdm script to to proper folder
sudo cp -r ~/.gc/dotfiles/lightdm/* /etc/lightdm/

# Add Wallpapers
cd ~/Pictures
git clone https://github.com/pietryszak/wallpapers
sudo cp ~/Pictures/wallpapers/caffe-gruvbox.png /usr/share/pixmaps/

# Copy vivaldi speeddial icons to to proper folder
cp -r ~/.gc/dotfiles/vivaldi-icons ~/Pictures

# Remove apps 
echo "${green}${bold}REMOVE UNNECESSARY APPS${reset}"
sudo dnf remove -y azote 

# Last update
echo "${green}${bold}UPDATE SYSTEM BEFORE RESTART${reset}"
sudo dnf upgrade --refresh 
sudo dnf upgrade -y 
sudo dnf autoremove -y 

# Sudo timeout back to default
echo "${green}${bold}SET SUDO TIMEOUT TO DEFAULT${reset}"
sudo sed -i 's/Defaults        env_reset,timestamp_timeout=60/#Defaults        env_reset,timestamp_timeout=60/g' /etc/sudoers

# Reboot
echo "${MAGENTA}${bold}INSTALLATION SUCCESFULL !! REBOOT SYSTEM${reset}"
sudo reboot