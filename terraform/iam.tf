###############################################################################
# IAM: Dynamic Groups y Policies.
# Nota: los Dynamic Groups viven a nivel de tenancy (compartment_id = tenancy).
###############################################################################

# 1) Identidad de la Function (Resource Principal).
resource "oci_identity_dynamic_group" "fn_dg" {
  compartment_id = var.tenancy_ocid
  name           = "${local.app_name}-fn-dg"
  description    = "Identidad de la Function ${local.app_name} / Identity for Function ${local.app_name}"
  matching_rule  = "ALL {resource.type='fnfunc', resource.compartment.id='${var.compartment_ocid}'}"
}

# 2) Identidad del Resource Schedule (solo si el scheduler está habilitado).
resource "oci_identity_dynamic_group" "schedule_dg" {
  count          = local.schedule_enabled ? 1 : 0
  compartment_id = var.tenancy_ocid
  name           = "${local.app_name}-schedule-dg"
  description    = "Resource Schedule que invoca la Function / Resource Schedule invoking the Function"
  matching_rule  = "ALL {resource.type='resourceschedule', resource.compartment.id='${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "policies" {
  compartment_id = var.compartment_ocid
  name           = "${local.app_name}-policies"
  description    = "Policies para la Function ${local.app_name} / Policies for Function ${local.app_name}"

  statements = concat(
    [
      # Permiso base: la Function puede resolver el namespace de Object Storage.
      # Baseline: the Function can resolve the Object Storage namespace.
      "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.fn_dg.name} TO READ objectstorage-namespaces IN COMPARTMENT ${var.compartment_name}",

      # --- Ejemplos: descomenta/edita según lo que tu Function necesite -------
      # --- Examples: uncomment/edit depending on what your Function needs -----
      # "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.fn_dg.name} TO READ objects IN COMPARTMENT ${var.compartment_name} WHERE target.bucket.name='my-bucket'",
      # "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.fn_dg.name} TO MANAGE objects IN COMPARTMENT ${var.compartment_name} WHERE target.bucket.name='my-output-bucket'",
      # "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.fn_dg.name} TO MANAGE dataflow-family IN COMPARTMENT ${var.compartment_name}",
      # "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.fn_dg.name} TO USE fn-invocation IN COMPARTMENT ${var.compartment_name}",
    ],
    # El Resource Schedule necesita invocar la Function.
    local.schedule_enabled ? [
      "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.schedule_dg[0].name} TO USE fn-function IN COMPARTMENT ${var.compartment_name}",
      "ALLOW DYNAMIC-GROUP ${oci_identity_dynamic_group.schedule_dg[0].name} TO USE fn-invocation IN COMPARTMENT ${var.compartment_name}",
    ] : []
  )
}
