# Episode 00 — Bootstrap: SP auth + remote tfstate

**The hook:** before you can do *any* repeatable cloud demo, you need two things —
a way to authenticate that isn't your personal login, and a place to keep state
that survives a `terraform destroy`. This episode builds both.

## What it deploys

- A resource group `rg-tfstate-demos` (kept — not torn down)
- A storage account + private `tfstate` blob container with versioning on
- Costs roughly pennies/month — this is the *only* always-on piece

## Run it

```bash
source ../../scripts/load-azure-creds.sh   # ARM_* from Vault
terraform init
terraform plan
terraform apply
```

## Wire later episodes to the backend it creates

```bash
terraform output backend_snippet     # prints a ready-to-paste backend block
```

Drop that into the next episode's `backend.tf`, set a unique `key`, then
`terraform init -migrate-state`.

## Teardown note

Unlike every other episode, **you keep this one.** It's the shared backend. If you
ever want a truly clean slate: `terraform destroy` here last, after all other
episodes are gone.
