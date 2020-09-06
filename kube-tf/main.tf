provider "kubernetes" {
    host = "https://api.dubokops.vmwlatam.com"

    username = "var.username" 
    password = "var.password"
    insecure = var.security

    load_config_file = false
}


resource "kubernetes_pod" "nginx" {
    metadata {
        name = "nginx-example"
        labels = {
            App = "nginx"
        } 
    }

    spec {
        container {
            image = "nginx:1.7.8"
            name = "example"
            
            port {
                container_port = 80
            } 
        } 
    }
} 



