# Nmap Scan Report

**Task:** 2 — Network Security & Scanning  **Author:** Ajinkya  **Date:** `____`
**Authorization:** Own lab only. Target `192.168.56.20` (Metasploitable2), isolated Host-Only network.

> Fill every `____` from my **real** scan files (`Task-2/nmap/results-*/`). Do not copy values from reference lists or other people's reports. Leave a row empty rather than inventing it.

## 1. Scope and method
| Item | Value |
|------|-------|
| Scanner | Nmap `____` (run `nmap --version`) |
| Scan host | Kali `192.168.56.10` |
| Target | `192.168.56.20` |
| Network state | NAT adapter disconnected: ☐ yes |
| Snapshot taken first | ☐ yes |
| Start / end time | `____` / `____` |

Commands executed (copy exactly from my terminal/log):
```text
____
```

## 2. TCP SYN scan results (`-sS -p-`)
Open ports found: `____` Closed/filtered: `____`

| Port/Proto | State | Service | Version (from `-sV`) | Observation / risk note |
|------------|-------|---------|----------------------|-------------------------|
| `____` | `____` | `____` | `____` | `____` |

## 3. UDP scan results (`-sU --top-ports 30`)
| Port/Proto | State | Service | Note |
|------------|-------|---------|------|
| `____` | `____` | `____` | `____` |
(`open|filtered` means Nmap could not tell open from filtered.)

## 4. OS detection (`-O`)
Nmap's guess: `____` Confidence/aggressive guesses: `____`
Caveat: OS detection is a statistical guess.

## 5. Analysis
1. **Attack surface:** `____` open TCP ports. Services that send credentials in clear text (FTP, Telnet): `____`
2. **Outdated versions seen in banners:** `____`
3. **Services that should not be exposed in production:** `____`
4. **Recommended hardening (generic):** disable unused services, patch/upgrade, replace Telnet/FTP with SSH/SFTP, restrict access with a firewall, limit information in banners.
5. **Limitations:** a scan shows reachability and announced versions; it does not prove exploitability. See the [OpenVAS report](OpenVAS-Vulnerability-Report.md) for vulnerability checks.

## 6. Evidence files
| File | Description | Captured |
|------|-------------|----------|
| `evidence/T2-03-nmap-tcp.png` | TCP scan output | ☐ |
| `evidence/T2-04-nmap-udp.png` | UDP scan output | ☐ |
| `evidence/T2-05-nmap-version-os.png` | -sV / -O output | ☐ |
| `nmap/results-<timestamp>/` | `.nmap` `.xml` `.gnmap` `.html` | ☐ |

## 7. Declaration
All scans were performed only against systems I own inside my isolated lab. Signed: `____`
