resource "digitalocean_droplet" "controller" {
  count      = var.num_controllers
  backups    = false
  image      = data.digitalocean_image.debian.id
  monitoring = false
  name       = "controller-${count.index}"
  region     = "nyc3"
  size       = "s-4vcpu-8gb"
  ssh_keys   = [data.digitalocean_ssh_key.pop_os.id]
  tags = [
    digitalocean_tag.lfs258.id,
    digitalocean_tag.controller.id
  ]
  vpc_uuid = digitalocean_vpc.lfs258.id
}

resource "digitalocean_droplet" "worker" {
  count      = var.num_workers
  backups    = false
  image      = data.digitalocean_image.debian.id
  monitoring = false
  name       = "worker-${count.index}"
  region     = "nyc3"
  size       = "s-2vcpu-4gb"
  ssh_keys   = [data.digitalocean_ssh_key.pop_os.id]
  tags = [
    digitalocean_tag.lfs258.id,
    digitalocean_tag.worker.id
  ]
  vpc_uuid = digitalocean_vpc.lfs258.id
}
