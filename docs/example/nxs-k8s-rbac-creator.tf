module "k8s-rbac-controller" {
  source = "github.com/nixys/nxs-k8s-rbac-creator"

  output_files_path = "./files"

  k8s_api_endpoint = "https://172.20.1.2"
  k8s_auth_cluster_ca_certificate = {
    raw     = "-----BEGIN CERTIFICATE-----\nMIIELDCCApSgAwIBAgIQcLahmhzRbVMSRZX2cQXtuTANBgkqhkiG9w0BAQsFADAv\n ... 8hZp/GUpn6jahcXxmuKaAQ==\n-----END CERTIFICATE-----\n"
    encoded = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS..."
  }
  k8s_cluster_name   = "cluster-name"
  k8s_config_path    = "~/.kube/config"
  k8s_config_context = "config-context"

  roles_list = [
    {
      name      = "role-1",
      namespace = "default",
      rules = [
        {
          api_groups = [""],
          resources  = ["pods"],
          verbs      = ["get", "list"],
        }
      ]
    }
  ]

  cluster_roles_list = [
    {
      name = "cluster-role-1",
      rules = [
        {
          api_groups = [""],
          resources  = ["namespaces"],
          verbs      = ["get", "list", "watch", "create"],
        }
      ]
    },
    {
      name = "cluster-role-2",
      rules = [
        {
          api_groups = [""],
          resources  = ["namespaces"],
          verbs      = ["get"]
        },
        {
          api_groups = [""],
          resources  = ["namespaces"],
          verbs      = ["list"]
        }
      ]
    }
  ]

  sa_list = [
    {
      name      = "sa-1"
      namespace = "kube-system"
    },
    {
      name      = "sa-2"
      namespace = "default"
    },
  ]

  bindings = [
    {
      type       = "role_binding"
      prefix     = "prefix-1"
      namespaces = ["default"]
      sa = [
        {
          name      = "sa-1",
          namespace = "kube-system",
        }
      ],
      users = [
        {
          name  = "user-1",
          group = "group-1",
        },
        {
          name  = "user-2",
          group = "group-2",
        }
      ]
      groups        = ["group-1"]
      roles         = ["role-1"]
      cluster_roles = ["cluster-role-2"]
    },
    {
      type   = "cluster_role_binding"
      prefix = "prefix-2"
      sa = [
        {
          name      = "sa-2",
          namespace = "default",
        }
      ],
      users = [
        {
          name  = "user-2",
          group = "group-2",
        }
      ],
      cluster_roles = ["cluster-role-1"]
    },
  ]

}
