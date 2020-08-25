provider vra {
  url           = var.vra_url
  refresh_token = var.vra_refresh_token
}

data vra_project "this" {
  name = var.project_name
}


resource random_id "this" {
  byte_length = 8
}


resource "vra_deployment" "this" {
  name        = "${var.name_prefix}-${random_id.this.hex}"
  description = ""
  project_id  = data.vra_project.this.id
}


resource "vra_machine" "this" {
  count         = 1
  name          = "${var.name_prefix}-${count.index}"
  description   = var.machine_description
  project_id    = data.vra_project.this.id
  image         = var.image
  flavor        = var.flavor
  deployment_id = vra_deployment.this.id

  constraints {
    mandatory  = true
    expression = var.tags
  }
}