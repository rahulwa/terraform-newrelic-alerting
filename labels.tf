locals {
  select_hosts_apmApplicationNames = "(`apmApplicationNames` LIKE '%|${var.nr_service_name}|%')"
  select_hosts_where_clause        = "${var.select_hosts_where_clause == "" ? local.select_hosts_apmApplicationNames : var.select_hosts_where_clause}"
}