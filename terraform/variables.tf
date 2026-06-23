###############################################################################
# Autenticación y ubicación / Auth and location
###############################################################################

variable "config_file_profile" {
  description = "Perfil de ~/.oci/config a usar / Profile from ~/.oci/config."
  type        = string
  default     = "DEFAULT"
}

variable "tenancy_ocid" {
  description = "OCID del tenancy (requerido para dynamic groups a nivel raíz)."
  type        = string
}

variable "compartment_ocid" {
  description = "OCID del compartimiento donde se crean los recursos."
  type        = string
}

variable "compartment_name" {
  description = "Nombre del compartimiento (usado en las sentencias de policy IAM)."
  type        = string
}

variable "region" {
  description = "Región de OCI, p.ej. us-ashburn-1."
  type        = string
}

###############################################################################
# Function
###############################################################################

variable "function_image" {
  description = <<-EOT
    URL completa de la imagen de la Function en OCIR, incluyendo tag.
    Se construye y publica previamente con `fn build && fn push` (ver README).
    Ej: iad.ocir.io/<namespace>/<repo>/fn-hello:0.0.1
  EOT
  type        = string
}

variable "function_subnet_id" {
  description = "OCID de la subnet (en un VCN existente) para la Function Application."
  type        = string
}
