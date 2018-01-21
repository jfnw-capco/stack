variable "token" {}
variable "branch" {}
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
variable "lb_count" {}

provider "digitalocean" {
    token = "${var.token}"
}


# Creates a tag for the branch 
resource "digitalocean_tag" "branch_tag" {
  name = "${var.branch}"
}

# Create a new droplet
resource "digitalocean_droplet" "master" {
    image  = "docker-16-04"
    name   = "${var.namespace}-${var.app}-${var.branch}-master-${count.index + 1}"
    region = "${var.region}"
    size   = "${var.size}"
    private_networking = true
    ssh_keys = "${var.node_keys}"
}

# Create a new droplet
resource "digitalocean_droplet" "node" {
    image  = "${var.image_id}"
    count  = "${var.node_count}"
    name   = "${var.namespace}-${var.app}-${var.branch}-node-${count.index + 1}"
    region = "${var.region}"
    size   = "${var.size}"
    tags   = ["${digitalocean_tag.branch_tag.id}"]
    private_networking = true
    ssh_keys = "${var.node_keys}"
    user_data = <<EOF
#!/bin/bash
cd /app
docker-compose -p "api" up --scale app=3 -d
EOF
}


# Creates the load balancer
resource "digitalocean_loadbalancer" "lb" {
  name = "${var.namespace}-${var.app}-${var.branch}-lb-${count.index + 1}"
  count  = "${var.lb_count}"
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

  droplet_tag = "${digitalocean_tag.branch_tag.name}"
}


resource "digitalocean_firewall" "public" {
  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-public-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "80"
      source_load_balancer_uids = ["${digitalocean_loadbalancer.lb.*.id}"]
    },
    {
      protocol                  = "tcp"
      source_addresses     = ["${digitalocean_droplet.master.id}"]
    },
    {
      protocol                  = "udp"
      source_addresses     = ["${digitalocean_droplet.master.id}"]
    }
  ]
  outbound_rule = [
    {
      protocol                  = "icmp"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "tcp"
      port_range                = "80"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "tcp"
      destination_addresses     = ["${digitalocean_droplet.master.id}"]
    },
    {
      protocol                  = "udp"
      destination_addresses     = ["${digitalocean_droplet.master.id}"]
    }
  ]
}


resource "digitalocean_firewall" "master" {
  droplet_ids = ["${digitalocean_droplet.master.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-swarm-fw"
  inbound_rule = [
    {
      protocol                = "tcp"
      source_addresses        = ["${digitalocean_droplet.node.*.id}"]
    },
    {
      protocol                = "udp"
      source_addresses        = ["${digitalocean_droplet.node.*.id}"]
    }
  ]
  outbound_rule = [
    {
      protocol                = "icmp"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                = "tcp"
      destination_addresses   = ["${digitalocean_droplet.node.*.id}"]
    },
    {
      protocol                = "udp"
      destination_droplet_ids = ["${digitalocean_droplet.node.*.id}"]
    }
  ]
}

# Add a record to the domain
resource "digitalocean_record" "api" {
  domain = "${var.domain}"
  type   = "A"
  name   = "${var.app}"
  count  = "${var.lb_count}"
  value  = "${digitalocean_loadbalancer.lb.*.ip[count.index]}"
}