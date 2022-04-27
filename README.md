# k8s-rbac-controller

k8s-rbac-controller is an open source module for terraform. This module create service accounts and users, then generate kubeconfig for them. Also module create role bindings and cluster role bindings for service accounts, users and groups.

# Variables

* `output_files_path`: the path to directorie where save generated tls files and kubeconfig for users and service accounts. Default: "./files".
* `k8s_api_endpoint`: the hostname (in form of URI) of the Kubernetes API.
* `k8s_insecure`: whether the server should be accessed without verifying the TLS certificate. Default: false.
* `k8s_cluster_name`: k8s cluster name.
* `k8s_auth_cluster_ca_certificate`: PEM-encoded root certificates bundle for TLS authentication.
* * `raw`(optional): raw certificate. Example: "-----BEGIN CERTIFICATE-----\nMIIELDCCApSgAwIBAgIQcLahmhzRbVMSRZX2cQXtuTANBgkqhkiG9w0BAQsFADAv\n...\n-----END CERTIFICATE-----\n".
* * `encoded`(optional): base64 encoded certificate.

**Note:** One of field `raw` or `encoded` must be set. If both are given, the `raw` field will be used.

**Note:** Variables `k8s_api_endpoint`, `k8s_auth_cluster_ca_certificate` and `k8s_cluster_name` needed for generate kubeconfig.

* `k8s_config_path`: the path for kubeconfig.
* `k8s_config_context`(optional): kubeconfig context.
* `roles_list`: list of create roles.
* * `name`: role name.
* * `namespace`: role namespace.
* * `rules`: list of rules.
* * * `api_groups`: list of api groups.
* * * `resources`: list of resources.
* * * `verbs`: list of verbs.
* * * `resource_names`(optional): white list of names that the rule applies to.
* `cluster_roles_list`: list of cluster roles.
* * `name`: cluster role name.
* * `rules`: list of rules.
* * * `api_groups`: list of api groups.
* * * `resources`: list of resources.
* * * `verbs`: list of verbs.
* * * `resource_names`(optional): white list of names that the rule applies to.
* `sa_list`: list of service accounts.
* * `name`:  service account name.
* * `namespace`:  service account namespace.
* `bindings`: list of bindings.
* * `type`: type of binding (role_binding or cluster_role_binding).
* * `prefix`: unique string that use in binding name.
* * `namespaces`(optional): list of namespaces where role binding create. Uses only for role binding.
* * `sa_list`(optional): list of service accounts.
* * * `name`:  service account name.
* * * `namespace`:  service account namespace.
* * `users`(optional): list of users. Users create from this list.
* * * `name`: name of the user.
* * * `group`: user group.
* * `groups`(optional): list of groups.
* * `roles`(optional): list of roles.
* * `cluster_roles`(optional): list of cluster roles

**Note:** Value for `type` variable may be one of this: role_binding or cluster_role_binding.

**Note:** Variable `namespaces` uses only for role binding. If variable is empty for role binding deploy will fail.

**Note:** One of variable (`sa_list`, `users`, `groups`) must be set for all bindings type.

**Note:** Users creates from `users` variable.

**Note:** Variables `roles` or `cluster_roles` must be set for role binding.

**Note:** Variable `cluster_roles` must be set for cluster role binding.

# Module usage example

* Usage example located in this [directory](example).
