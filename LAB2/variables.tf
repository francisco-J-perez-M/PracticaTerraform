variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
  default     = "integradora"
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, qa, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "El entorno debe ser dev, qa o prod."
  }
}

variable "location" {
  type        = string
  description = "Región de Azure donde se desplegarán los recursos"
  default     = "mexicocentral"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Espacio de direcciones CIDR para la VNet"
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  type        = map(string)
  description = "Mapa de etiquetas clave-valor para asignar a los recursos"
  default = {
    managed_by = "Terraform"
  }
}

variable "subscription_id" {
  type        = string
  description = "ID de la suscripción de Azure"
  default     = "3b30866f-49cf-4810-8dd6-9c58aea86f8d"
  sensitive   = true
}