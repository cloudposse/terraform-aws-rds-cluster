output "database_name" {
  value       = var.db_name
  description = "Database name"
}

output "master_username" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.master_username) : join("", aws_rds_cluster.secondary.*.master_username)
  description = "Username for the master DB user"
}

output "cluster_identifier" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.cluster_identifier) : join("", aws_rds_cluster.secondary.*.cluster_identifier)
  description = "Cluster Identifier"
}

output "arn" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.arn) : join("", aws_rds_cluster.secondary.*.arn)
  description = "Amazon Resource Name (ARN) of the cluster"
}

output "endpoint" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.endpoint) : join("", aws_rds_cluster.secondary.*.endpoint)
  description = "The DNS address of the RDS instance"
}

output "reader_endpoint" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.reader_endpoint) : join("", aws_rds_cluster.secondary.*.reader_endpoint)
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
  value       = aws_rds_cluster_instance.default.*.dbi_resource_id
  description = "List of the region-unique, immutable identifiers for the DB instances in the cluster"
}

output "cluster_resource_id" {
  value       = local.is_regional_cluster ? join("", aws_rds_cluster.primary.*.cluster_resource_id) : join("", aws_rds_cluster.secondary.*.cluster_resource_id)
  description = "The region-unique, immutable identifie of the cluster"
}

output "cluster_security_groups" {
  value       = coalescelist(aws_rds_cluster.primary.*.vpc_security_group_ids, aws_rds_cluster.secondary.*.vpc_security_group_ids, [""])
  description = "Default RDS cluster security groups"
}

output "security_group_id" {
  value       = join("", aws_security_group.default.*.id)
  description = "Security Group ID"
}

output "security_group_arn" {
  value       = join("", aws_security_group.default.*.arn)
  description = "Security Group ARN"
}

output "security_group_name" {
  value       = join("", aws_security_group.default.*.name)
  description = "Security Group name"
}
