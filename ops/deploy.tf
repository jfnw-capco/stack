variable "token" {}
variable "node_image_id" {}
variable "short_branch" {}

provider "digitalocean" {
    token = "${var.token}"
}


# Create a new droplet
resource "digitalocean_droplet" "node" {
    image  = "${var.node_image_id}"
    name   = "io-delineate-node-${var.short_branch}-${count.index + 1}"
    region = "lon1"
    size   = "1gb"
    ssh_keys = [17505046]
}

# Starts up the containers
provisioner "local-exec" {
    command = "/app/startup.sh"
  }


# Creates the load balancer
resource "digitalocean_loadbalancer" "lb" {
  name = "io-delineate-lb"
  region = "lon1"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 22
    protocol = "tcp"
  }

  droplet_ids = ["${digitalocean_droplet.node.id}"]
}


# Add a record to the domain
resource "digitalocean_record" "api" {
  domain = "delineate.io"
  type   = "A"
  name   = "api"
  value  = "${digitalocean_loadbalancer.lb.ip}"
}

