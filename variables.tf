variable "service_name" {
  type        = "string"
  description = "Name of the service, avoid using `-` in name"
}

variable "severity" {
  type        = "string"
  description = "severity level of alert like `s1`, `s2` or `s3`"
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

variable "nw_service_name" {
  type        = "string"
  description = "New Relic app name that you want to monitor"
}

variable "runbook_url" {
  type        = "string"
  description = "URL of runbook for this service"
}

variable "cpu_utilisation_thresold_duration" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if CPU utlization was more than 90% in this interval for whole time."
}

variable "memory_free_thresold_byte" {
  type        = "string"
  description = "The maximum byte available for free memory in whole 5 minutes, triggers the alert."
}

variable "disk_free_thresold_percentage" {
  type        = "string"
  description = "The minimum percentage available for free disk in whole 5 minutes, triggers the alert."
}

variable "host_not_responding_thresold_duration" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if agent does not respont in this interval for whole time."
  default     = ""
}

variable "service_unavailable_thresold_duration" {
  type        = "string"
  description = "The duration in minutes, to trigger the alert if service was not running in this interval for whole time."
}

variable "not_running_process_where_query" {
  type        = "string"
  description = "the where cluase of process nrql for selecting processes. like `\"commandName IN ('supervisord', 'gunicorn')\"`"
}

variable "error_5xx_thresold_count" {
  type        = "string"
  description = "The maximum count of 5XX errors in whole 5 minutes, triggers the alert."
}

variable "percentile95_database_transcation_thresold_time" {
  type        = "string"
  description = "The maximum time taken by 95% of database transcations greater than it in whole 5 minutes, triggers the alert."
}

variable "percentile95_transaction_thresold_time" {
  type        = "string"
  description = "The maximum time taken by 95% of transcations greater than it in whole 5 minutes, triggers the alert."
}
