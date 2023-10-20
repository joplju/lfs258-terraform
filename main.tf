terraform {
  backend "local" {
    path = "../../../../../media/jjoplin/backups/tfstate/do-lfs258.tfstate"
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  required_version = "~> 1.5.4"
}
