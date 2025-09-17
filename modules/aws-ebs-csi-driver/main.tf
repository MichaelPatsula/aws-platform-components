######################
## EKS Pod Identity ##
######################

resource "aws_iam_role" "aws_ebs_csi_driver_eks_pod_identity" {
  name = "aws-ebs-csi-driver-pod-identity"

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

resource "aws_iam_role_policy_attachment" "aws_ebs_csi_driver_eks_pod_identity" {
  role       = aws_iam_role.aws_ebs_csi_driver_eks_pod_identity.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "aws_ebs_csi_driver_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "aws-ebs-csi-driver-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.aws_ebs_csi_driver_eks_pod_identity.arn
}
