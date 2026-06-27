#!/usr/bin/env bash
# Wrap one episode in the full demo loop: init -> apply -> (pause to record) -> destroy.
# A trap guarantees teardown even if you Ctrl-C during recording, so nothing is
# left billing on the credit.
#
# Platform-agnostic — run from any series. Load that platform's creds first.
# Usage:  ../../shared/apply-record-destroy.sh episodes/00-bootstrap
set -euo pipefail

EP="${1:?usage: apply-record-destroy.sh <episode-dir>}"
[ -d "$EP" ] || { echo "no such episode dir: $EP"; exit 1; }

# Each series loads its own creds before calling this (Azure: source
# scripts/load-azure-creds.sh). Terraform errors clearly if unauthenticated.

cd "$EP"

cleanup() {
  echo
  echo ">>> Tearing down $EP ..."
  terraform destroy -auto-approve || echo "!! destroy failed — RUN 'terraform destroy' MANUALLY and check the portal."
}
trap cleanup EXIT

terraform init -input=false
terraform apply -auto-approve

echo
echo "============================================================"
echo " Deployed: $EP"
echo " Record now. Press ENTER when done to tear everything down."
echo "============================================================"
read -r _

# trap cleanup() runs on exit
