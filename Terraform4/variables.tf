variable "location" {
  type        = string
  default     = "mexicocentral"
  description = "Región de Azure establecida para la práctica (México Central)."
}

variable "prefix" {
  type        = string
  default     = "mex"
  description = "Prefijo para la nomenclatura de recursos."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Usuario administrador de la máquina virtual Worker."
}

variable "db_admin_username" {
  type        = string
  default     = "pgadmin"
  description = "Usuario administrador del servidor PostgreSQL."
}

variable "db_admin_password" {
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123456!"
  description = "Contraseña de acceso para PostgreSQL."
}