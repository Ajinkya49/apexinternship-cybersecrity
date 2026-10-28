# Step 5 — Firewall Basics with iptables

A firewall filters packets by rules (source/destination, protocol, port, connection state). `iptables` configures the Linux kernel's packet filter (Kali's `iptables` uses the nftables backend; the commands are the same).

## 1. Concepts
| Term | Meaning |
|------|---------|
| Table | `filter` (default; allow/deny), `nat`, `mangle` |
| Chain | `INPUT` (to this host), `OUTPUT` (from this host), `FORWARD` (through it) |
| Rule | Match + target, evaluated top to bottom; first match wins |
| Targets | `ACCEPT` allow, `DROP` silently discard, `REJECT` discard and reply with an error |
| Policy | Default action when no rule matches |
| Stateful | `-m conntrack --ctstate ESTABLISHED,RELATED` lets replies to my own connections through |

**DROP vs REJECT (what a scanner sees):** DROP → no reply → Nmap reports the port **filtered** (slow, timeouts). REJECT → immediate error → port looks **closed**.

## 2. Plan for the demo
* Firewall runs on **Kali** (`192.168.56.10`), only for the Host-Only interface `eth1`.
* A test service listens on port 8080.
* The "attacker/scanner" is a **different machine of mine**: my host PC with Nmap installed (scanning only `192.168.56.10`), or Metasploitable2/another VM if it has Nmap.
  Scanning Kali from Kali itself uses loopback and would bypass these `eth1` rules, so it is not a valid test.
* Everything is in a dedicated chain `LABDEMO`, so cleanup is one command and my update/NAT traffic is never touched.

## 3. Steps (USER ACTION REQUIRED)
**3.1 Baseline.** On Kali:
```bash
sudo iptables -L -n -v                                  # existing rules (record them)
python3 -m http.server 8080 --bind 192.168.56.10 &      # test service
```
From the scanner machine:
```bash
nmap -sS -p 8080,9999 192.168.56.10
```
*Expected:* 8080 `open`, 9999 `closed`. 📸 `T2-11-iptables-baseline.png`

**3.2 Deny a specific port.**
```bash
cd Task-2/scripts
sudo ./iptables-demo.sh block-port 8080
sudo iptables -L LABDEMO -n -v --line-numbers
```
Rescan from the scanner machine: `nmap -sS -p 8080,9999 192.168.56.10`
*Expected:* 8080 now `filtered`. 📸 `T2-12-iptables-blocked.png`

**3.3 Allow a specific port (explicit allow, shown manually).** Example of the allow syntax (do not leave it active):
```bash
sudo iptables -I LABDEMO 1 -p tcp --dport 22 -j ACCEPT   # allow SSH on eth1
sudo iptables -D LABDEMO -p tcp --dport 22 -j ACCEPT     # remove it again
```

**3.4 Block a port-scan attempt.**
```bash
sudo ./iptables-demo.sh scan-defense
```
From the scanner machine run a fast scan: `nmap -sS -p 1-200 192.168.56.10`
*Expected:* after about 15 SYNs within 10 s the rest of the ports are not answered, so results show many `filtered` ports (and the scan may take longer or be incomplete).
On Kali:
```bash
sudo ./iptables-demo.sh status
sudo journalctl -k | grep LAB-PORTSCAN | head
```
*Expected:* kernel log lines starting with `LAB-PORTSCAN:` that include the scanner's source IP. 📸 `T2-13-iptables-scan-blocked.png`

**3.5 Clean up.**
```bash
kill %1 2>/dev/null           # stop the python test server
sudo ./iptables-demo.sh cleanup
sudo iptables -L -n -v        # back to the original rules
```
The `firewall/iptables-before-*.rules` files are backups made by the script (`iptables-save` format); restore with `sudo iptables-restore < file` if ever needed.

## 4. How the scan-defense rule works
| Rule | Effect |
|------|--------|
| `... -m recent --name labscan --set` | Record the source IP of every new SYN |
| `... --update --seconds 10 --hitcount 15 -j LOG` | If this source has sent ≥ 15 SYNs in 10 s, write a kernel log line |
| `... --update --seconds 10 --hitcount 15 -j DROP` | …and drop that SYN |

Limits to mention in the report: it is rate-based, so slow scans (`-T1`) evade it; it also affects legitimate bursts; production setups use IDS/IPS (Snort/Suricata, fail2ban), geo/IP reputation and upstream filtering.

## 5. Good firewall habits (for the write-up)
* Default-deny inbound, allow only what is needed; allow `ESTABLISHED,RELATED`.
* Log before dropping when you need visibility.
* Keep rules in version control and test before applying remotely (avoid locking yourself out).
* Persist rules deliberately (`iptables-persistent`/`nftables`) — this demo intentionally does **not** persist anything.

## 6. If the `recent` module is unavailable
Error such as `Couldn't load match 'recent'`: run `sudo modprobe xt_recent`. If it still fails, use only the port-block demo (3.2) and state that in the report.

Evidence: `T2-11` to `T2-13`.
