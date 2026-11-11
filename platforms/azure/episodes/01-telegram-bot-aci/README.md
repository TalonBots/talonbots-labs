# Episode 01 — Telegram Bot on Azure Container Instances

**The hook:** a real Telegram bot, live in Azure, stood up with a *single*
`terraform apply` — Terraform builds the container image, pushes it, and runs it.
No servers, no Kubernetes, no always-on cost. We apply, we demo, then one
`terraform destroy` removes **everything** — registry, image, container.
The whole cloud bill for this episode: fractions of a cent.

## What one `apply` does

1. Creates a resource group (ephemeral)
2. Creates a throwaway **Azure Container Registry** (Basic)
3. Runs **`az acr build`** to build `sample-bot/` straight into the registry (server-side — no local Docker)
4. Runs the image on an **Azure Container Instance** in long-poll mode — the bot dials **out** to `api.telegram.org`, so no inbound ports or public IP

All of it is in Terraform state, so `terraform destroy` takes all of it back down. No leftovers, no surprise bill — the whole point.

## Prerequisites

1. **Episode 00 complete** — at minimum, `ARM_*` env vars exported with a Contributor service principal (`source ../../scripts/load-azure-creds.sh`).
2. **A Telegram bot token** from @BotFather:
   - Open Telegram → search `@BotFather` → send `/newbot`, follow the prompts
   - Copy the token (looks like `123456789:AABBccdd...`)
3. **Azure CLI** (`az`) and **Terraform** >= 1.6. *(No local Docker needed — the build happens in ACR.)*

---

## Step 1 — Set your bot token

```bash
cd platforms/azure/episodes/01-telegram-bot-aci
export TF_VAR_telegram_bot_token="YOUR_TOKEN_FROM_BOTFATHER"
# (or: cp terraform.tfvars.example terraform.tfvars and edit it — it's gitignored)
```

## Step 2 — Apply, record, destroy

### Option A — manual (good for stepping through on camera)

```bash
source ../../scripts/load-azure-creds.sh
terraform init
terraform apply
#  ^ first apply takes ~2-3 min: it builds the image in ACR before starting the bot.

# -- RECORD --
# Message your bot on Telegram: /start, /ping, or any text (it echoes).
# Watch live logs in a second terminal:
#   az container logs --resource-group rg-telegram-bot-demo --name aci-telegram-bot --follow

terraform destroy -auto-approve   # removes ACR, image, container — everything
```

### Option B — apply-record-destroy helper (trap guarantees teardown)

Run from this episode directory:

```bash
source ../../scripts/load-azure-creds.sh
../../../../shared/apply-record-destroy.sh .
# Ctrl-C at any point → destroy fires automatically.
```

> **Why the build is inside Terraform:** a `null_resource` runs `az acr build`
> after the registry exists and before the container starts (`depends_on`). It
> re-runs only when `sample-bot/` changes. The `az` CLI authenticates with the
> same `ARM_*` service principal Terraform uses — so one `apply` does it all, and
> one `destroy` cleans it all. That's the difference from a "build it manually,
> forget to delete the registry, get a bill" tutorial.

---

## Cost note

ACI is billed per-second on vCPU + memory:

| Resource | Rate (eastus) | 30-min session |
|----------|---------------|----------------|
| 0.5 vCPU | ~$0.0000135/vCPU-s | ~$0.012 |
| 1.0 GB   | ~$0.0000015/GB-s   | ~$0.003 |

The Basic ACR is ~$0.17/day, prorated and **destroyed with everything else** —
a demo session costs **well under $0.05** total. Inside the $150 credit, it's $0.

**After filming**, confirm nothing's left:
```bash
../../scripts/cost-guard.sh
```

---

## What you built

- A **serverless container** running a Telegram bot — no VMs, no orchestrators, no always-on cost
- A **one-apply pipeline**: Terraform orchestrates an `az acr build` *and* the deploy, all in one state
- A **real bot** on Telegram's long-polling API — outbound-only, so no firewall rules or public IPs
- A **clean teardown**: one `terraform destroy` removes the registry, the image, and the container

Everything down in one command. That's the TalonBots Labs model.

## Least-privilege mode: deploy into an existing resource group

If your service principal is Contributor on **one resource group** instead of the
whole subscription, it can't create or delete resource groups. Point the episode at
the pre-created RG instead:

```bash
export TF_VAR_existing_resource_group="rg-my-demo"
terraform apply
```

`terraform destroy` then removes the ACR, image and container but leaves the empty RG
in place. Provider auto-registration is skipped in this mode, so
`Microsoft.ContainerRegistry` and `Microsoft.ContainerInstance` must already be
registered on the subscription (they are on most subscriptions; check with
`az provider show -n Microsoft.ContainerInstance --query registrationState`).
