#!/usr/bin/env bash
# Quick safety sweep: list every resource group tagged for these demos so you can
# confirm NOTHING was left running after a recording session.
#
# Requires Azure CLI logged in as the SP:
#   az login --service-principal -u "$ARM_CLIENT_ID" -p "$ARM_CLIENT_SECRET" -t "$ARM_TENANT_ID"
#   az account set --subscription "$ARM_SUBSCRIPTION_ID"
#
# Usage:
#   scripts/cost-guard.sh           # list demo resource groups
#   scripts/cost-guard.sh --nuke    # DELETE every demo-tagged RG (asks first)
set -euo pipefail

# Scope to this repo's Azure series only — won't touch other projects' RGs.
PROJECT="talonbots-labs"
SERIES="azure"

echo ">>> Resource groups tagged project=${PROJECT}, series=${SERIES}:"
mapfile -t RGS < <(az group list --query "[?tags.project=='${PROJECT}' && tags.series=='${SERIES}'].name" -o tsv)

if [ "${#RGS[@]}" -eq 0 ]; then
  echo "  (none — clean. Nothing billing.)"
  exit 0
fi
printf '  - %s\n' "${RGS[@]}"

if [ "${1:-}" == "--nuke" ]; then
  echo
  read -rp "Delete ALL ${#RGS[@]} resource group(s) above? type 'yes': " ans
  [ "$ans" == "yes" ] || { echo "aborted."; exit 1; }
  for rg in "${RGS[@]}"; do
    echo ">>> deleting $rg ..."
    az group delete --name "$rg" --yes --no-wait
  done
  echo "Delete requested (async). Re-run without --nuke in a minute to confirm empty."
fi
