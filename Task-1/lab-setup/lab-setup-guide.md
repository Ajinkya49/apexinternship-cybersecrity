# Lab Setup Guide

Step-by-step build of the isolated lab. Every step that must be done by hand on my computer is marked **USER ACTION REQUIRED**. Nothing here is a claim that a step was completed — completion is shown only by the evidence files listed in [../evidence/EVIDENCE-CHECKLIST.md](../evidence/EVIDENCE-CHECKLIST.md).

Design reference: [network-design.md](network-design.md).

## Contents

* [Step 0 — Pre-flight](#step-0--pre-flight)
* [Step 1 — Install VirtualBox](#step-1--install-virtualbox)
* [Step 2 — Create the Host-Only network](#step-2--create-the-host-only-network)
* [Step 3 — Install Kali Linux](#step-3--install-kali-linux)
* [Step 4 — Import Metasploitable2](#step-4--import-metasploitable2)
* [Step 5 — Assign static IP addresses](#step-5--assign-static-ip-addresses)
* [Step 6 — DVWA](#step-6--dvwa)
* [Step 7 — Verify connectivity and isolation](#step-7--verify-connectivity-and-isolation)
* [Step 8 — Install and check the tools](#step-8--install-and-check-the-tools)
* [Step 9 — Snapshots](#step-9--snapshots)
* [VMware alternative](#vmware-alternative)

---

## Step 0 — Pre-flight

**USER ACTION REQUIRED**

1. Enable virtualization (Intel VT-x / AMD-V) in BIOS/UEFI if it is off.
2. Free about 60 GB of disk and close memory-heavy programs.
3. Download from **official sources only**, and compare the published checksum with your download:
   * VirtualBox installer — virtualbox.org
   * Kali Linux (pre-built VirtualBox image *or* installer ISO) — kali.org
   * Metasploitable2 — the official Rapid7 distribution

Verify a download checksum (Windows PowerShell shown; Linux/macOS use `sha256sum file`):

```powershell
Get-FileHash .\kali-linux-*.7z -Algorithm SHA256
```

Compare the result with the value published on the download page. If it differs, delete the file and download again.

## Step 1 — Install VirtualBox

**USER ACTION REQUIRED**

1. Run the VirtualBox installer with default options (accept the network driver prompt; it temporarily disconnects the network).
2. Optionally install the matching Extension Pack (not required for this task).
3. Open VirtualBox → **Help → About** and note the version: `____`.

📸 Evidence: `01-virtualbox.png` (VirtualBox Manager window; later it should show both VMs).

## Step 2 — Create the Host-Only network

**USER ACTION REQUIRED**

1. VirtualBox 7.x: **File → Tools → Network Manager** (6.x: **File → Host Network Manager**).
2. Open the **Host-only Networks** tab and **Create** one if none exists (commonly named `vboxnet0` or *VirtualBox Host-Only Ethernet Adapter*).
3. Set IPv4 address `192.168.56.1`, mask `255.255.255.0`.
4. DHCP server: either **disabled** (I use static addresses) or enabled with a range that does **not** include `.10` and `.20` (VirtualBox's default range starts at `.100`).

📸 Evidence: `03-host-only-network.png` (Network Manager showing the adapter and its address).

> Do **not** enable Windows "Internet Connection Sharing", bridge the Host-Only adapter, or add port-forwarding to the target. That would break isolation.

## Step 3 — Install Kali Linux

**USER ACTION REQUIRED**

*Option A (simplest): pre-built VirtualBox image* — extract, double-click the `.vbox` file (or **Machine → Add**), start the VM.

*Option B: ISO install* — **New** → Type *Linux*, Version *Debian (64-bit)*, ~4 GB RAM, 2 CPUs, 40 GB disk, attach the ISO, run the installer.

Then configure networking (VM powered **off**): **Settings → Network**

| Adapter | Attached to | Purpose |
|---------|-------------|---------|
| Adapter 1 | NAT | Updates / package installs only |
| Adapter 2 | Host-only Adapter (select the network from Step 2) | Lab traffic |

Start Kali and run, explaining to yourself what each does:

```bash
whoami          # which account am I?
hostname        # machine name
uname -a        # kernel and architecture
cat /etc/os-release   # distribution/version
```

Update while the NAT adapter is connected:

```bash
sudo apt update          # refresh package lists
sudo apt full-upgrade -y # upgrade installed packages
```

📸 Evidence: `02-kali.png` — Kali desktop with a terminal showing the commands above.

> Kali's default credentials depend on the image you used (pre-built images historically used `kali`/`kali`). Change the password on first use: `passwd`.

## Step 4 — Import Metasploitable2

**USER ACTION REQUIRED**

1. Extract the Metasploitable2 archive (contains a `.vmdk`).
2. VirtualBox → **New** → Type *Linux*, Version *Ubuntu (32-bit)*, 512 MB–1 GB RAM.
3. At the disk step choose **Use an existing virtual hard disk file** and select the `.vmdk`.
4. **Settings → Network**: Adapter 1 → **Host-only Adapter** (same network as Kali). Disable all other adapters. **Never NAT or Bridged.**
5. Start it. Login (documented default for this training VM): `msfadmin` / `msfadmin`.

Run:

```bash
ifconfig          # note the address (before static config)
uname -a
```

📸 Evidence: `10-metasploitable.png` (VM console showing login and `ifconfig`/`uname -a`).

## Step 5 — Assign static IP addresses

Plan: Kali `eth1` = `192.168.56.10/24`, Metasploitable2 `eth0` = `192.168.56.20/24`.

### Kali (NetworkManager)

**USER ACTION REQUIRED** — find the connection name for the Host-Only interface first:

```bash
ip -br addr                      # identify the interface (often eth1)
nmcli connection show            # list connection names (e.g. "Wired connection 2")
```

Then (replace the name with yours):

```bash
sudo nmcli connection modify "Wired connection 2" \
  ipv4.method manual ipv4.addresses 192.168.56.10/24
sudo nmcli connection up "Wired connection 2"
ip -br addr
```

No gateway or DNS is set on this interface on purpose: it is a lab-only network.

### Metasploitable2

**USER ACTION REQUIRED**

```bash
sudo nano /etc/network/interfaces
```

Set the `eth0` stanza to:

```text
auto eth0
iface eth0 inet static
address 192.168.56.20
netmask 255.255.255.0
```

Apply and confirm:

```bash
sudo /etc/init.d/networking restart
ifconfig eth0
route -n
```

If you prefer DHCP (Host-Only DHCP enabled), record the addresses you actually received and adjust all documents and scripts accordingly.

## Step 6 — DVWA

**Option A (recommended): use the copy on Metasploitable2.** It is available at `http://192.168.56.20/dvwa/` from Kali's browser.

**USER ACTION REQUIRED**

1. In Kali's Firefox open `http://192.168.56.20/dvwa/`.
2. Log in with the documented training default (`admin` / `password`).
3. If prompted, open *Setup / Reset DB* and create/reset the database.
4. Open *DVWA Security* and set the level to **Low** for learning (only in this isolated lab).

**Option B: separate DVWA instance** (own VM or local install). Only use packages from official/Kali repositories (check with `apt search dvwa`) and bind it to the Host-Only or loopback interface, never to a real network.

📸 Evidence: `11-dvwa.png` (DVWA page in Kali's browser with the `192.168.56.20` address visible).

## Step 7 — Verify connectivity and isolation

Run on **Kali**. Each command is explained first.

| Command | What it checks |
|---------|----------------|
| `ip -br addr` | Brief list of interfaces and addresses — is `eth1` `192.168.56.10/24`? |
| `ip route` | Routing table — which networks are directly connected |
| `ping -c 4 192.168.56.20` | ICMP echo to the target, 4 packets — basic reachability and latency |
| `traceroute -n 192.168.56.20` | Hops to the target (`-n` skips DNS lookups). Expect a single hop on a flat network |
| `ss -tuln` | Listening TCP/UDP sockets on Kali itself (`-t` TCP, `-u` UDP, `-l` listening, `-n` numeric) |

```bash
ip -br addr
ip route
ping -c 4 192.168.56.20
traceroute -n 192.168.56.20
ss -tuln
```

Or run the helper, which saves **real** output to `evidence/terminal-output/`:

```bash
cd Task-1/scripts
chmod +x lab-verify.sh
./lab-verify.sh 192.168.56.20
```

Isolation check on **Metasploitable2** — confirm it has *no route out* instead of pinging real internet hosts:

```bash
route -n      # expect only the 192.168.56.0 network, no 0.0.0.0 default gateway
```

📸 Evidence: `04-connectivity.png` (Kali), `14-isolation-check.png` (Metasploitable2 `route -n`).

## Step 8 — Install and check the tools

Run on Kali (NAT adapter connected for any installs):

```bash
wireshark --version | head -n 1
nmap --version | head -n 1
nc -h 2>&1 | head -n 2
openssl version
which burpsuite
```

If something is missing: `sudo apt install wireshark nmap netcat-traditional openssl` (Burp Suite Community is normally preinstalled on full Kali images; otherwise `sudo apt install burpsuite`).

Usage and lab-only exercises: [../tools/tool-familiarization.md](../tools/tool-familiarization.md).

## Step 9 — Snapshots

**USER ACTION REQUIRED** — After verification, power off each VM and take a snapshot (**Machine → Take Snapshot**), named e.g. `task1-clean-baseline`. If a later experiment breaks something, restore it. This is standard lab hygiene, especially for intentionally vulnerable machines.

## VMware alternative

VMware Workstation/Player works too. Use a **Host-only** (e.g. VMnet1) network instead of VirtualBox's Host-Only adapter and **disable DHCP sharing/NAT/bridging for the target**. VMware picks its own subnet (shown in the Virtual Network Editor), so replace `192.168.56.x` in every document and script with your actual subnet. Record the product and version in the report.
