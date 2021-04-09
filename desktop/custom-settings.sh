##!/usr/bin/env bash

#ssh keys, isntead of creating new sshkey-gen, use thease
cd $HOME/.ssh && openssl enc -aes-256-cbc -pbkdf2 -d -in $HOME/workspace/private/codes.tar.gz.enc | tar xz
#secrets
cd $HOME/.ssh && openssl enc -aes-256-cbc -pbkdf2 -d -in passwd.tar.gz.enc | tar xz

#sudoer
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
sudo usermod -aG sudo $USER
echo $USER' ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

#installs
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ACCAF35C
echo 'deb http://apt.insync.io/ubuntu focal non-free contrib' | sudo tee /etc/apt/sources.list.d/insync.list
sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -iy google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb
sudo apt-key add openvpn-repo-pkg-key.pub
sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-focal.list
sudo sh -c "apt update && apt upgrade -y && apt dist-upgrade -y"
sudo apt install apt-transport-https openvpn openvpn3 git docker.io wget curl vim tmux terminator htop python lm-sensors cpufrequtils net-tools grc simple-scan ubuntu-restricted-extras deluge gparted libreoffice rename gnome-shell-extensions gnome-tweaks insync bluez-tools -y
sudo snap install fast postman gimp ffmpeg vlc robo3t-snap subliminal-subtitles
sudo snap connect subliminal-subtitles:removable-media core
sudo snap install mysql-workbench-community --candidate
sudo snap install atom --classic

#teamviewer
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -iy teamviewer_amd64.deb && rm teamviewer_amd64.deb
sudo apt install -fy

#purevpn
wget https://d3uym7n1flvv1x.cloudfront.net/linux/app/purevpn_1.2.5_amd64.deb
sudo dpkg -i purevpn_1.2.5_amd64.deb
rm purevpn_1.2.5_amd64.deb

#vpns
sudo openvpn3 config-import --config $HOME/.ssh/aws.ovpn --name AWS --persistent

#insync
insync-headless start
google-chrome https://insynchq.com/auth > KEY
insync-headless account add -c gd -a [KEY]

#atom packages
apm install language-nginx language-docker language-vue
# apm install language-brightscript roku-develop

#docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo gpasswd -a $USER docker

#purges & cleaning
rm /tmp/*.deb
sudo apt purge '^firefox*' '^thunderbird*' gnome-shell-extension-ubuntu-dock -y
sudo sh -c "apt update && apt upgrade -y && apt dist-upgrade -y && apt autoremove -y && apt autoclean && apt clean"

#bash
mkdir $HOME/.bash
cd $HOME/.bash
git clone git://github.com/jimeh/git-aware-prompt.git
echo '
export EDITOR=vim
export GITAWAREPROMPT=$HOME/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "
' >> $HOME/.bashrc
sed -i 's/^SELECTED_EDITOR=.*/SELECTED_EDITOR="\/usr\/bin\/vim.basic"/' $HOME/.selected_editor

#bash_personal_envs
while read p; do
  export "$p"
  echo "export $p" >> $HOME/.bashrc
done < $HOME/workspace/private/bash_env_vars

#workspace
mkdir $HOME/workspace
git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git clone git@github.com:elmarcu/some-scripts.git

#boot options
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash, intel_pstate=disable"/' /etc/default/grub
sudo update-grub

#cpu
echo 'GOVERNOR="ondemand"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand.service
sudo systemctl reload cpufrequtils.service

#crontab
(crontab -u $USER -l; cat $HOME/workspace/private/bash_env_vars ) | crontab -u $USER -
(crontab -u $USER -l; cat $HOME/workspace/some-scripts/desktop/crontab-scripts ) | crontab -u $USER -

#desktop executables, aliases and configs
cp -r $HOME/workspace/some-scripts/desktop/executables $HOME/.executables
cp $HOME/workspace/some-scripts/desktop/bash_aliases $HOME/.bash_aliases
cp $HOME/workspace/some-scripts/desktop/pam_environment $HOME/.pam_environment
cp $HOME/workspace/some-scripts/desktop/sshconfig $HOME/.ssh/config
cp $HOME/workspace/private/profile.jpg $HOME/.face
sudo cp $HOME/workspace/private/profile.jpg /var/lib/AccountsService/icons/$USER
cp $HOME/workspace/private/wallpaper.jpg $HOME/pictures/.wallpaper.jpg
gsettings set org.gnome.desktop.background picture-uri "'file://$HOME/.wallpaper.jpg'"
gsettings set org.gnome.desktop.screensaver picture-uri "'file://$HOME/.wallpaper.jpg'"

#desktop settings
dconf write /system/locale/region "'en_US.UTF-8'"
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.desktop.wm.preferences button-layout "''"#"'close,maximize,minimize:'"
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.gnome.shell.extensions.desktop-icons show-home false
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface locate-pointer false
gsettings set org.gnome.mutter dynamic-workspaces true
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop', 'atom_atom.desktop']"
#tweaks
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
#keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+altgr-intl')]"
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
#keybindings
dconf write /org/gnome/settings-daemon/plugins/media-keys/www "'<Super>g'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/home "'<Super>x'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/terminal "''"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'gnome-terminal --full-screen'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Super>c'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'gnome-calculator'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'calculator'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Super>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gedit'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'editor'"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/']"

#lights- darkmode
sh $HOME/.executables/toggle-lights.sh

#secrets-backup
cd $HOME/.ssh/ && tar cz access-* | openssl enc -aes-256-cbc -pbkdf2 -e > $HOME/.ssh/passwd.tar.gz.enc && rm access-*
cd $HOME/.ssh/ && tar cz --exclude config * | openssl enc -aes-256-cbc -pbkdf2 -e > $HOME/workspace/private/codes.tar.gz.enc

sudo service gdm3 restart
