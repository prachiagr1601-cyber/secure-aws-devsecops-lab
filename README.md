# Secure AWS DevSecOps Lab

## Objective

This project demonstrates a secure AWS infrastructure delivery workflow using Terraform, GitHub Actions, and Trivy.

## Architecture

```text
GitHub repository
  └─ GitHub Actions
      ├─ Terraform format and validation
      └─ Trivy IaC security scan
          ↓
Terraform configuration
  ├─ Private S3 audit-log bucket
  ├─ Customer-managed KMS encryption key
  └─ Multi-Region AWS CloudTrail