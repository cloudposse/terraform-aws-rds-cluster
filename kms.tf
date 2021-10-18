locals {
  storage_create_kms_key              = var.storage_encrypted && var.kms_key_arn == ""
  storage_kms_key_arn                 = local.storage_create_kms_key ? module.storage_kms_key[1].key_arn : var.kms_key_arn
  performance_insights_create_kms_key = var.performance_insights_enabled && var.performance_insights_kms_key_id == ""
  performance_insights_kms_key_id     = local.performance_insights_create_kms_key ? module.performance_insights_kms_key[1].key_arn : var.performance_insights_kms_key_id

  # This policy is copied from aws/rds
  kms_policy = data.aws_iam_policy_document.performance_insights.json
}

data "aws_iam_policy_document" "performance_insights" {
  statement {
    sid       = "Allow management of the key"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Allow access through RDS for all principals in the account that are authorized to use RDS"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:DescribeKey",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["rds.${data.aws_region.current.name}.${data.aws_partition.current.dns_suffix}"]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "Allow direct access to key metadata to the account"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
      "kms:RevokeGrant",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

module "storage_kms_key" {
  for_each            = local.storage_create_kms_key ? [1] : []
  source              = "cloudposse/kms-key/aws"
  version             = "0.11.0"
  context             = module.this.context
  description         = "RDS storage encryption for ${module.this.id}"
  enable_key_rotation = false
  policy              = local.kms_policy
}

module "performance_insights_kms_key" {
  for_each            = local.storage_create_kms_key ? [1] : []
  source              = "cloudposse/kms-key/aws"
  version             = "0.11.0"
  context             = module.this.context
  attributes          = ["performance-insights"]
  description         = "RDS performance insights encryption for ${module.this.id}"
  enable_key_rotation = false
  policy              = local.kms_policy
}
