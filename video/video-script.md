# Task 2 — 5-Minute Demo Video Script

**Video link:** `PASTE-VIDEO-LINK-HERE`
**Goal:** show a scan and its findings, plus packet analysis and the firewall. Show only real results from my lab; if something failed, say so.

## Before recording — USER ACTION REQUIRED
1. Both VMs on, Kali NAT **disconnected**, Greenbone scan already finished (do not wait on camera).
2. Pre-open: terminal in `Task-2/`, Nmap results (or run `nmap-scan.sh` beforehand), Greenbone report, Wireshark capture file or live window, scanner machine ready for the iptables demo.
3. Large terminal font, notifications off, no personal data on screen.

## Timeline
| Time | Section | Show on screen | Say (own words) | Evidence |
|------|---------|----------------|-----------------|----------|
| 0:00–0:25 | Intro | README, lab diagram | "I'm Ajinkya. This is ApexPlanet Task 2, Network Security & Scanning. Everything runs in my isolated lab against systems I own." | README |
| 0:25–1:00 | Recon | `nmap -sn 192.168.56.0/24`, one banner grab; a flash of whois/nslookup | "Passive recon gathers public information; active recon touches only my lab. A ping sweep finds live hosts and banner grabbing shows what services announce." | `T2-01`, `T2-02` |
| 1:00–2:00 | Nmap | `sudo ./nmap-scan.sh` output or saved report: `-sS`, `-sU`, `-sV`, `-O` | "SYN scan lists open TCP ports; UDP is slower so I limited it; -sV identifies versions and -O guesses the OS. These are observations. My report lists the services I found." | `T2-03`–`T2-05` |
| 2:00–3:15 | OpenVAS findings | Greenbone report: severity counts, top findings | "OpenVAS found ___ results: ___ high, ___ medium, ___ low. The top finding is ___ with CVSS ___. These are scanner-reported, not exploited. My fixes: update software, remove clear-text services, restrict exposure." | `T2-06`, `T2-07` |
| 3:15–4:05 | Wireshark | FTP stream with USER/PASS (lab account), SYN burst I/O graph | "FTP sends credentials in clear text, visible in this TCP stream. The hping3 burst, capped and aimed at my own VM, shows as a spike of SYN packets." | `T2-09`, `T2-10` |
| 4:05–4:45 | Firewall | `iptables-demo.sh block-port`, rescan shows filtered; scan-defense log lines | "An iptables rule drops port 8080 so Nmap sees it as filtered. A rate rule logs and drops fast SYN scans, shown by the kernel log." | `T2-12`, `T2-13` |
| 4:45–5:00 | Wrap-up | GitHub repo | "Reports, scripts, evidence and analysis are in my GitHub repo apexinternship-cybersecrity. Thank you." | repo |

## Tips
* Record one take per section and join them; stay under about 5:15.
* Do not show the Greenbone admin password or any personal account.
* Upload (unlisted), test the link logged out, then paste it here, in reports and in the root README.

## After recording
- [ ] About 5 minutes, audio clear, text readable
- [ ] Only lab addresses (`192.168.56.x`, `127.0.0.1`) visible
- [ ] Link recorded in the repo
