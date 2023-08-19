resource "kubernetes_secret" "sa" {
  for_each = {
    for k, v in local.sa_array : "${v.name}_${v.namespace}" => v
  }

  metadata {
    name      = format("%s-%s", each.value["name"], "token-secret")
    namespace = each.value["namespace"]

    annotations = {
      "kubernetes.io/service-account.name"      = each.value["name"]
      "kubernetes.io/service-account.namespace" = each.value["namespace"]
    }
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [kubernetes_service_account.service_account]
}
