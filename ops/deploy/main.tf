variable "token" {}
variable "branch" {}
variable "image_ids" { type = "map" }
variable "region" {}
variable "size" {}
variable "app" {}
variable "namespace" {}
variable "domain" {}
variable "keys" { type = "list" }

provider "digitalocean" {
    token = "${var.token}"
}