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

#profile
echo "
export WORKSPACE=$(echo $HOME)/workspace
export WORKSPACE_PRIVATE=$(echo $WORKSPACE)/$(echo $USER)
export NAME=$NAME
export EMAIL=$EMAIL
export GITHUB_TOKEN=$GITHUB_TOKEN
export GITHUB_PROJECT=$GITHUB_PROJECT
export SLACK_TOKEN=$SLACK_TOKEN
export JIRA_PROJECT=$JIRA_PROJECT
export API_PROJECT=$API_PROJECT
" >> $HOME/.bashrc

#githubs repo
cd $WORKSPACE_PRIVATE
ssh-keygen
#copy id-rsa.pub contents to github user
git clone git@github.com:elmarcu/some-scripts.git

git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git config --global pull.ff only

#executables
mkdir -p $HOME/.bin
cp $WORKSPACE_PRIVATE/some-scripts/workspace-common/bin/* $HOME/.bin/
cp $WORKSPACE_PRIVATE/some-scripts/workspace-linux/bin/* $HOME/.bin/
chmod +x $HOME/.bin/*

#workspace and fast aliases generator
$HOME/.bin/workspace_generator

#copy and run contents of .git_clone_repos
cat $HOME/.git_clone_repos
