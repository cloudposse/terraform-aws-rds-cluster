# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.serverless_2_07_01.html
# https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html

provider "aws" {
  region = "us-west-1"
}

module "rds_cluster_aurora_mysql_serverless" {
  source               = "../.."
  namespace            = "eg"
  stage                = "dev"
  name                 = "db"
  engine               = "aurora-mysql"
  engine_mode          = "serverless"
  engine_version       = "5.7.mysql_aurora.2.07.1"
  cluster_family       = "aurora-mysql5.7"
  cluster_size         = 0
  admin_user           = "admin1"
  admin_password       = "Test123456789"
  db_name              = "dbname"
  db_port              = 3306
  vpc_id               = "vpc-xxxxxxxx"
  security_groups      = ["sg-xxxxxxxx"]
  subnets              = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id              = "Zxxxxxxxx"
  enable_http_endpoint = true

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = 16
      min_capacity             = 1
      seconds_until_auto_pause = 300
      timeout_action           = "ForceApplyCapacityChange"
    }
  ]
}
