locals {
  cluster_instance_count = module.this.enabled ? var.cluster_size : 0
  is_regional_cluster    = var.cluster_type == "regional"
}

resource "aws_security_group" "default" {
  count       = module.this.enabled ? 1 : 0
  name        = module.this.id
  description = "Allow inbound traffic from Security Groups and CIDRs"
  vpc_id      = var.vpc_id
  tags        = module.this.tags
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = module.this.enabled ? length(var.security_groups) : 0
  description              = "Allow inbound traffic from existing security groups"
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = var.security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = module.this.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description       = "Allow inbound traffic from existing CIDR blocks"
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
}

resource "aws_security_group_rule" "egress" {
  count             = module.this.enabled ? 1 : 0
  description       = "Allow outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
}

# The name "primary" is poorly chosen. We actually mean standalone or regional.
# The primary cluster of a global database is actually created with the "secondary" cluster resource below.
resource "aws_rds_cluster" "primary" {
  count                               = module.this.enabled && local.is_regional_cluster ? 1 : 0
  cluster_identifier                  = var.cluster_identifier == "" ? module.this.id : var.cluster_identifier
  database_name                       = var.db_name
  master_username                     = var.admin_user
  master_password                     = var.admin_password
  backup_retention_period             = var.retention_period
  preferred_backup_window             = var.backup_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  final_snapshot_identifier           = var.cluster_identifier == "" ? lower(module.this.id) : lower(var.cluster_identifier)
  skip_final_snapshot                 = var.skip_final_snapshot
  apply_immediately                   = var.apply_immediately
  storage_encrypted                   = var.engine_mode == "serverless" ? null : var.storage_encrypted
  kms_key_id                          = var.kms_key_arn
  source_region                       = var.source_region
  snapshot_identifier                 = var.snapshot_identifier
  vpc_security_group_ids              = compact(flatten([join("", aws_security_group.default.*.id), var.vpc_security_group_ids]))
  preferred_maintenance_window        = var.maintenance_window
  db_subnet_group_name                = join("", aws_db_subnet_group.default.*.name)
  db_cluster_parameter_group_name     = join("", aws_rds_cluster_parameter_group.default.*.name)
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  tags                                = module.this.tags
  engine                              = var.engine
  engine_version                      = var.engine_version
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  engine_mode                         = var.engine_mode
  iam_roles                           = var.iam_roles
  backtrack_window                    = var.backtrack_window
  enable_http_endpoint                = var.engine_mode == "serverless" && var.enable_http_endpoint ? true : false

  depends_on = [
    aws_db_subnet_group.default,
    aws_rds_cluster_parameter_group.default,
    aws_security_group.default,
  ]

  dynamic "s3_import" {
    for_each = var.s3_import[*]
    content {
      bucket_name           = lookup(s3_import.value, "bucket_name", null)
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = lookup(s3_import.value, "ingestion_role", null)
      source_engine         = lookup(s3_import.value, "source_engine", null)
      source_engine_version = lookup(s3_import.value, "source_engine_version", null)
    }
  }

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

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time
    content {
      source_cluster_identifier  = lookup(restore_to_point_in_time.value, "source_cluster_identifier", "120m")
      restore_type               = lookup(restore_to_point_in_time.value, "restore_type", "copy-on-write")
      use_latest_restorable_time = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", true)
    }
  }

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection
  replication_source_identifier   = var.replication_source_identifier
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#replication_source_identifier
resource "aws_rds_cluster" "secondary" {
  count                               = module.this.enabled && ! local.is_regional_cluster ? 1 : 0
  cluster_identifier                  = var.cluster_identifier == "" ? module.this.id : var.cluster_identifier
  database_name                       = var.db_name
  master_username                     = var.admin_user
  master_password                     = var.admin_password
  backup_retention_period             = var.retention_period
  preferred_backup_window             = var.backup_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  final_snapshot_identifier           = var.cluster_identifier == "" ? lower(module.this.id) : lower(var.cluster_identifier)
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
  tags                                = module.this.tags
  engine                              = var.engine
  engine_version                      = var.engine_version
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  engine_mode                         = var.engine_mode
  iam_roles                           = var.iam_roles
  backtrack_window                    = var.backtrack_window
  enable_http_endpoint                = var.engine_mode == "serverless" && var.enable_http_endpoint ? true : false

  depends_on = [
    aws_db_subnet_group.default,
    aws_db_parameter_group.default,
    aws_rds_cluster_parameter_group.default,
    aws_security_group.default,
  ]

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

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  deletion_protection             = var.deletion_protection

  global_cluster_identifier = var.global_cluster_identifier

  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#replication_source_identifier
  # ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica.
  # If DB Cluster is part of a Global Cluster, use the lifecycle configuration block ignore_changes argument
  # to prevent Terraform from showing differences for this argument instead of configuring this value.

  lifecycle {
    ignore_changes = [
      replication_source_identifier, # will be set/managed by Global Cluster
      snapshot_identifier,           # if created from a snapshot, will be non-null at creation, but null afterwards
    ]
  }
}

resource "aws_rds_cluster_instance" "default" {
  count                           = local.cluster_instance_count
  identifier                      = var.cluster_identifier == "" ? "${module.this.id}-${count.index + 1}" : "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier              = coalesce(join("", aws_rds_cluster.primary.*.id), join("", aws_rds_cluster.secondary.*.id))
  instance_class                  = var.instance_type
  db_subnet_group_name            = join("", aws_db_subnet_group.default.*.name)
  db_parameter_group_name         = join("", aws_db_parameter_group.default.*.name)
  publicly_accessible             = var.publicly_accessible
  tags                            = module.this.tags
  engine                          = var.engine
  engine_version                  = var.engine_version
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  monitoring_interval             = var.rds_monitoring_interval
  monitoring_role_arn             = var.enhanced_monitoring_role_enabled ? join("", aws_iam_role.enhanced_monitoring.*.arn) : var.rds_monitoring_role_arn
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  availability_zone               = var.instance_availability_zone

  depends_on = [
    aws_db_subnet_group.default,
    aws_db_parameter_group.default,
    aws_iam_role.enhanced_monitoring,
    aws_rds_cluster.secondary,
    aws_rds_cluster_parameter_group.default,
  ]
}

resource "aws_db_subnet_group" "default" {
  count       = module.this.enabled ? 1 : 0
  name        = module.this.id
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnets
  tags        = module.this.tags
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = module.this.enabled ? 1 : 0
  name_prefix = "${module.this.id}${module.this.delimiter}"
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

  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "default" {
  count       = module.this.enabled ? 1 : 0
  name_prefix = "${module.this.id}${module.this.delimiter}"
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

  tags = module.this.tags

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  cluster_dns_name_default = "master.${module.this.name}"
  cluster_dns_name         = var.cluster_dns_name != "" ? var.cluster_dns_name : local.cluster_dns_name_default
  reader_dns_name_default  = "replicas.${module.this.name}"
  reader_dns_name          = var.reader_dns_name != "" ? var.reader_dns_name : local.reader_dns_name_default
}

module "dns_master" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.0"

  enabled  = module.this.enabled && length(var.zone_id) > 0 ? true : false
  dns_name = local.cluster_dns_name
  zone_id  = var.zone_id
  records  = coalescelist(aws_rds_cluster.primary.*.endpoint, aws_rds_cluster.secondary.*.endpoint, [""])

  context = module.this.context
}

module "dns_replicas" {
  source  = "cloudposse/route53-cluster-hostname/aws"
  version = "0.12.0"

  enabled  = module.this.enabled && length(var.zone_id) > 0 && var.engine_mode != "serverless" ? true : false
  dns_name = local.reader_dns_name
  zone_id  = var.zone_id
  records  = coalescelist(aws_rds_cluster.primary.*.reader_endpoint, aws_rds_cluster.secondary.*.reader_endpoint, [""])

  context = module.this.context
}

resource "aws_appautoscaling_target" "replicas" {
  count              = module.this.enabled && var.autoscaling_enabled ? 1 : 0
  service_namespace  = "rds"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  resource_id        = "cluster:${coalesce(join("", aws_rds_cluster.primary.*.id), join("", aws_rds_cluster.secondary.*.id))}"
  min_capacity       = var.autoscaling_min_capacity
  max_capacity       = var.autoscaling_max_capacity
}

resource "aws_appautoscaling_policy" "replicas" {
  count              = module.this.enabled && var.autoscaling_enabled ? 1 : 0
  name               = module.this.id
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
