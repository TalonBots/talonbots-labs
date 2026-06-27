# Cost control — demoing Azure on a fixed monthly credit

The credit (Visual Studio Enterprise → $150/mo) **expires monthly, no rollover**.
The whole repo is built so a surprise bill is structurally hard.

## Rules

1. **Ephemeral by default.** Every episode except `00-bootstrap` is `apply` →
   record → `destroy`. Nothing stays running overnight.
2. **Everything is tagged** `project=talonbots-labs`, `series=azure`, `ephemeral=true`.
   Those tags are how `scripts/cost-guard.sh` finds and nukes leftovers.
3. **One always-on resource only:** the tfstate storage account (~pennies/mo).
4. **Cheap SKUs for demos.** B-series VMs, LRS storage, Standard tiers. The demo
   is the architecture, not the horsepower.
5. **Verify clean after every session:** `scripts/cost-guard.sh` should print
   "none" once the bootstrap RG is excluded.

## End-of-session ritual

```bash
scripts/cost-guard.sh          # what's still up?
scripts/cost-guard.sh --nuke   # delete every demo RG (keeps nothing)
```

## Budget alert (set once in the portal)

Cost Management → Budgets → create a $150 budget on the subscription with alerts
at 50% / 80% / 100%. Belt-and-suspenders against a forgotten `destroy`.
