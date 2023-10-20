data "digitalocean_image" "debian" {
  slug = "debian-12-x64"
}

data "digitalocean_ssh_key" "pop_os" {
  name = "Pop_OS SSH Key"
}
