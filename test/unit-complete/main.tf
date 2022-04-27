module "test" {
  source = "../.."

  # add all required arguments

  project = "your-project-id"

  # add all optional arguments that create additional/extended resources


  role    = "roles/editor"
  members = ["user:admin@example.com"]

  # add most/all other optional arguments
}

module "test-audit" {
  source = "../.."

  # add all required arguments

  project = "your-project-id"

  # add all optional arguments that create additional/extended resources

  audit_configs = [
    {
      service = "allServices"
      audit_log_configs = [
        {
          log_type = "DATA_WRITE"
        },
        {
          log_type = "DATA_READ"
        }
      ]
    }
  ]

  # add most/all other optional arguments
}
