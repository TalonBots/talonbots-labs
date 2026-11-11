# Asset version archive

**Never overwrite a canonical asset in place.** Every iteration lands here with a
descriptive, dated name so a prior version is always recoverable by filename
(not just from git). The canonical file in `assets/` is a *copy* of the chosen
version — keep its name stable so docs and uploads never break.

## Convention
`<asset>-v<N>-<descriptor>[-STATUS]-<YYYY-MM-DD>.png`

## Banner history
| Version | File | Notes |
|---|---|---|
| v1 | `banner-v1-horizontal-original-2026-06-26.png` | Logo-left, name + tagline + footer. Superseded. |
| v2 | `banner-v2-centered-BROKEN-2026-06-26.png` | Centered vertical lockup — too tall, straddled YouTube's crop. Do not use. |
| v3 | `banner-v3-horizontal-compact-2026-06-26.png` | Compact horizontal. Superseded. |
| v4 | `banner-v4-horizontal-uppercaseB-2026-06-26.png` | **CURRENT canonical.** Horizontal, uppercase-B wordmark. |

Canonical pointer: `assets/youtube-banner-2560x1440.png` == v4 (byte-identical).
