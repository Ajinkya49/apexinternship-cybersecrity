# Lab Setup Report

**Internship:** ApexPlanet Software Pvt. Ltd. — Cybersecurity & Ethical Hacking
**Task:** 1 — Foundation & Environment Setup
**Author:** Ajinkya
**Date completed:** `____`
**Video walkthrough:** `PASTE-VIDEO-LINK-HERE`

> **How to use this report.** Sections below describe the intended build and where to put proof. Fields marked `____` and every screenshot must be filled in from **my own** lab. Nothing here claims an installation succeeded until the matching evidence exists in [`../evidence/`](../evidence/EVIDENCE-CHECKLIST.md). Do not paste screenshots or output that did not come from my machines.

## 1. Purpose and scope

Build an isolated lab for learning ethical hacking fundamentals: an attacker/analyst machine (Kali Linux), an intentionally vulnerable target (Metasploitable2 with DVWA) and a private Host-Only network. Scope is limited to systems I own inside that network and `localhost`.

## 2. Safe-lab boundaries and authorization

* Testing is limited to `127.0.0.1`, Kali (`192.168.56.10`), Metasploitable2/DVWA (`192.168.56.20`).
* No scanning, probing, exploiting or brute-forcing of public IPs, real websites, third-party or institutional networks.
* Metasploitable2 has a Host-Only adapter only (no NAT, no Bridged, no port-forwarding).
* Kali's NAT adapter is used only for updates and is disconnected during lab exercises.
* Tool output that suggests a possible weakness is treated as an observation, not a confirmed vulnerability.

## 3. Environment summary

| Item | Value (fill from real observation) |
|------|------------------------------------|
| Host OS / version | `____` |
| Host CPU / RAM | `____` |
| Virtualization software + version | VirtualBox `____` (Help → About) |
| Kali Linux version | `____` (`cat /etc/os-release`) |
| Kali VM resources | `____` vCPU / `____` MB RAM / `____` GB disk |
| Metasploitable2 source and checksum verified? | `____` |
| Metasploitable2 VM resources | `____` MB RAM |
| Host-Only network name / address | `____` / `192.168.56.1/24` (planned) |
| Kali Host-Only IP | `____` (planned `192.168.56.10`) |
| Metasploitable2 IP | `____` (planned `192.168.56.20`) |

## 4. Virtualization software installation

Steps followed: see [lab setup guide, steps 0–1](../lab-setup/lab-setup-guide.md#step-0--pre-flight).

Notes (problems, workarounds): `____`

📸 `evidence/01-virtualbox.png` — `☐ captured`

## 5. Kali Linux installation

Method used (pre-built image / ISO): `____`
Post-install actions: password changed `☐`, `apt update` + `full-upgrade` run `☐`

Commands to show in the screenshot: `whoami`, `hostname`, `uname -a`, `cat /etc/os-release`, `ip -br addr`.

📸 `evidence/02-kali.png` — `☐ captured`

## 6. Metasploitable2 and DVWA setup

Metasploitable2 was imported as an existing `.vmdk` into a new VM with a **Host-only** adapter. DVWA is the web application bundled with it, reached from Kali at `http://192.168.56.20/dvwa/`; security level set to `____` (Low for learning).

📸 `evidence/10-metasploitable.png` — `☐ captured`
📸 `evidence/11-dvwa.png` — `☐ captured`

## 7. Host-Only Adapter configuration

| VM | Adapter 1 | Adapter 2 |
|----|-----------|-----------|
| Kali | NAT (updates only) | Host-only: `____` |
| Metasploitable2 | Host-only: `____` | disabled |

Static addressing method and commands used: `____` (see [guide step 5](../lab-setup/lab-setup-guide.md#step-5--assign-static-ip-addresses)).

📸 `evidence/03-host-only-network.png` — `☐ captured`

## 8. Network topology

```text
 Host PC  (192.168.56.1)
    │
 ═══╪════════ Host-Only network 192.168.56.0/24 ════════
    │                          │
 Kali Linux                Metasploitable2 (+ DVWA)
 192.168.56.10             192.168.56.20
 (eth0 NAT: updates only)  (Host-only only)
```

Details: [network design](../lab-setup/network-design.md).

## 9. Connectivity and isolation verification

Commands (explained in [guide step 7](../lab-setup/lab-setup-guide.md#step-7--verify-connectivity-and-isolation)):

```bash
ip -br addr
ip route
ping -c 4 192.168.56.20
traceroute -n 192.168.56.20
ss -tuln
./scripts/lab-verify.sh 192.168.56.20
```

Results from my lab (fill in from real output):

| Check | Observed result |
|-------|-----------------|
| Kali `eth1` address | `____` |
| Ping Kali → Metasploitable2 | `____` packets received / `____` ms avg |
| Traceroute hop count | `____` |
| Metasploitable2 default route present? | `____` (expected: no) |

📸 `evidence/04-connectivity.png`, `evidence/14-isolation-check.png` — `☐ captured`
📄 `evidence/terminal-output/lab-verify-<timestamp>.txt` — `☐ saved`

## 10. Wireshark test capture

Interface: `____` Filter(s) used: `____`
What I observed (my own words, from my capture): `____`

📸 `evidence/05-wireshark.png` — `☐ captured`

## 11. Other tool checks

| Tool | Version output | What I did | Evidence |
|------|----------------|-----------|----------|
| Nmap | `____` | Scanned only `192.168.56.20` / `127.0.0.1` | `06-nmap.png` `☐` |
| Burp Suite | `____` | Proxied DVWA at `192.168.56.20` | `07-burpsuite.png` `☐` |
| Netcat | `____` | Localhost client/server test | `08-netcat.png` `☐` |
| OpenSSL | `____` | Hash / encrypt / decrypt / sign | `09-openssl.png` `☐` |

Observations must be reported accurately: what a tool printed is not proof of a vulnerability.

## 12. Linux, networking and cryptography study

* Linux: [cheat sheet](../linux-cheatsheet/linux-cheatsheet.md), [permissions](../linux-cheatsheet/linux-permissions.md) — `12-linux-commands.png`, `13-package-management.png`
* Networking: [networking fundamentals](../networking/networking-fundamentals.md)
* Cryptography: [cryptography fundamentals](../cryptography/cryptography-fundamentals.md)
* Cybersecurity basics: [notes](../notes/01-cybersecurity-basics.md)

## 13. Problems encountered and fixes

| Problem | Cause | Fix |
|---------|-------|-----|
| `____` | `____` | `____` |

## 14. Reflection

What I learned: `____`
What I would improve: `____`

## 15. Ethical-use declaration

All activity in this report was performed only on systems I own or explicitly control, inside an isolated Host-Only lab. No public or third-party systems were scanned, probed or attacked.

Signed: `____` Date: `____`
