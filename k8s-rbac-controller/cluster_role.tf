resource "kubernetes_cluster_role" "cluster_roles" {
  for_each = {
    for k, v in local.cluster_roles_array : "${v.name}" => v
  }
  metadata {
    name = each.value["name"]
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
