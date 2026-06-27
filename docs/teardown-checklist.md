# Teardown checklist — run after every recording session

- [ ] `terraform destroy` ran for the episode (or the apply-record-destroy trap fired)
- [ ] `scripts/cost-guard.sh` shows no demo resource groups except `rg-tfstate-demos`
- [ ] Azure portal → Resource groups: visually confirm nothing unexpected
- [ ] No orphaned public IPs, disks, or NICs (these bill even when detached)
- [ ] Cost Management → today's spend looks sane
- [ ] State file for the episode is clean / removed if it was a throwaway

If anything is stuck: `scripts/cost-guard.sh --nuke` deletes every demo-tagged RG.
