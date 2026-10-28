# Lab Network Design

## 1. Goals

* Keep intentionally vulnerable machines **off** every real network.
* Give Kali two paths: an isolated lab path and a temporary update path.
* Make the lab reproducible with a fixed address plan.

## 2. Topology (text diagram)

```text
         Internet / home or college network
                      │
                      │   (only Kali's Adapter 1, NAT, and only while updating)
               ┌──────┴───────┐
               │  VirtualBox  │  NAT: Kali eth0 10.0.2.15 → gateway 10.0.2.2 (VirtualBox defaults)
               └──────┬───────┘
                      │
   Host PC ─ Host-Only Ethernet Adapter 192.168.56.1/24
                      │
    ══════════════════╪══════════════ Host-Only network 192.168.56.0/24 (isolated)
          │                           │
 ┌────────┴──────────┐        ┌───────┴────────────────┐
 │ Kali Linux        │        │ Metasploitable2        │
 │ eth1 192.168.56.10│        │ eth0 192.168.56.20     │
 │ Wireshark, Nmap,  │        │ Services incl. DVWA    │
 │ Burp, Netcat      │        │ NO NAT / NO Bridged    │
 └───────────────────┘        └────────────────────────┘
```

## 3. IP-addressing plan

| Item | Value |
|------|-------|
| Lab subnet | `192.168.56.0/24` (mask `255.255.255.0`) |
| Network address | `192.168.56.0` |
| Broadcast | `192.168.56.255` |
| Usable hosts | `192.168.56.1` – `192.168.56.254` (254 hosts) |
| Host PC (adapter) | `192.168.56.1` |
| Kali (static) | `192.168.56.10` |
| Metasploitable2 (static) | `192.168.56.20` |
| DHCP (if enabled) | VirtualBox default range begins at `.100` — does not collide with `.10`/`.20` |
| Default gateway on lab segment | none (not needed; hosts talk directly) |
| DNS inside lab | none required; use IPs or `/etc/hosts` names |

Addresses are *private* (RFC 1918 `192.168.0.0/16`) and are not routable on the internet.

## 4. Machine roles

| Machine | Role | Why |
|---------|------|-----|
| Host PC | Hypervisor, can reach VMs via `192.168.56.1` | Runs VirtualBox |
| Kali Linux | Attacker / analyst workstation | Pre-packaged security tools |
| Metasploitable2 | Vulnerable target | Safe place to practise scanning and observation |
| DVWA | Vulnerable web application (on Metasploitable2) | Practise web proxying and, later, web vulnerabilities |

## 5. Isolation rules (safe-lab boundaries)

1. Metasploitable2 has **only** a Host-Only adapter.
2. No bridged adapters on any lab VM.
3. No port-forwarding rules to the target.
4. No Internet Connection Sharing on the host's Host-Only adapter.
5. Kali's NAT adapter is for updates; **disconnect it** (VM Settings → Network → Adapter 1 → uncheck *Cable Connected*, which works while running) before running scans or traffic-generation exercises.
6. Scans, proxying and packet captures target only `127.0.0.1`, `192.168.56.10`, `192.168.56.20`.
7. Snapshots are taken before experiments.
8. Capture files (`.pcap/.pcapng`) are not committed without review.

## 6. Traffic flows used in Task 1

| Flow | From → To | Purpose |
|------|-----------|---------|
| ICMP echo | Kali → Metasploitable2 | Connectivity test, Wireshark ICMP capture |
| TCP connect | Kali → Metasploitable2:21/22/23/80 | Nmap service checks, Netcat banner/port tests |
| HTTP | Kali browser → Metasploitable2:80 (DVWA) | Wireshark HTTP capture, Burp proxying |
| Loopback | Kali ↔ Kali (`127.0.0.1`) | Netcat client/server, OpenSSL TLS demo, Burp listener on 8080 |

## 7. How isolation is verified

* `route -n` on Metasploitable2 shows no `0.0.0.0` default route.
* VM settings screenshot shows Adapter 1 = Host-only only.
* Kali `ip route` shows `192.168.56.0/24` on `eth1`.

Evidence mapping: [../evidence/EVIDENCE-CHECKLIST.md](../evidence/EVIDENCE-CHECKLIST.md).
