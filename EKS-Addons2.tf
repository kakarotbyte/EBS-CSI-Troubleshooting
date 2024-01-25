#### Create Addons 2nd Demo Cluster
module "eks_blueprints_addons_two" {
  source  = "aws-ia/eks-blueprints-addons/aws"

  cluster_name      = module.eks_two.cluster_name
  cluster_endpoint  = module.eks_two.cluster_endpoint
  cluster_version   = module.eks_two.cluster_version
  oidc_provider_arn = module.eks_two.oidc_provider_arn
  
  # EKS Add-ons
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn= aws_iam_role.ebs_csi_role_two.arn
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

####Create Role For EBS CSI2nd Demo Cluster
data "aws_iam_policy_document" "ebs_policy_driver_assume_role_policy_two" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks_two.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller"]
    }

    principals {
      identifiers = [module.eks_two.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

#### attach Policy for EBS CSI 2nd Demo Cluster
resource "aws_iam_role" "ebs_csi_role_two" {
  assume_role_policy = data.aws_iam_policy_document.ebs_policy_driver_assume_role_policy_two.json
}
resource "aws_iam_role_policy_attachment" "ebs_policy_two" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_role_two.name
}
