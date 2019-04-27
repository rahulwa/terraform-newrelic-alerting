provider "newrelic" {
  # Use NEWRELIC_API_KEY environment variable.
}

locals {
  original_prefix    = "${join("-", compact(concat(list(var.severity, var.stage, var.service_name), var.attributes)))}"
  alarm_label_prefix = "${lower(local.original_tags)}"
}

resource "newrelic_alert_policy" "this" {
  name = "${local.alarm_label_prefix}"
}

data "newrelic_application" "app" {
  name = "${var.nw_service_name}"
}