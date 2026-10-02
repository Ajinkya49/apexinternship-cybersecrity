# 5-Minute Video Walkthrough Script

**Video link:** `PASTE-VIDEO-LINK-HERE`

**Goal:** show my lab setup working, in about 5 minutes (aim for 4:45–5:15).
**Only show real things from my own lab.** If something did not work, say so honestly — that is acceptable and professional.

## Before recording — USER ACTION REQUIRED

1. Both VMs powered on, Kali NAT adapter **disconnected**.
2. Terminal font enlarged (≥ 16 pt) and a clean desktop; close unrelated windows/tabs and hide personal notifications.
3. Pre-open: VirtualBox Manager, Kali terminal, Wireshark (on `eth1`), Firefox on `http://192.168.56.20/dvwa/`, Metasploitable2 console.
4. Screen recorder ready (OBS Studio / built-in recorder) with microphone test done.
5. Keep this script beside the recording, but speak naturally in your own words.

## Timeline

| Time | Section | Show on screen | Say (adapt to your own words) | Evidence file |
|------|---------|----------------|-------------------------------|---------------|
| 0:00–0:30 | Intro | Title slide or README in browser | "Hi, I'm Ajinkya. This is my ApexPlanet Cybersecurity & Ethical Hacking Task 1 walkthrough: foundation and environment setup. Everything I show runs in my own isolated lab; I only test systems I own." | repo README |
| 0:30–1:15 | Virtualization & VMs | VirtualBox Manager with Kali and Metasploitable2; Help → About | "I'm using VirtualBox version ___. Here are my two machines: Kali Linux as the attacker/analyst workstation and Metasploitable2 as an intentionally vulnerable target, plus DVWA." | `01-virtualbox.png`, `10-metasploitable.png` |
| 1:15–2:00 | Host-Only network | Network Manager; each VM's Network settings | "The lab uses a Host-Only network, 192.168.56.0/24. Kali has a NAT adapter for updates only, which I disconnect during tests. Metasploitable2 has only the Host-Only adapter, so it can't reach or be reached from my real network." | `03-host-only-network.png`, `14-isolation-check.png` |
| 2:00–2:45 | Connectivity | Kali terminal: `ip -br addr`, `ping -c 4 192.168.56.20`, `traceroute -n 192.168.56.20`; optionally `./lab-verify.sh` | "Kali is 192.168.56.10 and the target is 192.168.56.20. The ping shows replies, and traceroute shows one hop because they share a flat network. On Metasploitable2, `route -n` shows no default gateway." | `04-connectivity.png` |
| 2:45–3:30 | Wireshark | Wireshark on `eth1`, filter `icmp`, run ping; then `http` while loading DVWA | "In Wireshark I'm capturing on the Host-Only interface. Here are ICMP echo requests and replies — that's layer 3. Loading DVWA over HTTP I can read the request in clear text, which shows why HTTPS matters." | `05-wireshark.png` |
| 3:30–4:15 | Tools: Nmap, Netcat, Burp | `nmap -sT -sV -p 21,22,23,80 192.168.56.20`; `./netcat-demo.sh`; Burp HTTP history | "Nmap scans only my lab target and reports which ports and services respond — that's an observation, not proof of a vulnerability. Netcat shows a client and server on localhost. Burp proxies my browser to DVWA so I can inspect requests." | `06-nmap.png`, `08-netcat.png`, `07-burpsuite.png` |
| 4:15–4:45 | Linux & crypto | Cheat sheet in browser; `./openssl-demo.sh` output (hash, encrypt/decrypt, `Verified OK`) | "My repository has a Linux cheat sheet, permissions guide, networking and cryptography notes. With OpenSSL I hashed a file with SHA-256, encrypted and decrypted with AES, and verified a signature. Hashing is not encryption, and MD5 is broken." | `09-openssl.png`, `12-linux-commands.png`, `13-package-management.png` |
| 4:45–5:00 | Wrap-up | GitHub repository page; evidence folder | "All notes, scripts, the lab setup report and evidence are in my GitHub repository, apexinternship-cybersecrity. Thanks for watching." | repo |

## Recording tips

* If a step fails on camera, narrate the troubleshooting; do not cut it out dishonestly.
* Don't show passwords for personal accounts. DVWA/Metasploitable2 training credentials are fine.
* Keep each section within its time box; trim by skipping optional commands (not the Host-Only/isolation explanation).
* Export to MP4, upload (unlisted), test the link logged out, then paste it at the top of this file, in [../reports/Lab-Setup-Report.md](../reports/Lab-Setup-Report.md) and in the root README.

## Checklist after recording

- [ ] Length ≈ 5 minutes
- [ ] Audio clear, text readable
- [ ] Only lab systems visible (`192.168.56.x`, `127.0.0.1`)
- [ ] Link works and is recorded in the repository
