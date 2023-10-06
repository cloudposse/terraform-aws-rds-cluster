region = "us-east-2"

availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]

namespace = "eg"

stage = "test"

name = "rds-cluster"

# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html#Concepts.DBInstanceClass.SupportAurora
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance
instance_type = "db.t3.large"

cluster_family = "aurora-postgresql15"

engine_version = "15.3"

engine = "aurora-postgresql"

engine_mode = "provisioned"

cluster_size = 1

deletion_protection = false

autoscaling_enabled = false

db_name = "test_db"

admin_user = "admin_test"

admin_password = "admin_password"

enhanced_monitoring_role_enabled = true

rds_monitoring_interval = 30

allocated_storage = 100

storage_type = "gp2"
