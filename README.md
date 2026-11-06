# Task 3 — Web Application Security

**Internship:** ApexPlanet Software Pvt. Ltd. — Cybersecurity & Ethical Hacking
**Timeline:** Days 25–36 | **Author:** Ajinkya
**Target:** DVWA on my own lab (Metasploitable2 `192.168.56.20/dvwa/`, or a standalone DVWA on `127.0.0.1`), from Kali `192.168.56.10`

## 1. Objective
Identify and exploit OWASP Top 10 vulnerability classes in a controlled lab, then demonstrate the matching fix for each: SQL injection, stored/reflected XSS, CSRF, local/remote file inclusion, advanced Burp Suite usage, and web security headers.

## 2. Ethical use and authorization
> **All testing is restricted to DVWA running on a system I own.**

* DVWA is **designed to be vulnerable**; I do not run it anywhere reachable from a real network, and I never practice these techniques against any other website, app or API — including ones I don't own, even "just to see."
* DVWA's Security Level controls how exploitable it is (Low/Medium/High/Impossible). I set it explicitly for each exercise and record it in the report, because the same request behaves differently at each level.
* I don't actually exfiltrate, publish or reuse the sample data DVWA exposes (it's synthetic test data, but I treat it the way I'd treat real data in practice).
* RFI (Remote File Inclusion) is demonstrated by hosting my **own** harmless include file on the **same isolated Host-Only network** — never a real external URL.
* "Exploit" here means demonstrate-and-screenshot in a classroom sense; this is not a penetration test and no finding here implies anything about a real production system.

## 3. Repository map
```text
Task-3/
├── README.md
├── sqli/sqli-guide.md                 Step 1  SQLi exploitation + prepared-statement fix
├── xss/xss-guide.md                   Step 2  Stored + reflected XSS, CSP/validation mitigation
├── csrf/csrf-guide.md                 Step 3  CSRF password-change attack + token mitigation
├── file-inclusion/lfi-rfi-guide.md    Step 4  LFI (read files) + RFI (own lab file only)
├── burp-advanced/burp-advanced-guide.md Step 5 Intercept/modify login, Intruder fuzzing
├── security-headers/headers-guide.md  Step 6  securityheaders.com + Apache header config
├── scripts/                           csrf-poc-server.py, rfi-payload-server.py, apply-headers.sh, validate-repo.sh
├── reports/
│   ├── Security-Testing-Report.md     fill from MY real exploitation + fixes
│   ├── requirements-matrix.md
│   └── submission-checklist.md
├── evidence/EVIDENCE-CHECKLIST.md
└── video/video-script.md              8-minute script
```

## 4. DVWA setup note
```text
http://192.168.56.20/dvwa/   (if using Metasploitable2's bundled copy)
or http://127.0.0.1/dvwa/    (if installed standalone on Kali)
Login: admin / password (training default)
DVWA Security: set per exercise (noted in each guide)
```
If "DVWA Security" isn't visible, go to Setup/Reset DB first.

## 5. Expected vs actual
"Expected" blocks are teaching shapes — not my results. My actual results are only what's captured in `evidence/` and `evidence/terminal-output/`, and what I fill into `reports/Security-Testing-Report.md`. I do not paste example payloads into the report as if they were my output.

## 6. Order of work
| Days | Step | Guide |
|------|------|-------|
| 25–27 | SQL Injection | [sqli](sqli/sqli-guide.md) |
| 27–29 | XSS | [xss](xss/xss-guide.md) |
| 29–30 | CSRF | [csrf](csrf/csrf-guide.md) |
| 30–31 | File Inclusion | [file-inclusion](file-inclusion/lfi-rfi-guide.md) |
| 31–33 | Burp Suite Advanced | [burp-advanced](burp-advanced/burp-advanced-guide.md) |
| 33–34 | Security Headers | [security-headers](security-headers/headers-guide.md) |
| 35–36 | Report, evidence, video | [reports](reports/Security-Testing-Report.md), [video](video/video-script.md) |
