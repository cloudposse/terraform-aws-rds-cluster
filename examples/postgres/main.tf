provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.2.0"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.2"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = [module.vpc.igw_id]
  ipv4_cidr_block      = [module.vpc.vpc_cidr_block]
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}

module "rds_cluster" {
  source = "../../"

  engine                    = var.engine
  engine_mode               = var.engine_mode
  engine_version            = var.engine_version
  cluster_family            = var.cluster_family
  cluster_size              = contains(regex("^(?:.*(aurora))?.*$", var.engine), "aurora") ? var.cluster_size : 0
  admin_user                = var.admin_user
  admin_password            = var.admin_password
  db_name                   = var.db_name
  instance_type             = var.instance_type
  db_cluster_instance_class = var.db_cluster_instance_class
  vpc_id                    = module.vpc.vpc_id
  subnets                   = module.subnets.private_subnet_ids
  security_groups           = [module.vpc.vpc_default_security_group_id]
  deletion_protection       = var.deletion_protection
  autoscaling_enabled       = var.autoscaling_enabled
  storage_type              = var.storage_type
  iops                      = var.iops
  allocated_storage         = var.allocated_storage

  context = module.this.context
}
