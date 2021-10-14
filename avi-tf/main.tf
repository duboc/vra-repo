terraform {
  required_providers {
    avi = {
      source  = "vmware/avi"
      version = "21.1.1"
    }
  }
}

provider "avi" {
  avi_username = var.username
  avi_tenant = var.tenant
  avi_password = var.password
  avi_controller = var.controller
  avi_version = "21.1.1"
}  


data "avi_tenant" "default_tenant" {
  name= "admin"
 }
data "avi_applicationprofile" "system_http_profile" {
  name= "System-HTTP"
 }

data "avi_cloud" "default_cloud" {
  name= "Defaul-Cloud"
 }

data "avi_sslkeyandcertificate" "system_default_cert" {
    name= "System-Default-Cert"
}

data "avi_sslprofile" "system_standard_sslprofile" {
    name= "System-Standard"
}

resource "avi_networkprofile" "network_profile1" {
  name = "tf-network-profile"
  profile {
    type = "PROTOCOL_TYPE_TCP_PROXY"
    tcp_proxy_profile {
      ignore_time_wait = false
      time_wait_delay = 2000
      max_retransmissions = 8
      max_syn_retransmissions = 8
      automatic = true
      receive_window = 64
      nagles_algorithm = false
      ip_dscp = 0
      reorder_threshold = 10
      min_rexmt_timeout = 100
      idle_connection_type = "KEEP_ALIVE"
      idle_connection_timeout = 600
      use_interface_mtu = true
      cc_algo = "CC_ALGO_NEW_RENO"
      aggressive_congestion_avoidance = false
      slow_start_scaling_factor = 1
      congestion_recovery_scaling_factor = 2
      reassembly_queue_size = 0
      keepalive_in_halfclose_state = true
      auto_window_growth = true
    }
  }
  connection_mirror = false
  tenant_ref = data.avi_tenant.default_tenant.id
}

resource "avi_healthmonitor" "test_hm_1" {
  name       = "terraform-monitor"
  type       = "HEALTH_MONITOR_HTTP"
  tenant_ref = data.avi_tenant.default_tenant.id
}

resource "avi_pool" "testpool" {
  name= "pool-42"
  health_monitor_refs= [avi_healthmonitor.test_hm_1.id]
  tenant_ref= data.avi_tenant.default_tenant.id
  cloud_ref= data.avi_cloud.default_cloud.id
  servers {
    ip {
      type= "V4"
      addr= var.address
    }
    port= 8080
  }
  fail_action {
    type= "FAIL_ACTION_CLOSE_CONN"
  }
}
resource "avi_vsvip" "test_vsvip" {
  name = "terraform-vip-1"
  vip {
    vip_id = "0"
    ip_address {
      type = "V4"
      addr = "192.168.100.5"
    }
  }
  cloud_ref = data.avi_cloud.default_cloud.id
  tenant_ref = data.avi_tenant.default_tenant.id
}
resource "avi_virtualservice" "https_vs" {
  name                          = "tf_vs"
  pool_ref                      = avi_pool.testpool.id
  tenant_ref                    = data.avi_tenant.default_tenant.id
  vsvip_ref                     = avi_vsvip.test_vsvip.id
  cloud_ref                     = data.avi_cloud.default_cloud.id
  ssl_key_and_certificate_refs  = [data.avi_sslkeyandcertificate.system_default_cert.id]
  ssl_profile_ref               = data.avi_sslprofile.system_standard_sslprofile.id
  application_profile_ref       = data.avi_applicationprofile.system_http_profile.id
  network_profile_ref           = avi_networkprofile.network_profile1.id
  cloud_type                    = "CLOUD_VCENTER"
  services {
    port           = 8443
    enable_ssl     = true
  }
}