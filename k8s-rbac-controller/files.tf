#==================== Users ==================== #
resource "local_file" "users_kubeconfigs" {
  for_each             = data.template_file.users_kubeconfig
  file_permission      = "0600"
  directory_permission = "0700"
  sensitive_content    = each.value.rendered
  filename             = "${var.output_files_path}/users/${each.key}/kubeconfig.yaml"
}

resource "local_file" "private_key" {
  for_each             = tls_private_key.user_keypair
  sensitive_content    = each.value.private_key_pem
  filename             = "${var.output_files_path}/users/${each.key}/tls/private_key"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "user_csr" {
  for_each             = tls_cert_request.user_csr
  sensitive_content    = each.value.cert_request_pem
  filename             = "${var.output_files_path}/users/${each.key}/tls/csr"
  file_permission      = "0600"
  directory_permission = "0700"
}

resource "local_file" "user_crt" {
  for_each             = kubernetes_certificate_signing_request.user_csr
  sensitive_content    = each.value.certificate
  filename             = "${var.output_files_path}/users/${each.key}/tls/user_crt"
  file_permission      = "0600"
  directory_permission = "0700"
}

#==================== Sa ==================== #
resource "local_file" "sa_kubeconfigs" {
  for_each             = data.template_file.sa_kubeconfig
  file_permission      = "0600"
  directory_permission = "0700"
  sensitive_content    = each.value.rendered
  filename             = "${var.output_files_path}/sa/${each.key}/kubeconfig.yaml"
}
