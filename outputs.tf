output "name" {
  value       = join("", aws_rds_cluster.default.*.database_name)
  description = "Database name"
}

output "user" {
  value       = join("", aws_rds_cluster.default.*.master_username)
  description = "Username for the master DB user"
}

output "cluster_name" {
  value       = join("", aws_rds_cluster.default.*.cluster_identifier)
  description = "Cluster Identifier"
}

output "arn" {
  value       = join("", aws_rds_cluster.default.*.arn)
  description = "Amazon Resource Name (ARN) of cluster"
}

output "endpoint" {
  value       = join("", aws_rds_cluster.default.*.endpoint)
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = join("", aws_rds_cluster.default.*.reader_endpoint)
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
}

output "master_host" {
  value       = module.dns_master.hostname
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = module.dns_replicas.hostname
  description = "Replicas hostname"
}

output "dbi_resource_ids" {
  value       = [aws_rds_cluster_instance.default.*.dbi_resource_id]
  description = "List of the region-unique, immutable identifiers for the DB instances in the cluster."
}

output "cluster_resource_id" {
  value       = join("", aws_rds_cluster.default.*.cluster_resource_id)
  description = "The region-unique, immutable identifie of the cluster."
}

