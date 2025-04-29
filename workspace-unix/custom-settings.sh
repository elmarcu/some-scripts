#workspace
export WORKSPACE=$(echo $HOME)/workspace
export WORKSPACE_PRIVATE=$(echo $HOME)/workspace/$(echo $USER) && mkdir -p $WORKSPACE_PRIVATE
read NAME && export NAME=$NAME
read EMAIL && export EMAIL=$EMAIL
read GITHUB_TOKEN && export GITHUB_TOKEN=$GITHUB_TOKEN
read GITHUB_PROJECT && export GITHUB_PROJECT=$GITHUB_PROJECT
read SLACK_TOKEN && export SLACK_TOKEN=$SLACK_TOKEN
read JIRA_PROJECT && export JIRA_PROJECT=$JIRA_PROJECT
read API_PROJECT && export API_PROJECT=$API_PROJECT

#bash from https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#githubs repo
cd $WORKSPACE_PRIVATE
ssh-keygen
#copy id-rsa.pub contents to github user
git clone git@github.com:elmarcu/some-scripts.git
git clone git@github.com:elmarcu/private.git

git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git config --global --replace-all core.pager "less -F -X"

#import ALIASES to profile file
cp $WORKSPACE_PRIVATE/some-scripts/workspace-common/bash_aliases $HOME/.bash_aliases
echo 'if [[ -n .bash_aliases ]]; then
  source ~/.bash_aliases
fi' >> $HOME/.zshrc

#profile
echo "
export WORKSPACE=$(echo $HOME)/workspace
export WORKSPACE_PRIVATE=$(echo $HOME)/workspace/$(echo $USER)
export NAME=$NAME
export EMAIL=$EMAIL
export GITHUB_TOKEN=$GITHUB_TOKEN
export GITHUB_PROJECT=$GITHUB_PROJECT
export SLACK_TOKEN=$SLACK_TOKEN
export JIRA_PROJECT=$JIRA_PROJECT
export API_PROJECT=$API_PROJECT
" >> $HOME/.zshrc

#brew install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# OR
cd /opt
sudo mkdir -p homebrew
sudo chown -R $(whoami) homebrew
curl -L https://github.com/Homebrew/brew/tarball/master |\
    tar xz --strip 1 -C homebrew
echo 'export PATH=/opt/homebrew/bin:$PATH' >> $HOME/.zshrc

#control external monitor brightness with mac
brew install --cask monitorcontrol
open /Applications/MonitorControl.app

#containers virtualization
brew install --cask docker
brew install --cask podman
open /Applications/Docker.app

#warp
brew install --cask warp

#visual code
brew install --cask visual-studio-code

#json parser (alternative to json_pp)
brew install jq
sudo ln -s /opt/homebrew/bin/jq /usr/local/bin/jq

#node install
brew install node
echo 'export PATH="/opt/homebrew/opt/node/bin:$PATH"' >> $HOME/.zshrc
npm i -D typescript

#mongo
brew install mongodb-database-tools
echo 'export PATH="/opt/homebrew/opt/mongosh/bin:$PATH"' >> $HOME/.zshrc

#mysql
brew install mysql
ln -s /opt/homebrew/opt/mysql/opt/homebrew/opt/mysql
echo 'export PATH="/opt/homebrew/opt/mysql/bin:$PATH"' >> $HOME/.zshrc
brew install --cask mysqlworkbench
open /Applications/MySQLWorkbench.app

#dbeaver
brew install --cask dbeaver-community
open /Applications/DBeaver.app

#golang
brew install go
which go
echo 'export PATH="/opt/homebrew/opt/go/bin:$PATH"' >> $HOME/.zshrc

#gcloud
brew install --cask google-cloud-sdk
eecho '# Google Cloud SDK configuration' >> ~/.zshrc
echo 'source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"' >> ~/.zshrc
echo 'source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"' >> ~/.zshrc
gcloud components update

#aws
brew install awscli

#github cli
brew install gh
which gh
echo 'export PATH="/opt/homebrew/bin/gh:$PATH"' >> $HOME/.zshrc

#vpn
brew install openconnect
#sudo openconnect --protocol=gp your-company-vpn.com -u [USER] --passwd-on-stdin

#tmux
brew install tmux

#executables
mkdir -p $HOME/.bin
cp $WORKSPACE_PRIVATE/some-scripts/workspace-common/bin/* $HOME/.bin/
cp $WORKSPACE_PRIVATE/some-scripts/workspace-unix/bin/* $HOME/.bin/
chmod +x $HOME/.bin/*

#workspace and fast aliases generator
$HOME/.bin/workspace-generator

#crontab
echo -e "$(printenv | xargs -n 1)\n$(cat $WORKSPACE_PRIVATE/some-scripts/workspace-common/crontab-scripts)" > .tempfile
(cat .tempfile ) | crontab -
rm .tempfile

#custom linux alias
#watch command
echo "
alias watch=$HOME/.bin/watch
alias upd='brew update --force; brew upgrade; brew cleanup; omz update'
" >> $HOME/.zshrc

source $HOME/.zshrc