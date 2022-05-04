#!/usr/bin/env bash

set -euo pipefail

# $WORKSPACE is shared between steps
source $WORKSPACE/virtual/environment/bin/activate

# Just for test (MUST NOT BE USED EXTERNALY WE MUST USE A SSH KEY)
wget https://rpmfind.net/linux/centos/8-stream/AppStream/x86_64/os/Packages/sshpass-1.09-4.el8.x86_64.rpm
rpm -i sshpass-1.09-4.el8.x86_64.rpm

cd pipeline/playbooks
ansible-playbook --key-file $WORKSPACE/ssh_auth.txt -i inventories build.yml -e app_repo=$APP_REPO -e app_branch=$BRANCH -e app_repo_name=$APP_REPO_NAME
