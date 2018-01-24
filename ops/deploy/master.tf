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
    ipv6                = true
    ssh_keys            = "${var.keys}"
    user_data           = <<EOF
#!/bin/bash
./startup/startup.sh
EOF
}

# Add a record to the domain
resource "digitalocean_record" "master_registry" {
  domain = "${var.domain}"
  type   = "A"
  name   = "registry"
  value  = "${digitalocean_droplet.master.ipv6_address}"
}