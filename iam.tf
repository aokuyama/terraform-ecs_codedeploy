resource "aws_iam_role" "deploy" {
  name = "${local.resource_name}-deploy"

  assume_role_policy = data.aws_iam_policy_document.assume_role_deploy.json
  inline_policy {
    name   = "ecr-push-image"
    policy = data.aws_iam_policy_document.deploy_ecr.json
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

data "aws_iam_policy_document" "deploy_ecr" {
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
}

data "aws_iam_openid_connect_provider" "githubusercontent" {
  url = "https://token.actions.githubusercontent.com"
}
