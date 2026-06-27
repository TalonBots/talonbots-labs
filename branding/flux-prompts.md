# TalonBots Labs — Flux Logo Prompts
*For use with CF Workers AI `@cf/black-forest-labs/flux-1-schnell`*
*Generated: 2026-06-26*

All three drafts were generated and saved as PNGs in this directory.
Use these prompts to regenerate or iterate with variations.

---

## Draft 1 — "Precision Strike" (Recommended Direction)
**File:** `logo-draft-1-precision-strike.png`

```
Minimal flat vector logo icon, geometric falcon raptor head side profile view, sharp angular polygonal design, glowing circuit trace inside bird body, dark navy blue background, red accent color, isolated icon no text, clean crisp edges, tech startup logo, dark mode, square format
```

**Iteration ideas:**
- Add "eyes glowing red" for more personality
- Try "low-poly origami falcon" for a flatter feel
- Try on white background: replace "dark navy blue background" with "pure white background, navy blue bird"

---

## Draft 2 — "Terminal Raptor" (Hacker Aesthetic)
**File:** `logo-draft-2-terminal-raptor.png`

```
Dark terminal hacker aesthetic logo, stylized raptor bird made of ASCII-like vector lines on black background, monospace font terminal prompt bracket symbols, electric blue neon glow outline, minimalist code art, no text no letters, isolated icon, square format, cyberpunk tech brand
```

**Iteration ideas:**
- Add "green phosphor CRT glow" instead of blue for a retro terminal feel
- Try "bird constructed entirely from forward-slash and pipe characters"
- Add "scanline texture overlay" for CRT monitor aesthetic

---

## Draft 3 — "Falcon.exe" (Isometric/Cyberpunk)
**File:** `logo-draft-3-falcon-exe.png`

```
Isometric 3D vector icon of a mechanical robotic raptor talon claw gripping hexagonal honeycomb grid, electric violet and orange color scheme, metallic panel lines bolts, futuristic cyberpunk tech logo, dark near-black background, glowing edges, no text no letters, square format, product icon style
```

**Iteration ideas:**
- Try "eagle talon" instead of "raptor talon" for a more recognizable silhouette
- Add "sparks electricity" around the grip point
- Try "neon pink and cyan" color scheme for a more 80s cyberpunk feel

---

## API Snippet (for re-running)

```bash
ACCOUNT_ID="$(vault kv get -field=account_id homelab/cloudflare)"
TOKEN="$(vault kv get -field=edit_token homelab/cloudflare)"
PROMPT="your prompt here"

curl -s -X POST \
  "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/ai/run/@cf/black-forest-labs/flux-1-schnell" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"prompt\": \"${PROMPT}\"}" | python3 -c "
import sys, json, base64
data = json.load(sys.stdin)
if data.get('success'):
    with open('output.png', 'wb') as f:
        f.write(base64.b64decode(data['result']['image']))
    print('Saved to output.png')
else:
    print('Error:', data.get('errors'))
"
```
