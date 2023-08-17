#==================== Users ==================== #
resource "local_file" "users_kubeconfigs" {
  for_each = kubernetes_certificate_signing_request_v1.user_csr
  content             =  templatefile("${path.module}/users-kubeconfig.tpl", {
    certificate-authority-data = local.certificate_authority_data
    server                     = var.k8s_api_endpoint
    k8s_cluster_name           = var.k8s_cluster_name
    user                       = each.key
    client-certificate-data    = base64encode(each.value.certificate)
    client-key-data            = base64encode(lookup(tls_private_key.user_keypair, each.key).private_key_pem)
  })
  file_permission      = "0600"
  directory_permission = "0700"
  filename             = "${var.output_files_path}/users/${each.key}/kubeconfig.yaml"
}

resource "local_file" "private_key" {
  for_each             = tls_private_key.user_keypair
  content              = each.value.private_key_pem
  filename             = "${var.output_files_path}/users/${each.key}/tls/private_key"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "user_csr" {
  for_each             = tls_cert_request.user_csr
  content              = each.value.cert_request_pem
  filename             = "${var.output_files_path}/users/${each.key}/tls/csr"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "user_crt" {
  for_each             = kubernetes_certificate_signing_request_v1.user_csr
  content              = each.value.certificate
  filename             = "${var.output_files_path}/users/${each.key}/tls/user_crt"
  file_permission      = "0600"
  directory_permission = "0700"
}

#==================== Sa ==================== #
resource "local_file" "sa_kubeconfigs" {
  for_each = {
    for k, v in local.sa_array : "${v.name}_${v.namespace}" => v
  }
  content             =  templatefile("${path.module}/sa-kubeconfig.tpl", {
    certificate-authority-data = local.certificate_authority_data
    server                     = var.k8s_api_endpoint
    k8s_cluster_name           = var.k8s_cluster_name
    sa_name                    = each.value["name"]
    namespace                  = each.value["namespace"]
    sa_token                   = lookup(data.kubernetes_secret.sa["${each.value["name"]}_${each.value["namespace"]}"].data, "token")
  })
  file_permission      = "0600"
  directory_permission = "0700"
  filename             = "${var.output_files_path}/sa/${each.key}/kubeconfig.yaml"
}
