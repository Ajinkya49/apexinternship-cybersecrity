# Step 4 — Packet Analysis with Wireshark

Capture on **`eth1`** (Host-Only, lab traffic). NAT disconnected. Targets: `192.168.56.20` and `192.168.56.10` only. Start with `sudo wireshark &`.

> **Expected** observations describe what typically appears; they are not my results. My results are the screenshots/logs listed in the [evidence checklist](../evidence/EVIDENCE-CHECKLIST.md).

Tips: use a **capture filter** `host 192.168.56.20` to keep files small; save captures as `.pcapng` (git-ignored — review before sharing). Name captures `T2-<topic>.pcapng`.

## 4.1 HTTP traffic
1. Display filter: `http`
2. In Kali's browser open `http://192.168.56.20/dvwa/login.php`, log in with the DVWA training login.
3. Select a `GET`, then **Follow → HTTP Stream**; find the login `POST` (`http.request.method == "POST"`).

*Expected:* request line, headers and HTML readable in clear text; form fields visible in the POST body. Conclusion to write: plain HTTP exposes content and credentials to anyone on the path; HTTPS (TLS) would hide them.

## 4.2 DNS traffic (lab-only resolver)
Public DNS is not queried. Set up a tiny resolver on Kali (NAT connected only for the install):
```bash
sudo apt install dnsmasq -y
sudo tee /etc/dnsmasq.d/lab.conf >/dev/null <<'CONF'
interface=eth1
bind-interfaces
no-resolv
address=/meta2.lab/192.168.56.20
address=/kali.lab/192.168.56.10
CONF
sudo systemctl restart dnsmasq
```
Capture with filter `dns`, then query it:
```bash
dig @192.168.56.10 meta2.lab
dig @192.168.56.10 kali.lab
```
*Expected:* a Standard query / Standard query response pair over UDP/53 with an A record. Look at: transaction ID, query name, answer, TTL. Stop afterwards: `sudo systemctl stop dnsmasq`.

## 4.3 FTP traffic and clear-text credentials
FTP sends the username and password unencrypted. Using the **lab training account only**:
```bash
ftp 192.168.56.20
# Name: msfadmin   Password: msfadmin   then: ls, then: quit
```
Wireshark filters:
```text
ftp
ftp.request.command == "USER" || ftp.request.command == "PASS"
```
Right-click a packet → **Follow → TCP Stream**.

*Expected:* the `USER` and `PASS` commands and their arguments appear in clear text. Write up: how an attacker on the same network segment could read them, and the fix (SFTP/FTPS/SSH, never reuse passwords).
Scope: only my own lab account. Do **not** try anything else against the FTP service (no backdoor trigger strings, no password guessing).

## 4.4 SYN flood analysis (simulated with hping3)
**Safety rules:** target `192.168.56.20` only; short, capped burst; never `--flood`; never `--rand-source` or spoofed `-a`; NAT disconnected; snapshot taken.
```bash
sudo apt install hping3 -y            # NAT connected only for install
cd Task-2/scripts && sudo ./hping3-syn-demo.sh 192.168.56.20
# equivalent manual command (500 SYNs, about 100 per second):
# sudo hping3 -S -p 80 -c 500 -i u10000 192.168.56.20
```
Wireshark analysis:
| Tool | How | What to look for |
|------|-----|------------------|
| Filter | `tcp.flags.syn==1 && tcp.flags.ack==0 && ip.dst==192.168.56.20` | Many SYNs from one source in a short time |
| Statistics → Conversations → TCP | sort by Packets | One source with hundreds of short connections to port 80 |
| Statistics → I/O Graph | filter above | A sharp rate spike while the burst runs |
| Analyze → Expert Information | — | Warnings about connection resets / no handshake completion |

*Expected pattern:* SYN → SYN/ACK from the target → RST from Kali. Because Kali's kernel did not itself open those connections, it normally resets each SYN/ACK, so the target's half-open entries are cleared quickly. This simulation **shows the traffic pattern** of a SYN flood; it does not exhaust the server. A real flood keeps connections half-open (often with spoofed sources) so the backlog fills and legitimate users are refused.

Defences to describe: SYN cookies (`sysctl net.ipv4.tcp_syncookies`), larger backlog, rate limiting per source (see [iptables](../firewall/iptables-guide.md)), upstream DDoS mitigation/CDN, connection-state monitoring.

## 4.5 Evidence
`T2-08-wireshark-http-dns.png`, `T2-09-wireshark-ftp-credentials.png`, `T2-10-wireshark-syn-flood.png` (packet list/IO graph with filter visible).
