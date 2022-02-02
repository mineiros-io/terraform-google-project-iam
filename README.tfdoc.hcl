header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-google-project-iam"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-google-project-iam/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-google-project-iam/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project-iam.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-google-project-iam/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gcp-provider" {
    image = "https://img.shields.io/badge/google-4-1A73E8.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-google/releases"
    text  = "Google Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-google-project-iam"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) module to create a [Google Project IAM](https://cloud.google.com/resource-manager/docs/access-control-proj) on [Google Cloud Services (GCP)](https://cloud.google.com/).

    **_This module supports Terraform version 1
    and is compatible with the Terraform Google Provider version 4._**

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
      A [Terraform] base module for creating a `google_project_iam_*` resources.

      It allows authoritative bindings (exclusive setting members),
      non-authoritative (adding additional members),
      or policy based IAM management of resource level access.

      Default GCP service accounts are added to specific roles.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-google-project-iam" {
        source = "github.com/mineiros-io/terraform-google-project-iam.git?ref=v0.1.0"

        project = "your-project-id"
        role    = "roles/editor"
        members = ["user:admin@example.com"]
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_depends_on" {
          type           = list(dependency)
          description    = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
          readme_example = <<-END
            module_depends_on = [
              google_network.network
            ]
          END
        }
      }

      section {
        title = "Main Resource Configuration"

        variable "project" {
          required    = true
          type        = string
          description = <<-END
            The project id of the target project. This is not inferred from the provider.
          END
        }

        variable "role" {
          type        = string
          description = <<-END
            The role that should be applied. Note that custom roles must be of the format `[projects|organizations]/{parent-name}/roles/{role-name}`.
          END
        }

        variable "members" {
          type        = set(string)
          default     = []
          description = <<-END
            Identities that will be granted the privilege in role. Each entry can have one of the following values:
            - `user:{emailid}`: An email address that represents a specific Google account. For example, alice@gmail.com or joe@example.com.
            - `serviceAccount:{emailid}`: An email address that represents a service account. For example, my-other-app@appspot.gserviceaccount.com.
            - `group:{emailid}`: An email address that represents a Google group. For example, admins@example.com.
            - `domain:{domain}`: A G Suite domain (primary, instead of alias) name that represents all the users of that domain. For example, google.com or example.com.
          END
        }

        variable "authoritative" {
          type        = bool
          default     = false
          description = <<-END
            Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role.
          END
        }

        variable "condition" {
          type           = object(condition)
          description    = <<-END
            An IAM Condition for the target project IAM binding.
          END
          readme_example = <<-END
            role          = "roles/storage.admin"
            authoritative = true
            condition = {
              title = "no_terraform_state_access"
              expression = <<EOT
                resource.type ==  "storage.googleapis.com/Bucket" &&
                resource.name != "terraform-state"
              EOT
            }
          END

          attribute "expression" {
            required    = true
            type        = string
            description = <<-END
              Textual representation of an expression in Common Expression Language syntax.
            END
          }

          attribute "title" {
            required    = true
            type        = string
            description = <<-END
              A title for the expression, i.e., a short string describing its purpose.
            END
          }

          attribute "description" {
            type        = string
            description = <<-END
              An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
            END
          }
        }

        variable "skip_adding_default_service_accounts" {
          type        = bool
          default     = false
          description = <<-END
            Whether to skip adding default GCP Service Accounts to specific roles.
            Please see links under [External Documentation](#external-documentation) for more information.

            Service Accounts added to non-conditional bindings of `roles/editor`:

            - App Engine default service account (`project-id@appspot.gserviceaccount.com`)
            - Compute Engine default service account (`project-number-compute@developer.gserviceaccount.com`)
            - Google APIs Service Agent (`project-number@cloudservices.gserviceaccount.com`)
          END
        }

        variable "policy_bindings" {
          type           = list(policy_binding)
          description    = <<-END
            A list of IAM policy bindings.

            **You can accidentally lock yourself out of your project using this resource. Deleting a google_project_iam_policy removes access from anyone without organization-level access to the project. Proceed with caution. It's not recommended to use `google_project_iam_policy` with your provider project to avoid locking yourself out, and it should generally only be used with projects fully managed by Terraform. If you do use this resource, it's recommended to import the policy before applying the change.**
          END
          readme_example = <<-END
            policy_bindings = [{
              role    = "roles/viewer"
              members = ["user:member@example.com"]
            }]
          END

          attribute "role" {
            required    = true
            type        = string
            description = <<-END
              The role that should be applied.
            END
          }

          attribute "members" {
            type        = set(string)
            default     = var.members
            description = <<-END
              Identities that will be granted the privilege in `role`.
            END
          }

          attribute "condition" {
            type           = object(condition)
            description    = <<-END
              An IAM Condition for a given binding.
            END
            readme_example = <<-END
              condition = {
                expression = "request.time < timestamp(\"2022-01-01T00:00:00Z\")"
                title      = "expires_after_2021_12_31"
              }
            END

            attribute "expression" {
              required    = true
              type        = string
              description = <<-END
                Textual representation of an expression in Common Expression Language syntax.
              END
            }

            attribute "title" {
              required    = true
              type        = string
              description = <<-END
                A title for the expression, i.e. a short string describing its purpose.
              END
            }

            attribute "description" {
              type        = string
              description = <<-END
                An optional description of the expression. This is a longer text which describes the expression, e.g. when hovered over it in a UI.
              END
            }
          }
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported in the outputs of the module:
    END

    output "module_enabled" {
      type        = bool
      description = <<-END
        Whether this module is enabled.
      END
    }

    output "iam" {
      type        = object(iam)
      description = <<-END
        All attributes of the created `iam_binding` or `iam_member` or
        `iam_policy` resource according to the mode.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Google Documentation:"
      content = <<-END
        - Project Access Control: https://cloud.google.com/resource-manager/docs/access-control-proj
        - Default service accounts: https://cloud.google.com/iam/docs/service-accounts#default
        - Google managed service accounts https://cloud.google.com/iam/docs/service-accounts#google-managed
      END
    }

    section {
      title   = "Terraform Google Provider Documentation:"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]
      
      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-google-project-iam"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-google-project-iam.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/Terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "badge-tf-gcp" {
    value = "https://img.shields.io/badge/google-3.x-1A73E8.svg?logo=terraform"
  }
  ref "releases-google-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-google/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://mineiros.io/slack"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "gcp" {
    value = "https://cloud.google.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-google-project-iam/blob/main/CONTRIBUTING.md"
  }
}
