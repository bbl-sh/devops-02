terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
provider "random" {}
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  features {}
}
# resource Group
resource "azurerm_resource_group" "dev" {
  name     = "rg-dev"
  location = "Central India" # change this region to US
}

#development Storage Account
resource "azurerm_storage_account" "dev_storage" {
  name                     = "devstorageacct${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

#staging Storage Account
resource "azurerm_storage_account" "stage_storage" {
  name                     = "stagestorageacct${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# production Storage Account
resource "azurerm_storage_account" "prod_storage" {
  name                     = "prodstorageacct${random_string.random.result}"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = azurerm_resource_group.dev.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}

# output the URLs of the static websites
output "dev_storage_url" {
  value = azurerm_storage_account.dev_storage.primary_web_endpoint
}

output "stage_storage_url" {
  value = azurerm_storage_account.stage_storage.primary_web_endpoint
}

output "prod_storage_url" {
  value = azurerm_storage_account.prod_storage.primary_web_endpoint
}
resource "local_file" "storage_urls" {
  filename = "storage_url.txt"
  content  = <<-EOT
  Development Storage URL: ${azurerm_storage_account.dev_storage.primary_web_endpoint}
  Staging Storage URL: ${azurerm_storage_account.stage_storage.primary_web_endpoint}
  Production Storage URL: ${azurerm_storage_account.prod_storage.primary_web_endpoint}
  EOT
}
