######################
### KubeCost - SSO ###
######################

# resource "aws_secretsmanager_secret" "kubecost_sp" {
#   name = "${var.name}-kubecost-sp"
# }

# resource "aws_secretsmanager_secret_version" "kubecost_sp" {
#   secret_id     = aws_secretsmanager_secret.kubecost_sp.id
#   secret_string = jsonencode({
#     client_id     = var.kubecost_secrets.service_principal.client_id
#     client_secret = var.kubecost_secrets.service_principal.client_secret
#   })
# }

################################
### KubeCost - Keys & Tokens ###
################################

# resource "aws_secretsmanager_secret" "kubecost_keys_and_token" {
#   count = var.kubecost_secrets != null ? 1 : 0

#   name = "kubecost-keys-and-token"
# }

# resource "aws_secretsmanager_secret_version" "kubecost_keys_and_token" {
#   count = var.kubecost_secrets != null ? 1 : 0

#   secret_id     = aws_secretsmanager_secret.kubecost_keys_and_token.id
#   secret_string = jsonencode({
#     token             = var.kubecost_secrets.token
#     product_key       = var.kubecost_secrets.product_key
#     cloud_service_key = <<EOT
#   {
#     "subscriptionId": ${var.azure_secrets.subscription_id},
#     "serviceKey": {
#       "appId": ${var.kubecost_secrets.service_principal.client_id},
#       "password": ${var.kubecost_secrets.service_principal.client_secret},
#       "tenant": ${var.azure_secrets.tenant_id},
#     }
#   }
#   EOT
#   })
# }



# In the context of Azure, the Kubecost cloud service key is used to enable
# Kubecost to access and fetch cloud billing data (specifically Azure Cost Management data)
# to provide accurate cost allocation, chargeback, and showback across Kubernetes workloads.


# Integration with cloud service providers (CSPs) via their respective billing APIs allows Kubecost to display out-of-cluster (OOC) costs (e.g. AWS S3, Google Cloud Storage, Azure Storage Account).
# Additionally, it allows Kubecost to reconcile Kubecost's in-cluster estimates with actual billing data to improve accuracy.


# https://www.ibm.com/docs/en/kubecost/self-hosted/2.x?topic=integration-aws-cloud-using-irsaeks-pod-identities
# https://github.com/kubecost/docs-cloud/blob/main/cloud-billing-integrations/aws-cloud-integration.md



# Product key: The product key is used to activate Kubecost Enterprise or Kubecost Cloud features.
# KubecostToken: Used for cloud-based kubecost deployments or integrations with Kubecost cloud, allowing secure authentication and communication with Kubecost's backend services