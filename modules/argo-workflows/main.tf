data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "argo_workflows" {
  bucket = "argo-workflows-${data.aws_caller_identity.this.account_id}"

  tags = {
    Name = "argo-workflows"
  }
}

######################
## EKS Pod Identity ##
######################

resource "aws_iam_role" "argo_workflows_eks_pod_identity" {
  name = "argo-workflows-pod-identity-role"

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

resource "aws_iam_role_policy_attachment" "argo_workflows_eks_pod_identity" {
  policy_arn = aws_iam_policy.argo_workflows_eks_pod_identity.arn
  role       = aws_iam_role.argo_workflows_eks_pod_identity.name
}

# https://argo-workflows.readthedocs.io/en/latest/configure-artifact-repository/#configuring-aws-s3
resource "aws_iam_policy" "argo_workflows_eks_pod_identity" {
  name        = "argo-workflows-s3-access"
  description = "Policy to allow argo-workflows to use S3 bucket as an artifact repository"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",        
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
        ],
        Resource = ["${aws_s3_bucket.argo_workflows.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [aws_s3_bucket.argo_workflows.arn]
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "argo_workflows_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "argo-workflows-system"
  service_account = "argo-workflows-sa"
  role_arn        = aws_iam_role.argo_workflows_eks_pod_identity.arn
}

#########
## SSO ##
#########

module "argo_workflow_sso_sp" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-azure-service-principal.git?ref=v2.0.0"

  azure_resource_attributes = var.resource_attributes
  user_defined              = "argo-workflow"

  owners = var.service_principal_owners

  web_redirect_uris = ["https://argo-workflows.${var.dns_zone_name}/oauth2/callback"]

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
}
