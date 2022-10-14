module "test-sa" {
  source = "github.com/mineiros-io/terraform-google-service-account?ref=v0.0.10"

  account_id = "service-account-id-${local.random_suffix}"
}

module "test" {
  source = "../.."

  # add all required arguments

  project = "unit-complete-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources


  role = "roles/editor"

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments
}

module "test2" {
  source = "../.."

  # add all required arguments

  project = "unit-complete-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources

  # add all optional arguments that create additional/extended resources

  role = "roles/editor"

  authoritative = false

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  # add most/all other optional arguments

  # add most/all other optional arguments
}

module "test3" {
  source = "../.."

  # add all required arguments

  project = "unit-complete-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources

  role = "roles/editor"

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  policy_bindings = [
    {
      condition = {
        expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
        title       = "expires_after_2021_12_31"
        description = "description here"
      }
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
    },
    {
      role = "roles/browser"
      members = [
        "user:member@example.com",
      ]
    }
  ]

  # add most/all other optional arguments
}

module "test4" {
  source = "../.."

  # add all required arguments

  project = "unit-complete-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources

  role = "roles/editor"

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  policy_bindings = [
    {
      condition = {
        expression  = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
        title       = "expires_after_2021_12_31"
        description = "description here"
      }
      role = "roles/viewer"
      members = [
        "user:member@example.com",
        "computed:myserviceaccount",
      ]
    },
    {
      role = "roles/browser"
      members = [
        "user:member@example.com",
      ]
    }
  ]

  audit_configs = [
    {
      service = "allServices"
      audit_log_configs = [
        {
          log_type = "DATA_READ"
          exempted_members = [
            "user:example@example.com"
          ]
        },
        {
          log_type = "DATA_WRITE"
        },
        {
          log_type = "ADMIN_READ"
        }
      ]
    }
  ]

  # add most/all other optional arguments
}

module "test5" {
  source = "../.."

  # add all required arguments

  project = "unit-complete-${local.random_suffix}"

  # add all optional arguments that create additional/extended resources

  role = "roles/editor"

  members = [
    "user:member@example.com",
    "computed:myserviceaccount",
  ]

  computed_members_map = {
    myserviceaccount = "serviceAccount:${module.test-sa.service_account.email}"
  }

  audit_configs = [
    {
      service = "allServices"
      audit_log_configs = [
        {
          log_type = "DATA_READ"
          exempted_members = [
            "user:example@example.com"
          ]
        },
        {
          log_type = "DATA_WRITE"
        },
        {
          log_type = "ADMIN_READ"
        }
      ]
    }
  ]

  # add most/all other optional arguments
}
