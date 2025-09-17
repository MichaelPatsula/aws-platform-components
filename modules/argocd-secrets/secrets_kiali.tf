
# The Grafana token Kiali uses. The role of the token should be "Viewer".
resource "aws_secretsmanager_secret" "kiali_grafana_token" {
  count = var.kiali_secrets != null ? 1 : 0

  name = "${var.name}/kiali/grafana-token"
}

resource "aws_secretsmanager_secret_version" "kiali_grafana_token" {
  count = var.kiali_secrets != null ? 1 : 0

  secret_id     = aws_secretsmanager_secret.kiali_grafana_token[0].id
  secret_string = var.kiali_secrets.grafana_token
}

