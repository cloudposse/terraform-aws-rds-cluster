# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance#monitoring_role_arn

module "enhanced_monitoring_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  enabled    = module.this.enabled && var.enhanced_monitoring_role_enabled
  attributes = ["enhanced-monitoring"]

  context = module.this.context
}

# Create IAM role for enhanced monitoring
resource "aws_iam_role" "enhanced_monitoring" {
  count              = module.this.enabled && var.enhanced_monitoring_role_enabled ? 1 : 0
  name               = module.enhanced_monitoring_label.id
  assume_role_policy = join("", data.aws_iam_policy_document.enhanced_monitoring.*.json)
  tags               = module.enhanced_monitoring_label.tags
}

# Attach Amazon's managed policy for RDS enhanced monitoring
resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count      = module.this.enabled && var.enhanced_monitoring_role_enabled ? 1 : 0
  role       = join("", aws_iam_role.enhanced_monitoring.*.name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Allow RDS monitoring to assume the enhanced monitoring role
data "aws_iam_policy_document" "enhanced_monitoring" {
  count = module.this.enabled && var.enhanced_monitoring_role_enabled ? 1 : 0

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
