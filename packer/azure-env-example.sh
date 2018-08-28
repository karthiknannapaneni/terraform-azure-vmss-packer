#Setup Azure service credentials:
export ARM_SUBSCRIPTION_ID=<service_account_subscription_id>
export ARM_CLIENT_ID=<service_account_client_id>
export ARM_CLIENT_SECRET=<service_account_client_secret>
export ARM_TENANT_ID=<service_account_tenant_id>

#Setup Packer variables:
export TF_VAR_location="EAST US"
export TF_VAR_packer_resource_group_name="resource_group_name"
export TF_VAR_image_name="packer_image_name"

#Setup tags for Packer image:
export environment="dev"
export app="vmss-packer"
export owner="kawsar-at-hashicorp"
export ttl="24h"
