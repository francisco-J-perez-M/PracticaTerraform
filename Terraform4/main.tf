# -----------------------------------------------------------------------------
# 1. GRUPOS DE RECURSOS (Resource Groups)
# -----------------------------------------------------------------------------
resource "azurerm_resource_group" "rg_vnet" {
  name     = "rg-${var.prefix}-network"
  location = var.location
}

resource "azurerm_resource_group" "rg_app" {
  name     = "rg-${var.prefix}-app"
  location = var.location
}

resource "azurerm_resource_group" "rg_db" {
  name     = "rg-${var.prefix}-db"
  location = var.location
}

resource "azurerm_resource_group" "rg_vm" {
  name     = "rg-${var.prefix}-vm"
  location = var.location
}

resource "azurerm_resource_group" "rg_endpoints" {
  name     = "rg-${var.prefix}-endpoints"
  location = var.location
}

resource "azurerm_resource_group" "rg_bastion" {
  name     = "rg-${var.prefix}-bastion"
  location = var.location
}

# -----------------------------------------------------------------------------
# 2. VIRTUAL NETWORK Y LAS 5 SUBREDES (Mantiene el diagrama de arquitectura)
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-lz-prod"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_vnet.location
  resource_group_name = azurerm_resource_group.rg_vnet.name
}

# Subnet 1: App Service Delegada
resource "azurerm_subnet" "snet_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "delegation-appservice"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Subnet 2: Database Subnet
resource "azurerm_subnet" "snet_db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Subnet 3: Worker VM Subnet
resource "azurerm_subnet" "snet_vm" {
  name                 = "snet-vm"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Subnet 4: Endpoints Subnet
resource "azurerm_subnet" "snet_endpoints" {
  name                 = "snet-endpoints"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

# Subnet 5: Azure Bastion Subnet
resource "azurerm_subnet" "snet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.5.0/24"]
}

# -----------------------------------------------------------------------------
# 3. STORAGE ACCOUNT Y PRIVATE ENDPOINT (Aislamiento PaaS)
# -----------------------------------------------------------------------------
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage" {
  name                     = "stlzprod${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_endpoints.name
  location                 = azurerm_resource_group.rg_endpoints.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  public_network_access_enabled = false
}

# DNS Zone y Endpoint: Blob Storage
resource "azurerm_private_dns_zone" "dns_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_endpoints.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_blob" {
  name                  = "link-blob-vnet"
  resource_group_name   = azurerm_resource_group.rg_endpoints.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_blob.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "pe_blob" {
  name                = "pe-blob"
  location            = azurerm_resource_group.rg_endpoints.location
  resource_group_name = azurerm_resource_group.rg_endpoints.name
  subnet_id           = azurerm_subnet.snet_endpoints.id

  private_service_connection {
    name                           = "psc-blob"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-group-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_blob.id]
  }
}

# -----------------------------------------------------------------------------
# 4. APP SERVICE LINUX + VNET INTEGRATION
# -----------------------------------------------------------------------------
resource "azurerm_service_plan" "asp" {
  name                = "asp-lz-prod"
  resource_group_name = azurerm_resource_group.rg_app.name
  location            = azurerm_resource_group.rg_app.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-lz-prod-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg_app.name
  location            = azurerm_resource_group.rg_app.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "app_vnet_integration" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = azurerm_subnet.snet_app.id
}