locals {
  storage_create_kms_key              = var.storage_encrypted && var.kms_key_arn == "" ? true : false
  storage_kms_key_arn                 = local.storage_create_kms_key ? module.storage_kms_key[1].key_arn : var.kms_key_arn
  performance_insights_create_kms_key = var.performance_insights_enabled && var.performance_insights_kms_key_id == "" ? true : false
  performance_insights_kms_key_id     = local.performance_insights_create_kms_key ? module.performance_insights_kms_key[1].key_arn : var.performance_insights_kms_key_id

  # This policy is copied from aws/rds
  kms_policy = <<-EOT
  {
      "Version": "2012-10-17",
      "Id": "auto-rds-2",
      "Statement": [
          {
              "Sid": "Allow management of the key",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
              },
              "Action": "kms:*",
              "Resource": "*"
          },
          {
              "Sid": "Allow access through RDS for all principals in the account that are authorized to use RDS",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "*"
              },
              "Action": [
                  "kms:Encrypt",
                  "kms:Decrypt",
                  "kms:ReEncrypt*",
                  "kms:GenerateDataKey*",
                  "kms:CreateGrant",
                  "kms:ListGrants",
                  "kms:DescribeKey"
              ],
              "Resource": "*",
              "Condition": {
                  "StringEquals": {
                      "kms:ViaService": "rds.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}",
                      "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
                  }
              }
          },
          {
              "Sid": "Allow direct access to key metadata to the account",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
              },
              "Action": [
                  "kms:Describe*",
                  "kms:Get*",
                  "kms:List*",
                  "kms:RevokeGrant"
              ],
              "Resource": "*"
          }
      ]
  }
  EOT
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "storage_kms_key" {
  for_each            = local.storage_create_kms_key ? [1] : []
  source              = "cloudposse/kms-key/aws"
  version             = "~> 0.9"
  context             = module.this.id
  description         = "RDS storage encryption for ${module.this.id}"
  enable_key_rotation = false
  policy              = local.kms_policy
}

module "performance_insights_kms_key" {
  for_each            = local.storage_create_kms_key ? [1] : []
  source              = "cloudposse/kms-key/aws"
  version             = "~> 0.9"
  context             = module.this.id
  attributes          = ["performance-insights"]
  description         = "RDS performance insights encryption for ${module.this.id}"
  enable_key_rotation = false
  policy              = local.kms_policy
}
