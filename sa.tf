resource "kubernetes_service_account" "service_account" {
  for_each = {
    for k, v in local.sa_array : "${v.name}_${v.namespace}" => v
  }

  metadata {
    namespace = each.value["namespace"]
    name      = each.value["name"]
  }
}
