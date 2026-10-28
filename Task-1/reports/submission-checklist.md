# Final Submission Checklist

Tick each box only when it is **true in the repository on GitHub**. Run `./scripts/validate-repo.sh` first.

## Repository content

- [ ] `README.md` (root) and `Task-1/README.md` present and links work
- [ ] [Lab Setup Report](Lab-Setup-Report.md) — all `____` fields filled from real observation
- [ ] Linux [cheat sheet](../linux-cheatsheet/linux-cheatsheet.md) and [permissions guide](../linux-cheatsheet/linux-permissions.md)
- [ ] [Networking](../networking/networking-fundamentals.md), [cryptography](../cryptography/cryptography-fundamentals.md), [tool](../tools/tool-familiarization.md) and [cybersecurity basics](../notes/01-cybersecurity-basics.md) notes
- [ ] [Scripts](../scripts/validate-repo.sh) present and executable (`chmod +x scripts/*.sh`)
- [ ] [Requirements matrix](requirements-matrix.md) updated: every ⏳ turned into ✅ or honestly marked not done
- [ ] Ethical-use disclaimer present (README §4, report §2 and §15)

## Evidence (all from my own lab)

- [ ] `01-virtualbox.png`
- [ ] `02-kali.png`
- [ ] `03-host-only-network.png`
- [ ] `04-connectivity.png`
- [ ] `05-wireshark.png`
- [ ] `06-nmap.png`
- [ ] `07-burpsuite.png`
- [ ] `08-netcat.png`
- [ ] `09-openssl.png`
- [ ] `10-metasploitable.png`
- [ ] `11-dvwa.png`
- [ ] `12-linux-commands.png`
- [ ] `13-package-management.png`
- [ ] `14-isolation-check.png`
- [ ] Logs in `evidence/terminal-output/` created by running the scripts myself
- [ ] No screenshot is edited, downloaded, or generated — all are my own captures

## Video

- [ ] 5-minute walkthrough recorded using [video-script.md](../video/video-script.md)
- [ ] Uploaded (unlisted is fine) and link works while logged out
- [ ] Link pasted into the report header and the root `README.md`

## Safety and hygiene

- [ ] No private keys, passphrases, `.pem`, `.key`, `.pcap/.pcapng` committed (`git ls-files | grep -E '\.(pem|key|pcapng?|enc|pass)$'` prints nothing)
- [ ] No real IP addresses, usernames or personal data other than the lab ones in screenshots
- [ ] Every test targeted only `127.0.0.1` or `192.168.56.x`
- [ ] Kali's NAT adapter was disconnected during scans
- [ ] VM snapshots taken (optional but recommended)

## Push

```bash
git add .
git status                      # review what will be committed
git commit -m "Task 1: foundation and lab setup documentation and evidence"
git push origin main
```
