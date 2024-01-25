module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "ebs-demo-1"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  eks_managed_node_groups = {
    green = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_types = ["t3.large"]

    }
  }
  # aws-auth configmap
  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


module "eks_two" {
  source  = "terraform-aws-modules/eks/aws"

  cluster_name    = "ebs-demo-2"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = true
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  eks_managed_node_groups = {
    blue = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_types = ["t3.large"]

    }
  }
  # aws-auth configmap
  manage_aws_auth_configmap = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

