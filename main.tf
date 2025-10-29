module "argo_workflows" {
    count = var.component_toggle.argo_workflows ? 1 : 0
    source = "./modules/argo-workflows"

    resource_attributes      = var.resource_attributes
    naming_convention        = var.naming_convention
    name                     = var.name
    dns_zone_name            = var.dns_zone_name
    service_principal_owners = var.service_principal_owners
    cluster_name             = var.cluster_name 
}

module "argocd" {
    count = var.component_toggle.argocd ? 1 : 0
    source = "./modules/argocd"

    resource_attributes         = var.resource_attributes
    naming_convention           = var.naming_convention
    name                        = var.name
    dns_zone_name               = var.dns_zone_name
    service_principal_owners    = var.service_principal_owners
    cluster_name                = var.cluster_name
}

module "argocd_vault_plugin_secrets" {
    count = var.component_toggle.argocd_secrets ? 1 : 0
    source = "./modules/argocd-secrets"

    name = var.name

    argo_workflow_secrets = {
        sso_service_principal = {
            client_id     = module.argo_workflows[0].sso_service_principal.application_registration.client_id
            client_secret = module.argo_workflows[0].sso_service_principal.application_registration_password.value
        }
        artifact_repository = {
            bucket = module.argo_workflows[0].s3_bucket.bucket
            region = data.aws_region.this.name
        }
    }
    velero_secrets = {
        s3 = {
            bucket = module.velero[0].s3_bucket.bucket
        }
    }
    grafana_secrets =  var.component_toggle.grafana ? {
        admin_password = try(var.argocd_secrets.grafana.admin_password, null)
        sso_service_principal = {
            client_id     = module.grafana[0].sso_service_principal.application_registration.client_id
            client_secret = module.grafana[0].sso_service_principal.application_registration_password.value
        }
    } : null

    argocd_secrets        = var.argocd_secrets.argocd_secrets
    azure_secrets         = var.argocd_secrets.azure_secrets      
    kubernetes_cluster    = var.argocd_secrets.kubernetes_cluster
    cnp_controller        = var.argocd_secrets.cnp_controller
    kiali_secrets         = var.argocd_secrets.kiali_secrets
    loki_secrets          = var.argocd_secrets.loki_secrets
    alertmanager_secrets  = var.argocd_secrets.alertmanager_secrets
}

module "aws_ebs_csi_driver" {
    count = var.component_toggle.aws_ebs_csi_driver ? 1 : 0
    source = "./modules/aws-ebs-csi-driver"

    name                        = var.name
    cluster_name                = var.cluster_name
}

module "aws_loadbalancer_controller" {
    count = var.component_toggle.aws_loadbalancer_controller ? 1 : 0
    source = "./modules/aws-loadbalancer-controller"

    name                        = var.name
    cluster_name                = var.cluster_name
}

module "cert-manager" {
    count = var.component_toggle.cert_manager ? 1 : 0
    source = "./modules/cert-manager"

    name                    = var.name
    cluster_name            = var.cluster_name     
}

module "grafana" {
    count = var.component_toggle.grafana ? 1 : 0
    source = "./modules/grafana"

    resource_attributes      = var.resource_attributes
    naming_convention        = var.naming_convention
    name                     = var.name    
    dns_zone_name            = var.dns_zone_name
    service_principal_owners = var.service_principal_owners
    grafana_sso_sp_members   = var.grafana_sso_sp_members   
}

module "velero" {
    count = var.component_toggle.velero ? 1 : 0
    source = "./modules/velero"

    name         = var.name
    cluster_name = var.cluster_name     
}
