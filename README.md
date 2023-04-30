![standard-readme compliant](https://img.shields.io/badge/Terraform-6B42BC?style=for-the-badge&logo=terraform&logoColor=white) ![standard-readme compliant](https://img.shields.io/badge/VMware-231f20?style=for-the-badge&logo=VMware&logoColor=white)

# Terraform Automation

Automation of home infrastructure via the VSphere provider. This provider is currently used to manage a VMware VSphere environment including virtual machines, hosts, inventories, networks, storage, datastores and content libraries.

## Table of Contents
- [Goals](#Goals)
- [Prerequisites](#Prerequisites)
- [Install](#install)
- [Usage](#usage)
- [Issues](#Issues)
- [Maintainers](#maintainers)

## Goals
The goals for this repository are:

1. Use Terraform with the VSphere provider to fully automate all virtual machine creation as well as networking, data storage via VCenter on an ESXI host.
2. Produce the code in such a way that's usable, readable and maintainable by third parties.
3. Ensure the code is able to be built upon and expanded to add additional infrastructure and features.
4. Keep in-line with IAC methodologies.

## Prerequisites
- Two OVF templates hosted on an accessible web server (Vyos and a Linux distribution).
- A ESXI host with a passthrough enabled network card.
- A VCenter installation. [See..](https://github.com/tekore/Hypervisor-Automation)
- The Linux OVF templates have 'cloud-init' and 'vmware-tools' installed.

## Install
This project uses [Terraform](https://www.terraform.io/). You'll need to install Terraform to run this code, once Terraform in installed;
- Clone the repo:
```sh
$ git clone https://github.com/tekore/Vsphere
```

- Initialise Terraform
```sh
$ terraform init
```

## Usage
The provided .tfvars template "[tfvars-template](https://github.com/tekore/Vsphere/blob/main/tfvars-template "tfvars-template")" will need to be updated with the needed variables relevant to your install.  

Once this is done, run;
```sh
$ terraform plan --var-file="tfvars-template.tfvars"
$ terraform apply --var-file="tfvars-template.tfvars"
```

## Issues
- With nightly Vyos builds 'cloud-init' installs are not natively possible. Unless you're willing to pay for a Vyos subscription, including an SSH key in your Vyos OVF template for future configuration is recommended.
- For the 'script_text' customization to work (in doc vms.tf), the Linux OVF template will need 'cloud-init' and 'vmware-tools' installed.
- This code is for a SINGLE ESXI host, to enable several ESXI hosts in a cluster, add the following resource:
```sh
resource "vsphere_compute_cluster" "compute_cluster" {
  name                      = "compute-cluster"
  datacenter_id             = vsphere_datacenter.datacenter.moid
  host_system_ids           = [vsphere_host.esxi.id]
}
```
Then change the 'resource_pool_id' in 'vms.tf' to reflect the new resource:
```sh
resource "vsphere_virtual_machine" "rhel8" {
...
  resource_pool_id = vsphere_compute_cluster.compute_cluster.resource_pool_id
...
}
```

## Maintainers
[@Tekore](https://github.com/tekore)
