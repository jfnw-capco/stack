# Outputs the reachable IPs 
output "reachable" {
  value = ["${digitalocean_loadbalancer.master_lb.*.ip}"]
}

# Outputs the non-reachable IPs
output "non_reachable" {
  value = ["${digitalocean_droplet.masters.*.ipv4_address}"]
}

# Outputs the A records for HTTP testing
output "a_records" {
  value = "${digitalocean_droplet.masters.*.ipv4_address}"
}