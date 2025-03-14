region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.SupportAurora
instance_type = "db.t3.medium"

cluster_family = "aurora-mysql8.0"

engine = "aurora-mysql"

engine_mode = "provisioned"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false

db_name = "test_db"

admin_user = "admin"

admin_password = "admin_password"

enhanced_monitoring_role_enabled = true

rds_monitoring_interval = 30

intra_security_group_traffic_enabled = true

parameter_group_name_prefix_enabled = true

rds_cluster_identifier_prefix_enabled = true
