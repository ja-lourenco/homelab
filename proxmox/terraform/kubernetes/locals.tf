locals {
  common = {
    name_prefix = "k8s"
    vmid_prefix = var.template_vmid
    node_name   = "pve"

    on_boot         = true
    stop_on_destroy = true
    boot_order      = ["scsi0"]
    scsi_hardware   = "virtio-scsi-pci"
    gateway         = var.gateway

    tags = ["terraform", "k8s"]
  }

  agent = {
    status = false
  }

  cpu = {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory = {
    dedicated = 3072
    floating  = 0
  }

  disk = {
    storage = {
      local = "local"
      lvm   = "local-lvm"
    }

    interface = {
      scsi = "scsi0"
      ide  = "ide2"
    }

    size = {
      control_plane = 32
      worker        = 40
    }
  }

  initialization = {
    user_account = {
      username = "ubuntu"
      keys     = [trimspace(file(var.ssh_public_key_path))]
    }
  }

  network = {
    model  = "virtio"
    bridge = "vmbr0"
  }

  operating_system = {
    type = "l26"
  }

  vga = {
    type = "serial0"
  }
}
