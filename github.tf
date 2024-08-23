data "github_repository" "app" {
  name = var.github_repository
}
resource "github_actions_variable" "example_variable" {
  for_each = local.github_actions_variables

  repository    = data.github_repository.app.name
  variable_name = each.key
  value         = each.value
}
