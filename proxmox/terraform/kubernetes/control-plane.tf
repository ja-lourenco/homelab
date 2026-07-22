resource "proxmox_virtual_environment_vm" "control_plane" {
  count = local.control_plane_count

  name      = "${local.common.name_prefix}-control-plane-${local.control_plane_vmid + count.index}"
  vm_id     = local.control_plane_vmid + count.index
  node_name = local.common.node_name
  tags      = concat(local.common.tags, ["control-plane"])

  started = local.common.started
  on_boot = local.common.on_boot

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  cpu {
    cores = local.control_plane.cpu_cores
  }

  memory {
    dedicated = local.control_plane.memory_dedicated
  }

  initialization {
    ip_config {
      ipv4 {
        address = format("%s/24", cidrhost(var.cidr, local.control_plane_vmid))
        gateway = local.common.gateway
      }
    }
  }

  depends_on = [proxmox_virtual_environment_vm.ubuntu_server_24_template]
}
