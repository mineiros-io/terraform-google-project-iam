module "test" {
  source = "../.."

  module_enabled = false

  # add all required arguments

  project = "your-project-id"

  # add all optional arguments that create additional/extended resources
}
