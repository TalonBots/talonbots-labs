# TalonBots Labs — AWS series

**Status: planned.** Series stub — no episodes yet.

Follows the shared conventions in [`../../shared/README.md`](../../shared/README.md):
one episode per directory, `apply` → record → `destroy`, everything tagged
`project=talonbots-labs`, `series=aws`, secrets loaded from a vault at runtime.

Planned structure (mirrors the Azure series):

```
aws/
├── episodes/00-bootstrap/   # auth + remote state for this platform
├── modules/                 # reusable AWS building blocks
├── scripts/                 # AWS credential loading + cost guard
└── docs/                    # cost-control + teardown checklist
```
