resource "google_project_iam_binding" "project" {
  count = var.module_enabled && var.authoritative ? 1 : 0

  depends_on = [var.module_depends_on]

  project = var.project
  role    = var.role

  members = var.members

  dynamic "condition" {
    for_each = var.condition != null ? ["condition"] : []

    content {
      title       = var.condition.title
      description = try(var.condition.description, null)
      expression  = var.condition.expression
    }
  }
}

resource "google_project_iam_member" "project" {
  for_each = var.module_enabled && !var.authoritative ? var.members : []

  project = var.project
  role    = var.role

  member = each.value

  dynamic "condition" {
    for_each = var.condition != null ? ["condition"] : []

    content {
      title       = var.condition.title
      description = try(var.condition.description, null)
      expression  = var.condition.expression
    }
  }
}
