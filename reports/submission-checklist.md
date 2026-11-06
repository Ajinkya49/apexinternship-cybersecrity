# Task 3 Final Submission Checklist
Tick only when true on GitHub. Run `scripts/validate-repo.sh` first.

## Reports/docs
- [ ] [Security-Testing-Report.md](Security-Testing-Report.md): every `____` filled from real exploitation
- [ ] All six guides present and read through once for accuracy against my actual DVWA version
- [ ] [Requirements matrix](requirements-matrix.md) updated
- [ ] Ethical-use statement present (README §2, report §10)

## Evidence
- [ ] `T3-01` … `T3-14` screenshots (see [checklist](../evidence/EVIDENCE-CHECKLIST.md))
- [ ] No screenshot edited, downloaded or generated
- [ ] CSRF PoC and RFI marker file clearly lab-only (no real external URLs)

## Video
- [ ] 8-minute demo recorded showing one exploitation **and its fix**
- [ ] Link works logged out; pasted in video script, report and root README

## Safety and hygiene
- [ ] All testing targeted only DVWA on my own lab, never a real site
- [ ] RFI used my own lab-hosted file, not an external URL
- [ ] No real credentials, personal data, or `apply-headers.sh` backups with sensitive content committed
- [ ] DVWA Security level noted for every exercise

## Push
```bash
git add .
git status
git commit -m "Task 3: web application security - DVWA exploitation, fixes, and evidence"
git push origin main
```
