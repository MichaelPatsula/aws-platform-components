#########
## SSO ##
#########

module "argocd_sso_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.resource_attributes
  user_defined              = "argocd"

  owners = var.service_principal_owners

  web_redirect_uris = ["https://platform-argocd.${var.dns_zone_name}/auth/callback"]

  group_membership_claims = ["All", "ApplicationGroup"]
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
}

############################################
## ArgoCD Vault Plugin - EKS Pod Identity ##
############################################

resource "aws_iam_role" "argocd_eks_pod_identity" {
  name = "argocd-pod-identity-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "pods.eks.amazonaws.com"
      },
      Action = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "argocd_eks_pod_identity" {
  policy_arn = aws_iam_policy.argocd_eks_pod_identity.arn
  role       = aws_iam_role.argocd_eks_pod_identity.name
}

# https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/#configuring-aws-s3
resource "aws_iam_policy" "argocd_eks_pod_identity" {
  name        = "argocd-secrets-access"
  description = "Policy to allow argocd to fetch secrets from AWS SecretManager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",        
        Action = ["secretsmanager:GetSecretValue"],
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "argocd_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "platform-management-system"
  service_account = "argocd-sa"
  role_arn        = aws_iam_role.argocd_eks_pod_identity.arn
}
