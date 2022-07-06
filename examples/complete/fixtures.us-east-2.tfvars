region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

instance_type = "db.t3.small"

cluster_family = "aurora5.6"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false

engine = "aurora"

engine_mode = "provisioned"

db_name = "test_db"

admin_user = "admin"

admin_password = "admin_password"

enhanced_monitoring_role_enabled = true

rds_monitoring_interval = 30

intra_security_group_traffic_enabled = true
