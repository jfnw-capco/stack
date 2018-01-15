variable "token" {}
variable "image_id" {}

provider "digitalocean" {
    token = "${var.token}"
}

# Create a new droplet
resource "digitalocean_droplet" "terraform" {
    image  = "${var.image_id}"
    name   = "terrform-droplet"
    region = "nyc3"
    size   = "512mb"
}
