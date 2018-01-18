variable "token" {}
variable "image_id" {}
variable "region" {}
variable "size" {}
variable "app" {}
variable "namespace" {}
variable "domain" {}
variable "node_count" {}
variable "node_keys" {
  type = "list"
}

provider "digitalocean" {
    token = "${var.token}"
}

# Create a new droplet
resource "digitalocean_droplet" "node" {
    image  = "${var.image_id}"
    count  = "${var.node_count}"
    name   = "${var.namespace}.${var.app}.${count.index + 1}"
    region = "${var.region}"
    size   = "${var.size}"
    ssh_keys = "${var.node_keys}"
    user_data = <<EOF
#!/bin/bash
cd /app
docker-compose -p "api" up --scale app=3 -d
EOF
}


# Creates the load balancer
resource "digitalocean_loadbalancer" "lb" {
  name = "${var.namespace}-${var.app}-lb"
  region = "${var.region}"

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

  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
}


# Add a record to the domain
resource "digitalocean_record" "api" {
  domain = "${var.domain}"
  type   = "A"
  name   = "${var.app}"
  value  = "${digitalocean_loadbalancer.lb.ip}"
}