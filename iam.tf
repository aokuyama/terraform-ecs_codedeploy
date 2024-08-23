resource "aws_iam_role" "deploy" {
  name = "${local.resource_name}-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGitHubActionsWithOIDCProvider"
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.githubusercontent.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" : "repo:${var.github_repository}:*"
          }
        }
      }
    ]
  })
  inline_policy {
    name = "ecr-push-image"
    policy = jsonencode(
      {
        Statement = [
          {
            Action   = "ecr:GetAuthorizationToken"
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "ecr:UploadLayerPart",
              "ecr:PutImage",
              "ecr:InitiateLayerUpload",
              "ecr:CompleteLayerUpload",
              "ecr:BatchCheckLayerAvailability",
            ]
            Effect = "Allow"
            Resource = [
              aws_ecr_repository.app.arn
            ]
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}
data "aws_iam_openid_connect_provider" "githubusercontent" {
  url = "https://token.actions.githubusercontent.com"
}
