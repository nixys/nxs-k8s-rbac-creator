#==================== Files ==================== #
variable "output_files_path" {
  description = "Path where save kubeconfig and tls files."
  default     = "./files"
  type        = string
}

#==================== K8S ==================== #
variable "k8s_api_endpoint" {
  description = "The hostname (in form of URI) of the Kubernetes API."
  type        = string
}

variable "k8s_insecure" {
  description = "Whether the server should be accessed without verifying the TLS certificate."
  type        = bool
  default     = false
}

variable "k8s_auth_cluster_ca_certificate" {
  description = "PEM-encoded root certificates bundle for TLS authentication."
  type        = any

  validation {
    condition     = can(var.k8s_auth_cluster_ca_certificate.raw) || can(var.k8s_auth_cluster_ca_certificate.encoded)
    error_message = "The \"k8s_auth_cluster_ca_certificate\" argument must be a object!"
  }

  validation {
    condition     = anytrue([(length(try(var.k8s_auth_cluster_ca_certificate.raw, "")) > 0 ? true : false), (length(try(var.k8s_auth_cluster_ca_certificate.encoded, "")) > 0 ? true : false)])
    error_message = "One of field (raw or encoded) must be set!"
  }
}

variable "default_k8s_auth_cluster_ca_certificate" {
  description = "Defautl values for k8s_auth_cluster_ca_certificate"
  type = object(
    {
      raw     = string,
      encoded = string,
  })
  default = {
    raw     = ""
    encoded = ""
  }
}

variable "k8s_cluster_name" {
  description = "k8s cluster name."
  type        = string
}

variable "k8s_config_path" {
  description = "k8s config path."
  type        = string
}

variable "k8s_config_context" {
  description = "k8s config context."
  default     = null
  type        = string
}

#==================== K8S users ==================== #
variable "roles_list" {
  description = "List to create roles."
  type = list(object(
    {
      name      = string,
      namespace = string,
      rules = list(object(
        {
          api_groups = list(string),
          resources  = list(string),
          verbs      = list(string)
      }))
    })
  )

  validation {
    condition     = alltrue([for i in var.roles_list : alltrue([length(i.rules) > 0 ? true : false])])
    error_message = "Rules list must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.roles_list : alltrue([for j in i.rules : length(j.api_groups) > 0 ? true : false])])
    error_message = "List of api_groups must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.roles_list : alltrue([for j in i.rules : length(j.resources) > 0 ? true : false])])
    error_message = "List of resources must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.roles_list : alltrue([for j in i.rules : length(j.verbs) > 0 ? true : false])])
    error_message = "List of verbs must not be empty!"
  }

}

variable "cluster_roles_list" {
  description = "List to create cluster roles."
  type = list(object(
    {
      name = string,
      rules = list(object(
        {
          api_groups = list(string),
          resources  = list(string),
          verbs      = list(string)
      }))
    })
  )

  validation {
    condition     = alltrue([for i in var.cluster_roles_list : alltrue([length(i.rules) > 0 ? true : false])])
    error_message = "Rules list must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.cluster_roles_list : alltrue([for j in i.rules : length(j.api_groups) > 0 ? true : false])])
    error_message = "List of api_groups must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.cluster_roles_list : alltrue([for j in i.rules : length(j.resources) > 0 ? true : false])])
    error_message = "List of resources must not be empty!"
  }

  validation {
    condition     = alltrue([for i in var.cluster_roles_list : alltrue([for j in i.rules : length(j.verbs) > 0 ? true : false])])
    error_message = "List of verbs must not be empty!"
  }

}

variable "sa_list" {
  description = "List to create sa."
  type = list(object(
    {
      name      = string,
      namespace = string
    })
  )
}

variable "bindings" {
  description = "List of users and sa for roles and cluster roles bindings."
  type        = any

  validation {
    condition     = alltrue([for i in var.bindings : anytrue([length(lookup(i, "sa", [])) > 0 ? true : false, length(lookup(i, "users", [])) > 0 ? true : false, length(lookup(i, "groups", [])) > 0 ? true : false])])
    error_message = "Sa, users or groups list must be set!"
  }

  validation {
    condition     = alltrue([for i in var.bindings : anytrue([length(lookup(i, "roles", [])) > 0 ? true : false, length(lookup(i, "cluster_roles", [])) > 0 ? true : false])])
    error_message = "Roles or CluserRoles list must be set!"
  }

  validation {
    condition     = alltrue([for i in var.bindings : anytrue([length(lookup(i, "namespaces", [])) > 0 ? true : false]) if i.type == "role_binding"])
    error_message = "Namespaces list must be set for role binding!"
  }

  validation {
    condition     = alltrue([for i in var.bindings : anytrue([length(lookup(i, "cluster_roles", [])) > 0 ? true : false]) if i.type == "cluster_role_binding"])
    error_message = "Cluster roles list must be set for cluster role binding!"
  }

  validation {
    condition     = alltrue([for i in var.bindings : contains(["role_binding", "cluster_role_binding"], i.type)])
    error_message = "Only role_binding or cluster_role_binding type supported!"
  }

}

variable "default_bindings" {
  description = "Uses to set default values for bindings."
  type = object({
    type          = string
    prefix        = string
    namespaces    = list(string)
    sa            = list(map(string))
    users         = list(map(string))
    groups        = list(string)
    roles         = list(string)
    cluster_roles = list(string)
  })
  default = {
    type          = ""
    prefix        = ""
    namespaces    = []
    sa            = []
    users         = []
    groups        = []
    roles         = []
    cluster_roles = []
  }
}
