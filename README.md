![standard-readme compliant](https://img.shields.io/badge/Terraform-6B42BC?style=for-the-badge&logo=terraform&logoColor=white) ![standard-readme compliant](https://img.shields.io/badge/VMware-231f20?style=for-the-badge&logo=VMware&logoColor=white)

# Terraform Automation

Automation of home infrastructure via the VSphere provider. This provider is currently used to manage a VMware VSphere environment including virtual machines, hosts, inventories, networks, storage, datastores and content libraries.

## Table of Contents
- [Goals](#Goals)
- [Prerequisites](#Prerequisites)
- [Install](#install)
- [Usage](#usage)
- [Maintainers](#maintainers)

## Goals
The goals for this repository are:

1. Use Terraform with the VSphere provider to fully automate all virtual machine creation as well as networking and data storage via VCenter on an ESXI host.
2. Produce the code in such a way that's usable, readable and maintainable by third parties.
3. Ensure the code is able to be built upon and expanded to add additional infrastructure and features.
4. Keep in-line with IAC methodologies.

## Prerequisites
- A ESXI host with VCenter installed. [See..](https://github.com/tekore/Hypervisor-Automation)

## Install
This project uses [Terraform](https://www.terraform.io/). You'll need to install Terraform to run this code, once Terraform is installed:
- Clone the repo:
```sh
$ git clone https://github.com/tekore/Vsphere
```

- Initialise Terraform
```sh
$ terraform init
```

## Usage
If you choose to use the provided .tfvars template "[tfvars-template](https://github.com/tekore/Vsphere/blob/main/tfvars-template "tfvars-template")" will need to be updated with the needed variables relevant to your install.  

Once this is done, run;
```sh
$ terraform plan -var-file=/<PATH-TO-TFVARS-FILE>.tfvars
$ terraform apply -var-file=/<PATH-TO-TFVARS-FILE>.tfvars
```

## Maintainers
[@Tekore](https://github.com/tekore)
