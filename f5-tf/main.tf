provider "bigip" {
  address  = var.hostname
  username = var.username
  password = var.password
}

resource bigip_ltm_node "this" {
  count            = var.quantidade
  name             = "/Common/${var.namePrefix}-${count.index}"
  address          = var.ip_address[count.index]
  connection_limit = "0"
  dynamic_ratio    = "1"
  monitor          = "/Common/icmp"
  description      = ""
  rate_limit       = "disabled"
}

resource bigip_ltm_pool "this" {
  name                = "/Common/${var.namePrefix}-pool"
  load_balancing_mode = "round-robin"
  description         = ""
  monitors            = ["/Common/https"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource bigip_ltm_pool_attachment "this" {
  count = 3
  pool  = bigip_ltm_pool.this.name
  node = "${bigip_ltm_node.this[count.index].name}:80"
}

resource bigip_ltm_virtual_server "this" {
  name                       = "/Common/${var.virtual_server_name}"
  destination                = var.virtual_server_ip
  description                = var.virtual_server_description
  port                       = var.virtual_server_port
  pool                       = bigip_ltm_pool.this.id
  profiles                   = ["/Common/serverssl"]
  source_address_translation = "automap"
  translate_address          = "enabled"
  translate_port             = "enabled"
}
