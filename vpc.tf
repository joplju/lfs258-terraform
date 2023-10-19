resource "digitalocean_vpc" "lfs258" {
  description = "VPC for resources associated with the LFS258 K8S cluster"
  ip_range    = local.vpc_cidr
  name        = "lfs258"
  region      = "nyc3"
}

resource "digitalocean_firewall" "lfs258-controller" {
  name = "lfs258-controller"
  # droplet_ids = [for controller in digitalocean_droplet.controller : controller.id]
  tags = [
    digitalocean_tag.lfs258.id,
    digitalocean_tag.controller.id
  ]
  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = [
      var.home_ip,
    ]
  }
  inbound_rule {
    protocol   = "tcp"
    port_range = "443"
    source_addresses = [
      var.home_ip,
    ]
  }
}

resource "digitalocean_firewall" "lfs258-worker" {
  name = "lfs258-worker"
  # droplet_ids = [for worker in digitalocean_droplet.worker : worker.id]
  tags = [
    digitalocean_tag.lfs258.id,
    digitalocean_tag.worker.id
  ]
  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = [
      var.home_ip,
    ]
  }
}
