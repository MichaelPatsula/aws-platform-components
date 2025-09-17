# terraform-aurora-azure-environment-argo-secrets

This repository contains an opionionated Terraform module that can be used to handle the Argo Secrets that are stored in Azure Key Vault.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.26.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_resource_names"></a> [azure\_resource\_names](#module\_azure\_resource\_names) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names.git | v2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_workflow_secrets"></a> [argo\_workflow\_secrets](#input\_argo\_workflow\_secrets) | The secrets for the Argo Workflows component. | <pre>object({<br>    sso_service_principal = object({<br>      client_id     = string<br>      client_secret = string<br>    })<br>    storage_account = object({<br>      name     = string<br>      endpoint = string<br>      key      = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_argocd_keyvault_id"></a> [argocd\_keyvault\_id](#input\_argocd\_keyvault\_id) | The Azure resource ID of the Azure Key Vault which contains the ArgoCD secrets. | `string` | n/a | yes |
| <a name="input_azure_resource_attributes"></a> [azure\_resource\_attributes](#input\_azure\_resource\_attributes) | Attributes used to describe Azure resources | <pre>object({<br>    project     = string<br>    environment = string<br>    location    = optional(string, "Canada Central")<br>    instance    = number<br>  })</pre> | n/a | yes |
| <a name="input_azure_secrets"></a> [azure\_secrets](#input\_azure\_secrets) | The Azure related secrets. | <pre>object({<br>    tenant_id       = string<br>    subscription_id = string<br>  })</pre> | n/a | yes |
| <a name="input_cert_manager_secrets"></a> [cert\_manager\_secrets](#input\_cert\_manager\_secrets) | The secrets for the Cert-Manager component. | <pre>object({<br>    aad_pod_identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_grafana_secrets"></a> [grafana\_secrets](#input\_grafana\_secrets) | The secrets for the Grafana component. | <pre>object({<br>    admin_password = optional(string)<br>    sso_service_principal = object({<br>      client_id     = string<br>      client_secret = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_kubernetes_cluster"></a> [kubernetes\_cluster](#input\_kubernetes\_cluster) | The secrets related to the Kubernetes cluster. | <pre>object({<br>    server = string<br>    argocd_sa = object({<br>      token  = string<br>      caData = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_velero_secrets"></a> [velero\_secrets](#input\_velero\_secrets) | The secrets for the Velero component. | <pre>object({<br>    aad_pod_identity = object({<br>      client_id   = string<br>      resource_id = string<br>    })<br>    storage_account = object({<br>      name                = string<br>      resource_group_name = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_alertmanager_secrets"></a> [alertmanager\_secrets](#input\_alertmanager\_secrets) | The secrets for the Alertmanager component. | <pre>object({<br>    msteams_connector = object({<br>      testing           = string<br>      prod_critical     = string<br>      prod_major        = string<br>      prod_minor        = string<br>      non_prod_critical = string<br>      non_prod_major    = string<br>      non_prod_minor    = string<br>      dev_critical      = string<br>      dev_major         = string<br>      dev_minor         = string<br>    })<br>    smtp = object({<br>      smarthost = string<br>      username  = string<br>      password  = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_argocd_secrets"></a> [argocd\_secrets](#input\_argocd\_secrets) | The secrets for the Argo CD component. | <pre>object({<br>    helm_repositories = map(object({<br>      url      = string<br>      username = string<br>      password = string<br>    }))<br>    git_repositories = map(object({<br>      url      = string<br>      username = string<br>      password = string<br>    }))<br>  })</pre> | <pre>{<br>  "git_repositories": {},<br>  "helm_repositories": {}<br>}</pre> | no |
| <a name="input_loki_secrets"></a> [loki\_secrets](#input\_loki\_secrets) | The secrets for the Loki component. | <pre>object({<br>    username = optional(string, "loki-ingest")<br>    password = optional(string)<br>  })</pre> | <pre>{<br>  "password": null,<br>  "username": "loki-ingest"<br>}</pre> | no |
| <a name="input_image_pull_secret"></a> [image\_pull\_secret](#input\_image\_pull\_secret) | The image pull secret for the cluster. The value should be the .dockerconfigjson. The value is non-automated. It may be best to input them manually. | `string` | `null` | no |
| <a name="input_kiali_secrets"></a> [kiali\_secrets](#input\_kiali\_secrets) | The non-automated secrets for the Kiali component. It may be best to input them manually. | <pre>object({<br>    grafana_token = string<br>  })</pre> | `null` | no |
| <a name="input_kubecost_secrets"></a> [kubecost\_secrets](#input\_kubecost\_secrets) | The non-automated secrets for the Kubecost component. It may be best to input them manually. | <pre>object({<br>    service_principal = object({<br>      client_id     = string<br>      client_secret = string<br>    })<br>    token       = string<br>    product_key = string<br>  })</pre> | `null` | no |


<!-- END_TF_DOCS -->

## History

| Date       | Release | Change                                                                                                           |
| ---------- | ------- | ---------------------------------------------------------------------------------------------------------------- |
| 2025-01-25 | v1.0.0  | Initial commit of Argo Secrets for Azure Key Vault                                                               |
