# shared/ — conventions every platform series follows

The platforms differ (Azure SP vs AWS IAM vs GCP service account), but the
*shape* of a demo is identical everywhere. Keep it consistent so viewers learn
the pattern once.

## The demo loop

Every episode is `init` → `apply` → **record** → `destroy`. Use the wrapper:

```bash
../../shared/apply-record-destroy.sh <episode-dir>
```

It traps exit so even a Ctrl-C during recording still tears down. Auth must
already be loaded in your shell (each platform has its own `scripts/load-*`).

## Conventions

1. **One episode = one self-contained directory** under `platforms/<x>/episodes/`,
   numbered (`00-`, `01-`, …). It has its own `*.tf` and a `README.md` that is
   the episode's script/notes.
2. **Tag everything** so leftovers are findable and nukeable. Standard tags:
   `project=talonbots-labs`, `series=<platform>`, `ephemeral=true`.
3. **Reusable building blocks live in `platforms/<x>/modules/`.** Lift to a
   shared module only when two platforms genuinely share it.
4. **Secrets never touch git.** Load from Vault (or a gitignored `.env`) at
   runtime; commit only `*.example` templates.
5. **Bootstrap once per platform.** Episode `00` stands up that platform's
   remote-state backend; it's the only thing you keep between sessions.

## Per-session teardown ritual

Each platform ships a cost-guard. Run it after recording and confirm nothing is
left running before you close out.
