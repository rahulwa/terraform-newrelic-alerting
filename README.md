# terraform-newrelic-alerting Module
A Terraform module for New Relic alerting with following preconfigured alerts for an application:
- High CPU Utilisation
- High Memory Utilisation
- High Disk Utilisation
- Host Not Reporting
- Service Not Running
- 5XX Error High
- Database Call Slow
- Web Requests High Latency
- Transactions High Latency
- Apdex Error
- Error Percentage
- Response Time Background Slow
- Response Time Web Slow

For more info, look into [alerts.tf file](./alerts.tf).

It can be used as

```hcl
module "newrelic_alerts_sev1" {
  source                                              = "<PATH/TO/terraform-newrelic-alerting/"
  # newrelic_alert_policy_name                         = "<EXISTING_POLICY_NAME_IF_THESE_ALERTRULES_NEEDS_TO_BE_CREATED_INSIDE_IT_INSTEAD_OF_NEW_POLICY>
  service_name                                        = "EXAMPLE-APP"                  # put here name of application
  severity                                            = "severity1"
  nr_service_name                                     = "<NEWRELIC-APP-NAME>"          # put here newrelic app name
  cpu_utilisation_threshold_duration_minutes          = "15"
  memory_free_threshold_byte                          = "524288000"                    # 500MB
  disk_free_threshold_percentage                      = "30"
  # service_unavailable_threshold_duration_minutes      = "5"
  # not_running_process_where_query                     = "commandName IN ('supervisord')" # Process monitoring NRQL where -->
  error_5xx_threshold_count                           = "10"
  database_transcation_threshold_seconds              = 1
  web_transaction_threshold_seconds                   = 1
  transaction_threshold_seconds                       = 5
  apdex_threshold                                     = "0.8"
  error_percentage_threshold                          = 10
  response_time_background_threshold_seconds          = 3
  response_time_web_threshold_seconds                 = 1
  runbook_url                                         = "<RUNBOOK-URL>"               # Put here runbook url of application
}
```