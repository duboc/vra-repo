variable "minha_lista" {
    type    = list(string)
    default = ["objetoA", "objetoB", "objectoC"]
}


variable "user_information" {
      type = object({
              name    = string
              address = string
                    })
}

variable "prefix" {
  default = "duboc"
  description = "The prefix which should be used for all resources in this example"
}

variable "zona" {
  default = 1
} 

variable "location" {
  default = "Brazil South"
  description = "The Azure Region in which all resources in this example should be created."
}
