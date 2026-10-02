# Task 1 — Foundation & Environment Setup

**Internship:** ApexPlanet Software Pvt. Ltd. — Cybersecurity & Ethical Hacking
**Timeline:** Days 1–12
**Author:** Ajinkya
**Repository:** <https://github.com/Ajinkya49/apexinternship-cybersecrity>

---

## Table of contents

1. [Objectives](#1-objectives)
2. [Scope](#2-scope)
3. [Repository map](#3-repository-map)
4. [Ethical use and authorization](#4-ethical-use-and-authorization)
5. [Lab architecture](#5-lab-architecture)
6. [Prerequisites](#6-prerequisites)
7. [Setup process (summary)](#7-setup-process-summary)
8. [Verification commands](#8-verification-commands)
9. [Learning outcomes](#9-learning-outcomes)
10. [Troubleshooting](#10-troubleshooting)
11. [Evidence requirements](#11-evidence-requirements)
12. [How to read "expected" vs "actual"](#12-expected-vs-actual)

---

## 1. Objectives

Build strong fundamentals in cybersecurity, Linux, networking and cryptography, and set up a professional, **isolated** ethical-hacking lab that later tasks can reuse.

## 2. Scope

| Area | What is covered | Where |
|------|-----------------|-------|
| Cybersecurity basics | CIA Triad, phishing, malware, DDoS, SQL injection, brute force, ransomware, social engineering, wireless attacks, insider threats | [notes/01-cybersecurity-basics.md](notes/01-cybersecurity-basics.md) |
| Lab setup | VirtualBox, Kali Linux, Metasploitable2 / DVWA, Host-Only network | [lab-setup/](lab-setup/lab-setup-guide.md), [reports/Lab-Setup-Report.md](reports/Lab-Setup-Report.md) |
| Linux fundamentals | Navigation, permissions, `chmod`, `chown`, `apt`/`dpkg`, `ip`, `ping`, `ss`, `traceroute` | [linux-cheatsheet/](linux-cheatsheet/linux-cheatsheet.md) |
| Networking | OSI, TCP/IP, DNS, HTTP/HTTPS, IP addressing, subnetting, NAT | [networking/networking-fundamentals.md](networking/networking-fundamentals.md) |
| Cryptography | Symmetric vs asymmetric, MD5/SHA-256, certificates, SSL/TLS, OpenSSL | [cryptography/cryptography-fundamentals.md](cryptography/cryptography-fundamentals.md) |
| Tools | Wireshark, Nmap, Burp Suite, Netcat | [tools/tool-familiarization.md](tools/tool-familiarization.md) |
| Deliverables | Lab Setup Report, repo notes + cheat sheet, 5-minute video | [reports/](reports/), [video/](video/video-script.md) |

## 3. Repository map

```text
Task-1/
├── README.md                          <- you are here
├── notes/
│   └── 01-cybersecurity-basics.md
├── lab-setup/
│   ├── lab-setup-guide.md             <- step-by-step build guide
│   └── network-design.md              <- topology, IP plan, isolation rules
├── linux-cheatsheet/
│   ├── linux-cheatsheet.md
│   └── linux-permissions.md
├── networking/
│   └── networking-fundamentals.md
├── cryptography/
│   └── cryptography-fundamentals.md
├── tools/
│   └── tool-familiarization.md
├── scripts/
│   ├── lab-verify.sh                  <- run on Kali; saves real output
│   ├── openssl-demo.sh                <- local-only crypto demo
│   ├── netcat-demo.sh                 <- localhost-only client/server demo
│   └── validate-repo.sh               <- checks files and Markdown links
├── evidence/
│   ├── EVIDENCE-CHECKLIST.md          <- what to capture, exact filenames
│   └── terminal-output/               <- real output saved by the scripts
├── reports/
│   ├── Lab-Setup-Report.md
│   ├── requirements-matrix.md
│   └── submission-checklist.md
└── video/
    └── video-script.md
```

## 4. Ethical use and authorization

> **All testing is restricted to systems I own or explicitly control.**

* Permitted targets: `127.0.0.1` / `localhost`, my own Kali VM, my own Metasploitable2 VM, my own DVWA instance, all on the isolated Host-Only network `192.168.56.0/24`.
* **Not permitted:** scanning, probing, exploiting, brute-forcing, or otherwise testing public IP addresses, real websites, third-party systems, school/college/home networks, or anything outside the lab.
* Metasploitable2 and DVWA are **intentionally vulnerable**. They must never be bridged to a real network, exposed through port-forwarding, or run with a NAT/Bridged adapter.
* A tool reporting a *possible* issue is **not** proof of a vulnerability. Findings in this repository are described as observations, and demonstrations are labelled as demonstrations, not real security assessments.
* Task 1 does **not** include exploitation. It is about foundations and environment setup.

## 5. Lab architecture

Full detail: [lab-setup/network-design.md](lab-setup/network-design.md).

```text
                    ┌──────────────────────── Host PC ────────────────────────┐
                    │  VirtualBox                                              │
                    │  Host-Only Ethernet Adapter  192.168.56.1/24             │
                    │            │                                             │
                    │   ═════════╪══════ Host-Only network 192.168.56.0/24 ═══ │
                    │            │               │                             │
                    │   ┌────────┴─────────┐ ┌───┴──────────────────┐         │
                    │   │ Kali Linux       │ │ Metasploitable2      │         │
                    │   │ attacker/analyst │ │ target (+ DVWA)      │         │
                    │   │ eth1 .56.10      │ │ eth0 .56.20          │         │
                    │   │ eth0 NAT (updates│ │ Host-Only ONLY       │         │
                    │   │ only)            │ │ no default gateway   │         │
                    │   └──────────────────┘ └──────────────────────┘         │
                    └──────────────────────────────────────────────────────────┘
```

| Machine | Role | Adapter 1 | Adapter 2 | Address plan |
|---------|------|-----------|-----------|--------------|
| Host PC | Hypervisor | — | Host-Only Ethernet Adapter | 192.168.56.1 |
| Kali Linux | Attacker / analysis workstation | NAT (package updates only) | Host-Only | 192.168.56.10 (static) |
| Metasploitable2 | Intentionally vulnerable target (also hosts DVWA) | Host-Only | — | 192.168.56.20 (static) |

## 6. Prerequisites

* A 64-bit PC with virtualization enabled in BIOS/UEFI (Intel VT-x / AMD-V).
* About 8 GB RAM minimum (16 GB is more comfortable) and ~60 GB free disk.
* Oracle VirtualBox (VMware Workstation/Player also works; adapt the network names — see the setup guide).
* Kali Linux VirtualBox image or installer ISO from the official site.
* Metasploitable2 image from its official distribution, with the checksum verified.

## 7. Setup process (summary)

Detailed steps with **USER ACTION REQUIRED** markers are in [lab-setup/lab-setup-guide.md](lab-setup/lab-setup-guide.md). Summary:

1. Install VirtualBox and create a Host-Only network (`192.168.56.0/24`).
2. Import/install Kali; give it a NAT adapter (updates) and a Host-Only adapter.
3. Import Metasploitable2 with a **Host-Only adapter only**.
4. Assign static addresses (Kali `.10`, Metasploitable2 `.20`).
5. Verify connectivity and isolation with the commands below.
6. Install/inspect Wireshark, Nmap, Burp Suite, Netcat on Kali.
7. Capture evidence and fill in the report.

## 8. Verification commands

Each command is explained in [lab-setup/lab-setup-guide.md](lab-setup/lab-setup-guide.md#step-7--verify-connectivity-and-isolation). Quick reference (run on **Kali**):

```bash
ip -br addr                          # which addresses do my interfaces have?
ip route                             # which networks/gateways do I know about?
ping -c 4 192.168.56.20              # is the lab target reachable? (ICMP)
traceroute -n 192.168.56.20          # how many hops? (expect 1 on a flat network)
ss -tuln                             # which ports is Kali itself listening on?
./scripts/lab-verify.sh              # runs the above and saves real output
```

On **Metasploitable2** (isolation check):

```bash
ifconfig eth0        # confirm 192.168.56.20
route -n             # expect NO default (0.0.0.0) gateway
```

## 9. Learning outcomes

After completing Task 1 I can:

* explain the CIA Triad and map common threats to the property they harm;
* build and document an isolated attacker/target lab;
* navigate Linux, manage permissions, install packages and inspect networking state;
* explain OSI/TCP-IP, DNS, HTTP vs HTTPS, subnetting and NAT with worked examples;
* distinguish hashing, symmetric and asymmetric cryptography and use OpenSSL locally;
* use Wireshark, Nmap, Burp Suite and Netcat **inside the lab** and interpret their output carefully.

## 10. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| VirtualBox says "VT-x is disabled" / 64-bit guests missing | Virtualization off in BIOS, or Hyper-V/WSL2 conflict | Enable VT-x/AMD-V in BIOS; on Windows disable conflicting Hyper-V features if needed |
| Kali has no `eth1` address | Host-Only adapter not enabled, or connection set to DHCP with DHCP server off | Check VM Settings → Network → Adapter 2; set the static address (guide step 5) |
| `ping 192.168.56.20` fails | Wrong adapter attachment, wrong IP, or target not booted | Confirm both VMs use the **same** Host-Only network name; check `ip -br addr` and `ifconfig` on each |
| Metasploitable2 keyboard layout odd | Default US layout | Use `msfadmin`/`msfadmin` carefully; avoid special characters while editing |
| `apt update` fails on Kali | NAT adapter disabled/disconnected | Re-enable Adapter 1 (NAT) temporarily |
| Wireshark shows no interfaces | Not run with capture permission | Run `sudo wireshark` or add your user to the `wireshark` group, then log out/in |
| Wireshark shows no traffic | Wrong interface selected | Capture on `eth1` (Host-Only) for lab traffic; `lo` for localhost |
| Burp shows nothing | Browser not using proxy | Set Firefox proxy to `127.0.0.1:8080`; confirm Burp proxy listener is running |
| `nc -l -p 4444` errors | Different netcat flavour | Try `nc -l 4444` (OpenBSD/ncat syntax) — see [tools](tools/tool-familiarization.md#4-netcat) |

## 11. Evidence requirements

Never fabricate evidence. Screenshots and terminal output must come from **my own** environment. The exact list and filenames are in [evidence/EVIDENCE-CHECKLIST.md](evidence/EVIDENCE-CHECKLIST.md). Status of every requirement: [reports/requirements-matrix.md](reports/requirements-matrix.md). Final checks: [reports/submission-checklist.md](reports/submission-checklist.md).

## 12. Expected vs actual

Throughout these documents:

* **Expected output** blocks are *teaching examples* showing the typical shape of output. They are **not** my results.
* **Actual evidence** is only what lives in [`evidence/`](evidence/EVIDENCE-CHECKLIST.md) (screenshots) and `evidence/terminal-output/` (files written by my scripts on my machines).
* Where a value is mine to fill in, it appears as `____` and must be completed from real observation.
