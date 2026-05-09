variable "cidr" {
  type        = string
  description = "CIDR for the Kubernetes cluster"
}

variable "endpoint" {
  type        = string
  description = "Proxmox API URL"
}

variable "pve_ip_address" {
  type        = string
  description = "Proxmox VE IP Address"
}

variable "api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
}

variable "api_token" {
  type        = string
  description = "Proxmox API Token Secret"
}

variable "tls_insecure" {
  type        = string
  description = "Proxmox TLS Insecure"
}

variable "template_vmid" {
  type        = number
  description = "Proxmox Template VMID"
}

variable "is_template" {
  type        = bool
  default     = false
  description = "Whether the VM is a template"
}


variable "ssh_user" {
  type        = string
  description = "SSH User for Node Access"
}

variable "ssh_password" {
  type        = string
  description = "SSH Password for Node Access"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Local SSH Public Key Path"
}
