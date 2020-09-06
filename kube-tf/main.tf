provider "kubernetes" {
    host = "https://api.dubokops.vmwlatam.com"
    
    insecure = true
    load_config_file = false
}


resource "kubernetes_namespace" "meuSpace" {
    metadata {
        name = "meunamespace"
    } 
} 

