# Networking Fundamentals

Study notes for ApexPlanet Task 1. Practical exercises use only the isolated lab ([network design](../lab-setup/network-design.md)).

## 1. OSI model

| # | Layer | Job | Data unit | Examples | Lab observation |
|---|-------|-----|-----------|----------|-----------------|
| 7 | Application | Services used by apps | Data | HTTP, DNS, FTP, SSH, SMTP | Wireshark filter `http` |
| 6 | Presentation | Encoding, compression, encryption | Data | TLS, character sets, JPEG | TLS handshake (`tls`) |
| 5 | Session | Open/maintain/close sessions | Data | Sessions, RPC, NetBIOS | — |
| 4 | Transport | End-to-end delivery, ports | Segment / Datagram | TCP, UDP | `tcp.port == 80` |
| 3 | Network | Logical addressing, routing | Packet | IP, ICMP | `icmp`, `ip.addr == 192.168.56.20` |
| 2 | Data Link | Local delivery by MAC | Frame | Ethernet, ARP, Wi-Fi | `arp` |
| 1 | Physical | Bits on the medium | Bits | Cables, radio, NIC | virtual NIC in VirtualBox |

Mnemonic (top→bottom): **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing.

## 2. TCP/IP model and mapping

| TCP/IP layer | OSI layers | Key protocols |
|--------------|------------|---------------|
| Application | 5–7 | HTTP(S), DNS, SSH, FTP, SMTP, DHCP |
| Transport | 4 | TCP, UDP |
| Internet | 3 | IP, ICMP |
| Link | 1–2 | Ethernet, ARP, Wi-Fi |

**Encapsulation:** data → (+TCP header) segment → (+IP header) packet → (+Ethernet header) frame → bits. Wireshark's packet-details pane shows these layers stacked.

## 3. Common protocols and ports

| Protocol | Port / transport | Purpose | Secure? |
|----------|------------------|---------|---------|
| HTTP | 80/TCP | Web | No (cleartext) |
| HTTPS | 443/TCP | Web over TLS | Yes |
| FTP | 21/TCP | File transfer | No (cleartext credentials) |
| SSH | 22/TCP | Remote shell | Yes |
| Telnet | 23/TCP | Remote shell | No (cleartext) |
| SMTP | 25/TCP | Mail transfer | Depends (STARTTLS) |
| DNS | 53/UDP and TCP | Name resolution | No by default (DoT/DoH add privacy) |
| DHCP | 67–68/UDP | Address assignment | No |
| NTP | 123/UDP | Time sync | No |
| ICMP | (no ports) | Diagnostics (`ping`) | — |

Port ranges: well-known `0–1023`, registered `1024–49151`, dynamic/ephemeral `49152–65535` (Linux often uses `32768–60999`).

**TCP vs UDP:** TCP is connection-oriented (three-way handshake `SYN → SYN/ACK → ACK`, retransmission, ordering). UDP is connectionless and lightweight (DNS queries, streaming).

## 4. DNS resolution

Names exist because humans prefer them to IPs. Typical lookup for `www.example.com`:

1. Application asks the OS **stub resolver**; it checks `/etc/hosts` and its cache first.
2. If not found, it asks the configured **recursive resolver** (from DHCP or `/etc/resolv.conf`).
3. The recursive resolver (if uncached) queries a **root server** → told where `.com` servers are.
4. It queries a **TLD server** (`.com`) → told which authoritative servers hold `example.com`.
5. It queries the **authoritative server** → receives the A/AAAA record.
6. The answer is cached for its **TTL** and returned to the application.

| Record | Meaning |
|--------|---------|
| A | Name → IPv4 |
| AAAA | Name → IPv6 |
| CNAME | Alias to another name |
| MX | Mail servers |
| NS | Authoritative name servers |
| TXT | Free text (SPF, verification) |
| PTR | IP → name (reverse) |

**Lab-safe DNS practice** (no external queries): use `/etc/hosts` to define lab names.

```bash
echo "192.168.56.20 meta2.lab" | sudo tee -a /etc/hosts   # on Kali
getent hosts meta2.lab                                     # resolves via system config
ping -c 2 meta2.lab
```

To capture real DNS packets in Wireshark inside the lab, run a tiny lab-only resolver (e.g. `dnsmasq`) on Kali bound to the Host-Only interface and query it with `dig @192.168.56.10 meta2.lab` — optional, see [tool notes](../tools/tool-familiarization.md#1-wireshark). I do not query public DNS servers as part of testing.

## 5. HTTP vs HTTPS

| | HTTP | HTTPS |
|--|------|-------|
| Port | 80 | 443 |
| Encryption | None | TLS encrypts the content in transit |
| Identity | None | Server certificate validated by clients |
| Integrity | None | Tampering detected |
| Wireshark view | Request line, headers, body readable | Only TLS handshake metadata (and encrypted records) |

A basic HTTP request:

```text
GET /dvwa/login.php HTTP/1.1
Host: 192.168.56.20
User-Agent: Firefox
```

Common methods: `GET` (read), `POST` (submit), `PUT`, `DELETE`. Status codes: `200` OK, `301/302` redirect, `401` auth required, `403` forbidden, `404` not found, `500` server error.

> Why it matters: login credentials sent over HTTP are readable by anyone on the path. DVWA runs over plain HTTP in the lab, which makes it a convenient place to *see* this in Wireshark.

## 6. IPv4 addressing

* 32 bits written as four decimal octets: `192.168.56.10` = `11000000.10101000.00111000.00001010`.
* An address has a **network part** and a **host part**, divided by the **subnet mask** / **prefix length**.
* Special addresses: network address (all host bits 0), broadcast (all host bits 1), loopback `127.0.0.0/8`.

### Private (RFC 1918) vs public

| Range | CIDR | Addresses |
|-------|------|-----------|
| 10.0.0.0 – 10.255.255.255 | `10.0.0.0/8` | 16,777,216 |
| 172.16.0.0 – 172.31.255.255 | `172.16.0.0/12` | 1,048,576 |
| 192.168.0.0 – 192.168.255.255 | `192.168.0.0/16` | 65,536 |

Other notable ranges: loopback `127.0.0.0/8`; link-local `169.254.0.0/16` (self-assigned when DHCP fails). Everything else (outside reserved blocks) is public and routable.

### Classes (historical)

A: `1–126` (/8), B: `128–191` (/16), C: `192–223` (/24). Modern networks use **CIDR** (classless) instead.

## 7. Subnet masks and CIDR

| CIDR | Mask | Total addresses | Usable hosts |
|------|------|-----------------|--------------|
| /8 | 255.0.0.0 | 16,777,216 | 16,777,214 |
| /16 | 255.255.0.0 | 65,536 | 65,534 |
| /24 | 255.255.255.0 | 256 | 254 |
| /25 | 255.255.255.128 | 128 | 126 |
| /26 | 255.255.255.192 | 64 | 62 |
| /27 | 255.255.255.224 | 32 | 30 |
| /28 | 255.255.255.240 | 16 | 14 |
| /29 | 255.255.255.248 | 8 | 6 |
| /30 | 255.255.255.252 | 4 | 2 |

Usable hosts = 2^(32 − prefix) − 2 (minus network and broadcast addresses).

### Worked examples

**Example 1 — the lab network `192.168.56.0/24`**

* Mask `255.255.255.0`, network `192.168.56.0`, broadcast `192.168.56.255`
* Usable range `192.168.56.1 – 192.168.56.254` (254 hosts)

**Example 2 — which subnet does `192.168.10.77/27` belong to?**

* /27 → mask `255.255.255.224`, block size `256 − 224 = 32`
* Blocks in the last octet: 0, 32, 64, 96, … → 77 falls in the block starting at **64**
* Network `192.168.10.64`, broadcast `192.168.10.95`, usable `192.168.10.65 – 192.168.10.94` (30 hosts)

**Example 3 — split `192.168.56.0/24` into four equal subnets**

* Need 4 subnets → borrow 2 bits → **/26**, block size 64
* Subnets: `192.168.56.0/26` (hosts .1–.62), `.64/26` (.65–.126), `.128/26` (.129–.190), `.192/26` (.193–.254)

**Example 4 — point-to-point link:** a `/30` gives exactly 2 usable hosts.

Tip: you can *calculate* but also *verify*: `ipcalc 192.168.10.77/27` (install `ipcalc` if needed) or `python3 -c "import ipaddress as i; n=i.ip_network('192.168.10.77/27',strict=False); print(n, n.netmask, n.broadcast_address, n.num_addresses-2)"`.

## 8. Gateway, DNS, DHCP and NAT

* **Default gateway:** the router a host uses for destinations outside its subnet (`ip route` shows `default via …`).
* **DNS server:** the resolver used for name lookups.
* **DHCP:** automatically provides address, mask, gateway and DNS.
* **ARP:** maps an IPv4 address to a MAC address on the local network (`ip neigh`).

**NAT (Network Address Translation).** Lets many private hosts share one public address. A NAT/PAT device rewrites source address and port on the way out and keeps a translation table to rewrite replies on the way back.

```text
Private 192.168.1.20:51000  ->  [router/NAT]  ->  203.0.113.5:40001 -> server
Private 192.168.1.21:51000  ->  [router/NAT]  ->  203.0.113.5:40002 -> server
```

(`203.0.113.0/24` is a documentation range used here purely as an example.)

NAT is not a firewall by design, though it incidentally blocks unsolicited inbound connections.

**In this lab:** VirtualBox's NAT adapter gives Kali a private address (default `10.0.2.15`, gateway `10.0.2.2`) for updates. The Host-Only network has **no NAT at all**, which is part of what keeps Metasploitable2 isolated.

## 9. Lab exercises (safe)

```bash
ip -br addr && ip route                  # identify subnet and routes
ping -c 3 192.168.56.20                  # ICMP across the Host-Only network
ip neigh                                 # ARP entries after pinging
traceroute -n 192.168.56.20              # one hop expected on a flat network
ss -tuln                                 # my own listening ports
```

Capture the ping in Wireshark (interface `eth1`, filter `icmp`) and the ARP exchange (`arp`), then identify each OSI layer in the details pane. Evidence: [`05-wireshark.png`](../evidence/EVIDENCE-CHECKLIST.md).

## 10. Self-check

1. Which OSI layer does a switch normally operate at? (2) A router? (3)
2. What are the network and broadcast addresses of `10.1.2.130/25`? (Network `10.1.2.128`, broadcast `10.1.2.255`)
3. Why can `192.168.56.10` not be reached directly from the internet? (Private range, no NAT/route)
4. What changes in Wireshark when a site moves from HTTP to HTTPS?
