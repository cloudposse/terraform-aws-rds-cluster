module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.5"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.enabled}"
}

resource "aws_security_group" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "Allow inbound traffic from Security Groups and CIDRs"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.db_port}"
    to_port         = "${var.db_port}"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  ingress {
    from_port   = "${var.db_port}"
    to_port     = "${var.db_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_cidr_blocks}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${module.label.tags}"
}

resource "aws_rds_cluster" "default" {
  count                               = "${var.enabled == "true" ? 1 : 0}"
  cluster_identifier                  = "${module.label.id}"
  database_name                       = "${var.db_name}"
  master_username                     = "${var.admin_user}"
  master_password                     = "${var.admin_password}"
  backup_retention_period             = "${var.retention_period}"
  preferred_backup_window             = "${var.backup_window}"
  final_snapshot_identifier           = "${lower(module.label.id)}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  apply_immediately                   = "${var.apply_immediately}"
  storage_encrypted                   = "${var.storage_encrypted}"
  snapshot_identifier                 = "${var.snapshot_identifier}"
  vpc_security_group_ids              = ["${aws_security_group.default.id}"]
  preferred_maintenance_window        = "${var.maintenance_window}"
  db_subnet_group_name                = "${aws_db_subnet_group.default.name}"
  db_cluster_parameter_group_name     = "${aws_rds_cluster_parameter_group.default.name}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  tags                                = "${module.label.tags}"
  engine                              = "${var.engine}"
  engine_version                      = "${var.engine_version}"
  engine_mode                         = "${var.engine_mode}"
  scaling_configuration               = "${var.scaling_configuration}"
}

resource "aws_rds_cluster_instance" "default" {
  count                   = "${var.enabled == "true" ? var.cluster_size : 0}"
  identifier              = "${module.label.id}-${count.index+1}"
  cluster_identifier      = "${aws_rds_cluster.default.id}"
  instance_class          = "${var.instance_type}"
  db_subnet_group_name    = "${aws_db_subnet_group.default.name}"
  db_parameter_group_name = "${aws_db_parameter_group.default.name}"
  publicly_accessible     = "${var.publicly_accessible}"
  tags                    = "${module.label.tags}"
  engine                  = "${var.engine}"
  engine_version          = "${var.engine_version}"
  monitoring_interval     = "${var.rds_monitoring_interval}"
  monitoring_role_arn     = "${var.rds_monitoring_role_arn}"
}

resource "aws_db_subnet_group" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = ["${var.subnets}"]
  tags        = "${module.label.tags}"
}

resource "aws_rds_cluster_parameter_group" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "DB cluster parameter group"
  family      = "${var.cluster_family}"
  parameter   = ["${var.cluster_parameters}"]
  tags        = "${module.label.tags}"
}

resource "aws_db_parameter_group" "default" {
  count       = "${var.enabled == "true" ? 1 : 0}"
  name        = "${module.label.id}"
  description = "DB instance parameter group"
  family      = "${var.cluster_family}"
  parameter   = ["${var.instance_parameters}"]
  tags        = "${module.label.tags}"
}

module "dns_master" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.5"
  namespace = "${var.namespace}"
  name      = "master.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${coalescelist(aws_rds_cluster.default.*.endpoint, list(""))}"]
  enabled   = "${var.enabled == "true" && length(var.zone_id) > 0 ? "true" : "false"}"
}

module "dns_replicas" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.2.5"
  namespace = "${var.namespace}"
  name      = "replicas.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${coalescelist(aws_rds_cluster.default.*.reader_endpoint, list(""))}"]
  enabled   = "${var.enabled == "true" && length(var.zone_id) > 0 ? "true" : "false"}"
}
