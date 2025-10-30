
resource "aws_secretsmanager_secret" "aurora_controller_image_pull_secret" {
  name = "${var.name}/aurora-controller"
}

resource "aws_secretsmanager_secret_version" "aurora_controller_image_pull_secret" {
  secret_id     = aws_secretsmanager_secret.aurora_controller_image_pull_secret.id
  secret_string = jsonencode({
    image-pull-secret = var.cnp_controller.image_pull_secret
  })
}
