data "template_file" "users_kubeconfig" {

  for_each = kubernetes_certificate_signing_request.user_csr
  template = file("${path.module}/users-kubeconfig.tpl")
  vars = {
    certificate-authority-data = local.certificate_authority_data
    server                     = var.k8s_api_endpoint
    k8s_cluster_name           = var.k8s_cluster_name
    user                       = each.key
    client-certificate-data    = base64encode(each.value.certificate)
    client-key-data            = base64encode(lookup(tls_private_key.user_keypair, each.key).private_key_pem)
  }

  depends_on = [kubernetes_certificate_signing_request.user_csr]
}

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

data "template_file" "sa_kubeconfig" {

  for_each = {
    for k, v in local.sa_array : "${v.name}_${v.namespace}" => v
  }

  template = file("${path.module}/sa-kubeconfig.tpl")
  vars = {
    certificate-authority-data = local.certificate_authority_data
    server                     = var.k8s_api_endpoint
    k8s_cluster_name           = var.k8s_cluster_name
    sa_name                    = each.value["name"]
    namespace                  = each.value["namespace"]
    sa_token                   = lookup(data.kubernetes_secret.sa["${each.value["name"]}_${each.value["namespace"]}"].data, "token")
  }

  depends_on = [data.kubernetes_secret.sa]
}
