# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
