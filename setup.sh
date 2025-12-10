# turn off power saving for wifi
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
    LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
    echo -e "The following has been added to $LOC.\n"
    echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
    echo -e "\n"
    echo -e "Restarting NetworkManager service...\n"
    sudo systemctl restart NetworkManager
    sleep 3
fi

# Start bluetooth service
echo -e "Starting the Bluetooth Service...\n"
sudo systemctl enable --now bluetooth.service
sleep 2

# ignore power key presses
echo "HandlePowerKey=ignore" | sudo tee -a /etc/systemd/logind.conf

# install all the packages
echo -e "\nInstalling all the packages...\n"
sudo pacman -S --noconfirm --needed - < pkglist.txt
sleep 2

# enable services
echo -e "\nEnabling all the services...\n"
sudo systemctl enable --now power-profiles-daemon.service

# download theme files
echo -e "\nDownload theme from here: \nhttps://www.gnome-look.org/p/1316887/\n and extract it to ~/.themes\n"

# set kitty as default terminal
echo -e "\nSetting kitty as the default terminal emulator...\n"
gsettings set org.cinnamon.desktop.default-applications.terminal exec 'kitty'

# setup zram-generator
echo -e "\nSetting up zram-generator...\n"
ZRAMLOC="/etc/systemd/zram-generator.conf"
echo -e "[zram0]\nsize = ram/2\ncompression-algorithm = zstd" | sudo tee $ZRAMLOC
sudo systemctl daemon-reexec
sudo systemctl restart systemd-zram-setup@zram0.service
swapon --show
sleep 4

# enable thermald service
echo -e "\nEnabling thermald service...\n"
sudo systemctl enable --now thermald.service

# setup android studio to show in rofi
read -p "Do you want to setup Android Studio to show in Rofi? (Y/N): " ANDSTUDIO
if [[ $ANDSTUDIO == "Y" || $ANDSTUDIO == "yes" || $ANDSTUDIO == "YES" || $ANDSTUDIO == "y" ]]; then    
    echo -e "\nSetting up Android Studio to show in Rofi...\n"
    STUDIO_PATH="/home/$USER/Setup/android-studio/bin"
    echo -e "[Desktop Entry]\nType=Application\nName=Android Studio\nComment=IDE for writing Android Applications\nExec=/bin/bash -c \"cd $STUDIO_PATH && ./studio.sh\"\nIcon=$STUDIO_PATH/studio.png\nTerminal=false\nCategories=Development;IDE;\nStartupWMClass=jetbrains-android-studio" > ~/.local/share/applications/android-studio.desktop
fi

# clear clipboard history after boot
echo -e "\nSetting up clipboard clear on boot...\n"
(crontab -l 2>/dev/null; echo "@reboot /usr/bin/clipvalut clear") | crontab -