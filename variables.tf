variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "name" {
  type        = "string"
  description = "Name of the application"
}

variable "zone_id" {
  type        = "string"
  description = "Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the DB master and replicas"
}

variable "security_groups" {
  type        = "list"
  description = "List of security groups to be allowed to connect to the DB instance"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID to create the cluster in (e.g. `vpc-a22222ee`)"
}

variable "subnets" {
  type        = "list"
  description = "List of VPC subnet IDs"
}

variable "availability_zones" {
  type        = "list"
  description = "List of Availability Zones that instances in the DB cluster can be created in"
}

variable "instance_type" {
  type        = "string"
  default     = "db.t2.small"
  description = "Instance type to use"
}

variable "cluster_size" {
  type        = "string"
  default     = "2"
  description = "Number of DB instances to create in the cluster"
}

variable "snapshot_identifier" {
  type        = "string"
  default     = ""
  description = "Specifies whether or not to create this cluster from a snapshot"
}

variable "db_name" {
  type        = "string"
  description = "Database name"
}

variable "db_port" {
  type        = "string"
  default     = "3306"
  description = "Database port"
}

variable "admin_user" {
  type        = "string"
  default     = "admin"
  description = "(Required unless a snapshot_identifier is provided) Username for the master DB user"
}

variable "admin_password" {
  type        = "string"
  description = "(Required unless a snapshot_identifier is provided) Password for the master DB user"
}

variable "retention_period" {
  type        = "string"
  default     = "5"
  description = "Number of days to retain backups for"
}

variable "backup_window" {
  type        = "string"
  default     = "07:00-09:00"
  description = "Daily time range during which the backups happen"
}

variable "maintenance_window" {
  type        = "string"
  default     = "wed:03:00-wed:04:00"
  description = "Weekly time range during which system maintenance can occur, in UTC"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "cluster_parameters" {
  type        = "list"
  default     = []
  description = "List of DB parameters to apply"
}

variable "cluster_family" {
  type        = "string"
  default     = "aurora5.6"
  description = "The family of the DB cluster parameter group"
}

variable "engine" {
  type        = "string"
  default     = "aurora"
  description = "The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-postgresql`"
}

variable "engine_version" {
  type        = "string"
  default     = ""
  description = "The version number of the database engine to use"
}

variable "allowed_cidr_blocks" {
  type        = "list"
  default     = []
  description = "List of CIDR blocks allowed to access"
}
