module "rds_cluster_aurora" {
  source             = "../../"
  engine             = "aurora-postgresql"
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
}
