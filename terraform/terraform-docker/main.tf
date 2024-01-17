terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0.0"
    }
  }

}


provider "docker" {}
provider "random" {

}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}


resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
  count   = 1
}

resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    #external = 1880
  }
}



output "container-name" {
  value       = docker_container.nodered_container[*].name
  description = "name of container"
}


output "ip-address-and-external-port" {
  value       = [for i in docker_container.nodered_container[*] : join(":", i.network_data[*]["ip_address"], i.ports[*].external)]
  description = "network data from node red container"
}


