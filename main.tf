data "aws_caller_identity" "current" {}

locals {
  name_prefix = var.name_prefix != "" ? "${var.name_prefix}-" : ""
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_iam_policy" "engineer_policy" {
  name        = "${local.name_prefix}engineer-policy"
  description = "least privileges for a deepnote engineer"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "acm:*",
          "autoscaling:*",
          "cloudformation:*",
          "cloudwatch:*",
          "dynamodb:*",
          "ec2:*",
          "eks:*",
          "elasticache:*",
          "elasticloadbalancing:*",
          "kms:*",
          "logs:*",
          "rds:*",
          "route53:*",
          "s3:*",
          "secretsmanager:*",
          "ssm:*",
          "lambda:*",
          "events:*",
          "ecr:*",
        ]
        Resource = "*"
      }
    ]
  })

  lifecycle {
    ignore_changes = [
      "description"
    ]
  }
}

resource "aws_iam_policy" "admin_policy" {
  name        = "${local.name_prefix}admin-policy"
  description = "The admin role is required during Deepnote installation but not for daily operations. It allows Deepnote to perform more complex actions such as creating new IAM roles and policies."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:Get*",
          "iam:List*"
        ]
        Resource = [
          "arn:aws:iam::*:role/*",
          "arn:aws:iam::*:policy/*",
          "arn:aws:iam::*:user/*",
          "arn:aws:iam::*:group/*",
          "arn:aws:iam::*:instance-profile/*",
          "arn:aws:iam::*:oidc-provider/*"
        ]
      },
      {
        Sid    = "AllowCreateServiceLinkedRole"
        Effect = "Allow"
        Action = [
          "iam:CreateServiceLinkedRole"
        ]
        Resource = [
          "arn:aws:iam::*:role/aws-service-role/*"
        ]
      },
      {
        Sid    = "AllowCreationWithRequiredTag"
        Effect = "Allow"
        Action = [
          "iam:Create*"
        ]
        Resource = [
          "arn:aws:iam::*:role/*",
          "arn:aws:iam::*:policy/*",
          "arn:aws:iam::*:instance-profile/*",
          "arn:aws:iam::*:oidc-provider/*"
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/ProvisionedBy" = "terraform"
            "aws:RequestTag/ManagedBy"     = "deepnote"
          }
        }
      },
      {
        Sid    = "AllowPostCreationActions"
        Effect = "Allow"
        Action = [
          "iam:Add*",
          "iam:Attach*",
          "iam:Delete*",
          "iam:Detach*",
          "iam:Put*",
          "iam:PassRole",
          "iam:Remove*",
          "iam:Tag*",
          "iam:Untag*",
          "iam:Update*"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:role/*",
          "arn:aws:iam::${local.account_id}:policy/*",
          "arn:aws:iam::${local.account_id}:user/*",
          "arn:aws:iam::${local.account_id}:instance-profile/*",
          "arn:aws:iam::${local.account_id}:oidc-provider/*"
        ]
      },
      {
        Sid    = "ExplicitlyDenyManipulationOfDeepnoteRolesAndPolicies"
        Effect = "Deny"
        Action = [
          "iam:Create*",
          "iam:Delete*",
          "iam:Update*",
          "iam:Attach*",
          "iam:Detach*",
          "iam:Put*",
          "iam:Tag*",
          "iam:Untag*"
        ],
        Resource = [
          "arn:aws:iam::${local.account_id}:role/${local.name_prefix}engineer",
          "arn:aws:iam::${local.account_id}:role/${local.name_prefix}admin",
          "arn:aws:iam::${local.account_id}:policy/${local.name_prefix}engineer-policy",
          "arn:aws:iam::${local.account_id}:policy/${local.name_prefix}admin-policy"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "engineer_role" {
  name = "${local.name_prefix}engineer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::318911662267:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_ProductionEngineer_81bae8be82beff06*",
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_ProductionEngineer_81bae8be82beff06*",
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_ProductionAdmin_e7ae0d41f57593ac*",
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_ProductionAdmin_e7ae0d41f57593ac*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "engineer_policy_attachment" {
  role       = aws_iam_role.engineer_role.name
  policy_arn = aws_iam_policy.engineer_policy.arn
}

resource "aws_iam_role" "admin_role" {
  name = "${local.name_prefix}admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::318911662267:root"
        }
        Action = "sts:AssumeRole"
        Condition = {
          ArnLike = {
            "aws:PrincipalArn" = [
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/*/AWSReservedSSO_ProductionAdmin_e7ae0d41f57593ac*",
              "arn:aws:iam::318911662267:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_ProductionAdmin_e7ae0d41f57593ac*"
            ]
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_engineer_policy_attachment" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.engineer_policy.arn
}

resource "aws_iam_role_policy_attachment" "admin_admin_policy_attachment" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}
