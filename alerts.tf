resource "newrelic_infra_alert_condition" "cpu_alert" {
  count      = "${var.cpu_utilisation_threshold_duration_minutes != "" ? 1 : 0}"
  policy_id  = "${data.newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_CPU_Utilisation"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "cpuPercent"
  comparison = "above"
  where      = "${local.select_hosts_where_clause}"

  critical {
    duration      = "${var.cpu_utilisation_threshold_duration_minutes}"
    value         = 90
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "memory_alert" {
  count      = "${var.memory_free_threshold_byte != "" ? 1 : 0}"
  policy_id  = "${data.newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_Memory_Utilisation"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "memoryFreeBytes"
  comparison = "below"
  where      = "${local.select_hosts_where_clause}"

  critical {
    duration      = 5
    value         = "${var.memory_free_threshold_byte}"
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "disk_alert" {
  count      = "${var.disk_free_threshold_percentage != "" ? 1 : 0}"
  policy_id  = "${data.newrelic_alert_policy.this.id}"
  name       = "${local.alarm_label_prefix}:High_Disk_Utilisation"
  type       = "infra_metric"
  event      = "SystemSample"
  select     = "diskFreePercent"
  comparison = "below"
  where      = "${local.select_hosts_where_clause}"

  critical {
    duration      = 5
    value         = "${var.disk_free_threshold_percentage}"
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "host_not_reporting" {
  count     = "${var.host_not_responding_threshold_duration_minutes != "" ? 1 : 0}"
  policy_id = "${data.newrelic_alert_policy.this.id}"
  name      = "${local.alarm_label_prefix}:Host_Not_Reporting"
  type      = "infra_host_not_reporting"
  where     = "${local.select_hosts_where_clause}"

  critical {
    duration = "${var.host_not_responding_threshold_duration_minutes}"
  }
}

resource "newrelic_infra_alert_condition" "service_not_running" {
  count         = "${var.not_running_process_where_query != "" && var.service_unavailable_threshold_duration_minutes != "" ? 1 : 0}"
  policy_id     = "${data.newrelic_alert_policy.this.id}"
  name          = "${local.alarm_label_prefix}:Service_Not_Running"
  type          = "infra_process_running"
  comparison    = "equal"
  process_where = "${var.not_running_process_where_query}"               # like: `"commandName IN ('supervisord', 'gunicorn')"`
  where         = "${local.select_hosts_where_clause}"

  critical {
    duration = "${var.service_unavailable_threshold_duration_minutes}"
    value    = 0
  }
}

resource "newrelic_nrql_alert_condition" "5xx_error" {
  count       = "${var.error_5xx_threshold_count != "" ? 1 : 0}"
  policy_id   = "${data.newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:5XX_Error_High"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.error_5xx_threshold_count}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT count(*) FROM Transaction WHERE appName IN ('${var.nr_service_name}') AND (httpResponseCode >= '500' OR response.status >= '500') AND request.uri LIKE '${var.select_transtion_request_uri_like}' ${var.allow_facet == "true" ? "FACET name" : ""}"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "5xx_percentage_error" {
  count       = "${var.error_5xx_threshold_percentage != "" ? 1 : 0}"
  policy_id   = "${var.newrelic_alert_policy_id}"
  name        = "${module.alarm_label_prefix.id}:5XX_Errors_High"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = "${var.duration_threshold_minutes}"
    operator      = "above"
    priority      = "${var.priority}"
    threshold     = "${var.error_5xx_threshold_percentage}"
    time_function = "all"
  }

  nrql {
    query       = "SELECT percentage(count(*), WHERE response.status >= '500' OR httpResponseCode >= '500') FROM Transaction WHERE appName IN ('${var.nr_service_name}') AND transactionType='Web' AND request.uri LIKE '${var.select_transtion_request_uri_like}' ${var.allow_facet == "true" ? "FACET name" : ""}"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "db_long_durantion" {
  count       = "${var.database_transcation_threshold_seconds != "" ? 1 : 0}"
  policy_id   = "${data.newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:Database_Call_Slow"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.database_transcation_threshold_seconds}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(databaseDuration, 90) FROM Transaction WHERE appName IN ('${var.nr_service_name}') AND name LIKE '${var.select_transcation_name_like}' ${var.allow_facet == "true" ? "FACET name" : ""}"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "web_transaction_long_durantion" {
  count       = "${var.web_transaction_threshold_seconds != "" ? 1 : 0}"
  policy_id   = "${data.newrelic_alert_policy.this.id}"
  name        = "${local.alarm_label_prefix}:Web_Requests_High_Latency"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.web_transaction_threshold_seconds}"
    time_function = "any"
  }

  nrql {
    query       = "SELECT percentile(webDuration, 90) FROM Transaction WHERE appName IN ('${var.nr_service_name}') AND request.uri LIKE '${var.select_transtion_request_uri_like}' ${var.allow_facet == "true" ? "FACET name" : ""}"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_nrql_alert_condition" "transaction_long_durantion" {
  count       = "${var.transaction_threshold_seconds != "" ? 1 : 0}"
  policy_id   = "${var.newrelic_alert_policy_id}"
  name        = "${local.alarm_label_prefix}:Transactions_High_Latency"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "${var.transaction_threshold_seconds}"
    time_function = "all"
  }

  nrql {
    query       = "SELECT percentile(duration, 90) FROM Transaction WHERE appName IN ('${var.nr_service_name}') AND name LIKE '${var.select_transcation_name_like}' ${var.allow_facet == "true" ? "FACET name" : ""}"
    since_value = "5"
  }

  value_function = "single_value"
}

resource "newrelic_alert_condition" "apdex" {
  count     = "${var.apdex_threshold != "" ? 1 : 0}"
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
    threshold     = "${var.apdex_threshold}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "error_percentage" {
  count     = "${var.error_percentage_threshold != "" ? 1 : 0}"
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
    threshold     = "${var.error_percentage_threshold}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "response_time_background" {
  count     = "${var.response_time_background_threshold_seconds != "" ? 1 : 0}"
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
    threshold     = "${var.response_time_background_threshold_seconds}"
    time_function = "all"
  }
}

resource "newrelic_alert_condition" "response_time_web" {
  count     = "${var.response_time_web_threshold_seconds != "" ? 1 : 0}"
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
    threshold     = "${var.response_time_web_threshold_seconds}"
    time_function = "all"
  }
}

########################### Generic NRQL alerts #############################################
resource "newrelic_nrql_alert_condition" "nrql_generic" {
  count       = "${var.nrql_generic_name != "" && var.nrql_generic_query != "" && var.nrql_generic_threshold != "" ? 1 : 0}"
  policy_id   = "${data.newrelic_alert_policy.this.id}"
  name        = "${module.alarm_label_prefix.id}:${var.nrql_generic_name}"
  enabled     = true
  runbook_url = "${var.runbook_url}"

  term {
    duration      = 5
    operator      = "${var.nrql_generic_operator}"
    priority      = "critical"
    threshold     = "${var.nrql_generic_threshold}"
    time_function = "all"
  }

  nrql {
    query       = "${var.nrql_generic_query}"
    since_value = "5"
  }

  value_function = "single_value"
}

################################################################################################
