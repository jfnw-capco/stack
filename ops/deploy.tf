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
    size   = "512mb"
    ssh-keys = [17505046]
}
