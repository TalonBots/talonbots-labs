# AZ-01 — Dry-run notes (validated 2026-06-26)

Ran the full episode live against the Visual Studio Enterprise credit, end to end.
This is the proof-of-correctness + a filming reference.

## Result: ✅ works end to end
- `terraform apply` → created `rg-telegram-bot-demo`, a throwaway Basic ACR (`acrtbot<rand>`), ran `az acr build` to build `sample-bot/` into it, then started the bot on ACI.
- Container came up **Running, 0 restarts**; logs showed `Bot starting — long-polling Telegram API.`
- Live test on **@TalonBotsAZ01Demo_bot**: `/start`, `/ping` (→ `pong`), and free-text echo all replied.
- `terraform destroy` removed ACI + ACR + RG in one shot. `cost-guard.sh` swept clean — **zero `project=talonbots-labs` resource groups left, nothing billing.**

## Environment gotchas (set up before filming)
- **`az` CLI is required** on the machine running Terraform — the in-TF `null_resource` calls `az acr build`. (Installed az-cli 2.87.0 during the dry-run; it was missing.)
- `Microsoft.ContainerRegistry` and `Microsoft.ContainerInstance` providers must be **Registered** on the subscription — both already were.
- Auth: `source ../../scripts/load-azure-creds.sh` exports `ARM_*`; the build step self-`az login`s with the same SP.
- Bot token supplied as `TF_VAR_telegram_bot_token` (read from Vault at runtime) — never written to a tfvars file.

## Timing / editing notes
- First `apply` takes **~2–4 min**, almost all of it the `az acr build` (uploads context, builds in ACR). That's the one dead-air stretch — **cut or timelapse it** in the edit.
- The `destroy` is fast (~1–2 min) and very satisfying on camera — let it play.
- Long-polling means there's **no public URL/webhook to show** — the visual proof is the Telegram chat replying + the live `az container logs`.

## The three "money" beats to capture on camera
1. `terraform apply` kicking off and the ACR build completing → ACI Running.
2. **The bot replying in Telegram** (`/ping → pong`) — the "it's actually live in Azure" moment.
3. `terraform destroy` + `cost-guard.sh` showing **"none — clean. Nothing billing."** → the brand payoff.

## Cost
A short demo session is **well under $0.05** (ACI per-second + a few minutes of Basic ACR), fully absorbed by the $150 monthly credit. Net out-of-pocket: $0.
