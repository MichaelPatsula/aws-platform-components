variable "name" {
  description = "A user-defined field that describes the Azure resource."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.name) >= 2 && length(var.name) <= 15
    error_message = "The user-defined field must be between 2-15 characters long."
  }
}

###############
### Secrets ###
###############

variable "argo_workflow_secrets" {
  description = "The secrets for the Argo Workflows component."
  type = object({
    sso_service_principal = object({
      client_id     = string
      client_secret = string
    })
    artifact_repository = object({
      bucket = string
      region = string
    })
  })
  sensitive = true
}

variable "argocd_secrets" {
  description = "The secrets for the Argo CD component."
  type = object({
    sso = optional(object({
      tenant_id     = string
      client_id     = string
      client_secret = string
    }))
    helm_repositories = optional(map(object({
      url      = string
      username = string
      password = string
    })))
    git_repositories = optional(map(object({
      url      = string
      username = string
      password = string
    })))
    cluster_registration = object({
      server = string
      token  = string
      caCert = string
    })
  })
  sensitive = true
}

variable "azure_secrets" {
  description = "Azure secrets"
  type = object({
    tenant_id = string
  })
}

variable "kubernetes_cluster" {
  description = "The secrets related to the Kubernetes cluster."
  type = object({
    load_balancer_subnet_name = string
  })
}

variable "cnp_controller" {
  description = "The secrets related to the cnp-controller component."
  type = object({
    image_pull_secret = string  # The image pull secret for the cluster. The value should be the .dockerconfigjson. The value is non-automated.
  })
  sensitive = true
}

variable "kiali_secrets" {
  description = "The non-automated secrets for the Kiali component. It may be best to input them manually."
  type = object({
    grafana_token = string
  })
  default   = null
  sensitive = true
}

# variable "kubecost_secrets" {
#   description = "The non-automated secrets for the Kubecost component. It may be best to input them manually."
#   type = object({
#     service_principal = object({
#       client_id     = string
#       client_secret = string
#     })
#     token       = string
#     product_key = string
#   })
#   default   = null
#   sensitive = true
# }

variable "loki_secrets" {
  description = "The secrets for the Loki component."
  type = object({
    username = optional(string, "loki-ingest")
    password = optional(string)
  })
  default = {
    username = "loki-ingest"
    password = null
  }
  sensitive = true
}

variable "velero_secrets" {
  description = "The secrets for the Velero component."
  type = object({
    s3 = object({
      bucket = string
    })
  })
}

variable "grafana_secrets" {
  description = "The secrets for the Grafana component."
  type = object({
    admin_password = optional(string)
    sso_service_principal = object({
      client_id     = string
      client_secret = string
    })
  })
  sensitive = true
}

variable "alertmanager_secrets" {
  description = "The secrets for the Alertmanager component."
  type = object({
    jira = optional(object({
      api_url  = string
      user     = string
      password = string
    }))
    msteams_connector = object({
      testing           = string
      prod_critical     = string
      prod_major        = string
      prod_minor        = string
      non_prod_critical = string
      non_prod_major    = string
      non_prod_minor    = string
      dev_critical      = string
      dev_major         = string
      dev_minor         = string
    })
    smtp = object({
      smarthost = string
      username  = string
      password  = string
    })
  })
  default   = null
  sensitive = true
}
