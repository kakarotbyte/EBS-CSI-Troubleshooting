output "cluster_one_id" {
    value = module.eks.cluster_id
}
output "cluster_one_endpoint" {
    value = module.eks.cluster_endpoint
}

output "cluster_two_id" {
    value = module.eks_two.cluster_id
}
output "cluster_two_endpoint" {
    value = module.eks_two.cluster_endpoint
}

output "cluster_two_name" {
    value = module.eks_two.cluster_name
}

output "cluster_one_name" {
    value = module.eks.cluster_name
}
output "EBS_volume_name" {
  value = aws_ebs_volume.static.id
}