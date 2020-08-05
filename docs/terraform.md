## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.0 |
| null | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
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
| copy\_tags\_to\_snapshot | Copy tags to backup snapshots | `bool` | `false` | no |
| db\_name | Database name (default is not to create a database) | `string` | `""` | no |
| db\_port | Database port | `number` | `3306` | no |
| deletion\_protection | If the DB instance should have deletion protection enabled | `bool` | `false` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enable\_http\_endpoint | Enable HTTP endpoint (data API). Only valid when engine\_mode is set to serverless | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch. The following log types are supported: audit, error, general, slowquery | `list(string)` | `[]` | no |
| engine | The name of the database engine to be used for this DB cluster. Valid values: `aurora`, `aurora-mysql`, `aurora-postgresql` | `string` | `"aurora"` | no |
| engine\_mode | The database engine mode. Valid values: `parallelquery`, `provisioned`, `serverless` | `string` | `"provisioned"` | no |
| engine\_version | The version of the database engine to use. See `aws rds describe-db-engine-versions` | `string` | `""` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| global\_cluster\_identifier | ID of the Aurora global cluster | `string` | `""` | no |
| iam\_database\_authentication\_enabled | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `false` | no |
| iam\_roles | Iam roles for the Aurora cluster | `list(string)` | `[]` | no |
| instance\_availability\_zone | Optional parameter to place cluster instances in a specific availability zone. If left empty, will place randomly | `string` | `""` | no |
| instance\_parameters | List of DB instance parameters to apply | <pre>list(object({<br>    apply_method = string<br>    name         = string<br>    value        = string<br>  }))</pre> | `[]` | no |
| instance\_type | Instance type to use | `string` | `"db.t2.small"` | no |
| kms\_key\_arn | The ARN for the KMS encryption key. When specifying `kms_key_arn`, `storage_encrypted` needs to be set to `true` | `string` | `""` | no |
| maintenance\_window | Weekly time range during which system maintenance can occur, in UTC | `string` | `"wed:03:00-wed:04:00"` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `""` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| performance\_insights\_enabled | Whether to enable Performance Insights | `bool` | `false` | no |
| performance\_insights\_kms\_key\_id | The ARN for the KMS key to encrypt Performance Insights data. When specifying `performance_insights_kms_key_id`, `performance_insights_enabled` needs to be set to true | `string` | `""` | no |
| publicly\_accessible | Set to true if you want your cluster to be publicly accessible (such as via QuickSight) | `bool` | `false` | no |
| rds\_monitoring\_interval | Interval in seconds that metrics are collected, 0 to disable (values can only be 0, 1, 5, 10, 15, 30, 60) | `number` | `0` | no |
| rds\_monitoring\_role\_arn | The ARN for the IAM role that can send monitoring metrics to CloudWatch Logs | `string` | `""` | no |
| reader\_dns\_name | Name of the reader endpoint CNAME record to create in the parent DNS zone specified by `zone_id`. If left empty, the name will be auto-asigned using the format `replicas.var.name` | `string` | `""` | no |
| replication\_source\_identifier | ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica | `string` | `""` | no |
| retention\_period | Number of days to retain backups for | `number` | `5` | no |
| scaling\_configuration | List of nested attributes with scaling properties. Only valid when `engine_mode` is set to `serverless` | <pre>list(object({<br>    auto_pause               = bool<br>    max_capacity             = number<br>    min_capacity             = number<br>    seconds_until_auto_pause = number<br>    timeout_action           = string<br>  }))</pre> | `[]` | no |
| security\_groups | List of security groups to be allowed to connect to the DB instance | `list(string)` | `[]` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted | `bool` | `true` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot | `string` | `""` | no |
| source\_region | Source Region of primary cluster, needed when using encrypted storage and region replicas | `string` | `""` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
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
| arn | Amazon Resource Name (ARN) of cluster |
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

