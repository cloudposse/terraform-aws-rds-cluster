module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.17.0"
  namespace   = var.namespace
  name        = var.name
  stage       = var.stage
  environment = var.environment
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
  enabled     = var.enabled
}

resource "aws_security_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = module.label.id
  description = "Allow inbound traffic from Security Groups and CIDRs"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.security_groups
  }

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.label.tags
}

resource "aws_rds_cluster" "default" {
  count                               = var.enabled ? 1 : 0
  cluster_identifier                  = var.cluster_identifier == "" ? module.label.id : var.cluster_identifier
  database_name                       = var.db_name
  master_username                     = var.admin_user
  master_password                     = var.admin_password
  backup_retention_period             = var.retention_period
  preferred_backup_window             = var.backup_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  final_snapshot_identifier           = var.cluster_identifier == "" ? lower(module.label.id) : lower(var.cluster_identifier)
  skip_final_snapshot                 = var.skip_final_snapshot
  apply_immediately                   = var.apply_immediately
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_arn
  source_region                       = var.source_region
  snapshot_identifier                 = var.snapshot_identifier
  vpc_security_group_ids              = compact(flatten([join("", aws_security_group.default.*.id), var.vpc_security_group_ids]))
  preferred_maintenance_window        = var.maintenance_window
  db_subnet_group_name                = join("", aws_db_subnet_group.default.*.name)
  db_cluster_parameter_group_name     = join("", aws_rds_cluster_parameter_group.default.*.name)
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  tags                                = module.label.tags
  engine                              = var.engine
  engine_version                      = var.engine_version
  engine_mode                         = var.engine_mode
  global_cluster_identifier           = var.global_cluster_identifier
  iam_roles                           = var.iam_roles
  backtrack_window                    = var.backtrack_window
  enable_http_endpoint                = var.engine_mode == "serverless" && var.enable_http_endpoint ? true : false

  dynamic "scaling_configuration" {
    for_each = var.scaling_configuration
    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts_configuration
    content {
      create = lookup(timeouts.value, "create", "120m")
      update = lookup(timeouts.value, "update", "120m")
      delete = lookup(timeouts.value, "delete", "120m")
    }
  }

  replication_source_identifier   = var.replication_source_identifier
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection
}

locals {
  cluster_instance_count = var.enabled ? var.cluster_size : 0
}

resource "aws_rds_cluster_instance" "default" {
  count                           = local.cluster_instance_count
  identifier                      = var.cluster_identifier == "" ? "${module.label.id}-${count.index + 1}" : "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier              = join("", aws_rds_cluster.default.*.id)
  instance_class                  = var.instance_type
  db_subnet_group_name            = join("", aws_db_subnet_group.default.*.name)
  db_parameter_group_name         = join("", aws_db_parameter_group.default.*.name)
  publicly_accessible             = var.publicly_accessible
  tags                            = module.label.tags
  engine                          = var.engine
  engine_version                  = var.engine_version
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  monitoring_interval             = var.rds_monitoring_interval
  monitoring_role_arn             = var.rds_monitoring_role_arn
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  availability_zone               = var.instance_availability_zone
}

resource "aws_db_subnet_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = module.label.id
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnets
  tags        = module.label.tags
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = module.label.id
  description = "DB cluster parameter group"
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = module.label.tags
}

resource "aws_db_parameter_group" "default" {
  count       = var.enabled ? 1 : 0
  name        = module.label.id
  description = "DB instance parameter group"
  family      = var.cluster_family

  dynamic "parameter" {
    for_each = var.instance_parameters
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = module.label.tags
}

locals {
  cluster_dns_name_default = "master.${var.name}"
  cluster_dns_name         = var.cluster_dns_name != "" ? var.cluster_dns_name : local.cluster_dns_name_default
  reader_dns_name_default  = "replicas.${var.name}"
  reader_dns_name          = var.reader_dns_name != "" ? var.reader_dns_name : local.reader_dns_name_default
}

module "dns_master" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.5.0"
  enabled = var.enabled && length(var.zone_id) > 0 ? true : false
  name    = local.cluster_dns_name
  zone_id = var.zone_id
  records = coalescelist(aws_rds_cluster.default.*.endpoint, [""])
}

module "dns_replicas" {
  source  = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.5.0"
  enabled = var.enabled && length(var.zone_id) > 0 && var.engine_mode != "serverless" ? true : false
  name    = local.reader_dns_name
  zone_id = var.zone_id
  records = coalescelist(aws_rds_cluster.default.*.reader_endpoint, [""])
}

resource "aws_appautoscaling_target" "replicas" {
  count              = var.enabled && var.autoscaling_enabled ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${join("", aws_rds_cluster.default.*.id)}"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "replicas" {
  count              = var.enabled && var.autoscaling_enabled ? 1 : 0
  name               = module.label.id
  service_namespace  = join("", aws_appautoscaling_target.replicas.*.service_namespace)
  scalable_dimension = join("", aws_appautoscaling_target.replicas.*.scalable_dimension)
  resource_id        = join("", aws_appautoscaling_target.replicas.*.resource_id)
  policy_type        = var.autoscaling_policy_type

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.autoscaling_target_metrics
    }

    disable_scale_in   = false
    target_value       = var.autoscaling_target_value
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown
  }
}
