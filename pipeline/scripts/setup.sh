#!/usr/bin/env bash

set -euo pipefail


#FETCH SECRET FROM SECRET MANAGER

IBMCLOUD_API_KEY="$(get_env ibmcloud-api-key "")"
DEV_REGION="$(get_env dev-region "")"
IBM_CLOUD_REGION="${DEV_REGION#*:*:}"

if ibmcloud login --apikey $IBMCLOUD_API_KEY -r "$IBM_CLOUD_REGION"  ;then
    echo "Logged into IBM clouds sucessfully"
else
    echo "could not log into IBM cloud"
    exit
fi

if ibmcloud plugin install secrets-manager  ;then
    echo "Installed the secrets manager sucessfully"
else
    echo "failed to install the secrets manager"
    exit
fi

ibmcloud secrets-manager secret --secret-type "arbitrary" --id "ebf45e88-6650-4c91-e795-d11250577278" --service-url https://c30c55a3-7252-47aa-aeb9-8d21da464f45.us-south.secrets-manager.appdomain.cloud --output json > ssh_auth.txt

if jq '.resources[] | select(.name=="test-auth") | .secret_data.payload' ssh_auth.txt > ssh_auth_secret.txt  ;then
    echo "The ssh auth token has been sucessfully preserved"
else
    echo "Secret 'test-auth' not present"
    exit
fi

cat ssh_auth_secret.txt

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

