data "kubernetes_secret" "sa" {
  for_each = {
    for k, v in local.sa_array : "${v.name}_${v.namespace}" => v
  }

  metadata {
    name      = kubernetes_service_account.service_account["${each.value["name"]}_${each.value["namespace"]}"].default_secret_name
    namespace = each.value["namespace"]
  }

  depends_on = [kubernetes_service_account.service_account]
}