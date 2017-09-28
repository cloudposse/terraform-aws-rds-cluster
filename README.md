# terraform-aws-rds-cluster

Terraform module to provision an [`RDS Aurora`](https://aws.amazon.com/rds/aurora) Cluster


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.


## Usage

Include this repository as a module in your existing terraform code:

```terraform
module "rds_cluster_aurora_acig" {
  source              = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=tags/0.2.1"
  cluster_size        = "2"
  namespace           = "${var.namespace}"
  stage               = "dev"
  name                = "aurora"
  admin_user          = "admin"
  admin_password      = "TestTest123"
  db_name             = "dbname"
  instance_type       = "db.t2.small"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  security_groups     = ["sg-0a6d5a3a"]
  subnets             = ["subnet-8b03333", "subnet-8b0772a3"]
}
```
