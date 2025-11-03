provider "aws" {
  region = "us-west-1"
}

module "rds_cluster_autoscaling_mysql_predefined" {
  source          = "../../"
  name            = "autoscaling_predefined_metrics"
  engine          = "aurora-mysql"
  cluster_family  = "aurora-mysql8.0"
  cluster_size    = 2
  namespace       = "eg"
  stage           = "dev"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = 5432
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  autoscaling_enabled            = true
  autoscaling_scale_in_cooldown  = 300
  autoscaling_scale_out_cooldown = 300
  autoscaling_min_capacity       = 1
  autoscaling_max_capacity       = 3
  autoscaling_policy_type        = "TargetTrackingScaling"
  autoscaling_target_metrics     = "RDSReaderAverageCPUUtilization" // or "RDSReaderAverageDatabaseConnections"
}

module "rds_cluster_autoscaling_mysql_custom_cluster_level" {
  source          = "../../"
  name            = "autoscaling_custom_metrics_cluster"
  engine          = "aurora-mysql"
  cluster_family  = "aurora-mysql8.0"
  cluster_size    = 2
  namespace       = "eg"
  stage           = "dev"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = 5432
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  autoscaling_enabled            = true
  autoscaling_scale_in_cooldown  = 300
  autoscaling_scale_out_cooldown = 300
  autoscaling_min_capacity       = 1
  autoscaling_max_capacity       = 3
  autoscaling_policy_type        = "TargetTrackingScaling"
  autoscaling_target_metrics     = "Custom"
  autoscaling_target_value       = 60
  autoscaling_custom_metric = {
    namespace   = "AWS/RDS"
    metric_name = "AuroraReplicaLagMaximum"   # any valid Aurora metric under AWS/RDS
    statistic   = "Average"
    # unit      = "Milliseconds"              # optional, if you want to pin it
    dimensions = [
      { name = "DBClusterIdentifier", value = "my-aurora-cluster" }
    ]
  }
}

# WARNING: Edge case for which i could not find a real use yet.
module "rds_cluster_autoscaling_mysql_custom_instances_level" {
  source          = "../../"
  name            = "autoscaling_custom_metrics_instances"
  engine          = "aurora-mysql"
  cluster_family  = "aurora-mysql8.0"
  cluster_size    = 2
  namespace       = "eg"
  stage           = "dev"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = 5432
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  autoscaling_enabled            = true
  autoscaling_scale_in_cooldown  = 300
  autoscaling_scale_out_cooldown = 300
  autoscaling_min_capacity       = 1
  autoscaling_max_capacity       = 3
  autoscaling_policy_type        = "TargetTrackingScaling"
  autoscaling_target_metrics     = "Custom"
  autoscaling_target_value       = 60
  autoscaling_custom_metric = {
    namespace   = "AWS/RDS"
    metric_name = "CPUUtilization"   # any valid Aurora metric under AWS/RDS
    statistic   = "Average"
    # unit      = "Percent"              # optional, if you want to pin it
    dimensions = [
      { name = "DBInstanceIdentifier", value = "my-aurora-reader-1" }
    ]
  }
}