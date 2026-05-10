locals {
  common = {
    name_prefix = "k8s"
    vmid_prefix = var.template_vmid
    node_name   = "pve"

    gateway = cidrhost(var.cidr, 1)

    started         = true
    on_boot         = true
    stop_on_destroy = true

    tags = ["terraform", "k8s"]
  }

  vm_defaults = {
    agent_enabled = false
    cpu_cores     = 2
    cpu_type      = "x86-64-v2-AES"

    memory_dedicated = 3072
    memory_floating  = 0

    network_model  = "virtio"
    network_bridge = "vmbr0"

    os_type  = "l26"
    vga_type = "serial0"
  }

  disk = {

    interface = "scsi0"
    storage = {
      local = "local"
      lvm   = "local-lvm"
    }

    sizes = {
      control_plane = 32
      node          = 40
    }
  }

  vm_user = {
    username = "ubuntu"
    keys     = [trimspace(file(var.ssh_public_key_path))]
  }

  control_plane_vmid = local.common.vmid_prefix + 1
  node_start_vmid    = local.common.vmid_prefix + 2
  node_count         = 2
}
