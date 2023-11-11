resource "digitalocean_vpc" "lfs258" {
  description = "VPC for resources associated with the LFS258 K8S cluster"
  ip_range    = var.vpc_cidr
  name        = "lfs258"
  region      = "nyc3"
}

#
# See https://kubernetes.io/docs/reference/networking/ports-and-protocols/ for details
#

resource "digitalocean_firewall" "lfs258-controller" {
  name        = "lfs258-controller"
  droplet_ids = [for controller in digitalocean_droplet.controller : controller.id]
  tags = [
    digitalocean_tag.controller.id
  ]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.home_ip_cidr]
  }
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = [var.home_ip_cidr]
  }
  # Kubernetes API server
  inbound_rule {
    protocol   = "tcp"
    port_range = "6443"
    source_addresses = [
      var.home_ip_cidr,
      var.vpc_cidr
    ]
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id,
    ]
  }
  # etcd client server API
  inbound_rule {
    protocol    = "tcp"
    port_range  = "2379-2380"
    source_tags = [digitalocean_tag.controller.id]
  }
  # cilium-health communication
  inbound_rule {
    protocol   = "tcp"
    port_range = "4240"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # Kubelet API
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10250"
    source_tags = [digitalocean_tag.controller.id]
  }
  # kube-scheduler
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10259"
    source_tags = [digitalocean_tag.controller.id]
  }
  # kube-controller-manager
  inbound_rule {
    protocol    = "tcp"
    port_range  = "10257"
    source_tags = [digitalocean_tag.controller.id]
  }
  # NodePort services
  inbound_rule {
    protocol   = "tcp"
    port_range = "30000-32767"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # VXLAN, for Cilium
  inbound_rule {
    protocol   = "udp"
    port_range = "8472"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # Cilium ICMP
  inbound_rule {
    protocol = "icmp"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = [
      "0.0.0.0/0",
    ]
  }
  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = [
      "0.0.0.0/0",
    ]
  }
  # Allow ping to other cluster members
  outbound_rule {
    protocol = "icmp"
    destination_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
}

resource "digitalocean_firewall" "lfs258-worker" {
  name        = "lfs258-worker"
  droplet_ids = [for worker in digitalocean_droplet.worker : worker.id]
  tags = [
    digitalocean_tag.worker.id
  ]
  inbound_rule {
    protocol   = "tcp"
    port_range = "22"
    source_addresses = [
      var.home_ip_cidr,
    ]
  }
  # cilium-health communication
  inbound_rule {
    protocol   = "tcp"
    port_range = "4240"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # Kubelet API
  inbound_rule {
    protocol   = "tcp"
    port_range = "10250"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # NodePort services
  inbound_rule {
    protocol   = "tcp"
    port_range = "30000-32767"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # VXLAN, for Cilium
  inbound_rule {
    protocol   = "udp"
    port_range = "8472"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  # Cilium ICMP
  inbound_rule {
    protocol = "icmp"
    source_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
  outbound_rule {
    protocol   = "tcp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = [
      "0.0.0.0/0",
    ]
  }
  outbound_rule {
    protocol   = "udp"
    port_range = "1-65535"
    #tfsec:ignore:digitalocean-compute-no-public-egress
    destination_addresses = [
      "0.0.0.0/0",
    ]
  }
  # Allow ping to other cluster members
  outbound_rule {
    protocol = "icmp"
    destination_tags = [
      digitalocean_tag.controller.id,
      digitalocean_tag.worker.id
    ]
  }
}
