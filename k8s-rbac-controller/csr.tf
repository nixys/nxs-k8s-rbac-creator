resource "tls_private_key" "user_keypair" {
  for_each = {
    for i in local.users_array : "${i.name}-${i.group}" => i
  }

  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "tls_cert_request" "user_csr" {

  for_each = {
    for i in local.users_array : "${i.name}-${i.group}" => i
  }

  private_key_pem = tls_private_key.user_keypair[each.key].private_key_pem

  subject {
    common_name  = each.value.name
    organization = each.value.group
  }
}

resource "kubernetes_certificate_signing_request_v1" "user_csr" {
  for_each = tls_cert_request.user_csr

  metadata {
    name = each.key
  }

  spec {
    usages  = ["client auth"]
    request = each.value.cert_request_pem
    signer_name = "kubernetes.io/kube-apiserver-client"
  }
  auto_approve = true
}
