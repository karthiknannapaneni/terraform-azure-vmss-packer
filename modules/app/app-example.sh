#!/bin/bash
#Add this shell script as an "Execute Shell" build step in Jenkins

#Adjust path:
export PATH=/usr/local/bin:$PATH

#Set variables:
export CLIENT_NAME="ACME"
export TFE_ORG="your-tfe-org"
export ID_RSA_PUB_PATH="/Users/Shared/Jenkins/.ssh/id_rsa.pub"

#Set Azure Service Account credentials
export ARM_SUBSCRIPTION_ID=<service_account_subscription_id>
export ARM_CLIENT_ID=<service_account_client_id>
export ARM_CLIENT_SECRET=<service_account_client_secret>
export ARM_TENANT_ID=<service_account_tenant_id>

#Set Set TFE Token:
export TFE_TOKEN=<token_for_terraform_enterprise>
export ATLAS_TOKEN=<token_for_terraform_enterprise>

#Adjust CLI variables:
export TFE_WORKSPACE="terraform-jenkins-app-${CLIENT_NAME}"
export WORKING_DIR="examples/simple/"

#Workspace setup:
export workspace_exists=$(tfe workspace list | grep ${TFE_WORKSPACE})
if [ -z "${workspace_exists}" ]
then
     echo "${TFE_WORKSPACE} does not exist, creating new"
     tfe workspace new -auto-apply "true"
else
     echo "${TFE_WORKSPACE} exists"
fi

#Environment variables:
tfe pushvars -senv-var "ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID}"
tfe pushvars -senv-var "ARM_CLIENT_ID=${ARM_CLIENT_ID}"
tfe pushvars -senv-var "ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET}"
tfe pushvars -senv-var "ARM_TENANT_ID=${ARM_TENANT_ID}"
tfe pushvars -env-var 'TF_WARN_OUTPUT_ERRORS=1'
tfe pushvars -env-var 'CONFIRM_DESTROY=1'

#Terraform variables:
tfe pushvars -var "core_tfe_organization=${TFE_ORG}"
tfe pushvars -var "core_infrastructure_workspace=terraform-jenkins-core-${CLIENT_NAME}"
tfe pushvars -var "location=EAST US"
tfe pushvars -var "app_resource_group_name=terraform-jenkins-app-${CLIENT_NAME}"
tfe pushvars -svar "id_rsa_pub=$(cat ${ID_RSA_PUB_PATH})"
#tfe pushvars -var "vmss_capacity=2"

#Packer related variables:
tfe pushvars -var "packer_resource_group_name=Demo-Azure-Packer-RG"
tfe pushvars -var "image_name=vmss-packer-jenkins-ubuntu1604-lts"

#Go to module directory:
cd ./${WORKING_DIR}
tfe pushconfig -upload-modules false -vcs false -poll 30 .
