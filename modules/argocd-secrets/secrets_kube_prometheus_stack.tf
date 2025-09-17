#####################
### Grafana - SSO ###
#####################

resource "aws_secretsmanager_secret" "grafana_azuread_oauth_sp" {
  name = "${var.name}/grafana/azuread_oauth_sp"
}

resource "aws_secretsmanager_secret_version" "grafana_azuread_oauth_sp" {
  secret_id     = aws_secretsmanager_secret.grafana_azuread_oauth_sp.id
  secret_string = jsonencode({
    client_id     = var.grafana_secrets.sso_service_principal.client_id
    client_secret = var.grafana_secrets.sso_service_principal.client_secret
  })
}

###############################
### Grafana - Admin Account ###
###############################

resource "aws_secretsmanager_secret" "grafana_credentials" {
  name = "${var.name}/grafana/credentials"
}

resource "aws_secretsmanager_secret_version" "grafana_credentials" {
  secret_id     = aws_secretsmanager_secret.grafana_credentials.id
  secret_string = var.grafana_secrets.admin_password != null ? var.grafana_secrets.admin_password : jsonencode({
    admin = random_password.grafana_admin_password.result
  })
}

resource "random_password" "grafana_admin_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

###########################
### AlertManager - Jira ###
###########################

resource "aws_secretsmanager_secret" "alertmanager_jira" {
  count = try(var.alertmanager_secrets.jira, null) != null ? 1 : 0

  name = "${var.name}/alertmanager/jira"
}

resource "aws_secretsmanager_secret_version" "alertmanager_jira" {
  count = try(var.alertmanager_secrets.jira, null) != null ? 1 : 0
  
  secret_id     = aws_secretsmanager_secret.alertmanager_jira[0].id
  secret_string = jsonencode({
    jira_api_url  = var.alertmanager_secrets.jira.api_url
    jira_user     = var.alertmanager_secrets.jira.user
    jira_password = var.alertmanager_secrets.jira.password
  })
}

###############################
### AlertManager - MS Teams ###
###############################

resource "aws_secretsmanager_secret" "alertmanager_notifications_msteams" {
  name = "${var.name}/alertmanager/notifications-msteams"
}

resource "aws_secretsmanager_secret_version" "alertmanager_notifications_msteams" {
  secret_id     = aws_secretsmanager_secret.alertmanager_notifications_msteams.id
  secret_string = jsonencode(var.alertmanager_secrets.msteams_connector)
}

###########################
### AlertManager - SMTP ###
###########################

resource "aws_secretsmanager_secret" "alertmanager_notifications_smtp" {
  name = "${var.name}/alertmanager/notifications-smtp"
}

resource "aws_secretsmanager_secret_version" "alertmanager_notifications_smtp" {
  secret_id     = aws_secretsmanager_secret.alertmanager_notifications_smtp.id
  secret_string = jsonencode(var.alertmanager_secrets.smtp)
}
