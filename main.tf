# Define composite variables for resources
module "label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

resource "aws_security_group" "default" {
  name        = "${module.label.id}"
  description = "Allow all inbound traffic from the security groups"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = "${var.db_port}"
    to_port         = "${var.db_port}"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
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
  cluster_identifier           = "${module.label.id}"
  availability_zones           = ["${var.availability_zones}"]
  database_name                = "${var.db_name}"
  master_username              = "${var.admin_user}"
  master_password              = "${var.admin_password}"
  backup_retention_period      = "${var.retention_period}"
  preferred_backup_window      = "${var.backup_window}"
  final_snapshot_identifier    = "${lower(module.label.id)}"
  skip_final_snapshot          = true
  apply_immediately            = true
  snapshot_identifier          = "${var.snapshot_identifier}"
  vpc_security_group_ids       = ["${aws_security_group.default.id}"]
  preferred_maintenance_window = "${var.maintenance_window}"
  db_subnet_group_name         = "${aws_db_subnet_group.default.name}"
  tags                         = "${module.label.tags}"
}

resource "aws_rds_cluster_instance" "default" {
  count                = "${var.cluster_size}"
  identifier           = "${module.label.id}-${count.index+1}"
  cluster_identifier   = "${aws_rds_cluster.default.id}"
  instance_class       = "${var.instance_type}"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  publicly_accessible  = false
  tags                 = "${module.label.tags}"
}

resource "aws_db_subnet_group" "default" {
  name        = "${module.label.id}"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = ["${var.subnets}"]
  tags        = "${module.label.tags}"
}

resource "aws_rds_cluster_parameter_group" "default" {
  name = "${module.label.id}"
  family = "aurora5.6"

  parameter = ["${var.parameters}"]
}

module "dns_master" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.1.1"
  namespace = "${var.namespace}"
  name      = "master.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_rds_cluster.default.endpoint}"]
}

module "dns_replicas" {
  source    = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-hostname.git?ref=tags/0.1.1"
  namespace = "${var.namespace}"
  name      = "replicas.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_rds_cluster.default.reader_endpoint}"]
}
