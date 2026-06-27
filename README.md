# TalonBots Labs

**Bots & automation, built on every stack.** Reproducible, IaC-first demos that
deploy a bot / agent / automation on whatever platform is in front of us —
Azure, GCP, AWS, Oracle, a local Proxmox box, OpenStack — then tear it all back
down. Each demo is one video.

The throughline isn't a cloud. It's the **bot**: the thing being automated,
deployed, or set loose. The platform is just where it runs this week.

## Principles

- **IaC-first.** If it can't be `apply`-ed and `destroy`-ed, it's not a demo here.
- **Ephemeral by default.** Spin up → record → tear down. Nothing left billing.
- **No secrets in git.** Credentials come from a vault / env at runtime.
- **Sanitized, public-forever.** Generic, original demos only — zero employer or
  client content, ever.

## Layout

| Path | What |
|------|------|
| `platforms/azure/` | Azure series — **live** (bootstrap episode + tooling). |
| `platforms/gcp/`, `aws/`, `oracle/`, `proxmox/`, `openstack/` | Stubbed — series to come. |
| `ai/` | Cross-platform agent / bot work (LiteLLM, MCP, agent patterns). |
| `shared/` | Platform-agnostic tooling + conventions (the record loop, tagging). |

Each platform directory is self-contained: its own `episodes/`, `modules/`,
`scripts/`, and `docs/`, because auth and cost-control differ per cloud.

## Series index

| Platform | Status | First episode |
|----------|--------|---------------|
| Azure | live | `platforms/azure/episodes/00-bootstrap` — SP auth + remote tfstate |
| GCP | planned | — |
| AWS | planned | — |
| Oracle Cloud | planned | — |
| Proxmox | planned | — |
| OpenStack | planned | — |

## Quick start (Azure series)

```bash
cd platforms/azure
source scripts/load-azure-creds.sh           # creds from Vault -> ARM_* env
../../shared/apply-record-destroy.sh episodes/00-bootstrap
```

See `shared/README.md` for the conventions every platform series follows.
