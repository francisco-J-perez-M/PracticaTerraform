# Grupo de recursos
resource "azurerm_resource_group" "qa" {
  name     = "rg-${local.suffix}"
  location = local.location
  tags     = local.tags
}

# Espacio de trabajo Log Analytics
resource "azurerm_log_analytics_workspace" "qa" {
  name                = "log-${local.suffix}"
  location            = azurerm_resource_group.qa.location
  resource_group_name = azurerm_resource_group.qa.name
  sku                 = var.log_analytics_sku
  retention_in_days   = 30
  daily_quota_gb      = 0.1
  tags                = local.tags
}

# Application Insights
resource "azurerm_application_insights" "qa" {
  name                 = "appi-${local.suffix}"
  location             = azurerm_resource_group.qa.location
  resource_group_name  = azurerm_resource_group.qa.name
  workspace_id         = azurerm_log_analytics_workspace.qa.id
  application_type     = var.application_type
  daily_data_cap_in_gb = 0.1
  tags                 = local.tags
}

# Plan de servicio Linux
resource "azurerm_service_plan" "qa" {
  name                = "asp-${local.suffix}"
  location            = azurerm_resource_group.qa.location
  resource_group_name = azurerm_resource_group.qa.name
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name
  tags                = local.tags
}

# Aplicación Web Linux
resource "azurerm_linux_web_app" "qa" {
  name                = var.web_app_name
  location            = azurerm_resource_group.qa.location
  resource_group_name = azurerm_resource_group.qa.name
  service_plan_id     = azurerm_service_plan.qa.id
  https_only          = true

  site_config {
    always_on           = false
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.qa.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  tags = local.tags
}