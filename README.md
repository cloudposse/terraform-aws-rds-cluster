# terraform-aws-rds-cluster

Terraform module to provision an [`RDS Aurora`](https://aws.amazon.com/rds/aurora) Cluster


## Usage

Include this repository as a module in your existing terraform code:

```hcl
module "rds_cluster_aurora" {
  source              = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  cluster_size        = "2"
  namespace           = "app"
  stage               = "dev"
  name                = "db"
  admin_user          = "admin"
  admin_password      = "TestTest123"
  db_name             = "dbname"
  instance_type       = "db.t2.small"
  vpc_id              = "vpc-xxxxxxx"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  security_groups     = ["sg-0a6d5a3a"]
  subnets             = ["subnet-8b03333", "subnet-8b0772a3"]
  zone_id             = "xxxxxxxx"
}
```


## Input

|  Name                              |  Default                       |  Description                                                                                                                         | Required |
|:-----------------------------------|:------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| namespace                          |                                | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                              | Yes      |
| stage                              |                                | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                              | Yes      |
| name                               |                                | Name of the application                                                                                                              | Yes      |
| zone_id                            |                                | Route53 parent zone ID. The module will create sub-domain DNS records in the parent zone for the DB master and replicas              | Yes      |
| security_groups                    |                                | List of security groups to be allowed to connect to the DB instance                                                                  | Yes      |
| vpc_id                             |                                | VPC ID to create the cluster in (_e.g._ `vpc-a22222ee`)                                                                              | Yes      |
| subnets                            |                                | List of VPC subnet IDs                                                                                                               | Yes      |
| availability_zones                 |                                | List of Availability Zones that instances in the DB cluster can be created in                                                        | Yes      |
| db_name                            |                                | Database name                                                                                                                        | Yes      |
| admin_user                         | admin                          | (Required unless a snapshot_identifier is provided) Username for the master DB user                                                  | Yes      |
| admin_password                     |                                | (Required unless a snapshot_identifier is provided) Password for the master DB user                                                  | Yes      |
| instance_type                      | db.t2.small                    | Instance type to use                                                                                                                 | No       |
| cluster_size                       | 2                              | Number of DB instances to create in the cluster                                                                                      | No       |
| snapshot_identifier                |                                | Specifies whether or not to create this cluster from a snapshot                                                                      | No       |
| db_port                            | 3306                           | Database port                                                                                                                        | No       |
| retention_period                   | "5"                            | Number of days to retain backups for                                                                                                 | No       |
| backup_window                      | 07:00-09:00                    | Daily time range during which the backups happen                                                                                     | No       |
| maintenance_window                 | wed:03:00-wed:04:00            | Weekly time range during which system maintenance can occur, in UTC                                                                  | No       |
| cluster_parameters                 | []                             | List of DB parameters to apply                                                                                                       | No       |
| cluster_family                     | aurora5.6                      | The family of the DB cluster parameter group                                                                                         | No       |
| attributes                         | []                             | Additional attributes (_e.g._ "vpc")                                                                                                 | No       |
| tags                               | {}                             | Additional tags (_e.g._ map("BusinessUnit","ABC")                                                                                    | No       |
| delimiter                          | -                              | Delimiter to be used between `name`, `namespace`, `stage` and `attributes`                                                           | No       |



## Outputs

| Name                          | Description                                                     |
|:------------------------------|:----------------------------------------------------------------|
| name                          | Database name                                                   |
| user                          | Username for the master DB user                                 |
| password                      | Password for the master DB user                                 |
| master_host                   | DB Master hostname                                              |
| replicas_host                 | Replicas hostname                                               |
| cluster_name                  | Cluster Identifier                                              |



## License

[APACHE 2.0](LICENSE) © 2017 [Cloud Posse, LLC](https://cloudposse.com)

See [`LICENSE`](LICENSE) for full details.
