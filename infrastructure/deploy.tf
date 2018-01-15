variable "token" {}

provider "digitalocean" {
    token = "${var.token}"
}

# Create a new droplet
resource "digitalocean_droplet" "terraform" {
    image  = "30941872"
    name   = "terrform-droplet"
    region = "nyc3"
    size   = "512mb"
}
