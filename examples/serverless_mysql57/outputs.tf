output "name" {
  value       = module.rds_cluster_aurora_mysql_serverless.database_name
  description = "Database name"
}

output "master_username" {
  value       = module.rds_cluster_aurora_mysql_serverless.master_username
  description = "Username for the master DB user"
}

output "cluster_identifier" {
  value       = module.rds_cluster_aurora_mysql_serverless.cluster_identifier
  description = "Cluster Identifier"
}

output "arn" {
  value       = module.rds_cluster_aurora_mysql_serverless.arn
  description = "Amazon Resource Name (ARN) of cluster"
}

output "endpoint" {
  value       = module.rds_cluster_aurora_mysql_serverless.endpoint
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = module.rds_cluster_aurora_mysql_serverless.reader_endpoint
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "master_host" {
  value       = module.rds_cluster_aurora_mysql_serverless.master_host
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = module.rds_cluster_aurora_mysql_serverless.replicas_host
  description = "Replicas hostname"
}
