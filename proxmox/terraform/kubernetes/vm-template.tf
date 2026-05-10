resource "proxmox_download_file" "ubuntu_server_24_img" {
  content_type = "import"
  datastore_id = local.disk.storage.local
  node_name    = local.common.node_name
  file_name    = "ubuntu-server-24-cloudimg-amd64.qcow2"
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite    = true
}


resource "proxmox_virtual_environment_vm" "ubuntu_server_24_template" {
  name        = "ubuntu-server-24-template"
  description = "Ubuntu 24.04 cloud-init template for Kubernetes nodes"
  tags        = concat(local.common.tags, ["template", "ubuntu-server-24"])

  node_name = local.common.node_name
  vm_id     = local.common.vmid_prefix

  started  = false
  on_boot  = false
  template = var.is_template

  agent {
    enabled = local.vm_defaults.agent_enabled
  }
  stop_on_destroy = true

  cpu {
    cores = local.vm_defaults.cpu_cores
    type  = local.vm_defaults.cpu_type
  }

  memory {
    dedicated = local.vm_defaults.memory_dedicated
    floating  = local.vm_defaults.memory_floating
  }

  disk {
    import_from  = proxmox_download_file.ubuntu_server_24_img.id
    datastore_id = local.disk.storage.lvm
    interface    = local.disk.interface
    size         = local.disk.sizes.control_plane
  }

  initialization {
    datastore_id = local.disk.storage.lvm

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = local.vm_user.username
      keys     = local.vm_user.keys
    }
  }

  network_device {
    bridge = local.vm_defaults.network_bridge
  }

  operating_system {
    type = local.vm_defaults.os_type
  }

  serial_device {}

  vga {
    type = local.vm_defaults.vga_type
  }
}

resource "null_resource" "convert_to_template" {
  depends_on = [proxmox_virtual_environment_vm.ubuntu_server_24_template]

  connection {
    type     = "ssh"
    host     = var.pve_ip_address
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "remote-exec" {
    inline = [
      "qm template ${local.common.vmid_prefix}"
    ]
  }
}
