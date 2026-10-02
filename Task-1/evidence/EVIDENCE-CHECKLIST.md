# Evidence Checklist

**Rule: never fabricate evidence.** Every screenshot and every terminal log must come from my own VirtualBox lab. This folder currently contains **no screenshots** — all items below are **USER ACTION REQUIRED**.

How to capture:

* Screenshot the *whole VM window* (not just a terminal fragment) so the VM name, prompt, IP addresses and date are visible when possible.
* Save as PNG in `Task-1/evidence/` using the exact filenames below.
* Blur nothing needed for the lab (no real personal data should appear). If a real account name, serial number or other personal detail shows up, crop or blur it.
* Terminal logs are written by the scripts to `evidence/terminal-output/` — commit them only after reading them.

## Screenshot list

| ☐ | File | Requirement it proves | What exactly to capture | Where documented |
|---|------|-----------------------|-------------------------|------------------|
| ☐ | `01-virtualbox.png` | Virtualization platform installed | VirtualBox Manager with **both** VMs listed; separately or in the same shot, **Help → About** showing the version | [Setup guide step 1](../lab-setup/lab-setup-guide.md#step-1--install-virtualbox) |
| ☐ | `02-kali.png` | Kali attacker machine running | Kali desktop with a terminal showing `whoami`, `hostname`, `uname -a`, `cat /etc/os-release`, `ip -br addr` | [Step 3](../lab-setup/lab-setup-guide.md#step-3--install-kali-linux) |
| ☐ | `03-host-only-network.png` | Private Host-Only network | VirtualBox Network Manager (host-only adapter `192.168.56.1/24`) **and** the VM Settings → Network pages of both VMs (can be 2 files: `03a…`, `03b…`) | [Step 2](../lab-setup/lab-setup-guide.md#step-2--create-the-host-only-network), [design](../lab-setup/network-design.md) |
| ☐ | `04-connectivity.png` | Kali ↔ target connectivity | Kali terminal: `ip -br addr`, `ping -c 4 192.168.56.20`, `traceroute -n 192.168.56.20`, `ss -tuln` | [Step 7](../lab-setup/lab-setup-guide.md#step-7--verify-connectivity-and-isolation) |
| ☐ | `05-wireshark.png` | Wireshark test capture | Wireshark on `eth1` showing ICMP echo request/reply (filter `icmp`); add a second shot (`05b-…`) for TCP handshake or HTTP | [Tools §1](../tools/tool-familiarization.md#1-wireshark) |
| ☐ | `06-nmap.png` | Nmap scanning inside the lab | Terminal with `nmap -sT -sV -p 21,22,23,80 192.168.56.20` **and its real output** | [Tools §2](../tools/tool-familiarization.md#2-nmap) |
| ☐ | `07-burpsuite.png` | Burp proxy against a local app | Burp **HTTP history** with requests to `192.168.56.20` (DVWA); optionally Firefox proxy settings | [Tools §3](../tools/tool-familiarization.md#3-burp-suite-community-edition) |
| ☐ | `08-netcat.png` | Netcat client/server test | Two terminals (listener + client) with the typed line arriving, or the output of `scripts/netcat-demo.sh` | [Tools §4](../tools/tool-familiarization.md#4-netcat) |
| ☐ | `09-openssl.png` | OpenSSL hashing/encryption/decryption | Output of `scripts/openssl-demo.sh` (hashes, encrypt/decrypt round trip, `Verified OK`) | [Cryptography](../cryptography/cryptography-fundamentals.md) |
| ☐ | `10-metasploitable.png` | Metasploitable2 running | VM console: login prompt/after login with `ifconfig` showing `192.168.56.20` and `uname -a` | [Step 4](../lab-setup/lab-setup-guide.md#step-4--import-metasploitable2) |
| ☐ | `11-dvwa.png` | DVWA target available | Kali Firefox at `http://192.168.56.20/dvwa/` (address bar visible), DVWA security page showing level | [Step 6](../lab-setup/lab-setup-guide.md#step-6--dvwa) |
| ☐ | `12-linux-commands.png` | Linux navigation/permissions | Terminal running `pwd`, `ls -l`, `find`, `grep`, `chmod 600`, then `ls -l` | [Cheat sheet](../linux-cheatsheet/linux-cheatsheet.md), [permissions](../linux-cheatsheet/linux-permissions.md) |
| ☐ | `13-package-management.png` | `apt`/`dpkg` | `apt search nmap`, `apt show nmap`, `dpkg -l \| grep nmap`, `dpkg -S /usr/bin/nmap` | [Cheat sheet §4](../linux-cheatsheet/linux-cheatsheet.md#4-package-management-debiankali) |
| ☐ | `14-isolation-check.png` | Target is isolated | Metasploitable2 `route -n` (no default gateway) and its VM network settings (Host-only only) | [Network design §5](../lab-setup/network-design.md#5-isolation-rules-safe-lab-boundaries) |

## Terminal-output logs (created by my scripts, on my machines)

| ☐ | Command | Saved file pattern | Runs on |
|---|---------|--------------------|---------|
| ☐ | `scripts/lab-verify.sh 192.168.56.20` | `evidence/terminal-output/lab-verify-<timestamp>.txt` | Kali |
| ☐ | `scripts/openssl-demo.sh` | `evidence/terminal-output/openssl-demo-<timestamp>.txt` | Kali (or any Linux) |
| ☐ | `scripts/netcat-demo.sh` | `evidence/terminal-output/netcat-demo-<timestamp>.txt` | Kali |

## Video

| ☐ | Item | Where |
|---|------|-------|
| ☐ | 5-minute walkthrough recorded and uploaded (unlisted link) | Replace `PASTE-VIDEO-LINK-HERE` in [video-script.md](../video/video-script.md) and in the report |

## Requirement → evidence summary

| Internship requirement | Evidence |
|-----------------------|----------|
| Lab Setup Report with Kali screenshot | `02-kali.png` |
| … Metasploitable screenshot | `10-metasploitable.png` (+ `11-dvwa.png`) |
| … Wireshark test capture | `05-wireshark.png` |
| Virtualization software | `01-virtualbox.png` |
| Isolated Host-Only network | `03-host-only-network.png`, `14-isolation-check.png`, `04-connectivity.png` |
| Linux fundamentals & cheat sheet | `12-linux-commands.png`, `13-package-management.png` |
| Cryptography with OpenSSL | `09-openssl.png` |
| Nmap / Burp / Netcat familiarity | `06`, `07`, `08` |
| GitHub repo with notes | the repository itself |
| 5-minute video | video link |

## Placeholder policy

If I cannot capture an item, I leave the file **absent** and mark it in the [requirements matrix](../reports/requirements-matrix.md) as *not done* — I do **not** substitute edited, downloaded or generated images.
