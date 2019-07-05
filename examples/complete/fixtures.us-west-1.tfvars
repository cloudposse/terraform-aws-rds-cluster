region = "us-west-1"

availability_zones = ["us-west-1b", "us-west-1c"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

instance_type = "db.t2.small"

cluster_family = "aurora5.6"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false

engine = "aurora"

engine_mode = "provisioned"

db_name = "test_db"

admin_user = "admin"

admin_password = "admin_password"
