resource "local_file" "vyos_yaml" {
  content = <<EOT
#cloud-config
vyos_config_commands:
  - set system host-name 'vyos-router'
  - set interfaces ethernet eth0 address dhcp
  - set interfaces ethernet eth0 description 'WAN'
	      EOT
  filename = "${path.module}/cloud-init/vyos.yaml"
  file_permission = 777
}

resource "local_file" "ubuntu_yaml" {
  content = <<EOT
#cloud-config
users:
  - default
  - name: ${var.user-data.username}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: ${var.user-data.password_hash}
    sudo: ALL=(ALL) NOPASSWD:ALL
              EOT
  filename = "${path.module}/cloud-init/ubuntu.yaml"
  file_permission = 777
}

resource "local_file" "rhel9_meta_data" {
  content = <<EOT
instance-id: rhel9
local-hostname: rhel9
              EOT
  filename = "${path.module}/cloud-init/meta-data"
  file_permission = 777
}

resource "local_file" "rhel9_user_data" {
  content = <<EOT
#cloud-config
users:
  - default
  - name: ${var.user-data.username}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: ${var.user-data.password_hash}
    sudo: ALL=(ALL) NOPASSWD:ALL
runcmd:
  - touch /place_holder_file.txt
              EOT
  filename = "${path.module}/cloud-init/user-data"
  file_permission = 777
  depends_on = [local_file.rhel9_meta_data]
}

resource "null_resource" "create_rhel9_iso" {
  provisioner "local-exec" {
    command = "cd ./cloud-init && genisoimage -output rhel9.iso -volid cidata -joliet -rock user-data meta-data"
  }
  triggers = tomap({data = data.local_file.rhel9_cloud_init.content_base64})
  depends_on = [local_file.rhel9_user_data]
}

resource "vsphere_file" "rhel9_rhel9_cloud_init_upload" {
  datacenter         = vsphere_datacenter.datacenter.name
  datastore          = data.vsphere_datastore.datastore.name
  source_file        = "${path.module}/cloud-init/rhel9.iso"
  destination_file   = "${path.module}/ISO/rhel9.iso"
  create_directories = true
  lifecycle {
    replace_triggered_by = [null_resource.create_rhel9_iso]
  }
  depends_on = [vsphere_datacenter.datacenter, local_file.rhel9_user_data]
}

data "vsphere_datastore" "datastore" {
  name          = var.data-storage.datastore
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.esxi]
}

resource "vsphere_datacenter" "datacenter" {
  name = var.data-storage.datacenter
}

resource "vsphere_content_library" "ova_library" {
  name            = "OVA Library"
  description     = "OVA Template Library"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "content_ubuntu" {
  name        = "UBUNTU"
  description = "UBUNTU OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.ubuntu)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

resource "vsphere_content_library_item" "content_rhel9" {
  name        = "RHEL9"
  description = "RHEL9 OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.rhel9)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

resource "vsphere_content_library_item" "content_vyos" {
  name        = "VYOS"
  description = "VYOS OVA Template"
  file_url    = format("http://%s:8000/%s", var.server_ip, var.templates.vyos)
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

