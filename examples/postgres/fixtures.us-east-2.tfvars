region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

instance_type = "db.m5d.large"

cluster_family = "postgres13"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false

engine = "postgres"

engine_mode = "provisioned"

engine_version = "13.4"

db_name = "test_db"

admin_user = "admin_test"

admin_password = "admin_password"

enhanced_monitoring_role_enabled = true

rds_monitoring_interval = 30

allocated_storage = 100

storage_type = "io1"

iops = 1000

db_cluster_instance_class = "db.m5d.large"
