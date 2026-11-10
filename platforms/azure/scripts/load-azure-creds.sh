#!/usr/bin/env bash
# Source this file (don't execute it) to get ARM_* credentials into your shell.
#   source scripts/load-azure-creds.sh
#
# Resolution order (first match wins):
#   1. ARM_CLIENT_ID / ARM_CLIENT_SECRET / ARM_TENANT_ID / ARM_SUBSCRIPTION_ID already exported
#   2. scripts/.env next to this file (gitignored; copy from .env.example)
#   3. HashiCorp Vault, ONLY if VAULT_ADDR is set and you export AZURE_VAULT_PATH
#      (e.g. secret/azure-sp with fields client_id, client_secret, tenant_id, subscription_id)
#
# Nothing is written to disk and no secret is ever echoed.

_tl_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_tl_have() { [ -n "${ARM_CLIENT_ID:-}" ] && [ -n "${ARM_CLIENT_SECRET:-}" ] && [ -n "${ARM_TENANT_ID:-}" ] && [ -n "${ARM_SUBSCRIPTION_ID:-}" ]; }

if ! _tl_have && [ -f "${_tl_dir}/.env" ]; then
  set -a; . "${_tl_dir}/.env"; set +a
fi

if ! _tl_have && [ -n "${VAULT_ADDR:-}" ] && [ -n "${AZURE_VAULT_PATH:-}" ] && command -v vault >/dev/null 2>&1; then
  for _f in client_id client_secret tenant_id subscription_id; do
    _v="$(vault kv get -field="$_f" "$AZURE_VAULT_PATH")" || { echo "vault read failed ($_f)"; unset _f _v; return 1; }
    case "$_f" in
      client_id) export ARM_CLIENT_ID="$_v" ;;
      client_secret) export ARM_CLIENT_SECRET="$_v" ;;
      tenant_id) export ARM_TENANT_ID="$_v" ;;
      subscription_id) export ARM_SUBSCRIPTION_ID="$_v" ;;
    esac
  done
  unset _f _v
fi

if ! _tl_have; then
  echo "ARM_* credentials not found."
  echo "  Option 1: export ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_TENANT_ID, ARM_SUBSCRIPTION_ID"
  echo "  Option 2: cp scripts/.env.example scripts/.env  and fill it in"
  unset -f _tl_have; unset _tl_dir
  return 1
fi

# NOTE: use the secret's VALUE, not its ID. Azure throws AADSTS7000215 if you send the ID.
export ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID
echo "ARM_* ready (secret hidden)."
unset -f _tl_have; unset _tl_dir
