module "test" {
  source = "../.."

  module_enabled = false

  project = "unit-disabled-${local.random_suffix}"
  # add all required arguments

  # add all optional arguments that create additional/extended resources
}

module "test2" {
  source = "../.."

  module_enabled = false

  project = "unit-disabled-${local.random_suffix}"
  # add all required arguments

  authoritative = false
  members       = ["user:member@example.com"]

  # add all optional arguments that create additional/extended resources
}
