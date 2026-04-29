# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2026-04-29

### Added

- Admin role can publish new versions of tagged application IAM policies (e.g. when adding a new S3 bucket).

## [1.2.0] - 2025-10-20

### Removed

- Legacy SSO principal ARN patterns from the engineer and admin role trust policies ([#2](https://github.com/deepnote/terraform-aws-deepnote-access/pull/2)).

## [1.1.0] - 2025-09-24

### Changed

- Engineer and admin role trust policies: additional `aws:PrincipalArn` patterns so both path-based and pathless SSO role ARNs can assume the roles ([#1](https://github.com/deepnote/terraform-aws-deepnote-access/pull/1)).

## [1.0.0] - 2025-07-17

### Added

- Initial release of the Deepnote IAM Management Module
- Engineer role with broad permissions for daily operations
- Admin role with IAM management capabilities
- Tag-based security controls
- Cross-account access for Deepnote (account: 978928340082)
- SSO integration support
- Self-protection mechanisms for Deepnote roles and policies

### Security

- Enforces proper tagging (`ProvisionedBy = "terraform"` and `ManagedBy = "deepnote"`)
- Prevents creation/management of untagged IAM resources
- Explicit deny statements for Deepnote role manipulation

[Unreleased]: https://github.com/deepnote/terraform-aws-deepnote-access/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/deepnote/terraform-aws-deepnote-access/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/deepnote/terraform-aws-deepnote-access/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/deepnote/terraform-aws-deepnote-access/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/deepnote/terraform-aws-deepnote-access/releases/tag/v1.0.0
