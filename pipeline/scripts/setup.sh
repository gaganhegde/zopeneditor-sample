#!/usr/bin/env bash

set -euo pipefail


#FETCH SECRET FROM SECRET MANAGER

IBMCLOUD_API_KEY="$(get_env ibmcloud-api-key "")"
SSH_INFO="$(get_env ssh-auth "")"
SECRET_NAME="$(get_env secret-name "")"
DEV_REGION="$(get_env dev-region "")"
IBM_CLOUD_REGION="${DEV_REGION#*:*:}"
INSTANCE_ID=$(echo $SSH_INFO | awk -F"%[0-9]*[A-B]*" '{print $9}')
INSTANCE_REGION=$(echo $SSH_INFO | awk -F"%[0-9]*[A-B]*" '{print $6}')
export SECRETS_MANAGER_URL="https://${INSTANCE_ID}.${INSTANCE_REGION}.secrets-manager.appdomain.cloud"

echo "Starting to fetch ${SECRET_NAME} secret"


if ibmcloud login --apikey $IBMCLOUD_API_KEY -r "${IBM_CLOUD_REGION}"  ;then
    echo "Logged into IBM cloud sucessfully"
else
    echo "could not log into IBM cloud"
    exit -1
fi

if ibmcloud plugin install secrets-manager  ;then
    echo "Secrets manager plugin installed sucessfully"
else
    echo "failed to install the secrets manager plugin"
    exit -1
fi

if ibmcloud secrets-manager all-secrets --search ${SECRET_NAME} --output json > ssh-auth-id.txt  ;then
    echo "Retrieved the secret instance ID sucessfully"
else
    echo "Failed to retrieve the secret instance ID"
    exit -1
fi

SECRET_ID=$(jq '.resources[] | select(.name=="ssh-auth") | .id' ssh-auth-id.txt | tr -d '"')

if ibmcloud secrets-manager secret --secret-type=arbitrary --id ${SECRET_ID} --service-url ${SECRETS_MANAGER_URL} --output json >ssh_auth_secret.txt  ;then
    echo "${SECRET_NAME} json has been retrieved"
else
    echo "${SECRET_NAME} json could not be retrieved"
    exit -1
fi

if jq --arg secret_name ${SECRET_NAME} '.resources[] | select(.name==$secret_name) | .secret_data.payload' ssh_auth_secret.txt | sed 's/\\n/\n/g' | tr -d '"' > $WORKSPACE/ssh_auth.txt  ;then
    echo "The ${SECRET_NAME} payload has been retrieved"
else
    echo "The ${SECRET_NAME} payload could not be retrieved"
    exit -1
fi

chmod 0600  $WORKSPACE/ssh_auth.txt

echo "Secret data for ${SECRET_NAME} securely stored"


# if jq '.resources[] | select(.name=="test-auth") | .secret_data.payload' ssh_auth.txt > ssh_auth_secret.txt  ;then
#     echo "The ssh auth token has been sucessfully preserved"
# else
#     echo "Secret 'test-auth' not present"
#     exit -1
# fi

# echo "just some tests"
# cat ssh_auth_secret.txt
# echo $SECRET_ID
# cat nothin.txt

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

