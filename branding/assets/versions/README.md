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

## Vector logo history
| Version | File | Notes |
|---|---|---|
| v1 | `raptor-logo-v1-potrace-hero-2026-11-13.svg` | **CURRENT canonical** `assets/raptor-logo.svg`. Hero (r3a) raptor, auto-traced from `raptor-hero-deglow.png`. |
| v1 | `raptor-mark-v1-potrace-bold-2026-11-13.svg` | **CURRENT canonical** `assets/raptor-mark.svg`. Bold (r3b) avatar/banner raptor, auto-traced from `raptor-deglow.png`. |

Canonical pointers: `assets/raptor-logo.svg` == raptor-logo v1, `assets/raptor-mark.svg` == raptor-mark v1 (byte-identical).
