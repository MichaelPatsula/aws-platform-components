data "aws_caller_identity" "this" {}

resource "aws_s3_bucket" "velero" {
  bucket = "${var.name}-velero-backups-${data.aws_caller_identity.this.account_id}"

  tags = {
    Name = "velero-backups"
  }
}

######################
## EKS Pod Identity ##
######################

resource "aws_iam_role" "velero_eks_pod_identity" {
  name = "${var.name}-velero-pod-identity-role"

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

resource "aws_iam_role_policy_attachment" "velero_eks_pod_identity" {
  policy_arn = aws_iam_policy.velero_eks_pod_identity.arn
  role       = aws_iam_role.velero_eks_pod_identity.name
}

resource "aws_iam_policy" "velero_eks_pod_identity" {
  name        = "${var.name}-velero-s3-access"
  description = "Policy to allow Velero to access S3 bucket for backups & create snapshots of volumes"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",        
        Action = [
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ],
        Resource = ["${aws_s3_bucket.velero.arn}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVolumes",
          "ec2:DescribeSnapshots",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [aws_s3_bucket.velero.arn]
      }
    ]
  })
}

resource "aws_eks_pod_identity_association" "velero_eks_pod_identity" {
  cluster_name    = var.cluster_name
  namespace       = "velero-system"
  service_account = "velero-server"
  role_arn        = aws_iam_role.velero_eks_pod_identity.arn
}
