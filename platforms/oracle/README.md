# TalonBots Labs — ORACLE series

**Status: planned.** Series stub — no episodes yet.

Follows the shared conventions in [`../../shared/README.md`](../../shared/README.md):
one episode per directory, `apply` → record → `destroy`, everything tagged
`project=talonbots-labs`, `series=oracle`, secrets loaded from a vault at runtime.

Planned structure (mirrors the Azure series):

```
oracle/
├── episodes/00-bootstrap/   # auth + remote state for this platform
├── modules/                 # reusable ORACLE building blocks
├── scripts/                 # ORACLE credential loading + cost guard
└── docs/                    # cost-control + teardown checklist
```
