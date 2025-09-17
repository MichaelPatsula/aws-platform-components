###########################
### Argo Workflow - SSO ###
###########################

resource "aws_secretsmanager_secret" "argo_workflows_sso" {
  name = "${var.name}/argo-workflows/sso"
}

resource "aws_secretsmanager_secret_version" "argo_workflows_sso" {
  secret_id     = aws_secretsmanager_secret.argo_workflows_sso.id
  secret_string = jsonencode(var.argo_workflow_secrets.sso_service_principal)
}

###########################################
### Argo Workflow - Artifact Repository ###
###########################################
# https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/#configuring-aws-s3

resource "aws_secretsmanager_secret" "argo_workflows_artifact_repository" {
  name = "${var.name}/argo-workflows/artifact-repository"
}

resource "aws_secretsmanager_secret_version" "argo_workflows_artifact_repository" {
  secret_id     = aws_secretsmanager_secret.argo_workflows_artifact_repository.id
  secret_string = jsonencode(var.argo_workflow_secrets.artifact_repository)
}