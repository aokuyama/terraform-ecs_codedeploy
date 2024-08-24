resource "aws_iam_role" "deploy" {
  name = "${local.resource_name}-deploy"

  assume_role_policy = data.aws_iam_policy_document.assume_role_deploy.json
  inline_policy {
    name   = "ecs-deploy"
    policy = data.aws_iam_policy_document.deploy_ecs.json
  }
}

data "aws_iam_policy_document" "assume_role_deploy" {
  statement {
    sid = "AllowGitHubActionsWithOIDCProvider"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.githubusercontent.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${data.github_repository.app.full_name}:*"]
    }
  }
}

data "aws_iam_policy_document" "deploy_ecs" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:UploadLayerPart",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.app.arn
    ]
  }

  statement {
    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:RegisterTaskDefinition",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "iam:PassRole",
    ]
    effect = "Allow"
    resources = [
      module.ecs.ecs_execution_role_arn,
      module.ecs.ecs_task_role_arn,
    ]
  }

  statement {
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
    ]
    effect = "Allow"
    resources = [
      module.ecs.ecs_service_id,
    ]
  }
}

data "aws_iam_openid_connect_provider" "githubusercontent" {
  url = "https://token.actions.githubusercontent.com"
}
