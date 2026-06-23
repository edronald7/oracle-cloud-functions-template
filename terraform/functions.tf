###############################################################################
# OCI Functions: Application + Function.
# La imagen se construye y publica con `fn build && fn push` (ver README) y se
# pasa por la variable function_image. Terraform no construye la imagen.
###############################################################################

resource "oci_functions_application" "app" {
  compartment_id = var.compartment_ocid
  display_name   = "app-${local.app_name}"
  subnet_ids     = [var.function_subnet_id]

  freeform_tags = local.freeform_tags
}

resource "oci_functions_function" "fn" {
  application_id     = oci_functions_application.app.id
  display_name       = local.function_name
  image              = var.function_image
  memory_in_mbs      = local.memory_in_mbs
  timeout_in_seconds = local.timeout

  # Variables de entorno desde function.json -> config.
  config = local.fn_config

  freeform_tags = local.freeform_tags
}
