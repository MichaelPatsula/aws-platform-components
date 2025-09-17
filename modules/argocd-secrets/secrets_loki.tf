locals {
  loki_username = try(var.loki_secrets.username, "loki-ingest")
  loki_password = try(var.loki_secrets.password, random_password.loki_password[0].result)
}

resource "aws_secretsmanager_secret" "loki_user" {
  name = "${var.name}/loki/user"
}

resource "aws_secretsmanager_secret_version" "loki_user" {
  secret_id     = aws_secretsmanager_secret.loki_user.id
  secret_string = jsonencode({
    user          = local.loki_username
    password      = local.loki_password
    authorization = "Basic ${base64encode("${local.loki_username}:${local.loki_password}")}"
  })
}

resource "random_password" "loki_password" {
  count = try(var.loki_secrets.password, null) == null ? 1 : 0
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
