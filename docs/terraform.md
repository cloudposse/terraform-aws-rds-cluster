
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin_password | (Required unless a snapshot_identifier is provided) Password for the master DB user | string | `` | no |
| admin_user | (Required unless a snapshot_identifier is provided) Username for the master DB user | string | `admin` | no |
| allowed_cidr_blocks | List of CIDR blocks allowed to access | list | `<list>` | no |
| apply_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | string | `true` | no |
| attributes | Additional attributes (e.g. `1`) | list | `<list>` | no |
| backup_window | Daily time range during which the backups happen | string | `07:00-09:00` | no |
| cluster_family | The family of the DB cluster parameter group | string | `aurora5.6` | no |
| cluster_parameters | List of DB parameters to apply | list | `<list>` | no |
| cluster_size | Number of DB instances to create in the cluster | string | `2` | no |
| db_name | Database name | string | - | yes |
| db_port | Database port | string | `3306` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| engine | The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql` | string | `aurora` | no |
| engine_mode | The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless` | string | `provisioned` | no |
| engine_version | The version number of the database engine to use | string | `` | no |
| iam_database_authentication_enabled | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | string | `false` | no |
| instance_parameters | List of DB instance parameters to apply | list | `<list>` | no |
| instance_type | Instance type to use | string | `db.t2.small` | no |
| maintenance_window | Weekly time range during which system maintenance can occur, in UTC | string | `wed:03:00-wed:04:00` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| publicly_accessible | Set to true if you want your cluster to be publicly accessible (such as via QuickSight) | string | `false` | no |
| rds_monitoring_interval | Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60) | string | `0` | no |
| rds_monitoring_role_arn | The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs | string | `` | no |
| retention_period | Number of days to retain backups for | string | `5` | no |
| scaling_configuration | List of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless` | list | `<list>` | no |
| security_groups | List of security groups to be allowed to connect to the DB instance | list | `<list>` | no |
| skip_final_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted | string | `true` | no |
| snapshot_identifier | Specifies whether or not to create this cluster from a snapshot | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| storage_encrypted | Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode` | string | `false` | no |
| subnets | List of VPC subnet IDs | list | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| vpc_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | string | - | yes |
| zone_id | Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of cluster |
| cluster_name | Cluster Identifier |
| endpoint | The DNS address of the RDS instance |
| master_host | DB Master hostname |
| name | Database name |
| password | Password for the master DB user |
| reader_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
| replicas_host | Replicas hostname |
| user | Username for the master DB user |

