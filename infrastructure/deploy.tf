variable "token" {}
variable "image_id" {}

provider "digitalocean" {
    token = "${var.token}"
}

# Create a new droplet
resource "digitalocean_droplet" "terraform" {
    image  = "${var.image_id}"
    name   = "io-delineate-node-${var.image_id}"
    region = "lon1"
    size   = "512mb"
}
