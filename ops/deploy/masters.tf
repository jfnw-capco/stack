 variable "masters_count" {}
variable "masters_lb_count" {}

# Creates the tag for the master
resource "digitalocean_tag" "master_tag" {
  name = "master-${var.branch}"
}

# Create a new droplet
resource "digitalocean_droplet" "masters" {
    image               = "${var.image_ids["master"]}"
    count               = "${var.masters_count}"
    name                = "${var.namespace}-${var.app}-${var.branch}-master-${count.index + 1}"
    region              = "${var.region}"
    size                = "${var.size}"
    tags                = ["${digitalocean_tag.master_tag.id}"]
    private_networking  = true
    ssh_keys            = "${var.keys}"
    user_data           = <<EOF
#!/bin/bash
./startup/startup.sh
EOF
}


# Creates the load balancer
resource "digitalocean_loadbalancer" "masters_public_lb" {
  name = "${var.namespace}-${var.app}-${var.branch}-master-public-${count.index + 1}"
  count  = "${var.masters_lb_count}"
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

  droplet_ids = ["${digitalocean_droplet.masters.*.id}"]
}

resource "digitalocean_firewall" "master_public" {
  droplet_ids = ["${digitalocean_droplet.masters.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-master-public-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "22"
      source_addresses          = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "tcp"
      port_range                = "80"
      source_addresses          = ["${digitalocean_loadbalancer.masters_public_lb.*.id}"]
    }
  ]
  outbound_rule = [
    {
      protocol                  = "icmp"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "tcp"
      port_range                = "1-65535"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "udp"
      port_range                = "1-65535"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    }
  ]
}

resource "digitalocean_firewall" "master_swarm" {
  droplet_ids = ["${digitalocean_droplet.masters.*.id}"]
  name = "${var.namespace}-${var.app}-${var.branch}-master-swarm-fw"
  inbound_rule = [
    {
      protocol                  = "tcp"
      port_range                = "2376"
      source_tags               = ["${digitalocean_tag.node_tag.name}"]
    },
    {
      protocol                  = "tcp"
      port_range                = "2377"
      source_tags               = ["${digitalocean_tag.node_tag.name}"]
    },
    {
      protocol                  = "tcp"
      port_range                = "7946"
      source_tags               = ["${digitalocean_tag.node_tag.name}"]
    },
    {
      protocol                  = "udp"
      port_range                = "7946"
      source_tags               = ["${digitalocean_tag.node_tag.name}"]
    },
    {
      protocol                  = "udp"
      port_range                = "4789"
      source_tags               = ["${digitalocean_tag.node_tag.name}"]
    }
  ]
}


# Add a record to the domain
resource "digitalocean_record" "master_registry" {
  domain = "${var.domain}"
  type   = "A"
  name   = "registry"
  count  = "${var.masters_lb_count}"
  value  = "${digitalocean_loadbalancer.masters_public_lb.*.ip[count.index]}"
}


