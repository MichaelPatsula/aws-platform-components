######################
## EKS Pod Identity ##
######################

resource "aws_iam_role" "cert_manager_eks_pod_identity" {
  name = "cert-manager-pod-identity"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "pods.eks.amazonaws.com"
        },
        Action = ["sts:AssumeRole", "sts:TagSession"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cert_manager_eks_pod_identity" {
  role       = aws_iam_role.cert_manager_eks_pod_identity.name
  policy_arn = aws_iam_policy.cert_manager_eks_pod_identity.arn
}

# cert-manager needs to be able to add records to Route53 in order to solve the DNS01 challenge.
# The route53:ListHostedZonesByName statement can be removed if you specify the (optional) hostedZoneID.
# You can further tighten the policy by limiting the hosted zone that cert-manager has access to (e.g. arn:aws:route53:::hostedzone/DIKER8JEXAMPLE).
# https://cert-manager.io/docs/configuration/acme/dns01/route53/
resource "aws_iam_policy" "cert_manager_eks_pod_identity" {
  name = "cert-manager-route53-dns01"
  description = "Allow cert-manager to solve DNS01 with Route53"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["route53:GetChange"],
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow",
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        Resource = "arn:aws:route53:::hostedzone/*"
        Condition = {
          "ForAllValues:StringEquals" = {
            "route53:ChangeResourceRecordSetsRecordTypes" = ["TXT"]
          }
        }
      },
      {
        Effect   = "Allow"
        Action   = "route53:ListHostedZonesByName"
        Resource = "*"
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "cert_manager_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "cert-manager-system"
  service_account = "cert-manager"
  role_arn        = aws_iam_role.cert_manager_eks_pod_identity.arn
}
