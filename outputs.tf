output "name" {
  value       = "${aws_rds_cluster.default.database_name}"
  description = "Database name"
}

output "user" {
  value       = "${aws_rds_cluster.default.master_username}"
  description = "Username for the master DB user"
}

output "password" {
  value       = "${aws_rds_cluster.default.master_password}"
  description = "Password for the master DB user"
}

output "master_host" {
  value       = "${module.dns_master.hostname}"
  description = "DB Master hostname"
}

output "replicas_host" {
  value       = "${module.dns_replicas.hostname}"
  description = "Replicas hostname"
}

output "cluster_name" {
  value       = "${aws_rds_cluster.default.cluster_identifier}"
  description = "Cluster Identifier"
}
