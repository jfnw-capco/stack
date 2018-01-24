variable "node_count" {}
variable "node_lb_count" {}

# Creates a tag for the nodes 
resource "digitalocean_tag" "node_tag" {
  name = "node-${var.branch}"
}

# Create a new droplet
resource "digitalocean_droplet" "node" {
    image  = "${var.image_ids["node"]}"
    count  = "${var.node_count}"
    name   = "${var.namespace}-${var.app}-${var.branch}-node-${count.index + 1}"
    region = "${var.region}"
    size   = "${var.size}"
    tags   = ["${digitalocean_tag.node_tag.id}"]
    private_networking = true
    ssh_keys = "${var.keys}"
    user_data = <<EOF
#!/bin/bash
./startup/startup.sh
EOF
}


# Creates the load balancer
resource "digitalocean_loadbalancer" "node_lb" {
  name = "${var.namespace}-${var.app}-${var.branch}-public-lb-${count.index + 1}"
  count  = "${var.node_lb_count}"
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


resource "digitalocean_firewall" "node_public" {
  droplet_ids = ["${digitalocean_droplet.node.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-node-public-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "80"
      source_load_balancer_uids = ["${digitalocean_loadbalancer.node_lb.*.id}"]
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
    },
    {
      protocol                  = "tcp"
      port_range                = "2376"
      destination_tags          = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "tcp"
      port_range                = "7946"
      destination_tags          = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "udp"
      port_range                = "7946"
      destination_tags          = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    },
    {
      protocol                  = "udp"
      port_range                = "4789"
      destination_tags          = ["${list(digitalocean_tag.master_tag.name, digitalocean_tag.node_tag.name)}"]
    }
  ]
}


# Add a record to the domain
resource "digitalocean_record" "api" {
  domain = "${var.domain}"
  type   = "A"
  name   = "${var.app}"
  count  = "${var.node_lb_count}"
  value  = "${digitalocean_loadbalancer.node_lb.*.ip[count.index]}"
}