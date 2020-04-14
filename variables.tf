variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "zone_id" {
  type        = string
  default     = ""
  description = "Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas"
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnets" {
  type        = list(string)
  description = "List of VPC subnet IDs"
}

variable "instance_type" {
  type        = string
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_port" {
  type        = number
  default     = 3306
  description = "Database port"
}

variable "admin_user" {
  type        = string
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = string
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = string
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "cluster_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB cluster parameters to apply"
}

variable "instance_parameters" {
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default     = []
  description = "List of DB instance parameters to apply"
}

variable "cluster_family" {
  type        = string
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = string
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = string
  default     = "provisioned"
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "engine_version" {
  type        = string
  default     = ""
  description = "The version number of the database engine to use"
}

variable "scaling_configuration" {
  type = list(object({
    auto_pause               = bool
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = number
    timeout_action           = string
  }))
  default     = []
  description = "List of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless`"
}

variable "timeouts_configuration" {
  type = list(object({
    create = string
    update = string
    delete = string
  }))
  default     = []
  description = "List of timeout values per action. Only valid actions are `create`, `update` and `delete`"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks allowed to access the cluster"
}

variable "publicly_accessible" {
  type        = bool
  description = "Set to true if you want your cluster to be publicly accessible (such as via QuickSight)"
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode`"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true`"
  default     = ""
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
  default     = false
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = true
}

variable "iam_database_authentication_enabled" {
  type        = bool
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  default     = false
}

variable "rds_monitoring_interval" {
  type        = number
  description = "Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60)"
  default     = 0
}

variable "rds_monitoring_role_arn" {
  type        = string
  default     = ""
  description = "The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs"
}

variable "replication_source_identifier" {
  type        = string
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery"
  default     = []
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights"
}

variable "performance_insights_kms_key_id" {
  type        = string
  default     = ""
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to true"
}

variable "autoscaling_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable cluster autoscaling"
}

variable "autoscaling_policy_type" {
  type        = string
  default     = "TargetTrackingScaling"
  description = "Autoscaling policy type. `TargetTrackingScaling` and `StepScaling` are supported"
}

variable "autoscaling_target_metrics" {
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
  description = "The metrics type to use. If this value isn't provided the default is CPU utilization"
}

variable "autoscaling_target_value" {
  type        = number
  default     = 75
  description = "The target value to scale with respect to target metrics"
}

variable "autoscaling_scale_in_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling down activity can start. Default is 300s"
}

variable "autoscaling_scale_out_cooldown" {
  type        = number
  default     = 300
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling up activity can start. Default is 300s"
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of instances to be maintained by the autoscaler"
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 5
  description = "Maximum number of instances to be maintained by the autoscaler"
}

variable "instance_availability_zone" {
  type        = string
  default     = ""
  description = "Optional parameter to place cluster instances in a specific availability zone. If left empty, will place randomly"
}

variable "cluster_dns_name" {
  type        = string
  description = "Name of the cluster CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `master.var.name`"
  default     = ""
}

variable "reader_dns_name" {
  type        = string
  description = "Name of the reader endpoint CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `replicas.var.name`"
  default     = ""
}

variable "global_cluster_identifier" {
  type        = string
  description = "ID of the Aurora global cluster"
  default     = ""
}

variable "source_region" {
  type        = string
  description = "Source Region of primary cluster, needed when using encrypted storage and region replicas"
  default     = ""
}

variable "iam_roles" {
  type        = list(string)
  description = "Iam roles for the Aurora cluster"
  default     = []
}

variable "backtrack_window" {
  type        = number
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. Must be between 0 and 259200 (72 hours)"
  default     = 0
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups"

  default = []
}
