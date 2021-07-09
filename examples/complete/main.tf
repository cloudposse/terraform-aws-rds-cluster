provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.17.0"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.28.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "rds_cluster" {
  source = "../../"

  engine              = var.engine
  engine_mode         = var.engine_mode
  cluster_family      = var.cluster_family
  cluster_size        = var.cluster_size
  admin_user          = var.admin_user
  admin_password      = var.admin_password
  db_name             = var.db_name
  instance_type       = var.instance_type
  vpc_id              = module.vpc.vpc_id
  subnets             = module.subnets.private_subnet_ids
  security_groups     = [module.vpc.vpc_default_security_group_id]
  deletion_protection = var.deletion_protection
  autoscaling_enabled = var.autoscaling_enabled

  cluster_parameters = [
    {
      name         = "character_set_client"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_connection"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_database"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_results"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_server"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_connection"
      value        = "utf8_bin"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_server"
      value        = "utf8_bin"
      apply_method = "pending-reboot"
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
    }
  ]

  context = module.this.context
}
