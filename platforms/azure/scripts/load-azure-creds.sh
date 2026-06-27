#!/usr/bin/env bash
# Source this file (don't execute it) to export Azure SP creds as ARM_* env vars.
#   source scripts/load-azure-creds.sh
#
# Creds come from Vault homelab/azure-sp — nothing is written to disk.
# Requires: vault CLI + a valid ~/.vault-token.

: "${VAULT_ADDR:=http://192.168.2.65:8200}"
export VAULT_ADDR

_p="homelab/azure-sp"

ARM_CLIENT_ID=$(vault kv get -field=client_id "$_p")           || { echo "vault read failed (client_id)"; return 1; }
ARM_CLIENT_SECRET=$(vault kv get -field=client_secret "$_p")   || { echo "vault read failed (client_secret)"; return 1; }
ARM_TENANT_ID=$(vault kv get -field=tenant_id "$_p")           || { echo "vault read failed (tenant_id)"; return 1; }
ARM_SUBSCRIPTION_ID=$(vault kv get -field=subscription_id "$_p") || { echo "vault read failed (subscription_id)"; return 1; }

export ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID

# NOTE: client_secret_id (the secret's *ID*) is NOT the same as client_secret
# (the secret's VALUE). Azure throws AADSTS7000215 if you send the ID. We export
# the VALUE above, which is correct.

echo "ARM_* exported for subscription ${ARM_SUBSCRIPTION_ID} (secret hidden)."
unset _p
