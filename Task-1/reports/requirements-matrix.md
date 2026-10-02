# Requirements Matrix — Task 1

Status key:

* **Docs** — documentation/script written in this repository.
* **Evidence** — real screenshot/log from *my* lab. **All evidence is currently pending**; no screenshot exists in this repository yet.
* ⏳ = USER ACTION REQUIRED, ✅ = done, ➖ = not applicable.

| # | Task 1 requirement | Documented in | Evidence needed | Docs | Evidence |
|---|--------------------|---------------|-----------------|------|----------|
| **1. Cybersecurity basics** | | | | | |
| 1.1 | CIA Triad | [notes §1](../notes/01-cybersecurity-basics.md#1-the-cia-triad) | — (study notes) | ✅ | ➖ |
| 1.2 | Phishing | [notes §3–4](../notes/01-cybersecurity-basics.md#3-threat-overview) | — | ✅ | ➖ |
| 1.3 | Malware | same | — | ✅ | ➖ |
| 1.4 | DDoS | same | — | ✅ | ➖ |
| 1.5 | SQL injection | same (+ parameterized-query example) | — | ✅ | ➖ |
| 1.6 | Brute force | same | — | ✅ | ➖ |
| 1.7 | Ransomware | same | — | ✅ | ➖ |
| 1.8 | Social engineering | same | — | ✅ | ➖ |
| 1.9 | Wireless attacks | same | — | ✅ | ➖ |
| 1.10 | Insider threats | same | — | ✅ | ➖ |
| 1.11 | Threat table (threat, example, impact, prevention, CIA property) | [notes §3](../notes/01-cybersecurity-basics.md#3-threat-overview) | — | ✅ | ➖ |
| **2. Lab environment** | | | | | |
| 2.1 | VirtualBox/VMware installed | [guide step 1](../lab-setup/lab-setup-guide.md#step-1--install-virtualbox), [report §4](Lab-Setup-Report.md#4-virtualization-software-installation) | `01-virtualbox.png` | ✅ | ⏳ |
| 2.2 | Kali Linux attacker machine | [guide step 3](../lab-setup/lab-setup-guide.md#step-3--install-kali-linux), [report §5](Lab-Setup-Report.md#5-kali-linux-installation) | `02-kali.png` | ✅ | ⏳ |
| 2.3 | Metasploitable2 and/or DVWA target | [guide steps 4, 6](../lab-setup/lab-setup-guide.md#step-4--import-metasploitable2), [report §6](Lab-Setup-Report.md#6-metasploitable2-and-dvwa-setup) | `10-metasploitable.png`, `11-dvwa.png` | ✅ | ⏳ |
| 2.4 | Private Host-Only network | [network design](../lab-setup/network-design.md), [guide step 2](../lab-setup/lab-setup-guide.md#step-2--create-the-host-only-network) | `03-host-only-network.png` | ✅ | ⏳ |
| 2.5 | Connectivity verification | [guide step 7](../lab-setup/lab-setup-guide.md#step-7--verify-connectivity-and-isolation), `scripts/lab-verify.sh` | `04-connectivity.png`, `lab-verify-*.txt` | ✅ | ⏳ |
| 2.6 | Isolation proof | [network design §5, §7](../lab-setup/network-design.md#7-how-isolation-is-verified) | `14-isolation-check.png` | ✅ | ⏳ |
| 2.7 | IP-addressing plan, machine roles, topology diagram | [README §5](../README.md#5-lab-architecture), [network design](../lab-setup/network-design.md) | — | ✅ | ➖ |
| **3. Linux fundamentals** | | | | | |
| 3.1 | Filesystem navigation | [cheat sheet §1, §7](../linux-cheatsheet/linux-cheatsheet.md) | `12-linux-commands.png` | ✅ | ⏳ |
| 3.2 | Permissions, `chmod`, `chown` | [permissions](../linux-cheatsheet/linux-permissions.md) | `12-linux-commands.png` | ✅ | ⏳ |
| 3.3 | Package management `apt`/`dpkg` | [cheat sheet §4](../linux-cheatsheet/linux-cheatsheet.md#4-package-management-debiankali) | `13-package-management.png` | ✅ | ⏳ |
| 3.4 | `ifconfig`/`ip`, `ping`, `netstat`/`ss`, `traceroute` | [cheat sheet §5](../linux-cheatsheet/linux-cheatsheet.md#5-networking) | `04-connectivity.png` | ✅ | ⏳ |
| 3.5 | Cheat sheet incl. `pwd ls cd find cat less grep cp mv mkdir rm chmod chown ps top systemctl apt dpkg ip ping ss traceroute hostname whoami uname` | [cheat sheet](../linux-cheatsheet/linux-cheatsheet.md) | — | ✅ | ➖ |
| **4. Networking basics** | | | | | |
| 4.1 | OSI model | [networking §1](../networking/networking-fundamentals.md#1-osi-model) | — | ✅ | ➖ |
| 4.2 | TCP/IP | [§2–3](../networking/networking-fundamentals.md#2-tcpip-model-and-mapping) | `05-wireshark.png` (TCP handshake) | ✅ | ⏳ |
| 4.3 | DNS | [§4](../networking/networking-fundamentals.md#4-dns-resolution) | optional lab-only DNS capture | ✅ | ⏳ (optional) |
| 4.4 | HTTP/HTTPS | [§5](../networking/networking-fundamentals.md#5-http-vs-https) | `05-wireshark.png` (HTTP) | ✅ | ⏳ |
| 4.5 | IP addressing, subnetting, CIDR | [§6–7](../networking/networking-fundamentals.md#6-ipv4-addressing) | — | ✅ | ➖ |
| 4.6 | NAT, gateway, DNS | [§8](../networking/networking-fundamentals.md#8-gateway-dns-dhcp-and-nat) | — | ✅ | ➖ |
| **5. Cryptography basics** | | | | | |
| 5.1 | Symmetric vs asymmetric | [crypto §2](../cryptography/cryptography-fundamentals.md#2-symmetric-vs-asymmetric) | — | ✅ | ➖ |
| 5.2 | MD5 / SHA-256, hashing ≠ encryption | [crypto §3](../cryptography/cryptography-fundamentals.md#3-hashing) | `09-openssl.png` | ✅ | ⏳ |
| 5.3 | Digital certificates, SSL/TLS | [crypto §7–8](../cryptography/cryptography-fundamentals.md#7-digital-certificates) | `09-openssl.png` | ✅ | ⏳ |
| 5.4 | OpenSSL encryption/decryption, signatures | [crypto §4–6](../cryptography/cryptography-fundamentals.md#4-symmetric-encryption-with-openssl-aes-256-cbc), `scripts/openssl-demo.sh` | `09-openssl.png`, `openssl-demo-*.txt` | ✅ | ⏳ |
| **6. Tool familiarization** | | | | | |
| 6.1 | Wireshark packet capture (ICMP/TCP/HTTP) | [tools §1](../tools/tool-familiarization.md#1-wireshark) | `05-wireshark.png` | ✅ | ⏳ |
| 6.2 | Nmap (lab only) | [tools §2](../tools/tool-familiarization.md#2-nmap) | `06-nmap.png` | ✅ | ⏳ |
| 6.3 | Burp Suite proxy vs DVWA | [tools §3](../tools/tool-familiarization.md#3-burp-suite-community-edition) | `07-burpsuite.png` | ✅ | ⏳ |
| 6.4 | Netcat local client/server | [tools §4](../tools/tool-familiarization.md#4-netcat), `scripts/netcat-demo.sh` | `08-netcat.png`, `netcat-demo-*.txt` | ✅ | ⏳ |
| **Deliverables** | | | | | |
| D1 | Lab Setup Report (Kali, Metasploitable, Wireshark screenshots) | [Lab-Setup-Report.md](Lab-Setup-Report.md) | `02`, `10`, `05` screenshots + filled `____` fields | ✅ template | ⏳ |
| D2 | GitHub repo with notes + Linux cheat sheet | this repository | — | ✅ | ⏳ push/commit |
| D3 | 5-minute video walkthrough | [video-script.md](../video/video-script.md) | recorded video + link | ✅ script | ⏳ |
| D4 | Ethical-use disclaimer | [README §4](../README.md#4-ethical-use-and-authorization), report §2/§15 | — | ✅ | ➖ |
| D5 | Evidence checklist | [EVIDENCE-CHECKLIST.md](../evidence/EVIDENCE-CHECKLIST.md) | — | ✅ | ➖ |
| D6 | Submission checklist | [submission-checklist.md](submission-checklist.md) | — | ✅ | ➖ |

## What has and has not been verified

| Item | Status |
|------|--------|
| Markdown links, code fences, file presence | Checked with `scripts/validate-repo.sh` |
| `openssl-demo.sh` and `netcat-demo.sh` | Syntax-checked and test-run in a separate Linux sandbox (OpenSSL 3.0.13, OpenBSD netcat). **That output is not lab evidence and was deleted.** Re-run on my Kali |
| `lab-verify.sh` | Syntax-checked; target guard tested (refuses non-lab addresses). Not run on Kali |
| Everything involving VirtualBox, Kali, Metasploitable2, Wireshark, Nmap, Burp Suite, DVWA, Host-Only network | **Not executed** — must be performed by me; screenshots pending |
