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


# Creates a tag for the nodes 
resource "digitalocean_tag" "node_tag" {
  name = "node-${var.branch}"
}


# Creates a tag for the masters
resource "digitalocean_tag" "master_tag" {
  name = "master-${var.branch}"
}


# Create a new droplet
resource "digitalocean_droplet" "master" {
    image  = "docker-16-04"
    name   = "${var.namespace}-${var.app}-${var.branch}-master-${count.index + 1}"
    region = "${var.region}"
    size   = "${var.size}"
    tags   = ["${digitalocean_tag.master_tag.id}"]
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
    tags   = ["${digitalocean_tag.node_tag.id}"]
    private_networking = true
    ssh_keys = "${var.node_keys}"
    user_data = <<EOF
#!/bin/bash
./startup/startup.sh
}


# Creates the load balancer
resource "digitalocean_loadbalancer" "public" {
  name = "${var.namespace}-${var.app}-${var.branch}-public-${count.index + 1}"
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

  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
}


resource "digitalocean_firewall" "public" {
  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-public-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "80"
      source_load_balancer_uids = ["${digitalocean_loadbalancer.public.*.id}"]
    },
    {
      protocol                  = "tcp"
      port_range                = "22"
      source_addresses          = ["0.0.0.0/0", "::/0"]
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
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    }
  ]
}

resource "digitalocean_firewall" "swarm_nodes" {
  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-swarm-node-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "2376"
      source_tags               = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "tcp"
      port_range                = "7946"
      source_tags               = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "udp"
      port_range                = "7946"
      source_tags               = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "udp"
      port_range                = "4789"
      source_tags               = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    }
  ]
  outbound_rule = [
    {
      protocol                  = "icmp"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    }
  ]
}


# Add a record to the domain
resource "digitalocean_record" "api" {
  domain = "${var.domain}"
  type   = "A"
  name   = "${var.app}"
  count  = "${var.lb_count}"
  value  = "${digitalocean_loadbalancer.public.*.ip[count.index]}"
}