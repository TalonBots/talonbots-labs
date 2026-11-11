# TalonBots Labs — Azure series

Reproducible, IaC-first Azure demos — built to be deployed, filmed, and torn down
on a fixed monthly credit. The Azure series of [TalonBots Labs](../../README.md).

Every demo is **ephemeral**: `apply` → record → `destroy`. Nothing is left running.
Cost-control on a free credit is a feature here, not an afterthought.

## Layout

| Path | What |
|------|------|
| `episodes/` | One self-contained demo per directory = one video. Start at `00-bootstrap`. |
| `modules/` | Reusable Azure building blocks shared across episodes. |
| `scripts/` | Azure credential loading (`load-azure-creds.sh`) + cost guard. |
| `docs/` | Teardown checklist and cost-control notes. |

> The apply→record→destroy loop is shared across all series: `../../shared/apply-record-destroy.sh`.

## Episodes

| # | Episode | What |
|---|---------|------|
| 00 | `episodes/00-bootstrap` | Service-principal auth + remote tfstate backend |
| 01 | `episodes/01-telegram-bot-aci` | A Telegram bot on ACI — one `apply` builds (ACR) + deploys, one `destroy` removes it all |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (optional, for inspection)
- An Azure subscription + a service principal with Contributor (see below)

## Auth — no secrets in this repo

Credentials are read from `ARM_*` environment variables at runtime. Never commit a
client secret.

```bash
cp scripts/.env.example scripts/.env     # gitignored; fill in your own service principal
source scripts/load-azure-creds.sh       # exports ARM_* (or uses ones already in your env)
```

Already export `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID` and
`ARM_SUBSCRIPTION_ID`? The loader just confirms they're set. If you keep the SP in
HashiCorp Vault, set `VAULT_ADDR` and `AZURE_VAULT_PATH` and the loader will read it.

## Reproduce a demo

```bash
source scripts/load-azure-creds.sh
cd episodes/00-bootstrap
terraform init
terraform apply
# ...record...
terraform destroy
```

Or use the helper that wraps the full loop with a teardown trap:

```bash
../../shared/apply-record-destroy.sh episodes/00-bootstrap
```

> Sanitization rule: this repo is public-facing. Generic, original demos only —
> zero employer/work content, ever. Assume every frame is public forever.
