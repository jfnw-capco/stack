variable "token" {}

provider "digitalocean" {
    token = "${var.token}"
    image_id = "${var.image_id}"
}

# Create a new droplet
resource "digitalocean_droplet" "terraform" {
    image  = "${var.image_id}"
    name   = "terrform-droplet"
    region = "nyc3"
    size   = "512mb"
}
