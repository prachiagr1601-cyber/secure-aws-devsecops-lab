\# SOC Runbook: AWS Audit-Logging Security Changes



\## Purpose



Investigate potentially unauthorized changes that reduce AWS audit visibility or expose CloudTrail logs.



\## High-priority alert events



\- `StopLogging`

\- `DeleteTrail`

\- `UpdateTrail`

\- `PutBucketPolicy`

\- `DeletePublicAccessBlock`

\- `PutKeyPolicy`

\- `DisableKey`

\- IAM role, policy, or access-key changes



\## Triage steps



1\. Identify the AWS account, Region, event time, source IP, user identity, and API call from CloudTrail.

2\. Determine whether the change has an approved Terraform pull request or change ticket.

3\. Check whether the actor is an expected administrator or an unusual identity.

4\. Compare the changed configuration with the Terraform code in GitHub.

5\. Assess impact:

&#x20;  - Is CloudTrail still logging?

&#x20;  - Is the S3 log bucket public or accessible by an unexpected principal?

&#x20;  - Was KMS access weakened or disabled?

&#x20;  - Were IAM permissions expanded?



\## Containment



\- If unauthorized, restrict or disable the compromised identity.

\- Restore the approved Terraform configuration through a reviewed change.

\- Re-enable CloudTrail immediately if logging was stopped.

\- Restore S3 public-access block and bucket policy.

\- Restore the approved KMS key policy.

\- Preserve CloudTrail, GitHub Actions, and IAM evidence.



\## Escalation criteria



Escalate to the security lead when:



\- CloudTrail is disabled or deleted.

\- Audit logs are publicly exposed, deleted, or inaccessible.

\- A privileged identity is suspected to be compromised.

\- KMS key policy changes allow unknown identities to decrypt logs.

\- An unauthorized deployment was made outside the approved pipeline.



\## Closure criteria



Close the incident only after:



\- The cause is identified and documented.

\- The approved Terraform configuration is restored.

\- Audit logging is confirmed operational.

\- Affected credentials or identities are remediated.

\- Detection logic and the runbook are updated if needed.

