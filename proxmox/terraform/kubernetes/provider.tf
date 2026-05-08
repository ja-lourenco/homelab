terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.106.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.endpoint
  api_token = "${var.api_token_id}=${var.api_token}"
  insecure  = var.tls_insecure
}
