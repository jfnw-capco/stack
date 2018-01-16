variable "token" {}
variable "node_image_id" {}

provider "digitalocean" {
    token = "${var.token}"
}

# Create a new droplet
resource "digitalocean_droplet" "node" {
    image  = "${var.image_id}"
    name   = "io-delineate-node-${var.image_id}"
    region = "lon1"
    size   = "512mb"
}
