resource "aws_secretsmanager_secret" "velero_storage" {
  name = "${var.name}/velero/storage"
}

resource "aws_secretsmanager_secret_version" "velero_storage" {
  secret_id     = aws_secretsmanager_secret.velero_storage.id
  secret_string = jsonencode(var.velero_secrets.s3)
}
