# create IAM role for monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds-cluster-example-1"
  assume_role_policy = "${data.aws_iam_policy_document.enhanced_monitoring.json}"
}

# Attach Amazon's managed policy for RDS enhanced monitoring
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# allow rds to assume this role
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

module "rds_cluster_aurora_postgres" {
  source             = "../../"
  engine             = "aurora-postgresql"
  cluster_size       = "2"
  namespace          = "cp"
  stage              = "dev"
  name               = "db"
  admin_user         = "admin"
  admin_password     = "Test123"
  db_name            = "dbname"
  instance_type      = "db.r4.large"
  vpc_id             = "vpc-xxxxxxx"
  availability_zones = ["us-east-1a", "us-east-1b"]
  security_groups    = ["sg-0a6d5a3a"]
  subnets            = ["subnet-8b03333", "subnet-8b0772a3"]
  zone_id            = "xxxxxxxx"

  # enable monitoring every 30 seconds
  rds_monitoring_interval = "30"

  # reference iam role created above
  rds_monitoring_role_arn = "${aws_iam_role.iam_role.arn}"
}
