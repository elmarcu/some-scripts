#workspace
export WORKSPACE=$(echo $HOME)/workspace
export WORKSPACE_PRIVATE=$(echo $WORKSPACE)/marcu && mkdir -p $WORKSPACE_PRIVATE
read NAME && export NAME=$NAME
read EMAIL && export EMAIL=$EMAIL
read GITHUB_TOKEN && export GITHUB_TOKEN=$GITHUB_TOKEN
read GITHUB_PROJECT && export GITHUB_PROJECT=$GITHUB_PROJECT
read SLACK_TOKEN && export SLACK_TOKEN=$SLACK_TOKEN
read JIRA_PROJECT && export JIRA_PROJECT=$JIRA_PROJECT
read API_PROJECT && export API_PROJECT=$API_PROJECT

#bash from https://github.com/ohmyzsh/ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#import ALIASES to profile file
cp $WORKSPACE_PRIVATE/some-scripts/unix/bash_aliases $HOME/.bash_aliases
echo 'if [[ -n .bash_aliases ]]; then
  source ~/.bash_aliases
fi' >> $HOME/.zshrc

#profile
echo "
export WORKSPACE=$(echo $HOME)/workspace
export WORKSPACE_PRIVATE=$(echo $WORKSPACE)/marcu
export NAME=$NAME
export EMAIL=$EMAIL
export GITHUB_TOKEN=$GITHUB_TOKEN
export GITHUB_PROJECT=$GITHUB_PROJECT
export SLACK_TOKEN=$SLACK_TOKEN
export JIRA_PROJECT=$JIRA_PROJECT
export API_PROJECT=$API_PROJECT
" >> $HOME/.zshrc

#executables
mkdir -p $HOME/bin
cp $WORKSPACE_PRIVATE/some-scripts/unix/bin/* $HOME/bin/
chmod +x $HOME/bin/*

#workspace and fast aliases generator
$HOME/bin/workspace_generator

#githubs repo
cd $WORKSPACE_PRIVATE
ssh-keygen
#copy id-rsa.pub contents to github user
git clone git@github.com:elmarcu/some-scripts.git
git clone git@github.com:elmarcu/private.git

git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git config --global --replace-all core.pager "less -F -X"

#crontab
echo -e "$(printenv | xargs -n 1)\n$(cat $WORKSPACE_PRIVATE/some-scripts/unix/crontab-scripts)" > .tempfile
(cat .tempfile ) | crontab -
rm .tempfile
