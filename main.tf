# Define composite variables for resources
module "label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=init"
  namespace = "${var.namespace}"
  name      = "${var.name}"
  stage     = "${var.stage}"
}

resource "aws_security_group" "default" {
  name        = "${module.label.id}"
  description = "Allow all inbound traffic"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port       = "3306"                     # MySQL
    to_port         = "3306"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

resource "aws_rds_cluster" "default" {
  cluster_identifier        = "${module.label.id}"
  availability_zones        = ["${var.availability_zones}"]
  database_name             = "${var.db_name}"
  master_username           = "${var.admin_user}"
  master_password           = "${var.admin_password}"
  backup_retention_period   = "${var.retention_period}"
  preferred_backup_window   = "${var.backup_window}"
  final_snapshot_identifier = "${lower(module.label.id)}"
  skip_final_snapshot       = true
  apply_immediately         = true
  snapshot_identifier       = "${var.snapshot_identifier}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
  ]

  preferred_maintenance_window = "${var.maintenance_window}"

  db_subnet_group_name = "${aws_db_subnet_group.default.name}"

  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
  ]

  tags = {
    Name      = "${module.label.id}"
    Namespace = "${var.namespace}"
    Stage     = "${var.stage}"
  }
}

resource "aws_rds_cluster_instance" "default" {
  count = "${var.cluster_size}"

  identifier           = "${module.label.id}-${count.index+1}"
  cluster_identifier   = "${aws_rds_cluster.default.id}"
  instance_class       = "${var.instance_type}"
  db_subnet_group_name = "${aws_db_subnet_group.default.name}"
  publicly_accessible  = false
}

resource "aws_db_subnet_group" "default" {
  name        = "${module.label.id}"
  description = "Allowed subnets for Aurora DB cluster instances"
  subnet_ids  = ["${var.subnets}"]
}

module "dns_master" {
  source    = "../hostname"
  namespace = "${var.namespace}"
  name      = "master.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_rds_cluster.default.endpoint}"]
}

module "dns_replicas" {
  source    = "../hostname"
  namespace = "${var.namespace}"
  name      = "replicas.${var.name}"
  stage     = "${var.stage}"
  zone_id   = "${var.zone_id}"
  records   = ["${aws_rds_cluster.default.reader_endpoint}"]
}
