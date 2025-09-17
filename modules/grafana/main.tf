#########
## SSO ##
#########

module "grafana_sso_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.resource_attributes
  naming_convention         = var.naming_convention
  user_defined              = "grafana"

  owners = var.service_principal_owners

  web_redirect_uris = [
    "https://grafana.${var.dns_zone_name}/login/azuread",
    "https://grafana.${var.dns_zone_name}"
  ]

  group_membership_claims = ["SecurityGroup", "ApplicationGroup"]
  optional_claims = {
    access_tokens = [{
      name = "groups"
    }]
    id_tokens = [{
      name = "groups"
    }]
    saml2_tokens = [{
      name = "groups"
    }]
  }

  roles_and_members = {
    Grafana_Viewer = {
      description = "Grafana read only Users"
      value       = "Viewer"
      members     = var.grafana_sso_sp_members.viewer
    }
    Grafana_Editor = {
      description = "Grafana Editor Users"
      value       = "Editor"
      members     = var.grafana_sso_sp_members.editor
    }
    Grafana_Admin = {
      description = "Grafana admin Users"
      value       = "Admin"
      members     = var.grafana_sso_sp_members.admin
    }
  }
}
