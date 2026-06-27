# azure-demos

Reproducible, IaC-first Azure demos — built to be deployed, filmed, and torn down
on a fixed monthly credit. Part of the **TalonBots** automation/IaC content brand.

Every demo is **ephemeral**: `apply` → record → `destroy`. Nothing is left running.
Cost-control on a free credit is a feature here, not an afterthought.

## Layout

| Path | What |
|------|------|
| `episodes/` | One self-contained demo per directory = one video. Start at `00-bootstrap`. |
| `modules/` | Reusable Azure building blocks shared across episodes. |
| `scripts/` | Credential loading + the apply→record→destroy loop + cost guard. |
| `docs/` | Teardown checklist and cost-control notes. |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.6
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (optional, for inspection)
- An Azure subscription + a service principal with Contributor (see below)

## Auth — no secrets in this repo

Credentials live in Vault (`homelab/azure-sp`) and are exported as `ARM_*`
environment variables at runtime. Never commit a client secret.

```bash
source scripts/load-azure-creds.sh   # pulls SP creds from Vault → ARM_* env vars
```

If you're following along without Vault, copy the template and fill it in
(it's gitignored):

```bash
cp scripts/.env.example scripts/.env
# edit scripts/.env with your own SP, then:  set -a; source scripts/.env; set +a
```

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
scripts/apply-record-destroy.sh episodes/00-bootstrap
```

## Episodes

| # | Title | Status |
|---|-------|--------|
| 00 | Bootstrap: service principal auth + remote tfstate backend | scaffolded |

> Sanitization rule: this repo is public-facing. Generic, original demos only —
> zero employer/work content, ever. Assume every frame is public forever.
