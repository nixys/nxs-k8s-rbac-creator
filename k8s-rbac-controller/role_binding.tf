resource "kubernetes_role_binding" "role_binding" {
  for_each = {
    for v in local.roles_binding_array : "${v.role}_${v.prefix}_${v.namespace}" => v if v.type == "role_binding"
  }

  metadata {
    name      = "${each.value["role"]}-${each.value["prefix"]}-role"
    namespace = each.value["namespace"]
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = each.value["role"]
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
      name      = subject.value.name
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

  depends_on = [kubernetes_role.roles]
}

resource "kubernetes_role_binding" "role_binding_cluster_role" {
  for_each = {
    for v in local.roles_binding_cluster_role_array : "${v.cluster_role}_${v.prefix}_${v.namespace}" => v if v.type == "role_binding"
  }

  metadata {
    name      = "${each.value["cluster_role"]}-${each.value["prefix"]}-cluster-role"
    namespace = each.value["namespace"]
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
      name      = subject.value.name
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
