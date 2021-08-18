##!/usr/bin/env bash

#sudoer
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
sudo usermod -aG sudo $USER
echo $USER' ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

#installs
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys ACCAF35C
sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -iy google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb
sudo apt-key add openvpn-repo-pkg-key.pub
sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-focal.list
sudo sh -c "apt update && apt upgrade -y && apt dist-upgrade -y"
sudo apt install apt-transport-https openvpn openvpn3 git docker.io wget curl vim tmux terminator htop iotop python lm-sensors cpufrequtils net-tools grc simple-scan ubuntu-restricted-extras deluge gparted firefox rename gnome-shell-extensions gnome-tweaks bluez-tools -y
sudo snap install fast gimp ffmpeg vlc subliminal-subtitles
sudo snap connect subliminal-subtitles:removable-media core

#sublime
sudo snap install sublime-text --classic --edge
cp $WORKSPACE_PRIVATE/some-scripts/desktop/settings-ide-sublime.json $HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings

#atom
sudo snap install atom --classic
apm install language-nginx language-docker language-vue sort-lines
# apm install language-brightscript roku-develop
cp $WORKSPACE_PRIVATE/some-scripts/desktop/settings-ide-atom.cson $HOME/.atom/config.cson

#vscode
sudo snap install code --classic
#code --list-extensions
code --install-extension raynigon.nginx-formatter ms-azuretools.vscode-docker ms-python.python ms-vscode-remote.remote-containers
cp $WORKSPACE_PRIVATE/some-scripts/desktop/settings-ide-vscode.json $HOME/.config/Code/User/settings.json

#mongo
wget https://downloads.mongodb.com/compass/mongodb-compass_1.26.1_amd64.deb
sudo dpkg -i mongodb-compass_1.26.1_amd64.deb && rm mongodb-compass_1.26.1_amd64.deb

#vpns
sudo openvpn3 config-import --config $HOME/.ssh/aws.ovpn --name AWS --persistent

#docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo groupadd docker
sudo gpasswd -a $USER docker

#purges & cleaning
rm /tmp/*.deb
sudo apt purge '^thunderbird*' 'libreoffice*' gnome-shell-extension-ubuntu-dock -y
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

#workspace
export WORKSPACE_PRIVATE=$(echo $HOME)/workspace/$(echo $USER)
mkdir $WORKSPACE_PRIVATE
cd $WORKSPACE_PRIVATE

#githubs repos
git clone git@github.com:elmarcu/some-scripts.git
git clone git@github.com:elmarcu/private.git

#bash_personal_envs
while read p; do
  export "$p"
  echo "export $p" >> $HOME/.bashrc
done < $WORKSPACE_PRIVATE/private/bash_env_vars

git config --global user.email "$EMAIL"
git config --global user.name "$NAME"

#ssh keys, isntead of creating new sshkey-gen, use these
cd $HOME/.ssh && openssl enc -aes-256-cbc -pbkdf2 -d -in $WORKSPACE_PRIVATE/private/codes.tar.gz.enc | tar xz
#secrets
cd $HOME/.ssh && openssl enc -aes-256-cbc -pbkdf2 -d -in passwd.tar.gz.enc | tar xz

#boot options
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=2/' /etc/default/grub
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash, intel_pstate=disable"/' /etc/default/grub
sudo update-grub

#cpu
echo 'GOVERNOR="ondemand"' | sudo tee /etc/default/cpufrequtils
sudo systemctl disable ondemand.service
sudo systemctl reload cpufrequtils.service

#crontab
(crontab -u $USER -l; cat $WORKSPACE_PRIVATE/private/bash_env_vars ) | crontab -u $USER -
(crontab -u $USER -l; cat $WORKSPACE_PRIVATE/some-scripts/desktop/crontab-scripts ) | crontab -u $USER -

#aliases
sed 's,'\$"$(grep "WORKSPACE_PRIVATE" $WORKSPACE_PRIVATE/private/bash_env_vars | tr '=' ' ' | awk '{print $1}')"','"$(grep "WORKSPACE_PRIVATE" $WORKSPACE_PRIVATE/private/bash_env_vars | tr '=' ' ' | awk '{print $2}')"',g; s,'\$"$(grep "KUBE_NAMESPACE" $WORKSPACE_PRIVATE/private/bash_env_vars | tr '=' ' ' | awk '{print $1}')"','"$(grep "KUBE_NAMESPACE" $WORKSPACE_PRIVATE/private/bash_env_vars | tr '=' ' ' | awk '{print $2}')"',g;' $WORKSPACE_PRIVATE/some-scripts/desktop/bash_aliases > $HOME/.bash_aliases

#desktop executables and configs
sudo cp $WORKSPACE_PRIVATE/some-scripts/desktop/bin/* /usr/bin/
cp $WORKSPACE_PRIVATE/some-scripts/desktop/pam_environment $HOME/.pam_environment
cp $WORKSPACE_PRIVATE/some-scripts/desktop/sshconfig $HOME/.ssh/config
cp $WORKSPACE_PRIVATE/private/profile.jpg $HOME/.face
sudo cp $WORKSPACE_PRIVATE/private/profile.jpg /var/lib/AccountsService/icons/$USER
cp $WORKSPACE_PRIVATE/private/wallpaper.jpg $HOME/pictures/.wallpaper.jpg
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
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
#tweaks
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true
gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
#keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+altgr-intl')]"
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
#keybindings
dconf write /org/gnome/settings-daemon/plugins/media-keys/www "'<Super>b'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/home "'<Super>x'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/terminal "''"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/binding "'<Super>g'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/command "'google-chrome --profile-directory=\"System Profile\"'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/name "'terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/binding "'<Super>t'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/command "'gnome-terminal --full-screen'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/name "'terminal'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/binding "'<Super>c'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/command "'gnome-calculator'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/name "'calculator'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/binding "'<Super>e'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/command "'gedit'"
dconf write /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/name "'editor'"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

#lights- darkmode
lights

#secrets-backup
cd $HOME/.ssh/ && tar cz access-* | openssl enc -aes-256-cbc -pbkdf2 -e > $HOME/.ssh/passwd.tar.gz.enc && rm access-*
cd $HOME/.ssh/ && tar cz --exclude config * | openssl enc -aes-256-cbc -pbkdf2 -e > $WORKSPACE_PRIVATE/private/codes.tar.gz.enc

sudo service gdm3 restart
