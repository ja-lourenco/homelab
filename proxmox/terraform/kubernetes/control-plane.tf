resource "proxmox_virtual_environment_vm" "control_plane" {
  name      = "${local.common.name_prefix}-control-plane"
  vm_id     = local.control_plane_vmid
  node_name = local.common.node_name
  tags      = concat(local.common.tags, ["control-plane"])

  started = local.common.started
  on_boot = local.common.on_boot

  clone {
    vm_id = var.template_vmid
    full  = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = format("%s/24", cidrhost(var.cidr, local.control_plane_vmid))
        gateway = local.common.gateway
      }
    }
  }
}
