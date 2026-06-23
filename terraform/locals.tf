locals {
  # Configuración central de la Function / Central Function config.
  cfg = jsondecode(file("${path.module}/../function.json"))

  app_name      = local.cfg.app_name
  function_name = local.cfg.function_name
  memory_in_mbs = try(local.cfg.memory_in_mbs, 256)
  timeout       = try(local.cfg.timeout_in_seconds, 60)

  # Variables de entorno que se inyectan en la Function.
  fn_config     = try(local.cfg.config, {})
  freeform_tags = try(local.cfg.tag, {})

  # Scheduler (CRON) opcional, controlado por function.json.
  schedule_enabled = try(local.cfg.schedule.enabled, false)
  schedule_cron    = try(local.cfg.schedule.cron, "0 6 * * *")
}
