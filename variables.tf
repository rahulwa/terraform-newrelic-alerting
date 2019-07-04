variable "service_name" {
  type        = "string"
  description = "Name of the service, avoid using `-` in name"
}

variable "severity" {
  type        = "string"
  description = "severity level of alert like `sev1`, `sev2` or `sev3`"
}

variable "stage" {
  type        = "string"
  description = "enviornment like `prod`, `stage`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes to put in alert name prefix, e.g. `1`"
}

variable "nr_service_name" {
  type        = "string"
  description = "New Relic app name that you want to monitor"
}

variable "runbook_url" {
  type        = "string"
  description = "URL of runbook for this service"
}

variable "cpu_utilisation_threshold_duration_minutes" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if CPU utlization was more than 90% in this interval for whole time."
}

variable "memory_free_threshold_byte" {
  type        = "string"
  description = "The maximum byte available for free memory in whole 5 minutes, triggers the alert."
}

variable "disk_free_threshold_percentage" {
  type        = "string"
  description = "The minimum percentage available for free disk in whole 5 minutes, triggers the alert."
}

variable "host_not_responding_threshold_duration_minutes" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if agent does not respont in this interval for whole time."
  default     = ""
}

variable "service_unavailable_threshold_duration_minutes" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if service was not running in this interval for whole time."
}

variable "not_running_process_where_query" {
  type        = "string"
  description = "the where cluase of process nrql for selecting processes. like `\"commandName IN ('supervisord', 'gunicorn')\"`"
}

variable "select_transtion_request_uri_like" {
  type        = "string"
  description = "To select specific API path for alerting, like `'%service%'`."
  default     = "%"
}

variable "allow_facet" {
  type        = "string"
  description = "If true, it add facets in NRQL alerts."
  default     = true
}

variable "select_transcation_name_like" {
  type        = "string"
  description = "To select specific function name for alerting, like `'%function%'`."
  default     = "%"
}

variable "error_5xx_threshold_count" {
  type        = "string"
  description = "The maximum count of 5XX errors in whole 5 minutes, triggers the alert."
}

variable "error_5xx_threshold_percentage" {
  type        = "string"
  description = "The maximum percentage of 5XX errors in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "database_transcation_threshold_seconds" {
  type        = "string"
  description = "The maximum time taken by 90% of database transcations greater than it in whole 5 minutes, triggers the alert."
}

variable "web_transaction_threshold_time" {
  type        = "string"
  description = "The maximum time taken by 90% of web transcations greater than it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "transaction_threshold_seconds" {
  type        = "string"
  description = "The maximum time taken by 90% of transcations greater than it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "apdex_threshold" {
  type        = "string"
  description = "The New Relic apdex below than it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "error_percentage_threshold" {
  type        = "string"
  description = "The New Relic error precentage greater than it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "response_time_background_threshold_seconds" {
  type        = "string"
  description = "The responce time for background transcations greater then it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "response_time_web_threshold_seconds" {
  type        = "string"
  description = "The responce time for web transcations greater then it in whole 5 minutes, triggers the alert."
  default     = ""
}

variable "select_hosts_where_clause" {
  type        = "string"
  description = "The where query for selecting hosts in infra alerts."
  default     = ""
}

########################### Generic NRQL alerts #############################################
variable "nrql_generic_name" {
  type        = "string"
  description = "The name of alert condition."
  default     = ""
}

variable "nrql_generic_query" {
  type        = "string"
  description = "The NRQL query of alert."
  default     = ""
}

variable "nrql_generic_operator" {
  type        = "string"
  description = "above, below, or equal."
  default     = "above"
}

variable "nrql_generic_threshold" {
  type        = "string"
  description = "The threshold of the alert."
  default     = ""
}
################################################################################################