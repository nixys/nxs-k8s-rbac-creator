# nxs-k8s-rbac-creator

## Introduction

nxs-k8s-rbac-creator is a terraform module that create RBAC rules for k8s.

### Features

- Create service accounts and users
- Generate kubeconfigs for them
- Create role bindings and cluster role bindings for service accounts, users and groups

### Who can use the tool

Developers and admins which work with different namespaces in k8s.

## Quickstart

[Set up](#settings) the nxs-k8s-rbac-creator terraform file, then init and run module.

### Settings

| Variable | Required | Default value | Description |
|---       | :---:    | :---:         |---          |
| `output_files_path` | true | ./files | The path to directorie where save generated tls files and kubeconfig for users and service accounts |
| `k8s_api_endpoint` | | true | The hostname (in form of URI) of the Kubernetes API |
| `k8s_insecure` | true | false | Whether the server should be accessed without verifying the TLS certificate |
| `k8s_cluster_name` | true | | k8s cluster name |
| `k8s_auth_cluster_ca_certificate` | true | | PEM-encoded root certificates bundle for TLS authentication |
| `k8s_auth_cluster_ca_certificate.raw` | false | | Raw certificate. Example: "-----BEGIN CERTIFICATE-----\nMIIELDCCApSgAwIBAgIQcLahmhzRbVMSRZX2cQXtuTANBgkqhkiG9w0BAQsFADAv\n...\n-----END CERTIFICATE-----\n". |
| `k8s_auth_cluster_ca_certificate.encoded` | false | | Base64 encoded certificate |
| `k8s_config_path` | true | | The path for kubeconfig |
| `k8s_config_context` | false | | Kubeconfig context |
| `roles_list` | true | | List of create roles|
| `roles_list.name` | true | | Role name |
| `roles_list.namespace` | true | | Role namespace |
| `roles_list.rules` | true | | List of rules |
| `roles_list.rules.api_groups` | true | | List of api groups |
| `roles_list.rules.resources` | true | | List of resources |
| `roles_list.rules.verbs` | true | | List of verbs |
| `roles_list.rules.resource_names` | false | | White list of names that the rule applies to |
| `cluster_roles_list` | true | | List of cluster roles |
| `cluster_roles_list.name` | true | | Cluster role name |
| `cluster_roles_list.rules` | true | | List of rules |
| `cluster_roles_list.rules.api_groups` | true | | List of api groups |
| `cluster_roles_list.rules.resources` | true | | List of resources |
| `cluster_roles_list.rules.verbs` | true | | List of verbs |
| `cluster_roles_list.rules.resource_names` | false | | White list of names that the rule applies to |
| `sa_list` | true | | List of service accounts |
| `sa_list.name` | true | | Service account name |
| `sa_list.namespace` | true | | Service account namespace |
| `bindings` | true | | List of bindings |
| `bindings.type` | true | | Type of binding (role_binding or cluster_role_binding) |
| `bindings.prefix` | true | | Unique string that use in binding name |
| `bindings.namespaces` | false | | List of namespaces where role binding create. Uses only for role binding |
| `bindings.sa_list` | false | | List of service accounts |
| `bindings.sa_list.name` | true | | Service account name |
| `bindings.sa_list.namespace` | true | | Service account namespace |
| `bindings.users` | false | | List of users. Users create from this list |
| `bindings.users.name` | true | | Name of the user |
| `bindings.users.group` | true | | User group |
| `bindings.groups` | false | | List of groups |
| `bindings.roles` | false | | List of roles |
| `bindings.cluster_roles` | false | | List of cluster roles |

**Note:** One of field `raw` or `encoded` must be set. If both are given, the `raw` field will be used.

**Note:** Variables `k8s_api_endpoint`, `k8s_auth_cluster_ca_certificate` and `k8s_cluster_name` needed for generate kubeconfig.

**Note:** Value for `type` variable may be one of this: role_binding or cluster_role_binding.

**Note:** Variable `namespaces` uses only for role binding. If variable is empty for role binding deploy will fail.

**Note:** One of variable (`sa_list`, `users`, `groups`) must be set for all bindings type.

**Note:** Users creates from `users` variable.

**Note:** Variables `roles` or `cluster_roles` must be set for role binding.

**Note:** Variable `cluster_roles` must be set for cluster role binding.

#### Example

Usage example located in this [directory](example).

## Roadmap

## Feedback

For support and feedback please contact me:
- telegram: [@aarchimaev](https://t.me/aarchimaev)
- e-mail: a.archimaev@nixys.ru

## License

nxs-k8s-rbac-creator is released under the [Apache License 2.0](LICENSE).
