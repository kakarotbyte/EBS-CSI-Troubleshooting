#### Create Addons #####
module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn
  
  # EKS Add-ons
  eks_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn= aws_iam_role.ebs_csi_role.arn
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

####Create Role For EBS CSI#### 
data "aws_iam_policy_document" "ebs_policy_driver_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(module.eks.oidc_provider_arn, "/^(.*provider/)/", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [module.eks.oidc_provider_arn]
      type        = "Federated"
    }
  }
}

#### attach Policy for EBS CSI ####
resource "aws_iam_role" "ebs_csi_role" {
  assume_role_policy = data.aws_iam_policy_document.ebs_policy_driver_assume_role_policy.json
}
resource "aws_iam_role_policy_attachment" "ebs_policy" {
  policy_arn = aws_iam_policy.ebs_custom_deny_policy.arn
  role       = aws_iam_role.ebs_csi_role.name
}

resource "aws_iam_policy" "ebs_custom_deny_policy" {
  name        = "ebs_custom_deny_policy"
  description = "ebs_custom_deny_policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("ebs-custom-policy.json")
}

resource "aws_ebs_volume" "static" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 40

  tags = {
    Name = "static-mount-volume"
  }
}