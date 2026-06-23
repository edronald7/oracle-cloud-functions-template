###############################################################################
# OCI Resource Scheduler: invoca la Function vía CRON.
# Se crea solo si function.json -> schedule.enabled = true.
# Para Functions, la acción "START_RESOURCE" equivale a invocar la Function.
###############################################################################

resource "oci_resource_scheduler_schedule" "this" {
  count = local.schedule_enabled ? 1 : 0

  compartment_id     = var.compartment_ocid
  display_name       = "schedule-${local.app_name}"
  description        = "Invoca la Function ${local.app_name} según CRON / Invokes the Function on CRON"
  action             = "START_RESOURCE"
  recurrence_type    = "CRON"
  recurrence_details = local.schedule_cron

  resources {
    id = oci_functions_function.fn.id
  }

  freeform_tags = local.freeform_tags

  # El schedule necesita la policy del schedule_dg para invocar la Function.
  depends_on = [oci_identity_policy.policies]
}
