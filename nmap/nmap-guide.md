# Step 2 — Port & Service Scanning with Nmap

Targets: `192.168.56.20` (Metasploitable2) and `127.0.0.1` only. Kali NAT disconnected. Snapshot taken.

## 1. Scan types and options

| Goal | Command | Notes |
|------|---------|-------|
| TCP SYN ("half-open") scan | `sudo nmap -sS 192.168.56.20` | Sends SYN, waits for SYN/ACK (open) or RST (closed), never completes the handshake. Needs root |
| All 65,535 TCP ports | `sudo nmap -sS -p- 192.168.56.20` | Default scans only the top 1,000 |
| UDP scan | `sudo nmap -sU --top-ports 30 192.168.56.20` | Slow because UDP has no handshake; limit ports |
| Service/version detection | `sudo nmap -sV 192.168.56.20` | Probes open ports to identify product and version |
| OS detection | `sudo nmap -O 192.168.56.20` | Guesses the OS from TCP/IP stack behaviour; it is a *guess* with a confidence score |
| Combined | `sudo nmap -sS -sV -O -p- 192.168.56.20` | Used for the main report |
| Save all formats | `-oA name` | Writes `.nmap`, `.xml`, `.gnmap` |

Port states: **open**, **closed**, **filtered** (no response/blocked), **open|filtered** (common for UDP).

## 2. Run the scans
Automated, with a lab-only guard and saved output:
```bash
cd Task-2/scripts
chmod +x nmap-scan.sh
sudo ./nmap-scan.sh 192.168.56.20
```
Results go to `nmap/results-<timestamp>/`. Manual equivalent:
```bash
mkdir -p nmap/manual && cd nmap/manual
sudo nmap -sS -p- -oA tcp-syn 192.168.56.20
sudo nmap -sU --top-ports 30 -oA udp 192.168.56.20
sudo nmap -sV -O -p- -oA full-report 192.168.56.20
xsltproc full-report.xml -o full-report.html     # sudo apt install xsltproc if missing
```

Optional: summarise a real XML result as Markdown to paste into the report (it only reformats what Nmap recorded):
```bash
python3 scripts/parse-nmap-xml.py nmap/results-<timestamp>/03-full-report.xml > nmap/summary.md
```

## 3. Reading the output (shape only)
**Expected shape — not my result:**
```text
PORT   STATE SERVICE VERSION
21/tcp open  ftp     <product> <version>
22/tcp open  ssh     <product> <version>
Device type: general purpose
OS details: <Linux kernel guess>
```
Record for each open port: number/protocol, state, service, version, and a one-line note on the risk. Also record scan duration, Nmap version and the exact command.

## 4. Reference only: what Metasploitable2 is documented to expose
Metasploitable2 is deliberately configured with many legacy services. Documentation commonly lists FTP (21), SSH (22), Telnet (23), SMTP (25), DNS (53), HTTP (80), RPC (111), SMB (139/445), r-services (512–514), Java RMI (1099), NFS (2049), ProFTPD (2121), MySQL (3306), PostgreSQL (5432), VNC (5900), X11 (6000), IRC (6667), AJP (8009) and Tomcat (8180). **Treat this as a reference for sanity-checking, not as results.** My report lists only what my scan actually shows.

## 5. Interpreting responsibly
* An open port means something answered, not that it is vulnerable.
* A version banner suggests which known issues *might* apply; confirming needs authorized verification (Task 2 uses OpenVAS for that, see [step 3](../openvas/openvas-guide.md)).
* OS and version detection can be wrong; say "Nmap reports/suggests".
* Nmap on a lab host is a **demonstration**, not a professional assessment.

## 6. Evidence
`T2-03-nmap-tcp.png`, `T2-04-nmap-udp.png`, `T2-05-nmap-version-os.png` and the saved result folder. Fill [reports/Nmap-Scan-Report.md](../reports/Nmap-Scan-Report.md).
