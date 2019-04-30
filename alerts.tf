resource "newrelic_infra_alert_condition" "cpu_alert" {
  count      = "${var.cpu_utilisation_thresold_duration_minutes != "" ? 1 : 0}"
  policy_id  = "${newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_CPU_Utilisation"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "cpuPercent"
  comparison = "above"
  where      = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration      = "${var.cpu_utilisation_thresold_duration_minutes}"
    value         = 90
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "memory_alert" {
  count      = "${var.memory_free_thresold_byte != "" ? 1 : 0}"
  policy_id  = "${newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_Memory_Utilisation"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "memoryFreeBytes"
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
  event      = "SystemSample"
  select     = "diskFreePercent"
  comparison = "below"
  where      = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration      = 5
    value         = "${var.disk_free_thresold_percentage}"
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "host_not_reporting" {
  count     = "${var.host_not_responding_thresold_duration_minutes != "" ? 1 : 0}"
  policy_id = "${newrelic_alert_policy.this.id}"
  name      = "${local.alarm_label_prefix}:Host_Not_Reporting"
  type      = "infra_host_not_reporting"
  where     = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration = "${var.host_not_responding_thresold_duration_minutes}"
  }
}

resource "newrelic_infra_alert_condition" "service_not_running" {
  count         = "${var.not_running_process_where_query != "" && var.service_unavailable_thresold_duration_minutes != "" ? 1 : 0}"
  policy_id     = "${newrelic_alert_policy.this.id}"
  name          = "${local.alarm_label_prefix}:Service_Not_Running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "${var.not_running_process_where_query}"               # like: `"commandName IN ('supervisord', 'gunicorn')"`
  where         = "(`apmApplicationNames` = '|${var.nw_service_name}|')"

  critical {
    duration = "${var.service_unavailable_thresold_duration_minutes}"
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
    query       = "SELECT count(*) FROM Transaction WHERE appName IN ('${var.nw_service_name}') AND response.status >= '500' AND request.uri LIKE '${var.select_transtion_request_uri_like}' FACET request.uri"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "db_long_durantion" {
  count       = "${var.percentile95_database_transcation_thresold_seconds != "" ? 1 : 0}"
  policy_id   = "${newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:95Percentile_Database_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.percentile95_database_transcation_thresold_seconds}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(databaseDuration, 95) FROM Transaction WHERE appName IN ('${var.nw_service_name}') AND name LIKE '${var.select_transcation_name_like}' FACET name"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "web_transaction_long_durantion" {
  count       = "${var.percentile95_web_transaction_thresold_seconds != "" ? 1 : 0}"
  policy_id   = "${newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:95Percentile_Web_Transaction_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.percentile95_web_transaction_thresold_seconds}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(duration, 95) FROM Transaction WHERE appName IN ('${var.nw_service_name}') AND request.uri LIKE '${var.select_transtion_request_uri_like}' FACET request.uri"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "transaction_long_durantion" {
  count       = "${var.percentile95_transaction_thresold_seconds != "" ? 1 : 0}"
  policy_id   = "${var.newrelic_alert_policy_id}"
  name        = "${local.alarm_label_prefix}:95Percentile_Transaction_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.percentile95_transaction_thresold_seconds}"
    time_function = "all"
  }

  nrql {
    query       = "SELECT percentile(duration, 95) FROM Transaction WHERE appName IN ('${var.nw_service_name}') AND name LIKE '${var.select_transcation_name_like}' FACET name"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_alert_condition" "apdex" {
  count     = "${var.apdex_thresold != "" ? 1 : 0}"
  policy_id = "${var.newrelic_alert_policy_id}"

  name            = "${local.alarm_label_prefix}:Apdex_Error"
  type            = "apm_app_metric"
  entities        = ["${data.newrelic_application.app.id}"]
  metric          = "apdex"
  runbook_url     = "${var.runbook_url}"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "below"
    priority      = "critical"
    threshold     = "${var.apdex_thresold}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "error_percentage" {
  count     = "${var.error_percentage_thresold != "" ? 1 : 0}"
  policy_id = "${var.newrelic_alert_policy_id}"

  name            = "${local.alarm_label_prefix}:Error_Percentage"
  type            = "apm_app_metric"
  entities        = ["${data.newrelic_application.app.id}"]
  metric          = "error_percentage"
  runbook_url     = "${var.runbook_url}"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.error_percentage_thresold}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "response_time_background" {
  count     = "${var.response_time_background_thresold_seconds != "" ? 1 : 0}"
  policy_id = "${var.newrelic_alert_policy_id}"

  name            = "${local.alarm_label_prefix}:Response_Time_Background_Slow"
  type            = "apm_app_metric"
  entities        = ["${data.newrelic_application.app.id}"]
  metric          = "response_time_background"
  runbook_url     = "${var.runbook_url}"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.response_time_background_thresold_seconds}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "response_time_web" {
  count     = "${var.response_time_web_thresold_seconds != "" ? 1 : 0}"
  policy_id = "${var.newrelic_alert_policy_id}"

  name            = "${local.alarm_label_prefix}:Response_Time_Web_Slow"
  type            = "apm_app_metric"
  entities        = ["${data.newrelic_application.app.id}"]
  metric          = "response_time_web"
  runbook_url     = "${var.runbook_url}"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.response_time_web_thresold_seconds}"
    time_function = "all"
  }
}