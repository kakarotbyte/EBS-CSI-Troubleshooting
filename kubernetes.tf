provider "kubernetes" {
    host = module.eks_two.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_two.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_two.cluster_name]
  }
}
