# Creates the tag for the master
resource "digitalocean_tag" "master_tag" {
  name = "master-${var.branch}"
}

# Create a new droplet
resource "digitalocean_droplet" "master" {
    image               = "${var.image_ids["master"]}"
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

resource "digitalocean_firewall" "master_public" {
  droplet_ids = ["${digitalocean_droplet.master.id}"]
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
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol                  = "udp"
      destination_addresses     = ["0.0.0.0/0", "::/0"]
    }
  ]
}

# Add a record to the domain
resource "digitalocean_record" "master_registry" {
  domain = "${var.domain}"
  type   = "A"
  name   = "registry"
  value  = "${digitalocean_droplet.master.ipv4_address}"
}

output "master_ip" {
  value = "${digitalocean_droplet.master.ipv4_address}"
}