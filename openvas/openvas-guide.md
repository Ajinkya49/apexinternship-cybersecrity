# Step 3 — Vulnerability Scanning with OpenVAS (Greenbone)

OpenVAS is the scanner inside the **Greenbone Vulnerability Management (GVM)** community edition. (Nessus Essentials is the permitted alternative; the workflow is similar.) Target: Metasploitable2 `192.168.56.20` only.

## 1. Prerequisites
* Kali with **≥ 4 GB RAM** (8 GB is more comfortable), ≥ 20 GB free disk, 2 vCPUs.
* NAT adapter **connected** for install and feed sync; **disconnected** before scanning.
* Snapshot of Kali and Metasploitable2.

## 2. Install and set up (USER ACTION REQUIRED, needs internet)
```bash
sudo apt update
sudo apt install gvm -y
sudo gvm-setup            # long: downloads vulnerability feeds, creates the admin user
sudo gvm-check-setup      # should end with "It seems like your GVM-xx installation is OK."
```
`gvm-setup` prints the generated **admin password** — save it somewhere private (do not commit it). To reset it later:
```bash
sudo runuser -u _gvm -- gvmd --user=admin --new-password='NEW-PASSWORD'
```
Start and stop:
```bash
sudo gvm-start            # starts services, opens the web UI URL
sudo gvm-stop
```
Update feeds when online: `sudo gvm-feed-update`.

If the install is too heavy for the PC, use Nessus Essentials (free, tenable.com) and document that choice; the report template works for either.

## 3. Run the scan (lab only)
1. Disconnect NAT. Confirm `ping -c 2 192.168.56.20` works.
2. Browse to `https://127.0.0.1:9392` (accept the self-signed certificate warning), log in as `admin`.
3. **Configuration → Targets → New Target:** name `Metasploitable2-lab`, hosts `192.168.56.20`, port list *All IANA assigned TCP* (or *All TCP and Nmap top 100 UDP*).
4. **Scans → Tasks → New Task:** name `Task2-Metasploitable2`, target above, scan config **Full and fast**.
5. Start the task and wait (can take 30 min to a few hours). Take a snapshot-safe approach: if Metasploitable2 hangs, restore the snapshot and rerun.
6. **Scans → Reports:** open the finished report; review **Results**, **Hosts**, **Ports**, **CVEs**.
7. Download the report as **PDF** (and optionally XML/CSV) into `Task-2/openvas/`.

📸 Evidence: `T2-06-openvas-dashboard.png` (task finished), `T2-07-openvas-results.png` (results list with severities), plus the exported PDF.

## 4. Reading severities
| Class | CVSS score | Meaning |
|-------|-----------|---------|
| Critical | 9.0 – 10.0 | Severe; usually remote and easy to exploit (CVSS v3 label) |
| High | 7.0 – 8.9 | Serious. *Greenbone's own "High" band is 7.0–10.0, so Critical findings appear as High in the UI* |
| Medium | 4.0 – 6.9 | Moderate; may need conditions |
| Low | 0.1 – 3.9 | Minor |
| Log / Info | 0.0 | Informational |

When classifying for the task, state which scale I used, e.g. "I split Greenbone's High findings into Critical (≥ 9.0) and High (7.0–8.9) using the CVSS v3 qualitative scale."

Useful fields: **Severity**, **QoD** (Quality of Detection — how reliable the detection is; low QoD may be a false positive), **CVE IDs**, **Solution** (vendor fix, mitigation or workaround).

Optional: tabulate the CSV export (only counts what is in my file):
```bash
python3 scripts/parse-openvas-csv.py openvas/report.csv 10
```

## 5. Analysis workflow
1. Count findings per severity.
2. Pick the top 5 by severity, then QoD, and for each write: affected service/port, what the check detected (own words), CVE/CVSS, risk if real, remediation.
3. Group by cause: outdated software, default/weak credentials, clear-text protocols, misconfiguration.
4. Note possible false positives and say what would be needed to confirm them *in an authorized setting*.
5. Finish with prioritized remediation.

## 6. Safety notes
* A vulnerability scanner sends many probes, and some checks can crash fragile services. Lab only, snapshot first.
* "Reported by the scanner" ≠ "proven exploitable". Task 2 does not exploit anything.
* Do not scan anything except `192.168.56.20` (and Kali itself if needed).

Fill [reports/OpenVAS-Vulnerability-Report.md](../reports/OpenVAS-Vulnerability-Report.md).
