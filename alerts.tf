resource "newrelic_infra_alert_condition" "cpu_alert" {
  count      = "${var.cpu_utilisation_thresold_duration != "" ? 1 : 0}"
  policy_id  = "${newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_CPU_Utilisation"
  type       = "infra_metric"
  event      = "cpuPercent"
  select     = "SystemSample"
  comparison = "above"
  where      = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration      = "${var.cpu_utilisation_thresold_duration}"
    value         = 90
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "memory_alert" {
  count      = "${var.memory_free_thresold_byte != "" ? 1 : 0}"
  policy_id  = "${newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_Memory_Utilisation"
  type       = "infra_metric"
  event      = "memoryFreeBytes"
  select     = "SystemSample"
  comparison = "below"
  where      = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration      = 5
    value         = "${var.memory_free_thresold_byte}"
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "disk_alert" {
  count      = "${var.disk_free_thresold_percentage != "" ? 1 : 0}"
  policy_id  = "${newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_Disk_Utilisation"
  type       = "infra_metric"
  event      = "diskFreePercent"
  select     = "SystemSample"
  comparison = "below"
  where      = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration      = 5
    value         = "${var.disk_free_thresold_percentage}"
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "host_not_reporting" {
  count     = "${var.host_not_responding_thresold_duration != "" ? 1 : 0}"
  policy_id = "${newrelic_alert_policy.this.id}"
  name      = "${local.alarm_label_prefix}:Host_Not_Reporting"
  type      = "infra_host_not_reporting"
  where     = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration = "${var.host_not_responding_thresold_duration}"
  }
}

resource "newrelic_infra_alert_condition" "service_not_running" {
  count         = "${var.not_running_process_where_query != "" ? 1 : 0}"
  policy_id     = "${newrelic_alert_policy.this.id}"
  name          = "${local.alarm_label_prefix}:Service_Not_Running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "${var.not_running_process_where_query}"               # like: `"commandName IN ('supervisord', 'gunicorn')"`
  where         = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration = "${var.service_unavailable_thresold_duration}"
    value    = 0
  }
}

resource "newrelic_nrql_alert_condition" "5xx_error" {
  count       = "${var.error_5xx_thresold_count != "" ? 1 : 0}"
  policy_id   = "${newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:5XX_Error_High"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.error_5xx_thresold_count}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT count(*) FROM Transaction WHERE appName IN ('${var.nw_service_name}') AND response.status >= '500' FACET request.uri"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "db_long_durantion" {
  count       = "${var.percentile95_database_transcation_thresold_time != "" ? 1 : 0}"
  policy_id   = "${newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:95Percentile_Database_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.percentile95_database_transcation_thresold_time}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(databaseDuration, 95) FROM Transaction WHERE appName IN ('${var.nw_service_name}')"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "transaction_long_durantion" {
  count       = "${var.percentile95_transaction_thresold_time != "" ? 1 : 0}"
  policy_id   = "${newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:95Percentile_Transaction_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.percentile95_transaction_thresold_time}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(duration, 95) FROM Transaction WHERE appName IN ('${var.nw_service_name}')"
    since_value = "5"
  }

  value_function = "single_value"
}
