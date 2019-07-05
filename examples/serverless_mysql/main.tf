# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.20180206.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html

provider "aws" {
  region = "us-west-1"

  # Make it faster by skipping some checks
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

module "rds_cluster_aurora_mysql_serverless" {
  source          = "../../"
  namespace       = "eg"
  stage           = "dev"
  name            = "db"
  engine          = "aurora"
  engine_mode     = "serverless"
  cluster_family  = "aurora5.6"
  cluster_size    = "0"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = "3306"
  instance_type   = "db.t2.small"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = 256
      min_capacity             = 2
      seconds_until_auto_pause = 300
    }
  ]
}
