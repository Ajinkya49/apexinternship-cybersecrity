# Step 1 — Reconnaissance

Recon = gathering information before testing. **Passive** recon never touches the target's systems; **active** recon does, so it needs authorization.

| Type | Techniques | Allowed targets in this task |
|------|-----------|------------------------------|
| Passive | Whois, nslookup/dig, Google dorking, Shodan | Domains/assets I own, or reserved `example.com`/`example.org` |
| Active | Ping sweep, banner grabbing | `127.0.0.1`, `192.168.56.0/24` lab only |

## 1. Passive recon
Kali needs its **NAT adapter connected** for DNS/Whois. Reconnect, run, then disconnect.

### 1.1 Whois — who registered a domain
```bash
whois example.com
```
Look for: registrar, creation/expiry dates, name servers, registrant contact (often redacted by privacy services). Why it matters: reveals ownership, infrastructure and social-engineering material.

### 1.2 nslookup / dig — DNS records
```bash
nslookup example.com                 # A record via my resolver
nslookup -type=MX example.com        # mail servers
nslookup -type=NS example.com        # authoritative name servers
nslookup -type=TXT example.com       # SPF/verification text
dig example.com +noall +answer       # same data, scriptable format
```
Record meanings: see [Task 1 networking notes](../../Task-1/networking/networking-fundamentals.md#4-dns-resolution).

### 1.3 Google dorking — advanced search operators
Use **only against my own site** (e.g. my portfolio or GitHub Pages) or just show the syntax on a generic query.

| Operator | Purpose | Example |
|----------|---------|---------|
| `site:` | Limit to a domain | `site:mydomain.example` |
| `filetype:` | Specific file types | `site:mydomain.example filetype:pdf` |
| `intitle:` | Words in page title | `intitle:"index of" site:mydomain.example` |
| `inurl:` | Words in URL | `inurl:admin site:mydomain.example` |
| `"quotes"` / `-` | Exact phrase / exclusion | `"internal use only" -public` |

Defensive takeaway: dorking finds what is already exposed; check your own site for accidentally indexed files, directory listings and admin pages. Do not open or interact with results that belong to others.

### 1.4 Shodan — search engine for internet-connected devices
Create a free account at shodan.io. For the task: show the interface, the filters (`port:`, `product:`, `country:`, `org:`) and the result page structure for **one generic or own-asset query**. Redact IP addresses in screenshots, and do not connect to any result. Takeaway: Shodan shows what a host's services announce publicly, which is why exposed databases and default banners are risky.

## 2. Active recon (lab only)
Disconnect NAT first.

### 2.1 Ping sweep — which hosts are alive
```bash
nmap -sn 192.168.56.0/24
```
`-sn` = host discovery only, no port scan. *Expected:* hosts `.1` (my host PC), `.10` (Kali) and `.20` (Metasploitable2) reported up. Alternative: `for i in 10 20; do ping -c 1 -W 1 192.168.56.$i; done`.

### 2.2 Banner grabbing — what services announce about themselves
```bash
nc -nv 192.168.56.20 21        # FTP greeting; type QUIT to exit
nc -nv 192.168.56.20 22        # SSH version string
curl -I http://192.168.56.20   # HTTP response headers (Server:, X-Powered-By:)
nmap -sV --script banner -p 21,22,23,25,80 192.168.56.20
```
Observation to record: product and version strings. A banner can be changed or hidden, so it is a clue and not proof.

## 3. Evidence
* `T2-01-recon-passive.png` (whois + nslookup output; plus Shodan/dork screenshots with identifiers redacted)
* `T2-02-recon-active.png` (ping sweep + banner grabs)
