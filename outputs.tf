output "name" {
  value       = "${join("", aws_rds_cluster.default.*.database_name)}"
  description = "Database name"
}

output "user" {
  value       = "${join("", aws_rds_cluster.default.*.master_username)}"
  description = "Username for the master DB user"
}

output "password" {
  value       = "${join("", aws_rds_cluster.default.*.master_password)}"
  description = "Password for the master DB user"
}

output "cluster_name" {
  value       = "${join("", aws_rds_cluster.default.*.cluster_identifier)}"
  description = "Cluster Identifier"
}

output "master_host" {
  value       = "${module.dns_master.hostname}"
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = "${module.dns_replicas.hostname}"
  description = "Replicas hostname"
}
