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
#open /Applications/MonitorControl.app

#containers virtualization
brew install --cask docker
#brew install --cask podman
#open /Applications/Docker.app

#warp
brew install --cask warp

#visual code
brew install --cask visual-studio-code

#json parser (alternative to json_pp)
brew install jq

#node install
brew install node
npm i -D typescript

#mongo
brew install mongodb-database-tools

#mysql
brew install mysql
ln -s /opt/homebrew/opt/mysql/opt/homebrew/opt/mysql
brew install --cask mysqlworkbench
#open /Applications/MySQLWorkbench.app

#dbeaver
brew install --cask dbeaver-community
#open /Applications/DBeaver.app

#golang
brew install go

#gcloud
brew install --cask google-cloud-sdk
gcloud components update

#aws
brew install awscli

#terraform
brew install terraform
#AWS_PROFILE=HULU_SSO terraform init

#github cli
brew install gh

#vpn
brew install openconnect
#sudo openconnect --protocol=gp your-company-vpn.com -u [USER] --passwd-on-stdin

#tmux
brew install tmux

#watch
brew install watch

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

source $HOME/.zshrc