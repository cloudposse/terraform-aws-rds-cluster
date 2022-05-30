enabled = true

region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false


db_name = "test_db"

admin_user = "postgres"

admin_password = "admin_password"

enhanced_monitoring_role_enabled = true

rds_monitoring_interval = 30

max_capacity = 16

min_capacity = 0.5
