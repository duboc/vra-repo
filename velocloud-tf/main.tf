terraform {
  required_providers {
    velocloud = {
      source = "adeleporte/velocloud"
    }
  }
}

provider "velocloud" {
  vco = "https://vco124-usca1.velocloud.net/portal/rest"
  token = var.myToken
}

 
data "velocloud_profile" "duboc_profile" {
    name = "duboc-profile"
}
 
resource "velocloud_edge" "duboc_edge" {
 
  configurationid               = data.velocloud_profile.duboc_profile.id
  modelnumber                   = "virtual"
 
  name                          = "duboc_edge"
 
  site {
    name                        = "duboc_"
    contactname                 = "Duboc"
    contactphone                = "+551010101010"
    contactmobile               = "+556010101010"
    contactemail                = "duboc@duboc.com"
    streetaddress               = "muquifo"
    city                        = "paulista"
    country                     = "SP"
 
    shippingstreetaddress       = "It's somewhere in the cloud"
    shippingcity                = "Cloud"
    shippingcountry             = "CM"
 
    lat                         = 53.397
    lon                         = -2
 
    shippingsameaslocation      = true
  }
}
 
output "duboc_edge_key" {value = velocloud_edge.duboc_edge.activationkey}
