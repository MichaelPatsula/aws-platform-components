variable "resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    department_code = string
    owner           = string
    project         = string
    environment     = string
    location        = optional(string, "Canada Central")
    instance        = number
  })
  nullable = false
}

variable "naming_convention" {
    type = string
}

variable "name" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "dns_zone_name" {
    type = string
}

variable "service_principal_owners" {
    type = list(string)
}

######################
## Component Toggle ##
######################

variable "component_toggle" {
  description = "Platform component toggle"
  type = object({
    argo_workflows              = optional(bool, true)
    argocd                      = optional(bool, true)
    argocd_secrets              = optional(bool, true)
    aws_ebs_csi_driver          = optional(bool, true)
    aws_loadbalancer_controller = optional(bool, true)
    cert_manager                = optional(bool, true)
    grafana                     = optional(bool, true)
    velero                      = optional(bool, true)
  })
}

#############
## Grafana ##
#############

variable "grafana_sso_sp_members" {
  description = "The members to configure on the Grafana SSO service principal"
  type = object({
    viewer = optional(map(string))
    editor = optional(map(string))
    admin  = optional(map(string))
  })
  default = {
    viewer = {}
    editor = {}
    admin  = {} 
  }  
}

####################
## ArgoCD Secrets ##
####################

variable "argocd_secrets" {
    type = object({
        argocd_secrets = optional(object({
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
        }))
        azure_secrets = object({
          tenant_id = string
        })
        kubernetes_cluster = optional(object({
            load_balancer_subnet_name = string
        }))
        cnp_controller = optional(object({
            image_pull_secret = string
        }))
        kiali_secrets = optional(object({
            grafana_token = string
        }))
        loki_secrets = optional(object({
            username = optional(string)
            password = optional(string)
        }))
        velero_secrets = optional(object({
            s3 = object({
                bucket = string
            })
        }))
        alertmanager_secrets = optional(object({
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
        }))
        grafana = optional(object({
            admin_password = string
        }))
    })
    
    sensitive = true
}
