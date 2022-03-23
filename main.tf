resource "google_project_iam_binding" "project" {
  count = var.module_enabled && var.policy_bindings == null && var.authoritative ? 1 : 0

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
  for_each = var.module_enabled && var.policy_bindings == null && var.authoritative == false ? var.members : []

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

resource "google_project_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  project     = var.project
  policy_data = data.google_iam_policy.policy[0].policy_data

  depends_on = [var.module_depends_on]
}

data "google_iam_policy" "policy" {
  count = var.module_enabled && var.policy_bindings != null ? 1 : 0

  dynamic "binding" {
    for_each = var.policy_bindings

    content {
      role = binding.value.role

      members = try(binding.value.members, var.members)

      dynamic "condition" {
        for_each = try([binding.value.condition], [])

        content {
          expression  = condition.value.expression
          title       = condition.value.title
          description = try(condition.value.description, null)
        }
      }
    }
  }
}

locals {
  audit_configs_map = { for c in var.audit_configs : c.service => c }
}

resource "google_project_iam_audit_config" "project" {
  for_each = var.module_enabled ? local.audit_configs_map : {}

  project = var.project

  service = each.value.service

  dynamic "audit_log_config" {
    for_each = each.value.audit_log_configs

    content {
      log_type         = audit_log_config.value.log_type
      exempted_members = try(audit_log_config.value.exempted_members, null)
    }
  }
}
