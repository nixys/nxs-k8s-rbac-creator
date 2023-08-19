apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${certificate-authority-data}
    server: ${server}
  name: ${k8s_cluster_name}
users:
- name: ${sa_name}
  user:
    token: ${sa_token}
contexts:
- context:
    cluster: ${k8s_cluster_name}
    user: ${sa_name}
    namespace: ${namespace}
  name: ${sa_name}
current-context: ${sa_name}