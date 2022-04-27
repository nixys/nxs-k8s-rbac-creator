resource "kubernetes_role" "roles" {
  for_each = {
    for k, v in local.roles_array : "${v.name}_${v.namespace}" => v
  }
  metadata {
    name      = each.value["name"]
    namespace = each.value["namespace"]
  }

  dynamic "rule" {
    for_each = each.value["rules"]

    content {
      api_groups     = rule.value["api_groups"]
      resources      = rule.value["resources"]
      verbs          = rule.value["verbs"]
      resource_names = try(rule.value["resource_names"], null)
    }
  }
}
