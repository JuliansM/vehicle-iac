variable "publisher_email" {
  description = "El email del dueño del servicio"
  type        = string
  validation {
    condition     = length(var.publisher_email) > 0
    error_message = "La variable publisher_email debe contener al menos un caracter."
  }
}

variable "publisher_name" {
  description = "Nombre del dueño del servicio"
  type        = string
  validation {
    condition     = length(var.publisher_name) > 0
    error_message = "La variable publisher_name debe contener al menos un caracter."
  }
}

variable "sku" {
  description = "El pricing tier del API Management"
  type        = string
  validation {
    condition     = contains(["Developer", "Standard", "Premium"], var.sku)
    error_message = "El sku debe ser alguno de los siguientes: Developer, Standard, Premium."
  }
}

variable "sku_count" {
  description = "El tamaño de la instancia del API Management"
  type = number
  validation {
    condition     = contains([1, 2], var.sku_count)
    error_message = "El sku_count debe ser alguno de los siguientes: 1, 2."
  }
}
