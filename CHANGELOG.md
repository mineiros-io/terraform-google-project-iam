# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0]

### Added

- Support for federated principals

## [0.4.0]

### Added

- Support for google v5 provider 

## [0.3.0]

### Added

- Add computed members feature
- Add support for audit log in policy bindings

### Removed

- BREAKING: Remove fallback to `var.members` in policy bindings
- BREAKING: Remove `module_enabled` output

## [0.2.0]

### Added

- Internal: Add Test-Suite

### Fixed

- Fix README examples and attribute names

### Removed

- BREAKING CHANGE: Remove support for Terraform before v1.0
- BREAKING CHANGE: Remove support for Terraform Google Provider before v4.0
- BREAKING CHANGE: Remove support for adding GCP service accounts in `roles/editor` bindings. Those should be passed by the user of the module if the services are actually enabled. There is currently no way to solve this in Terraform conditionally as there is no check if specific services are actually enabled.
  We recommend to use a custom editor role instead of editor role.

## [0.1.1]

### Added

- Add support for `google_project_iam_audit_config` resource

## [0.1.0]

### Added

- Add default GCP service accounts to `roles/editor` bindings controlled by new variable `skip_adding_default_service_accounts`

## [0.0.2]

### Added

- Support for provider 4.x

## [0.0.1]

### Added

- Initial Implementation

[unreleased]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/mineiros-io/terraform-google-project-iam/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-project-iam/releases/tag/v0.0.1
