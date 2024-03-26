resource "local_file" "ubuntu_yaml" {
  content = <<EOT
#cloud-config
users:
  - default
  - name: ${var.user-data.username}
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys: ${var.user-data.public-key}
    lock_passwd: false
    passwd: ${var.user-data.password-hash}
    sudo: ALL=(ALL) NOPASSWD:ALL
  - name: root
    shell: /bin/bash
    ssh_authorized_keys: ${var.user-data.public-key}
packages:
  - vim
write_files:
  - path: ${var.cloud-init.file-path}
    owner: 'root:root'
    permissions: '0600'
    encoding: b64
    content: ${var.cloud-init.file}
  - path: ${var.cloud-init.file2-path}
    encoding: b64
    content: ${var.cloud-init.file2}
runcmd:
  - ${var.cloud-init.runcmd}
package_update: true
package_upgrade: true
              EOT
  filename = "${path.module}/cloud-init/ubuntu.yaml"
  file_permission = 777
}

resource "vsphere_datacenter" "datacenter" {
  name = var.data-storage.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.data-storage.datastore
  datacenter_id = vsphere_datacenter.datacenter.moid
  depends_on    = [vsphere_host.esxi]
}

resource "vsphere_content_library" "ova_library" {
  name            = "OVA Library"
  description     = "OVA Template Library"
  storage_backing = [data.vsphere_datastore.datastore.id]
}

resource "vsphere_content_library_item" "content_ubuntu" {
  name        = "Ubuntu"
  description = "Ubuntu ova Template"
  file_url    = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  library_id  = vsphere_content_library.ova_library.id
  depends_on  = [vsphere_content_library.ova_library]
}

