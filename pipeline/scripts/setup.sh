#!/usr/bin/env bash

set -euo pipefail
export IBMCLOUD_API_KEY

if [ -f /config/api-key ]; then
  IBMCLOUD_API_KEY="$(cat /config/api-key)" # pragma: allowlist secret
else
  IBMCLOUD_API_KEY="$(cat /config/ibmcloud-api-key)" # pragma: allowlist secret
fi

echo "IBMCLOUD_API_KEY"
echo $IBMCLOUD_API_KEY

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

