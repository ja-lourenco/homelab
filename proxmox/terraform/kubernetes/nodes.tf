resource "proxmox_virtual_environment_vm" "node" {
  count = local.node_count

  name      = "${local.common.name_prefix}-node"
  node_name = local.common.node_name
  vm_id     = local.node_start_vmid + count.index
  tags      = concat(local.common.tags, ["node"])

  started = local.common.started
  on_boot = local.common.on_boot

  clone {
    vm_id = var.template_vmid
    full  = true
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
}
