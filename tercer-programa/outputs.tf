output "web_app_default_hostname" {
  value       = azurerm_linux_web_app.qa.default_hostname
  description = "URL predeterminada de la aplicación web"
}

output "resource_group_name" {
  value = azurerm_resource_group.qa.name
}