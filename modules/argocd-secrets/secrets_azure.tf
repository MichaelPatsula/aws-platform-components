resource "aws_secretsmanager_secret" "azure" {
  name = "${var.name}/azure"
}

resource "aws_secretsmanager_secret_version" "azure" {
  secret_id     = aws_secretsmanager_secret.azure.id
  secret_string = jsonencode({
    tenant_id = var.azure_secrets.tenant_id
  })
}