# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

locals {
  binding = try(google_project_iam_binding.project[0], null)
  member  = try(google_project_iam_member.project, null)

  iam_output = [local.binding, local.member]

  iam_output_index = var.authoritative ? 0 : 1
}

output "iam" {
  description = "All attributes of the created 'google_pubsub_subscription_iam_*' resource according to the mode."
  value       = local.iam_output[local.iam_output_index]
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}
