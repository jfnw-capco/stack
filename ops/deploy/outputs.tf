output "master_ip" {
  value = "${digitalocean_droplet.master.ipv6_address_privateip}"
}