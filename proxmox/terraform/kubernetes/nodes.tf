resource "proxmox_virtual_environment_vm" "node" {
  count = local.node_count

  name      = "${local.common.name_prefix}-node-${local.node_start_vmid + count.index}"
  vm_id     = local.node_start_vmid + count.index
  node_name = local.common.node_name
  tags      = concat(local.common.tags, ["node"])

  started = local.common.started
  on_boot = local.common.on_boot

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  cpu {
    cores = local.node.cpu_cores
  }

  memory {
    dedicated = local.node.memory_dedicated
  }

  disk {
    interface = local.disk.interface
    size      = local.disk.sizes.node
  }

  initialization {
    ip_config {
      ipv4 {
        address = format("%s/24", cidrhost(var.cidr, local.node_start_vmid + count.index))
        gateway = local.common.gateway
      }
    }
  }

  depends_on = [proxmox_virtual_environment_vm.ubuntu_server_24_template]
}
