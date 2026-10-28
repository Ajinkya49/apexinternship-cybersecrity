# Task 2 Requirements Matrix

Docs ✅ = written in this repo. Evidence ⏳ = **USER ACTION REQUIRED** (real capture from my lab; none exists yet). ➖ = not applicable.

| # | Requirement (from the task brief) | Documented in | Evidence needed | Docs | Evidence |
|---|-----------------------------------|---------------|-----------------|------|----------|
| 1.1 | Passive recon: Whois | [recon §1.1](../recon/recon-guide.md#11-whois--who-registered-a-domain) | `T2-01` | ✅ | ⏳ |
| 1.2 | Passive recon: Nslookup | [recon §1.2](../recon/recon-guide.md#12-nslookup--dig--dns-records) | `T2-01` | ✅ | ⏳ |
| 1.3 | Passive recon: Google dorking | [recon §1.3](../recon/recon-guide.md#13-google-dorking--advanced-search-operators) | `T2-01` | ✅ | ⏳ |
| 1.4 | Passive recon: Shodan | [recon §1.4](../recon/recon-guide.md#14-shodan--search-engine-for-internet-connected-devices) | `T2-01` | ✅ | ⏳ |
| 1.5 | Active recon: ping sweep | [recon §2.1](../recon/recon-guide.md#21-ping-sweep--which-hosts-are-alive) | `T2-02` | ✅ | ⏳ |
| 1.6 | Active recon: banner grabbing | [recon §2.2](../recon/recon-guide.md#22-banner-grabbing--what-services-announce-about-themselves) | `T2-02` | ✅ | ⏳ |
| 2.1 | Nmap TCP scan (-sS) | [nmap guide](../nmap/nmap-guide.md), `scripts/nmap-scan.sh` | `T2-03`, results folder | ✅ | ⏳ |
| 2.2 | Nmap UDP scan (-sU) | same | `T2-04` | ✅ | ⏳ |
| 2.3 | Service version detection (-sV) | same | `T2-05` | ✅ | ⏳ |
| 2.4 | OS detection (-O) | same | `T2-05` | ✅ | ⏳ |
| 2.5 | Create scan report for target systems | [Nmap-Scan-Report.md](Nmap-Scan-Report.md) | filled fields + results folder | ✅ template | ⏳ fill from real output |
| 3.1 | Setup OpenVAS or Nessus Essentials | [openvas guide §2](../openvas/openvas-guide.md#2-install-and-set-up-user-action-required-needs-internet) | `T2-06` | ✅ | ⏳ |
| 3.2 | Scan test VM (Metasploitable2) | [openvas guide §3](../openvas/openvas-guide.md#3-run-the-scan-lab-only) | `T2-06`, `T2-07`, PDF | ✅ | ⏳ |
| 3.3 | Analyze reports (Critical/High/Medium/Low) | [openvas guide §4–5](../openvas/openvas-guide.md#4-reading-severities), [OpenVAS report](OpenVAS-Vulnerability-Report.md) | filled report | ✅ template | ⏳ fill from real export |
| 4.1 | Capture HTTP, FTP, DNS traffic | [wireshark §4.1–4.3](../wireshark/packet-analysis-guide.md#41-http-traffic) | `T2-08`, `T2-09` | ✅ | ⏳ |
| 4.2 | Filter credentials from unencrypted FTP | [wireshark §4.3](../wireshark/packet-analysis-guide.md#43-ftp-traffic-and-clear-text-credentials) | `T2-09` | ✅ | ⏳ |
| 4.3 | Analyze SYN flood (simulate with hping3) | [wireshark §4.4](../wireshark/packet-analysis-guide.md#44-syn-flood-analysis-simulated-with-hping3), `scripts/hping3-syn-demo.sh` | `T2-10`, log | ✅ | ⏳ |
| 5.1 | Create simple iptables allow/deny rules | [firewall §3.2–3.3](../firewall/iptables-guide.md#3-steps-user-action-required), `scripts/iptables-demo.sh` | `T2-11`, `T2-12` | ✅ | ⏳ |
| 5.2 | Demonstrate blocking a port scan attempt | [firewall §3.4](../firewall/iptables-guide.md#3-steps-user-action-required) | `T2-13` | ✅ | ⏳ |
| D1 | Nmap Scan Report + OpenVAS Vulnerability Report | [reports/](.) | filled templates | ✅ templates | ⏳ |
| D2 | GitHub repo with detailed scan analysis | this repository | push to GitHub | ✅ structure | ⏳ push |
| D3 | 5-min demo video showing a scan & findings | [video-script.md](../video/video-script.md) | recorded video + link | ✅ script | ⏳ |
| — | Ethical-use statement | [README §2](../README.md#2-ethical-use-and-authorization) | — | ✅ | ➖ |

## What has been verified
| Item | Status |
|------|--------|
| File presence, code fences, relative links, script syntax | Checked with `scripts/validate-repo.sh` |
| Target guards in `nmap-scan.sh` and `hping3-syn-demo.sh` | Tested: they refuse non-lab addresses and over-limit counts |
| Nmap, hping3, iptables, OpenVAS, Wireshark, FTP/DNS captures | **Not executed** by the author of these documents (tools not available in the authoring sandbox). Commands follow standard documented usage; run and confirm on my Kali |
| Scan results, vulnerabilities, screenshots | **None included** — they must come from my own runs |
