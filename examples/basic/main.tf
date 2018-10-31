# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBClusterParameterGroup.html

module "rds_cluster_aurora_postgres" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  name            = "postgres"
  engine          = "aurora-postgresql"
  cluster_family  = "aurora-postgresql9.6"
  cluster_size    = "2"
  namespace       = "eg"
  stage           = "dev"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = "5432"
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-36f54c51"
  security_groups = ["sg-0a6d5a3a"]
  subnets         = ["subnet-705e3115", "subnet-dab9e2f0"]
  zone_id         = "Z19EN1IQ979KPE"
}
