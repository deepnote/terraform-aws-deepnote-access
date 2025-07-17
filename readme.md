# terraform-aws-deepnote-access

This Terraform module creates the necessary IAM roles and policies for Deepnote to manage your AWS infrastructure. It follows the principle of least privilege and includes proper tagging and security controls.

## Features

- **Engineer Role**: For daily operations and routine maintenance
- **Admin Role**: For installation and complex infrastructure changes
- **Tag-based Security**: Enforces proper tagging for all IAM resources
- **Cross-account Access**: Allows Deepnote to assume roles from their account
- **SSO Integration**: Supports AWS SSO role integration

## Quick Start


```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Provider configuration goes in the root module
provider "aws" {
  region  = "us-west-2"  # Change to your preferred region
  profile = ""           # Optional: specify AWS profile

  default_tags {
    tags = {
      ProvisionedBy = "terraform"
      ManagedBy     = "deepnote"
    }
  }
}

module "deepnote_iam" {
  source = "github.com/deepnote/terraform-aws-deepnote-access?ref=v1.0.0"

  # Optional: Customize naming
  name_prefix = "deepnote"
}
```


### Next Steps

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

## Variables

**Note**: This module does not configure the AWS provider. The provider configuration (region, profile, credentials) should be set in the root module that calls this module.

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name_prefix` | Prefix for resource names | `string` | `"deepnote"` |

## Outputs

| Name | Description |
|------|-------------|
| `engineer_role_arn` | ARN of the Deepnote engineer role |
| `admin_role_arn` | ARN of the Deepnote admin role |
| `engineer_role_name` | Name of the engineer role |
| `admin_role_name` | Name of the admin role |

## Security Features

### IAM Policy Restrictions
The admin policy includes:
- **Tag-based creation**: IAM resources can only be created with proper tags (`ProvisionedBy = "terraform"` and `ManagedBy = "deepnote"`)
- **Tag-based management**: IAM resources can only be managed if they have proper tags
- **Deny statements**: Prevents creation/management of untagged IAM resources
- **Self-protection**: Explicitly denies manipulation of Deepnote roles and policies

### Cross-Account Security
- Roles can only be assumed by Deepnote's account (978928340082)
- SSO integration with specific Deepnote SSO role patterns:
  - Production Engineer role: `AWSReservedSSO_ProductionEngineer_1b5a36fcae83ae61*`
  - Production Admin role: `AWSReservedSSO_ProductionAdmin_642531504c1179c1*`
- Proper resource-level permissions for IAM operations

### Engineer Policy Permissions
The engineer role has broad permissions for daily operations including:
- ACM, Auto Scaling, CloudFormation, CloudWatch
- DynamoDB, EC2, EKS, ElastiCache
- Elastic Load Balancing, KMS, CloudWatch Logs
- RDS, Route 53, S3, Secrets Manager
- SSM, Lambda, EventBridge, ECR

### Admin Policy Permissions
The admin role includes engineer permissions plus:
- IAM read operations (Get*, List*)
- Service-linked role creation
- IAM resource creation with required tags
- IAM resource management (add, attach, delete, detach, put, pass role, remove, tag, untag, update)
- Self-protection mechanisms

## Example Usage

See the `example/` directory for a complete working example.

## Versioning

This module follows [Semantic Versioning](https://semver.org/). For the versions available, see the [tags on this repository](https://github.com/deepnote/terraform-aws-deepnote-access/tags).

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For questions or issues, please contact Deepnote support or refer to the [Deepnote documentation](https://docs.deepnote.com).

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
