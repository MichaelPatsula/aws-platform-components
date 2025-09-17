######################
## EKS Pod Identity ##
######################

resource "aws_iam_role" "aws_loadbalancer_controller_eks_pod_identity" {
  name = "aws-loadbalancer-controller-pod-identity"

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

resource "aws_iam_role_policy_attachment" "aws_loadbalancer_controller_eks_pod_identity" {
  role       = aws_iam_role.aws_loadbalancer_controller_eks_pod_identity.name
  policy_arn = aws_iam_policy.aws_loadbalancer_controller_eks_pod_identity.arn
}


resource "aws_iam_policy" "aws_loadbalancer_controller_eks_pod_identity" {
  name = "aws-loadbalancer-controller"
  description = "AWS Loadbalancer Controller"

  policy = jsonencode(local.aws_loadbalancer_controller_policy)
}

resource "aws_eks_pod_identity_association" "aws_loadbalancer_controller_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "aws-loadbalancer-controller-system"
  service_account = "aws-loadbalancer-controller"
  role_arn        = aws_iam_role.aws_loadbalancer_controller_eks_pod_identity.arn
}
