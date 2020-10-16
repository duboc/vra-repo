variable "avi_username" {
  type    = string
  default = "admin"
}
variable "avi_password" {
  type    = string
  default = "Admin!23"
}
variable "avi_controller" {
  type    = string
  default = "10.186.217.36"
}
variable "avi_version" {
  type    = string
  default = "20.1.1"
}
variable "pool_name" {
  type    = string
  default = "duboc-pool"
}
variable "lb_algorithm" {
  type    = string
  default = "LB_ALGORITHM_ROUND_ROBIN"
}
variable "server1_ip" {
  type    = string
  default = "192.168.110.50"
}
variable "server1_port" {
  type    = number
  default = 80
}
variable "application_profile1" {
  type    = string
  default = "System-HTTP"
}
variable "poolgroup_name" {
  type    = string
  default = "poolgroup1"
}
variable "avi_terraform_vs_vip" {
  type    = string
  default = "172.27.100.205"
}
variable "vs_name" {
  type    = string
  default = "vs1"
}
variable "vs_port" {
  type    = number
  default = 80
}
variable "network_profile" {
  type    = string
  default = "System-TCP-Proxy"
}

