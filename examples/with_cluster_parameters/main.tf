module "rds_cluster_aurora_mysql" {
  source             = "../../"
  engine             = "aurora"
  cluster_size       = "2"
  namespace          = "cp"
  stage              = "dev"
  name               = "db"
  admin_user         = "admin"
  admin_password     = "Test123"
  db_name            = "dbname"
  instance_type      = "db.t2.small"
  vpc_id             = "vpc-xxxxxxx"
  availability_zones = ["us-east-1a", "us-east-1b"]
  security_groups    = ["sg-0a6d5a3a"]
  subnets            = ["subnet-8b03333", "subnet-8b0772a3"]
  zone_id            = "xxxxxxxx"

  cluster_parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_connection"
      value = "utf8"
    },
    {
      name  = "character_set_database"
      value = "utf8"
    },
    {
      name  = "character_set_results"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
    {
      name  = "collation_connection"
      value = "uft8_bin"
    },
    {
      name  = "collation_server"
      value = "uft8_bin"
    },
    {
      name         = "lower_case_table_names"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    },
  ]
}
