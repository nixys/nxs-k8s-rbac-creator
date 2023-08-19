resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  for_each = {
    for v in local.cluster_roles_binding_array : "${v.cluster_role}_${v.prefix}" => v if v.type == "cluster_role_binding"
  }

  metadata {
    name = "${each.value["cluster_role"]}-${each.value["prefix"]}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = each.value["cluster_role"]
  }

  dynamic "subject" {
    for_each = coalesce(each.value["sa"], [])

    content {
      kind      = "ServiceAccount"
      name      = subject.value["name"]
      namespace = subject.value["namespace"]
    }
  }

  dynamic "subject" {
    for_each = coalesce(each.value["users"], [])

    content {
      kind      = "User"
      name      = subject.value["name"]
      api_group = "rbac.authorization.k8s.io"
    }
  }

  dynamic "subject" {
    for_each = coalesce(each.value["groups"], [])

    content {
      kind      = "Group"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }

  depends_on = [kubernetes_cluster_role.cluster_roles]
}
