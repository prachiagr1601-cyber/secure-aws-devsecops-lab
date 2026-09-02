\# AWS DevSecOps Lab Threat Model



\## System



Terraform defines AWS audit logging controls. GitHub Actions validates and scans infrastructure code before it is accepted. When deployed, CloudTrail sends AWS management logs to a private encrypted S3 bucket.



\## Assets



\- Terraform source code

\- GitHub repository and workflow configuration

\- AWS deployment identity

\- S3 CloudTrail log bucket

\- AWS KMS key and key policy

\- CloudTrail configuration and audit logs



\## Trust boundaries



\- Engineer workstation → GitHub repository

\- GitHub repository → GitHub Actions workflow

\- GitHub Actions → AWS deployment identity

\- CloudTrail → S3 log bucket

\- S3 log bucket → SOC/security analysts



\## Threats and controls



| Threat | Impact | Preventative control | Detection |

|---|---|---|---|

| Malicious Terraform change | Public bucket, weak IAM, or lost audit visibility | Pull request review, Terraform validation, Trivy scan | GitHub audit logs and workflow results |

| Secret committed to Git | AWS credential compromise | `.gitignore`, secret-scanning controls, no credentials in code | GitHub secret-scanning alert |

| Stolen CI/CD identity | Unauthorized AWS deployment | Least-privilege identity and future GitHub OIDC | Alert on unusual deployment activity |

| CloudTrail disabled | Loss of security visibility | Restrict AWS permissions and protect configuration | Alert on `StopLogging` or trail-update events |

| S3 bucket made public | Exposure of audit logs | S3 public-access block and Trivy scan | Alert on bucket-policy/public-access changes |

| KMS key policy weakened | Unauthorized log decryption | Key policy review and protected infrastructure code | Alert on KMS key-policy changes |

| Log deletion or overwrite | Loss of investigation evidence | S3 versioning and `force\_destroy = false` | Alert on S3 delete actions |



\## Security decisions



\- Infrastructure changes are made through Terraform, not manually in AWS.

\- CloudTrail logs are stored in a private S3 bucket.

\- Encryption uses a customer-managed KMS key.

\- CI blocks High and Critical Terraform misconfigurations.

\- AWS deployment is not enabled in this lab; `terraform apply` requires explicit approval.

