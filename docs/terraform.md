<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.1.15 |
| null | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.1.15 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| admin\_password | (Required unless a snapshot\_identifier is provided) Password for the master DB user | `string` | `""` | no |
| admin\_user | (Required unless a snapshot\_identifier is provided) Username for the master DB user | `string` | `"admin"` | no |
| allowed\_cidr\_blocks | List of CIDR blocks allowed to access the cluster | `list(string)` | `[]` | no |
| apply\_immediately | Specifies whether any cluster modifications are applied immediately, or during the next maintenance window | `bool` | `true` | no |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| auto\_minor\_version\_upgrade | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| autoscaling\_enabled | Whether to enable cluster autoscaling | `bool` | `false` | no |
| autoscaling\_max\_capacity | Maximum number of instances to be maintained by the autoscaler | `number` | `5` | no |
| autoscaling\_min\_capacity | Minimum number of instances to be maintained by the autoscaler | `number` | `1` | no |
| autoscaling\_policy\_type | Autoscaling policy type. `TargetTrackingScaling` and `StepScaling` are supported | `string` | `"TargetTrackingScaling"` | no |
| autoscaling\_scale\_in\_cooldown | The amount of time, in seconds, after a scaling activity completes and before the next scaling down activity can start. Default is 300s | `number` | `300` | no |
| autoscaling\_scale\_out\_cooldown | The amount of time, in seconds, after a scaling activity completes and before the next scaling up activity can start. Default is 300s | `number` | `300` | no |
| autoscaling\_target\_metrics | The metrics type to use. If this value isn't provided the default is CPU utilization | `string` | `"RDSReaderAverageCPUUtilization"` | no |
| autoscaling\_target\_value | The target value to scale with respect to target metrics | `number` | `75` | no |
| backtrack\_window | The target backtrack window, in seconds. Only available for aurora engine currently. Must be between 0 and 259200 (72 hours) | `number` | `0` | no |
| backup\_window | Daily time range during which the backups happen | `string` | `"07:00-09:00"` | no |
| cluster\_dns\_name | Name of the cluster CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `master.var.name` | `string` | `""` | no |
| cluster\_family | The family of the DB cluster parameter group | `string` | `"aurora5.6"` | no |
| cluster\_identifier | The RDS Cluster Identifier. Will use generated label ID if not supplied | `string` | `""` | no |
| cluster\_parameters | List of DB cluster parameters to apply | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| cluster\_size | Number of DB instances to create in the cluster | `number` | `2` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>    label_key_case      = string<br>    label_value_case    = string<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| copy\_tags\_to\_snapshot | Copy tags to backup snapshots | `bool` | `false` | no |
| db\_name | Database name (default is not to create a database) | `string` | `""` | no |
| db\_port | Database port | `number` | `3306` | no |
| deletion\_protection | If the DB instance should have deletion protection enabled | `bool` | `false` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| enable\_http\_endpoint | Enable HTTP endpoint (data API). Only valid when engine\_mode is set to serverless | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery | `list(string)` | `[]` | no |
| engine | The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql` | `string` | `"aurora"` | no |
| engine\_mode | The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless` | `string` | `"provisioned"` | no |
| engine\_version | The version of the database engine to use. See `aws rds describe-db-engine-versions` | `string` | `""` | no |
| enhanced\_monitoring\_role\_enabled | A boolean flag to enable/disable the creation of the enhanced monitoring IAM role. If set to `false`, the module will not create a new role and will use `rds_monitoring_role_arn` for enhanced monitoring | `bool` | `false` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| global\_cluster\_identifier | ID of the Aurora global cluster | `string` | `""` | no |
| iam\_database\_authentication\_enabled | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `false` | no |
| iam\_roles | Iam roles for the Aurora cluster | `list(string)` | `[]` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| instance\_availability\_zone | Optional parameter to place cluster instances in a specific availability zone. If left empty, will place randomly | `string` | `""` | no |
| instance\_parameters | List of DB instance parameters to apply | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| instance\_type | Instance type to use | `string` | `"db.t2.small"` | no |
| kms\_key\_arn | The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true` | `string` | `""` | no |
| label\_key\_case | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`. <br>Default value: `title`. | `string` | `null` | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| label\_value\_case | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation). <br>Default value: `lower`. | `string` | `null` | no |
| maintenance\_window | Weekly time range during which system maintenance can occur, in UTC | `string` | `"wed:03:00-wed:04:00"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| performance\_insights\_enabled | Whether to enable Performance Insights | `bool` | `false` | no |
| performance\_insights\_kms\_key\_id | The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to true | `string` | `""` | no |
| publicly\_accessible | Set to true if you want your cluster to be publicly accessible (such as via QuickSight) | `bool` | `false` | no |
| rds\_monitoring\_interval | The interval, in seconds, between points when enhanced monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60 | `number` | `0` | no |
| rds\_monitoring\_role\_arn | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs | `string` | `null` | no |
| reader\_dns\_name | Name of the reader endpoint CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `replicas.var.name` | `string` | `""` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| replication\_source\_identifier | ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica | `string` | `""` | no |
| restore\_to\_point\_in\_time | List point-in-time recovery options. Only valid actions are `source_cluster_identifier`, `restore_type` and `use_latest_restorable_time` | <pre>list(object({<br>    source_cluster_identifier  = string<br>    restore_type               = string<br>    use_latest_restorable_time = bool<br>  }))</pre> | `[]` | no |
| retention\_period | Number of days to retain backups for | `number` | `5` | no |
| s3\_import | Restore from a Percona Xtrabackup in S3. The `bucket_name` is required to be in the same region as the resource. | <pre>object({<br>    bucket_name           = string<br>    bucket_prefix         = string<br>    ingestion_role        = string<br>    source_engine         = string<br>    source_engine_version = string<br>  })</pre> | `null` | no |
| scaling\_configuration | List of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless` | <pre>list(object({<br>    auto_pause               = bool<br>    max_capacity             = number<br>    min_capacity             = number<br>    seconds_until_auto_pause = number<br>    timeout_action           = string<br>  }))</pre> | `[]` | no |
| security\_groups | List of security groups to be allowed to connect to the DB instance | `list(string)` | `[]` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted | `bool` | `true` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot | `string` | `null` | no |
| source\_region | Source Region of primary cluster, needed when using encrypted storage and region replicas | `string` | `""` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted. The default is `false` for `provisioned` `engine_mode` and `true` for `serverless` `engine_mode` | `bool` | `false` | no |
| subnets | List of VPC subnet IDs | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| timeouts\_configuration | List of timeout values per action. Only valid actions are `create`, `update` and `delete` | <pre>list(object({<br>    create = string<br>    update = string<br>    delete = string<br>  }))</pre> | `[]` | no |
| vpc\_id | VPC ID to create the cluster in (e.g. `vpc-a22222ee`) | `string` | n/a | yes |
| vpc\_security\_group\_ids | Additional security group IDs to apply to the cluster, in addition to the provisioned default security group with ingress traffic from existing CIDR blocks and existing security groups | `list(string)` | `[]` | no |
| zone\_id | Route53 parent zone ID. If provided (not empty), the module will create sub-domain DNS records for the DB master and replicas | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | Amazon Resource Name (ARN) of the cluster |
| cluster\_identifier | Cluster Identifier |
| cluster\_resource\_id | The region-unique, immutable identifie of the cluster |
| cluster\_security\_groups | Default RDS cluster security groups |
| database\_name | Database name |
| dbi\_resource\_ids | List of the region-unique, immutable identifiers for the DB instances in the cluster |
| endpoint | The DNS address of the RDS instance |
| master\_host | DB Master hostname |
| master\_username | Username for the master DB user |
| reader\_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
| replicas\_host | Replicas hostname |
| security\_group\_arn | Security Group ARN |
| security\_group\_id | Security Group ID |
| security\_group\_name | Security Group name |

<!-- markdownlint-restore -->
