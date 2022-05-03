#!/usr/bin/env bash

set -euo pipefail

echo "test-1"

if ibmcloud --help ;then
    echo "Command Succeded"
else
    echo "ibmcloud command could not be found"
fi

IBMCLOUD_API_KEY="$(get_env ibmcloud-api-key "")"
DEV_REGION="$(get_env dev-region "")"
IBM_CLOUD_REGION="${DEV_REGION#*:*:}"
echo "printing the api key"
echo $IBMCLOUD_API_KEY
echo $DEV_REGION
echo "process completed"

if ibmcloud login --apikey $IBMCLOUD_API_KEY -r "$DEV_REGION"  ;then
    echo "Command Succeded"
else
    echo "could not login into IBM cloud"
fi

# $WORKSPACE is shared between steps
python3 -m venv $WORKSPACE/virtual/environment
source $WORKSPACE/virtual/environment/bin/activate

# Install ansible
pip3 install --only-binary=:all: ansible
pip3 install ansible==2.9.11

# Install xmltodict required for the z/OS collection ibm.ibm_zos_cics
pip3 install xmltodict 

# Install RedHat Ansible collections for z/OS 
ansible-galaxy collection install ibm.ibm_zos_core
ansible-galaxy collection install ibm.ibm_zos_cics

