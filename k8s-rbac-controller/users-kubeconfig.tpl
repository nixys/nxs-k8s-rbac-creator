apiVersion: v1
kind: Config
clusters:
- cluster:
    certificate-authority-data: ${certificate-authority-data}
    server: ${server}
  name: ${k8s_cluster_name}
users:
- name: ${user}
  user:
    client-certificate-data: ${client-certificate-data}
    client-key-data: ${client-key-data}
contexts:
- context:
    cluster: ${k8s_cluster_name}
    user: ${user}
  name: ${user}-${k8s_cluster_name}
current-context: ${user}-${k8s_cluster_name}