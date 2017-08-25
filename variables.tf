variable "namespace" {
  default = "global"
}

variable "stage" {
  default = "default"
}

variable "name" {
  default = "db"
}

variable "zone_id" {
  default = ""
}

variable "security_groups" {
  type = "list"
}

variable "vpc_id" {
  default = ""
}

variable "subnets" {
  type    = "list"
  default = []
}

variable "availability_zones" {
  type    = "list"
  default = []
}

variable "instance_type" {
  default = "db.t2.small"
}

variable "cluster_size" {
  default = "2"
}

variable "snapshot_identifier" {
  default = ""
}

variable "db_name" {
  default = "app"
}

variable "db_port" {
  default = "3306"
}

variable "admin_user" {
  default = "admin"
}

variable "admin_password" {
  default = ""
}

variable "retention_period" {
  default = "5"
}

variable "backup_window" {
  default = "07:00-09:00"
}

variable "maintenance_window" {
  default = "wed:03:00-wed:04:00"
}
