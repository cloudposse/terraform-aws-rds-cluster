variable "region" {
  type        = string
  description = "AWS region"
}

variable "availability_zones" {
  type = list(string)
}

variable "instance_type" {
  type        = string
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = number
  description = "Number of DB instances to create in the cluster"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "admin_user" {
  type        = string
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = string
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "cluster_family" {
  type        = string
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = string
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql`"
}

variable "engine_mode" {
  type        = string
  description = "The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless`"
}

variable "deletion_protection" {
  type        = bool
  description = "If the DB instance should have deletion protection enabled"
}

variable "autoscaling_enabled" {
  type        = bool
  description = "Whether to enable cluster autoscaling"
}

variable "enhanced_monitoring_role_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable the creation of the enhanced monitoring IAM role. If set to `false`, the module will not create a new role and will use `rds_monitoring_role_arn` for enhanced monitoring"
}

variable "rds_monitoring_interval" {
  type        = number
  description = "The interval, in seconds, between points when enhanced monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
}
