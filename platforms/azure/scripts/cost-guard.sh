#!/usr/bin/env bash
# Safety sweep: confirm NOTHING from these demos is still running after a session.
#
# Two checks:
#   1. Resource groups tagged project=talonbots-labs, series=azure (RG-per-episode mode).
#   2. Everything inside a pre-created RG, when one is named (RG-scoped service
#      principal mode). That RG is untagged and survives `terraform destroy`, so
#      check 1 cannot see what is left inside it.
#
# The RG is taken from --rg NAME, else $TF_VAR_existing_resource_group.
#
# Requires Azure CLI logged in as the SP:
#   az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" -t "$ARM_TENANT_ID"
#   az account set --subscription "$ARM_SUBSCRIPTION_ID"
#
# Usage:
#   scripts/cost-guard.sh                 # report
#   scripts/cost-guard.sh --rg rg-name    # also check a pre-created RG
#   scripts/cost-guard.sh --nuke          # delete demo-tagged RGs (asks first); never deletes a pre-created RG
#
# Exit codes: 0 = verified clean, 1 = leftovers found, 2 = could not verify (never reported as clean).
set -euo pipefail

PROJECT="talonbots-labs"   # scope to this repo's Azure series only
SERIES="azure"
EXISTING_RG="${TF_VAR_existing_resource_group:-}"
NUKE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --nuke) NUKE=1 ;;
    --rg)   shift; EXISTING_RG="${1:-}"; [ -n "$EXISTING_RG" ] || { echo "--rg needs a name" >&2; exit 2; } ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

# Never report "clean" if we could not look. Plain assignments so set -e sees az failures.
az account show >/dev/null 2>&1 || { echo "!!! az is not logged in: cannot verify. NOT clean, NOT checked." >&2; exit 2; }

LEFT=0

echo ">>> Resource groups tagged project=${PROJECT}, series=${SERIES}:"
TAGGED="$(az group list --query "[?tags.project=='${PROJECT}' && tags.series=='${SERIES}'].name" -o tsv)" \
  || { echo "!!! az group list failed: cannot verify." >&2; exit 2; }
mapfile -t RGS < <(printf '%s\n' "$TAGGED" | grep -v '^$' | grep -vx -- "${EXISTING_RG:-__none__}" || true)
if [ "${#RGS[@]}" -eq 0 ]; then
  echo "  (none)"
else
  printf '  - %s\n' "${RGS[@]}"; LEFT=1
fi

if [ -n "$EXISTING_RG" ]; then
  echo ">>> Resources inside pre-created resource group ${EXISTING_RG}:"
  INSIDE="$(az resource list --resource-group "$EXISTING_RG" --query "[].[name,type]" -o tsv)" \
    || { echo "!!! az resource list failed for ${EXISTING_RG}: cannot verify." >&2; exit 2; }
  if [ -z "$INSIDE" ]; then
    echo "  (empty)"
  else
    printf '%s\n' "$INSIDE" | sed 's/^/  - /'; LEFT=1
    echo "  (the resource group itself is pre-created and is never deleted by this script)"
  fi
fi

if [ "$LEFT" -eq 0 ]; then
  echo "clean. Nothing billing."
  exit 0
fi

if [ "$NUKE" -eq 1 ] && [ "${#RGS[@]}" -gt 0 ]; then
  echo
  read -rp "Delete ALL ${#RGS[@]} tagged resource group(s) above? type 'yes': " ans
  [ "$ans" == "yes" ] || { echo "aborted."; exit 1; }
  for rg in "${RGS[@]}"; do
    echo ">>> deleting $rg ..."
    az group delete --name "$rg" --yes --no-wait
  done
  echo "Delete requested (async). Re-run without --nuke in a minute to confirm empty."
fi
if [ -n "$EXISTING_RG" ] && [ -n "${INSIDE:-}" ]; then
  echo "To empty ${EXISTING_RG}: run 'terraform destroy' in the episode directory, or remove the listed resources in the portal."
fi
echo "NOT CLEAN."
exit 1
