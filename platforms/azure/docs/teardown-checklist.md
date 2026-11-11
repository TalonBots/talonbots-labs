# Teardown checklist — run after every recording session

- [ ] `terraform destroy` ran for the episode (or the apply-record-destroy trap fired)
- [ ] `scripts/cost-guard.sh` exits 0 and says "clean" (exit 1 = leftovers, exit 2 = could not verify; both mean NOT clean). With a pre-created RG, run it with `--rg NAME` or `TF_VAR_existing_resource_group` set so it also checks inside that RG. Demo RGs other than `rg-tfstate-demos` should not exist.
- [ ] Azure portal → Resource groups: visually confirm nothing unexpected
- [ ] No orphaned public IPs, disks, or NICs (these bill even when detached)
- [ ] Cost Management → today's spend looks sane
- [ ] State file for the episode is clean / removed if it was a throwaway

If anything is stuck: `scripts/cost-guard.sh --nuke` deletes every demo-tagged RG.
