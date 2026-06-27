# TalonBots Labs — Channel Setup Sheet

Copy-paste reference for dressing the YouTube channel + brand surfaces.
Channel already created (Brand Account, named **TalonBots Labs**):
`https://www.youtube.com/channel/UCp9ZuNFm0l491Q-ykIv5wrw`

---

## Locked brand
- **Name:** TalonBots Labs
- **Tagline:** Automate everything. Nuke the evidence.
- **Spine (positioning):** TalonBots Labs deploys production-grade bots and agents across every major cloud — reproducibly, cost-consciously, and without surprises.
- **Logo:** Terminal Raptor (neon cyan on black)

---

## YouTube → Studio → Customization

### Basic info
| Field | Value |
|-------|-------|
| **Name** | `TalonBots Labs` |
| **Handle** | `@TalonBotsLabs`  (fallbacks: `@TalonBots_Labs`, `@TalonBotsLab`) |
| **Contact email** | `hello@talonbots.com` |
| **Link — Website** | `https://talonbots.com` |
| **Link — GitHub** | `https://github.com/Talonbots` |

### Description (long) — 924 chars (YouTube limit 1000)
```
TalonBots Labs deploys production-grade bots and agents across every major cloud — reproducibly, cost-consciously, and without surprises.

Every episode: pick a bot, an agent, or an automation; deploy it on real infrastructure with reproducible code; film it; then destroy it before anyone sees a surprise bill. No click-ops. No "works on my machine." No cloud bills left running.

The bot is always the star. The cloud just changes — Azure one week, GCP the next, Proxmox or Oracle Free Tier after.

What you'll find here:
- IaC deployments (Terraform, Bicep, cloud-native), code in the GitHub org
- AI agent + LLM infra (LiteLLM, MCP servers, multi-agent patterns)
- Cost-controlled cloud across Azure, GCP, AWS, Oracle, and Proxmox
- Honest walkthroughs, including the parts that break

Every video has a matching repo at github.com/Talonbots. Fork it, deploy it, then destroy it.

Automate everything. Nuke the evidence.
```

### Description (short / preview card)
```
Bots and automation on every cloud — deployed with real IaC, filmed, then destroyed before the bill arrives. Azure, GCP, AWS, Oracle, Proxmox, AI agents. Every episode has a matching repo at github.com/Talonbots. Automate everything. Nuke the evidence.
```

### Branding tab — image assets
| Asset | File | Notes |
|-------|------|-------|
| **Profile picture** | `branding/assets/avatar-512-black.png` | 512×512, neon raptor on black |
| **Banner image** | `branding/assets/youtube-banner-2560x1440.png` | 2560×1440, 152 KB, content in safe-area |
| **Video watermark** (optional) | `branding/assets/favicon-180.png` | small raptor mark |

All paths are under `~/projects/talonbots-labs/`.

---

## Account / ownership notes
- Channel is a **Brand Account** (separate identity, supports multiple managers, transferable).
- Anchored under your Google account (sign in as the same account you created it with — likely `sun.lemunyon@gmail.com`).
- `hello@talonbots.com` is a forwarding alias, not a Google login — it's only the public *contact* email, set in Basic info.
- Monetization (YPP/AdSense) later ties to the owning Google account.

---

## Already done (no action needed)
- ✅ GitHub org `Talonbots` — public, profile README live (logo + tagline + spine + series table)
- ✅ Org avatar uploaded (neon raptor) — may need a hard refresh (`Ctrl-Shift-R`) to show
- ✅ Repo `github.com/Talonbots/talonbots-labs` (mirror of Gitea `admin/talonbots-labs`)
- ✅ `hello@talonbots.com` → your Gmail (Cloudflare Email Routing, live)

## Open items
- [ ] Set channel handle + paste name/description/links (above)
- [ ] Upload profile picture + banner (paths above)
- [ ] Set a verified contact email if YouTube prompts (it'll send a code to `hello@talonbots.com` → lands in your Gmail)
- [ ] Decide + add an upload schedule line (banner footer / About) when known
- [ ] Dry-run Azure AZ-01 against live credit (needs a @BotFather token), then film
- [ ] Crisp SVG of the logo (current marks are raster)
