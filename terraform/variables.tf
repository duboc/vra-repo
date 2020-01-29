variable vra_url {
  type    = string
  default = "https://api.mgmt.cloud.vmware.com"
}

variable vra_refresh_token {
  type = string
}

variable project_name {
  type    = string
  default = "Terraform"
}

variable name_prefix {
  type    = string
  default = "terraform"
}

variable tags {
  type = string
}

variable flavor {
  type    = string
  default = "Medium"
}

variable image {
  type    = string
  default = "Ubuntu"
}

variable machine_description {
  type    = string
  default = ""
}
