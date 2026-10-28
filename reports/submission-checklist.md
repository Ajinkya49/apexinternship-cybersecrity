# Task 2 Final Submission Checklist
Tick a box only when it is true on GitHub. Run `scripts/validate-repo.sh` first.

## Reports and docs
- [ ] [Nmap-Scan-Report.md](Nmap-Scan-Report.md): every `____` filled from my real scan files
- [ ] [OpenVAS-Vulnerability-Report.md](OpenVAS-Vulnerability-Report.md): filled from my real export; PDF saved in `openvas/`
- [ ] Guides present: recon, nmap, openvas, wireshark, firewall
- [ ] [Requirements matrix](requirements-matrix.md): every ⏳ turned into ✅ or honestly marked not done
- [ ] Ethical-use statement present (README §2, both reports)

## Evidence (my own lab)
- [ ] `T2-01` … `T2-13` screenshots (see [checklist](../evidence/EVIDENCE-CHECKLIST.md))
- [ ] `nmap/results-<timestamp>/` committed
- [ ] `evidence/terminal-output/hping3-syn-demo-*.txt` committed
- [ ] No screenshot is edited, downloaded or generated

## Video
- [ ] 5-minute demo recorded from [video-script.md](../video/video-script.md), showing a scan and findings
- [ ] Link works logged out; pasted in the video script, root README and reports

## Safety and hygiene
- [ ] All active tests targeted only `127.0.0.1` / `192.168.56.x`, with Kali NAT disconnected
- [ ] SYN burst was capped, no `--flood`, no spoofed sources
- [ ] iptables demo cleaned up (`iptables-demo.sh cleanup`)
- [ ] No passwords (e.g. Greenbone admin password), `.pcap/.pcapng`, keys or real personal data committed
- [ ] Shodan/dork screenshots contain no third-party IPs or private data

## Push
```bash
git add .
git status
git commit -m "Task 2: network security and scanning - reports, scripts and evidence"
git push origin main
```
