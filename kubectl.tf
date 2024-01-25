####
# data "kubectl_file_documents" "namespace"{
#     content = file("ns.yaml")
# }
# resource "kubectl_manifest" "ns-create" {
#     for_each  = data.kubectl_file_documents.namespace.manifests
#     yaml_body = each.value
#   depends_on = [
#     module.eks,
#     module.eks_blueprints_addons
#   ]
# }

data "kubectl_file_documents" "docs" {
    content = file("default-pod.yaml")
}
resource "kubectl_manifest" "ebs_csi_dynamic_provisioning_SC_PVC_POD" {
    for_each  = data.kubectl_file_documents.docs.manifests
    yaml_body = each.value
  depends_on = [
    module.eks,
    module.eks_blueprints_addons
  ]
}
# data "kubectl_file_documents" "static" {
#     content = file("static-pod.yaml")
# }
# resource "kubectl_manifest" "ebs_csi_static-provisioning_SC_PVC_POD" {
#     for_each  = data.kubectl_file_documents.static.manifests
#     yaml_body = each.value   
#   depends_on = [
#     module.eks,
#     module.eks_blueprints_addons
#   ]
# }