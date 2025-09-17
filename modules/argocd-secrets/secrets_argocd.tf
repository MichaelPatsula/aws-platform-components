####################
### ArgoCD - SSO ###
####################

resource "aws_secretsmanager_secret" "argocd_sso" {
  count = var.argocd_secrets.sso != null ? 1 : 0

  name = "${var.name}/argocd/sso"
}

resource "aws_secretsmanager_secret_version" "argocd_sso" {
  count = var.argocd_secrets.sso != null ? 1 : 0

  secret_id     = aws_secretsmanager_secret.argocd_sso[0].id
  secret_string = jsonencode(var.argocd_secrets.sso)
}

################################
### ArgoCD - Helm Repository ###
################################

resource "aws_secretsmanager_secret" "argocd_helm_repository" {
  for_each = nonsensitive(var.argocd_secrets.helm_repositories)

  name = "${var.name}/argocd/${each.key}-helm-repository"
}

resource "aws_secretsmanager_secret_version" "argocd_helm_repository" {
  for_each = nonsensitive(var.argocd_secrets.helm_repositories)

  secret_id     = aws_secretsmanager_secret.argocd_helm_repository[each.key].id
  secret_string = jsonencode(each.value)
}

###############################
### ArgoCD - Git Repository ###
###############################

resource "aws_secretsmanager_secret" "argocd_git_repository" {
  for_each = nonsensitive(var.argocd_secrets.git_repositories)

  name = "${var.name}/argocd/${each.key}-git-repository"
}

resource "aws_secretsmanager_secret_version" "argocd_git_repository" {
  for_each = nonsensitive(var.argocd_secrets.git_repositories)

  secret_id     = aws_secretsmanager_secret.argocd_git_repository[each.key].id
  secret_string = jsonencode(each.value)
}


#####################################
### ArgoCD - Cluster Registration ###
#####################################

resource "aws_secretsmanager_secret" "argocd_cluster_registration" {
  name = "${var.name}/argocd/cluster-registration"
}

resource "aws_secretsmanager_secret_version" "argocd_cluster_registration" {
  secret_id     = aws_secretsmanager_secret.argocd_cluster_registration.id
  secret_string = jsonencode(var.argocd_secrets.cluster_registration)
}
