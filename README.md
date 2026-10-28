# Task 2 — Network Security & Scanning

**Internship:** ApexPlanet Software Pvt. Ltd. — Cybersecurity & Ethical Hacking
**Timeline:** Days 13–24 | **Author:** Ajinkya
**Builds on:** [Task 1 lab](../Task-1/README.md) (Kali `192.168.56.10`, Metasploitable2 `192.168.56.20`, Host-Only `192.168.56.0/24`)

## 1. Objective
Learn reconnaissance, scanning and network-traffic analysis: passive and active recon, Nmap port/service/OS scanning, vulnerability scanning with OpenVAS (Greenbone), packet analysis with Wireshark, and basic firewalling with iptables.

## 2. Ethical use and authorization
> **All testing is restricted to systems I own or explicitly control.**

* Active scanning, packet generation and firewall tests target only `127.0.0.1`, Kali (`192.168.56.10`) and Metasploitable2 (`192.168.56.20`) in the isolated Host-Only lab. Kali's NAT adapter is **disconnected** during them.
* Passive recon uses only domains/assets I own or reserved example domains (e.g. `example.com`). No third-party host found through Shodan or Google dorking is contacted.
* The SYN-flood demonstration is a short, rate-limited burst (capped in the script) against my own VM. No `--flood`, no spoofed sources.
* A scanner finding is an **observation**, not proof of exploitability. This repository does not exploit anything.
* Scripts refuse targets outside the lab range.

## 3. Repository map
```text
Task-2/
├── README.md
├── recon/recon-guide.md                 Step 1  Whois, nslookup, dorking, Shodan, ping sweep, banner grabbing
├── nmap/nmap-guide.md                   Step 2  -sS -sU -sV -O, report creation
├── openvas/openvas-guide.md             Step 3  Greenbone/OpenVAS setup, scan, severity analysis
├── wireshark/packet-analysis-guide.md   Step 4  HTTP/FTP/DNS, FTP credentials, SYN flood
├── firewall/iptables-guide.md           Step 5  allow/deny ports, block a scan
├── scripts/                             nmap-scan.sh, hping3-syn-demo.sh, iptables-demo.sh, validate-repo.sh,
│                                        parse-nmap-xml.py, parse-openvas-csv.py (summarise MY real exports)
├── reports/
│   ├── Nmap-Scan-Report.md              fill from MY real scan output
│   ├── OpenVAS-Vulnerability-Report.md  fill from MY real scan export
│   ├── requirements-matrix.md
│   └── submission-checklist.md
├── evidence/EVIDENCE-CHECKLIST.md       screenshots + logs I must capture
└── video/video-script.md                5-minute demo script
```

## 4. Expected vs actual
Blocks labelled **expected** are teaching examples. **Actual** results are only the files in `evidence/` and `nmap/results-*` / `evidence/terminal-output/` that my scripts wrote on my machines. Fields marked `____` must be filled from real observation. No scan output, screenshot or finding in this repository was fabricated.

## 5. Order of work
| Days | Step | Guide |
|------|------|-------|
| 13–14 | Recon | [recon](recon/recon-guide.md) |
| 15–17 | Nmap + report | [nmap](nmap/nmap-guide.md), [report](reports/Nmap-Scan-Report.md) |
| 18–20 | OpenVAS + report | [openvas](openvas/openvas-guide.md), [report](reports/OpenVAS-Vulnerability-Report.md) |
| 21–22 | Wireshark | [wireshark](wireshark/packet-analysis-guide.md) |
| 23 | iptables | [firewall](firewall/iptables-guide.md) |
| 24 | Evidence, video, submit | [evidence](evidence/EVIDENCE-CHECKLIST.md), [video](video/video-script.md), [checklist](reports/submission-checklist.md) |

## 6. Common pre-flight (every session)
```bash
ip -br addr                 # Kali eth1 = 192.168.56.10 ?
ping -c 2 192.168.56.20     # target up?
```
Snapshot both VMs first (`Machine → Take Snapshot`); scanners can crash old VMs.
=======
# apexinternship-cybersecrity

ApexPlanet Software Pvt. Ltd. — **Cybersecurity & Ethical Hacking Internship**

| Task | Title | Folder | Status |
|------|-------|--------|--------|
| 1 | Foundation & Environment Setup (Days 1–12) | [`Task-1/`](Task-1/README.md) | Documentation drafted — evidence capture in progress |

> **Ethical-use notice:** every activity in this repository is performed only on systems I own or explicitly control (my own Kali Linux VM, Metasploitable2, DVWA, `localhost`) inside an isolated VirtualBox Host-Only network. See [Task-1/README.md](Task-1/README.md#4-ethical-use-and-authorization).db140ad34f312619fa6e72c13f36b285070eff5c
