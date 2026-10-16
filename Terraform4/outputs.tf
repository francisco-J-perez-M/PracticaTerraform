output "vnet_id" {
  description = "ID de la Virtual Network creada."
  value       = azurerm_virtual_network.vnet.id
}

output "app_service_default_hostname" {
  description = "URL del App Service."
  value       = azurerm_linux_web_app.app.default_hostname
}

output "storage_account_name" {
  description = "Nombre de la cuenta de almacenamiento asignada dinámicamente."
  value       = azurerm_storage_account.storage.name
}