# Task 2 Evidence Checklist

**Rule: never fabricate evidence.** All screenshots/logs must come from my own lab. This folder currently contains **no screenshots** — every item below is **USER ACTION REQUIRED**. Save PNGs in `Task-2/evidence/` with the exact names below. Make sure the VM window, IPs and time are visible; blur anything personal (e.g. real domain owner details, Shodan IPs).

| ☐ | File | What to capture | Guide |
|---|------|-----------------|-------|
| ☐ | `T2-01-recon-passive.png` | `whois` and `nslookup`/`dig` output for an owned/reserved domain; Shodan + dork syntax screenshots (identifiers blurred) | [recon](../recon/recon-guide.md) |
| ☐ | `T2-02-recon-active.png` | `nmap -sn 192.168.56.0/24` and a banner grab (`nc`/`curl -I`) | [recon](../recon/recon-guide.md#2-active-recon-lab-only) |
| ☐ | `T2-03-nmap-tcp.png` | `nmap -sS -p- 192.168.56.20` with output | [nmap](../nmap/nmap-guide.md) |
| ☐ | `T2-04-nmap-udp.png` | `nmap -sU --top-ports 30 …` with output | [nmap](../nmap/nmap-guide.md) |
| ☐ | `T2-05-nmap-version-os.png` | `-sV` and `-O` results | [nmap](../nmap/nmap-guide.md) |
| ☐ | `T2-06-openvas-dashboard.png` | Greenbone task `Done`, target `192.168.56.20` visible | [openvas](../openvas/openvas-guide.md) |
| ☐ | `T2-07-openvas-results.png` | Results list sorted by severity | [openvas](../openvas/openvas-guide.md) |
| ☐ | `T2-08-wireshark-http-dns.png` | Wireshark with `http` and/or `dns` filter showing lab traffic | [wireshark](../wireshark/packet-analysis-guide.md) |
| ☐ | `T2-09-wireshark-ftp-credentials.png` | FTP `USER`/`PASS` of the **lab account** in clear text (filter visible) | [wireshark §4.3](../wireshark/packet-analysis-guide.md#43-ftp-traffic-and-clear-text-credentials) |
| ☐ | `T2-10-wireshark-syn-flood.png` | SYN filter + Conversations or I/O graph showing the burst | [wireshark §4.4](../wireshark/packet-analysis-guide.md#44-syn-flood-analysis-simulated-with-hping3) |
| ☐ | `T2-11-iptables-baseline.png` | Baseline rules + scan showing port 8080 open | [firewall](../firewall/iptables-guide.md) |
| ☐ | `T2-12-iptables-blocked.png` | `LABDEMO` rule + rescan showing 8080 `filtered` | [firewall](../firewall/iptables-guide.md) |
| ☐ | `T2-13-iptables-scan-blocked.png` | Scan-defense rules + `LAB-PORTSCAN` log lines | [firewall](../firewall/iptables-guide.md) |

## Files and logs I must produce myself
| ☐ | Item | Created by |
|---|------|-----------|
| ☐ | `nmap/results-<timestamp>/` (`.nmap`, `.xml`, `.gnmap`, `.html`) | `sudo scripts/nmap-scan.sh` |
| ☐ | `openvas/<exported-report>.pdf` | Greenbone web UI |
| ☐ | `evidence/terminal-output/hping3-syn-demo-*.txt` | `scripts/hping3-syn-demo.sh` |
| ☐ | Wireshark captures (kept locally, not committed) | Wireshark |
| ☐ | Video link in [video-script.md](../video/video-script.md) | Upload after recording |

## Placeholder policy
If I cannot capture something, I leave the file **absent** and mark it *not done* in the [requirements matrix](../reports/requirements-matrix.md). I do not use edited, downloaded or generated images.
