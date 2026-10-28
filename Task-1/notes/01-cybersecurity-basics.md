# Cybersecurity Basics

> Study notes for ApexPlanet Task 1. Concepts only — all hands-on work happens in my isolated lab ([README](../README.md#4-ethical-use-and-authorization)).

## 1. The CIA Triad

| Property | Meaning | Everyday example | Typical controls |
|----------|---------|------------------|------------------|
| **Confidentiality** | Only authorized people can read the data | Your bank statement is visible only to you and the bank | Encryption, access control, MFA |
| **Integrity** | Data is accurate and has not been altered without authorization | A transfer of ₹500 cannot silently become ₹5000 | Hashing, digital signatures, checksums, change logging |
| **Availability** | Systems and data are usable when needed | A website loads during a sale | Redundancy, backups, DDoS protection, patching |

A useful habit: for every incident, ask *"which of C, I, A was harmed?"* Many attacks harm more than one.

## 2. Key vocabulary

* **Asset** – something worth protecting (data, server, reputation).
* **Threat** – something that could cause harm (a ransomware gang, a careless insider, a flood).
* **Vulnerability** – a weakness (unpatched software, weak password, bad configuration).
* **Risk** – likelihood × impact of a threat exploiting a vulnerability.
* **Attack vector** – the path used to reach the target (email attachment, open port, USB drive).
* **Exploit** – technique or code that takes advantage of a vulnerability.
* **Defence in depth** – multiple overlapping controls so one failure is not fatal.
* **Least privilege** – give each user/process only the access it needs.

## 3. Threat overview

| Threat | Example | Impact | Prevention | CIA property |
|--------|---------|--------|------------|--------------|
| **Phishing** | Fake "account suspended" email linking to a look-alike login page | Stolen credentials, account takeover, fraud | Check sender/URL, MFA, mail filtering, user training | Confidentiality (also Integrity) |
| **Malware** | Trojan hidden in a cracked-software installer | Data theft, system damage, backdoors | Patching, antivirus/EDR, install only trusted software, least privilege | Confidentiality, Integrity, Availability |
| **DDoS** | Botnet floods a site with traffic until it stops responding | Downtime, lost revenue | CDN/scrubbing, rate limiting, autoscaling, upstream filtering | Availability |
| **SQL injection** | Login form passes user input directly into a database query | Data leak, data modification, auth bypass | Parameterized queries, input validation, least-privilege DB accounts, WAF | Confidentiality, Integrity |
| **Brute force** | Automated guessing of passwords against a login page | Account compromise | Strong/unique passwords, lockout/rate limits, MFA | Confidentiality |
| **Ransomware** | Malware encrypts files and demands payment | Operations halted, data loss or leak | Offline backups, patching, email filtering, network segmentation | Availability (also Confidentiality via leaks) |
| **Social engineering** | Caller pretends to be IT support and asks for a password | Credential or data disclosure, unauthorized access | Verification procedures, awareness training, no sharing of secrets | Confidentiality, Integrity |
| **Wireless attacks** | "Evil twin" Wi-Fi hotspot imitating a café network | Traffic interception, credential theft | WPA2/WPA3, VPN on public Wi-Fi, verify network names, disable auto-join | Confidentiality, Integrity |
| **Insider threat** | Employee copies customer data before leaving, or clicks carelessly | Data breach, sabotage, fraud | Least privilege, logging/monitoring, offboarding process, separation of duties | Confidentiality, Integrity, Availability |

## 4. Threat notes in plain language

**Phishing.** Deceptive messages that trick someone into revealing credentials or running something. Variants: spear phishing (targeted), smishing (SMS), vishing (voice). *Defence:* hover before clicking, verify out-of-band, use MFA so a stolen password alone is not enough.

**Malware.** Umbrella term: viruses, worms, trojans, spyware, rootkits, ransomware. Spreads via attachments, downloads, removable media, vulnerable services. *Defence:* keep systems patched, restrict admin rights, use reputable endpoint protection.

**DDoS.** Overwhelms bandwidth, connection tables or application resources. Volumetric, protocol (e.g. SYN flood) and application-layer (HTTP flood) categories exist. *Defence:* upstream mitigation providers, rate limits, capacity planning. (I will **not** generate attack traffic in this lab.)

**SQL injection.** Happens when untrusted input becomes part of a query's *structure*. The conceptual difference:

```python
# VULNERABLE (concept): user input is concatenated into the query text
query = "SELECT * FROM users WHERE name = '" + user_input + "'"

# SAFER: parameterized query - input is always treated as data, never as SQL
cursor.execute("SELECT * FROM users WHERE name = %s", (user_input,))
```

DVWA lets me *study* this class of bug safely in my own lab in a later task; Task 1 only covers the concept.

**Brute force.** Trying many credentials. Related: credential stuffing (reusing leaked passwords). *Defence:* rate limiting, lockout with care, MFA, breached-password checks.

**Ransomware.** Encrypts data and demands payment; modern variants also steal data first ("double extortion"). *Defence:* tested offline/immutable backups are the single most effective recovery control, plus patching and phishing resistance.

**Social engineering.** Exploits human trust, urgency, authority or curiosity rather than software flaws. *Defence:* policy ("we never ask for passwords by phone"), verification steps, a reporting culture without blame.

**Wireless attacks.** Rogue access points, evil twins, deauthentication abuse, weak/old encryption (WEP, WPA with weak passphrases). *Defence:* WPA3/WPA2-AES with strong passphrase, VPN, certificate warnings taken seriously.

**Insider threats.** Malicious (intentional) or negligent (accidental). *Defence:* least privilege, activity logging, separation of duties, prompt access removal when roles change.

## 5. Defensive concepts

| Concept | One-line explanation |
|---------|----------------------|
| Defence in depth | Layer controls (network, host, application, people) |
| Least privilege | Minimum access needed, nothing more |
| Patch management | Fix known vulnerabilities promptly |
| Segmentation | Split networks so a breach cannot spread freely (this lab's Host-Only network is a small example) |
| MFA | Something you know + have/are |
| Backups (3-2-1) | 3 copies, 2 media types, 1 offsite/offline |
| Logging & monitoring | You cannot respond to what you cannot see |
| Security awareness | People are part of the system |

## 6. Attack lifecycle (simplified)

1. **Reconnaissance** – learn about the target.
2. **Initial access** – phishing, exposed service, stolen credentials.
3. **Execution & persistence** – run code, stay in.
4. **Privilege escalation & lateral movement** – widen access.
5. **Actions on objectives** – steal, encrypt, disrupt.

Ethical hacking mirrors steps 1–4 **with written authorization**, then reports fixes. Without authorization the same actions are illegal.

## 7. Self-check questions

1. Which CIA property does ransomware primarily attack? Why might it affect a second one?
2. Why is hashing a password different from encrypting it? (See [cryptography notes](../cryptography/cryptography-fundamentals.md).)
3. Name two controls that would reduce the impact of a successful phishing email.
4. Why does the lab keep Metasploitable2 off NAT/Bridged networks?
