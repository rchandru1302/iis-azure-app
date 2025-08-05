terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

module "rg" {
  source   = "./modules/rg"
  rg_name  = var.rg_name
  location = var.location
}

module "network" {
  source   = "./modules/network"
  rg_name  = var.rg_name
  location = var.location
}

module "vm" {
  source         = "./modules/vm"
  rg_name        = var.rg_name
  location       = var.location
  subnet_id      = module.network.subnet_id
  admin_username = var.admin_username
  admin_password = var.admin_password
}

module "autoscale" {
  source   = "./modules/autoscale"
  rg_name  = var.rg_name
  location = var.location
  vm_id    = module.vm.vm_id
}

module "monitor" {
  source   = "./modules/monitor"
  rg_name  = var.rg_name
  location = var.location
  vm_id    = module.vm.vm_id
}