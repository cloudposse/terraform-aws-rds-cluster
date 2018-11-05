# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html

provider "aws" {
  region = "us-west-2"

  # Make it faster by skipping some checks
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

module "rds_cluster_aurora_mysql" {
  source          = "../../"
  engine          = "aurora"
  cluster_family  = "aurora-mysql5.7"
  cluster_size    = "2"
  namespace       = "eg"
  stage           = "dev"
  name            = "db"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  instance_type   = "db.t2.small"
  vpc_id          = "vpc-xxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

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
