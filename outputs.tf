output "newrelic_alert_policy_id" {
  value       = "${newrelic_alert_policy.this.id}"
  description = "ID of created New Relic alert policy"
}
