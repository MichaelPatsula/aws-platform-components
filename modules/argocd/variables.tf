variable "resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    department_code = string
    owner           = string
    project         = string
    environment     = string
    location        = optional(string, "Canada Central")
    instance        = number
  })
  nullable = false
}

variable "naming_convention" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "dns_zone_name" {
    type = string
}

variable "service_principal_owners" {
    type = list(string)
}