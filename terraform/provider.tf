terraform {
  required_version = ">= 1.3"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.1.0"
    }
  }
}

# Provider OCI - usa ~/.oci/config con el perfil indicado.
provider "oci" {
  region              = var.region
  config_file_profile = var.config_file_profile
}
