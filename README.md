<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->
[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

# terraform-aws-rds-cluster [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-rds-cluster.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-rds-cluster) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-rds-cluster.svg)](https://github.com/cloudposse/terraform-aws-rds-cluster/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform module to provision an [`RDS Aurora`](https://aws.amazon.com/rds/aurora) cluster for MySQL or Postgres.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps. 
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out! 







## Usage


[Basic example](examples/basic)

```hcl
module "rds_cluster_aurora_postgres" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  name            = "postgres"
  engine          = "aurora-postgresql"
  cluster_family  = "aurora-postgresql9.6"
  cluster_size    = "2"
  namespace       = "eg"
  stage           = "dev"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = "5432"
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"
}
```

[Serverless MySQL](examples/serverless_mysql)

```hcl
module "rds_cluster_aurora_mysql_serverless" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  namespace       = "eg"
  stage           = "dev"
  name            = "db"
  engine          = "aurora"
  engine_mode     = "serverless"
  cluster_family  = "aurora5.6"
  cluster_size    = "0"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = "3306"
  instance_type   = "db.t2.small"
  vpc_id          = "vpc-xxxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = 256
      min_capacity             = 2
      seconds_until_auto_pause = 300
    },
  ]
}
```

[With cluster parameters](examples/with_cluster_parameters)

```hcl
module "rds_cluster_aurora_mysql" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  engine          = "aurora"
  cluster_family  = "aurora-mysql5.7"
  cluster_size    = "2"
  namespace       = "eg"
  stage           = "dev"
  name            = "db"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  instance_type   = "db.t2.small"
  vpc_id          = "vpc-xxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  cluster_parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_connection"
      value = "utf8"
    },
    {
      name  = "character_set_database"
      value = "utf8"
    },
    {
      name  = "character_set_results"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    },
    {
      name  = "collation_connection"
      value = "uft8_bin"
    },
    {
      name  = "collation_server"
      value = "uft8_bin"
    },
    {
      name         = "lower_case_table_names"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    },
  ]
}
```

[With enhanced monitoring](examples/enhanced_monitoring)

```hcl
# create IAM role for monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  name               = "rds-cluster-example-1"
  assume_role_policy = "${data.aws_iam_policy_document.enhanced_monitoring.json}"
}

# Attach Amazon's managed policy for RDS enhanced monitoring
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  role       = "${aws_iam_role.enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# allow rds to assume this role
data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
      actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

module "rds_cluster_aurora_postgres" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  engine          = "aurora-postgresql"
  cluster_family  = "aurora-postgresql9.6"
  cluster_size    = "2"
  namespace       = "eg"
  stage           = "dev"
  name            = "db"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  db_port         = "5432"
  instance_type   = "db.r4.large"
  vpc_id          = "vpc-xxxxxxx"
  security_groups = ["sg-xxxxxxxx"]
  subnets         = ["subnet-xxxxxxxx", "subnet-xxxxxxxx"]
  zone_id         = "Zxxxxxxxx"

  # enable monitoring every 30 seconds
  rds_monitoring_interval = "30"

  # reference iam role created above
  rds_monitoring_role_arn = "${aws_iam_role.enhanced_monitoring.arn}"
}
```






## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```

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




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-rds-cluster)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-rds](https://github.com/cloudposse/terraform-aws-rds) - Terraform module to provision AWS RDS instances
- [terraform-aws-rds-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-rds-cloudwatch-sns-alarms) - Terraform module that configures important RDS alerts using CloudWatch and sends them to an SNS topic



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-rds-cluster/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)][email]

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll [develop original modules][module_development] to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 



## Terraform Module Development

Are you interested in custom Terraform module development? Submit your inquiry using [our form][module_development] today and we'll get back to you ASAP.


## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Newsletter

Signup for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover. 

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-rds-cluster/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.  

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Sarkis Varozian][sarkis_avatar]][sarkis_homepage]<br/>[Sarkis Varozian][sarkis_homepage] | [![Mike Crowe][mike-zipit_avatar]][mike-zipit_homepage]<br/>[Mike Crowe][mike-zipit_homepage] | [![Sergey Vasilyev][s2504s_avatar]][s2504s_homepage]<br/>[Sergey Vasilyev][s2504s_homepage] | [![Todor Todorov][tptodorov_avatar]][tptodorov_homepage]<br/>[Todor Todorov][tptodorov_homepage] | [![Lee Huffman][leehuffman_avatar]][leehuffman_homepage]<br/>[Lee Huffman][leehuffman_homepage] |
|---|---|---|---|---|---|---|---|

  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: https://github.com/osterman.png?size=150
  [goruha_homepage]: https://github.com/goruha
  [goruha_avatar]: https://github.com/goruha.png?size=150
  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://github.com/aknysh.png?size=150
  [sarkis_homepage]: https://github.com/sarkis
  [sarkis_avatar]: https://github.com/sarkis.png?size=150
  [mike-zipit_homepage]: https://github.com/mike-zipit
  [mike-zipit_avatar]: https://github.com/mike-zipit.png?size=150
  [s2504s_homepage]: https://github.com/s2504s
  [s2504s_avatar]: https://github.com/s2504s.png?size=150
  [tptodorov_homepage]: https://github.com/tptodorov
  [tptodorov_avatar]: https://github.com/tptodorov.png?size=150
  [leehuffman_homepage]: https://github.com/leehuffman
  [leehuffman_avatar]: https://github.com/leehuffman.png?size=150



[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs
  [website]: https://cpco.io/homepage
  [github]: https://cpco.io/github
  [jobs]: https://cpco.io/jobs
  [hire]: https://cpco.io/hire
  [slack]: https://cpco.io/slack
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://cpco.io/twitter
  [testimonial]: https://cpco.io/leave-testimonial
  [newsletter]: https://cpco.io/newsletter
  [email]: https://cpco.io/email
  [commercial_support]: https://cpco.io/commercial-support
  [we_love_open_source]: https://cpco.io/we-love-open-source
  [module_development]: https://cpco.io/module-development
  [terraform_modules]: https://cpco.io/terraform-modules
  [readme_header_img]: https://cloudposse.com/readme/header/img?repo=cloudposse/terraform-aws-rds-cluster
  [readme_header_link]: https://cloudposse.com/readme/header/link?repo=cloudposse/terraform-aws-rds-cluster
  [readme_footer_img]: https://cloudposse.com/readme/footer/img?repo=cloudposse/terraform-aws-rds-cluster
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?repo=cloudposse/terraform-aws-rds-cluster
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img?repo=cloudposse/terraform-aws-rds-cluster
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?repo=cloudposse/terraform-aws-rds-cluster
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-rds-cluster&url=https://github.com/cloudposse/terraform-aws-rds-cluster
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-rds-cluster&url=https://github.com/cloudposse/terraform-aws-rds-cluster
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-rds-cluster
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-rds-cluster
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-rds-cluster
  [share_email]: mailto:?subject=terraform-aws-rds-cluster&body=https://github.com/cloudposse/terraform-aws-rds-cluster
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-rds-cluster?pixel&cs=github&cm=readme&an=terraform-aws-rds-cluster
