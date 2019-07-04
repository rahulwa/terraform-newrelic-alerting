provider "newrelic" {
  # Use NEWRELIC_API_KEY environment variable.
}

locals {
  original_prefix    = "${join("-", compact(concat(list(var.severity, var.stage, var.service_name), var.attributes)))}"
  alarm_label_prefix = "${lower(local.original_tags)}"
}

resource "newrelic_alert_policy" "this" {
  count  = "${var.newrelic_alert_policy_name == "" ? 1 : 0}"
  name   = "${local.alarm_label_prefix}"
}

data "newrelic_application" "app" {
  name = "${var.nr_service_name}"
}

data "newrelic_alert_policy" "this" {
  name        = "${var.newrelic_alert_policy_name != "" ? "${var.newrelic_alert_policy_name}" : "${local.alarm_label_prefix}"}"
  depends_on  = ["newrelic_alert_policy.this"]
}