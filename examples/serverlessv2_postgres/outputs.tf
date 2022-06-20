output "database_name" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.database_name
  description = "Database name"
}

output "master_username" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.master_username
  description = "Username for the master DB user"
  sensitive   = true
}

output "cluster_identifier" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.cluster_identifier
  description = "Cluster Identifier"
}

output "arn" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.arn
  description = "Amazon Resource Name (ARN) of the cluster"
}

output "endpoint" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.endpoint
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.reader_endpoint
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "master_host" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.master_host
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.replicas_host
  description = "Replicas hostname"
}

output "dbi_resource_ids" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.dbi_resource_ids
  description = "List of the region-unique, immutable identifiers for the DB instances in the cluster"
}

output "cluster_resource_id" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.cluster_resource_id
  description = "The region-unique, immutable identifie of the cluster"
}

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "Public subnet CIDR blocks"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDR blocks"
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC CIDR"
}

output "security_group_id" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.security_group_id
  description = "Security Group ID"
}

output "security_group_arn" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.security_group_arn
  description = "Security Group ARN"
}

output "security_group_name" {
  value       = module.rds_cluster_aurora_serverlessv2_postgres_13.security_group_name
  description = "Security Group name"
}
