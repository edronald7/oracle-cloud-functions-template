output "function_application_id" {
  description = "OCID de la Functions Application."
  value       = oci_functions_application.app.id
}

output "function_id" {
  description = "OCID de la Function."
  value       = oci_functions_function.fn.id
}

output "function_invoke_endpoint" {
  description = "Endpoint de invocación de la Function."
  value       = oci_functions_function.fn.invoke_endpoint
}

output "function_image" {
  description = "Imagen OCIR desplegada en la Function."
  value       = var.function_image
}

output "fn_dynamic_group" {
  description = "Dynamic group de la identidad (Resource Principal) de la Function."
  value       = oci_identity_dynamic_group.fn_dg.name
}

output "schedule_id" {
  description = "OCID del Resource Schedule (null si schedule.enabled = false)."
  value       = local.schedule_enabled ? oci_resource_scheduler_schedule.this[0].id : null
}

output "invoke_command" {
  description = "Comando para invocar la Function con Fn CLI."
  value       = "echo -n '{\"name\":\"OCI\"}' | fn invoke app-${local.app_name} ${local.function_name}"
}
