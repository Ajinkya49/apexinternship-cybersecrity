# Tool Familiarization

Wireshark, Nmap, Burp Suite and Netcat — used **only** against `localhost` and my own lab machines (Kali `192.168.56.10`, Metasploitable2/DVWA `192.168.56.20`) on the isolated Host-Only network.

> **Authorization reminder:** I do not scan, probe or intercept anything I do not own. Before any exercise below, disconnect Kali's NAT adapter (see [network design](../lab-setup/network-design.md#5-isolation-rules-safe-lab-boundaries)).

> **Expected vs actual:** "Expected observations" describe what typically appears. They are **not** my results. My results are the screenshots in [`evidence/`](../evidence/EVIDENCE-CHECKLIST.md) and the logs in `evidence/terminal-output/`.

---

## 1. Wireshark

**What it is:** a packet analyzer. It captures frames from a network interface and decodes protocols layer by layer.

### Start

```bash
sudo wireshark &
```

Select the interface: **`eth1`** (Host-Only, lab traffic) or **`lo`** (loopback, localhost traffic). Do not capture on the NAT interface while testing.

### Exercise A — ICMP (ping)

1. Start a capture on `eth1`, display filter: `icmp`
2. In a terminal: `ping -c 4 192.168.56.20`
3. Stop the capture.

*Expected observations:* paired *Echo (ping) request* / *Echo (ping) reply* packets between `192.168.56.10` and `192.168.56.20`. Expand a packet: Frame → Ethernet II → Internet Protocol → ICMP (OSI layers 2 → 3).

### Exercise B — TCP three-way handshake

1. Filter: `tcp.port == 80 && ip.addr == 192.168.56.20`
2. Browse to `http://192.168.56.20/` from Kali.

*Expected observations:* `[SYN]`, `[SYN, ACK]`, `[ACK]` at the start of the connection, followed by data segments. Quick filter for just connection attempts: `tcp.flags.syn == 1 && tcp.flags.ack == 0`.

### Exercise C — HTTP in cleartext

1. Filter: `http`
2. Load `http://192.168.56.20/dvwa/login.php`.
3. Right-click a packet → **Follow → HTTP Stream**.

*Expected observations:* request line (`GET …`), headers, and the HTML response are readable. A login `POST` would also expose submitted form fields — which is exactly why HTTP is unsafe on untrusted networks. (Only use DVWA's lab credentials here.)

### Exercise D — ARP

Filter `arp`, then run `ip neigh flush all` (harmless cache clear on Kali) followed by `ping -c 1 192.168.56.20`. *Expected:* an ARP request ("Who has 192.168.56.20?") and reply with the target's MAC.

### Exercise E — DNS (lab only, optional)

Public DNS is not queried. Optional lab-only approach: install `dnsmasq` on Kali, bind it to `192.168.56.10`, add `address=/meta2.lab/192.168.56.20`, then run `dig @192.168.56.10 meta2.lab` and filter `dns`. *Expected:* a query/response pair with the A record. If I skip this, I document it as "not performed".

### Exercise F — TLS on loopback

Capture `lo` with filter `tls` while running the `openssl s_server`/`s_client` demo ([cryptography notes](../cryptography/cryptography-fundamentals.md#8-ssltls)). *Expected:* Client Hello / Server Hello and encrypted application data.

### Useful display filters

| Filter | Shows |
|--------|-------|
| `ip.addr == 192.168.56.20` | Anything to/from the target |
| `icmp` | Ping |
| `tcp.port == 80` | HTTP-port traffic |
| `http.request.method == "POST"` | Form submissions |
| `dns` | DNS |
| `tls.handshake` | TLS handshakes |
| `!arp && !mdns` | Remove noise |

**Capture vs display filters:** capture filters (BPF, e.g. `host 192.168.56.20`) restrict what is recorded; display filters restrict what is shown afterwards.

📸 Evidence: `05-wireshark.png` — packet list with `icmp` and/or `http`/TCP handshake visible, interface name and addresses legible. Saved capture files stay local (`*.pcapng` is git-ignored) unless reviewed.

---

## 2. Nmap

**What it is:** a network scanner for host discovery, port scanning and service detection. Port scanning without permission can be illegal and against policy; my targets are `127.0.0.1` and `192.168.56.20` only.

| Command | Explanation |
|---------|-------------|
| `nmap -sn 192.168.56.20` | Host discovery only ("ping scan"), no port scan |
| `nmap -sT 127.0.0.1` | TCP connect scan of Kali's own top ports (uses full TCP connections; no raw sockets needed) |
| `nmap -sT -p 21,22,23,80 192.168.56.20` | Check four specific ports on the lab target |
| `nmap -sT -sV -p 21,22,23,80 192.168.56.20` | Also try to identify the service/version responding |
| `nmap -sT -p 1-1024 192.168.56.20` | Scan the well-known port range of the lab target |
| `nmap -sT -sV -sC -p 21,22,80 192.168.56.20` | Add Nmap's *default* script set (`-sC`) — informational checks, not an exploit run |
| `nmap -oN scan-lab.txt -sT -sV -p 21,22,23,80 192.168.56.20` | Save results to a file |

Option meanings: `-sn` no port scan; `-sT` TCP connect; `-sV` version detection; `-sC` default scripts; `-p` ports; `-oN` normal-format output.

Port states: **open** (something accepted the connection), **closed** (reachable but nothing listening), **filtered** (probes blocked/no response).

*Expected observations (Metasploitable2 is an old, intentionally exposed system):* several classic services such as FTP (21), SSH (22), Telnet (23) and HTTP (80) are typically reported open, with older version banners. Treat what Nmap prints as **what the service announces or what the probe suggests**.

**Interpreting results accurately**

* A version banner is not proof of a vulnerability. Confirming a vulnerability requires authorized, controlled verification against vendor/CVE information. Task 1 stops at *observation*.
* Some Nmap scripts can be intrusive; I only use the default `-sC` set, and only on the lab target.
* This is a **demonstration in a training lab**, not a real security assessment.

Evidence: run `./scripts/lab-verify.sh` (includes a small Nmap check) or capture the commands above → `06-nmap.png` and `evidence/terminal-output/`.

---

## 3. Burp Suite (Community Edition)

**What it is:** an intercepting web proxy. The browser sends traffic through Burp, so I can inspect and replay requests to an **authorized** web app (DVWA).

### Setup

1. Start Burp: `burpsuite` → Temporary project → Use Burp defaults → Start.
2. **Proxy → Proxy settings:** confirm a listener on `127.0.0.1:8080` (loopback only).
3. In Kali's Firefox: Settings → Network Settings → **Manual proxy configuration** → HTTP Proxy `127.0.0.1`, Port `8080`. Clear the "No proxy for" list only if needed for the lab addresses (Firefox excludes localhost by default).
4. **Target → Scope:** add `http://192.168.56.20/` and enable the option to ignore out-of-scope items so Burp does not log unrelated browser traffic.
5. For HTTPS sites (not needed for DVWA) browse to `http://burpsuite` to download Burp's CA certificate and import it into Firefox. Remove it when finished.

### Exercises (DVWA only)

| Step | What to do | What I learn |
|------|-----------|--------------|
| 1 | Turn **Intercept on**, load `http://192.168.56.20/dvwa/login.php` | Browser request held by Burp; I can read method, path, headers, cookies |
| 2 | Forward the request; turn intercept off | Traffic continues; entries appear under **HTTP history** |
| 3 | Log in with the DVWA lab credentials and inspect the `POST` | Form parameters and the `Set-Cookie` response header |
| 4 | Right-click a request → **Send to Repeater**, change a harmless parameter, **Send** | Replaying requests and reading responses |
| 5 | Read **Target → Site map** | Structure of the DVWA app |

Scope for Task 1: **proxying, inspecting and replaying normal requests**. No automated attacks or brute forcing.

### Clean-up

Switch Firefox back to **No proxy** when done. Leaving the proxy on routes all browsing through Burp.

📸 Evidence: `07-burpsuite.png` — Burp HTTP history/Proxy showing requests to `192.168.56.20` (and ideally the Firefox proxy setting).

---

## 4. Netcat

**What it is:** a simple tool for reading/writing data over TCP/UDP — handy for connectivity tests and learning how clients/servers talk.

Flavours differ:

| Flavour | Listen on port 4444 |
|---------|--------------------|
| netcat-traditional (Kali often defaults to this) | `nc -l -p 4444` |
| OpenBSD netcat / Ncat | `nc -l 4444` |

Check yours with `nc -h`.

### Exercise A — local chat (two terminals, loopback)

```bash
# Terminal 1 (server)
nc -l -p 4444          # or: nc -l 4444

# Terminal 2 (client)
nc 127.0.0.1 4444
```

Type a line in either terminal; it appears in the other. `Ctrl+C` to stop.

### Exercise B — port check

```bash
nc -zv 192.168.56.20 21 22 80     # -z scan only, -v verbose
```

*Expected:* "open"/"succeeded" lines for services that listen, "refused" for closed ones. Meaning of options: `-z` zero-I/O mode (just test the connection), `-v` verbose.

### Exercise C — banner read from a lab service

```bash
nc 192.168.56.20 21
```

*Expected:* the FTP service announces a greeting line. Type `QUIT` to close. Reading a banner I'm authorized to read is observation, not exploitation.

### Exercise D — file transfer inside the lab (optional)

```bash
# Receiver (Kali): nc -l -p 5555 > received.txt      (or nc -l 5555 > received.txt)
# Sender (Metasploitable2 or the same machine): nc 192.168.56.10 5555 < sample.txt
```

Compare with `sha256sum` on both ends to prove integrity — ties back to [hashing](../cryptography/cryptography-fundamentals.md#3-hashing).

### Out of scope

Reverse/bind shells (`-e`, `-c`), connecting to external hosts, and relaying traffic. Netcat is used here strictly as a debugging and learning tool.

### Automated localhost demo

```bash
cd Task-1/scripts && ./netcat-demo.sh
```

Runs listener + client on `127.0.0.1` and saves a log to `evidence/terminal-output/`. 📸 `08-netcat.png`.

---

## 5. Tool summary

| Tool | Used for | Lab target | Evidence |
|------|----------|-----------|----------|
| Wireshark | See what is on the wire | `eth1`, `lo` | `05-wireshark.png` |
| Nmap | Discover ports/services | `127.0.0.1`, `192.168.56.20` | `06-nmap.png` |
| Burp Suite | Inspect/replay web requests | DVWA at `192.168.56.20` | `07-burpsuite.png` |
| Netcat | Raw TCP connectivity tests | `127.0.0.1`, `192.168.56.20` | `08-netcat.png` |
