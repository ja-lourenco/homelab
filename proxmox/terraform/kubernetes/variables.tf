variable "cidr" {
  type        = string
  description = "CIDR for the Kubernetes cluster"
}

variable "endpoint" {
  type        = string
  description = "Proxmox API URL"
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
  default     = true
  description = "Whether the VM is a template"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Local SSH Public Key Path"
}

variable "control_plane_count" {
  type        = number
  description = "Number of control plane nodes"
}

variable "node_count" {
  type        = number
  description = "Number of worker nodes"
}
