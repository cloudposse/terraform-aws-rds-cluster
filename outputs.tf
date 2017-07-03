output "name" {
  value = "${aws_rds_cluster.default.database_name}"
}

output "user" {
  value = "${aws_rds_cluster.default.master_username}"
}

output "password" {
  value = "${aws_rds_cluster.default.master_password}"
}

output "master_host" {
  value = "${module.dns_master.hostname}"
}

output "replicas_host" {
  value = "${module.dns_replicas.hostname}"
}

output "cluster_name" {
  value = "${aws_rds_cluster.default.cluster_identifier}"
}
