provider "nsxt" {
  host                  = "10.182.3.46"
  username              = "admin"
  password              = "Admin!23Admin"
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}
