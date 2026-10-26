# Username/password account recovery runbook (draft)

**Status:** policy draft; not an executable reset procedure. Do not use it to
modify production accounts until the required identity-proof method and secure
credential-delivery channel are approved by the CampusLoop owner.

## Scope

- Normal registration and login use username/password only. No email, OTP, or
  email delivery is part of this flow.
- A legacy email-authenticated account with a still-valid Auth Core session can
  claim username credentials through the authenticated registration endpoint.
  That keeps the existing Auth Core UUID and activity/RSVP ownership.
- An expired legacy session and a forgotten username/password currently have no
  self-service recovery endpoint. The application has no admin reset endpoint
  or operator tool.

## Manual support handling

1. **Do not reset yet if the approved identity check is unknown.** The owner
   must define which existing campus record or in-person process establishes
   identity. Do not treat possession of an email address or a username alone as
   proof.
2. Use an authorized support operator and an approved private support channel.
   Do not ask the user for their old password; never put passwords, reset
   credentials, or session tokens in tickets, chat, analytics, or logs.
3. Preserve the user's existing Auth Core UUID. Do not delete/recreate the Auth
   Core user or change activity/RSVP ownership to recover an account.
4. **Until audited reset tooling exists, stop here rather than editing
   `username_password_account` or Auth Core tables directly.** No safe operator
   reset mechanism is implemented in this repository.

## Requirements before an operator reset can be enabled

The owner must approve the identity-proof and delivery procedures. Any later
tooling should issue a cryptographically random, single-use credential or
reset token with a short expiry; store only a verifier/hash; rate-limit attempts;
revoke existing sessions after reset; and audit the operator, Auth Core UUID,
time, and result without recording the password or raw token. Deliver the
one-time credential only through the owner-approved channel. Email is not
assumed or required.

**Current production gate:** production user/session counts have not been
inspected. Determine whether legacy users exist and approve the recovery
procedure before removing their only working sign-in path or applying the
authentication migration to production.
