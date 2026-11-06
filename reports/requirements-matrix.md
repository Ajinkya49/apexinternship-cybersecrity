# Task 3 Requirements Matrix
✅ = written here. ⏳ = USER ACTION REQUIRED (no evidence exists yet). ➖ = n/a.

| # | Requirement | Documented in | Evidence | Docs | Evidence |
|---|-------------|----------------|----------|------|----------|
| 1.1 | Install DVWA in Kali | [Task 1 §6](../../Task-1/lab-setup/lab-setup-guide.md#step-6--dvwa) | `11-dvwa.png` (Task 1) | ✅ | ⏳ |
| 1.2 | SQLi to extract usernames/passwords | [sqli guide](../sqli/sqli-guide.md) | `T3-01` | ✅ | ⏳ |
| 1.3 | Prevention via prepared statements | [sqli guide §6](../sqli/sqli-guide.md#6-mitigation-prepared-statements) | `T3-02` | ✅ | ⏳ |
| 2.1 | Stored XSS | [xss guide §1](../xss/xss-guide.md#1-stored-xss) | `T3-03` | ✅ | ⏳ |
| 2.2 | Reflected XSS via query params | [xss guide §2](../xss/xss-guide.md#2-reflected-xss) | `T3-04` | ✅ | ⏳ |
| 2.3 | Mitigation: input validation + CSP | [xss guide §4](../xss/xss-guide.md#4-mitigation) | `T3-05` | ✅ | ⏳ |
| 3.1 | CSRF attack changing a user's password | [csrf guide](../csrf/csrf-guide.md), `scripts/csrf-poc-server.py` | `T3-06` | ✅ | ⏳ |
| 3.2 | Token-based protection | [csrf guide §3](../csrf/csrf-guide.md#3-repeat-at-mediumhigh--token-based-protection) | `T3-07` | ✅ | ⏳ |
| 4.1 | LFI — read sensitive files | [lfi-rfi guide §1](../file-inclusion/lfi-rfi-guide.md#1-local-file-inclusion-lfi--read-sensitive-files) | `T3-08` | ✅ | ⏳ |
| 4.2 | RFI — execute code | [lfi-rfi guide §2](../file-inclusion/lfi-rfi-guide.md#2-remote-file-inclusion-rfi--include-and-execute-code-from-a-url), `scripts/rfi-payload-server.py` | `T3-09` | ✅ | ⏳ |
| 5.1 | Intercept and modify login requests | [burp-advanced §1](../burp-advanced/burp-advanced-guide.md#1-intercept-and-modify-a-login-request) | `T3-11` | ✅ | ⏳ |
| 5.2 | Fuzzing with Intruder | [burp-advanced §2](../burp-advanced/burp-advanced-guide.md#2-fuzzing-with-intruder-community-edition--rate-limited-but-functional-for-a-demo) | `T3-12` | ✅ | ⏳ |
| 6.1 | securityheaders.com analysis | [headers guide §1](../security-headers/headers-guide.md#1-analyze-with-securityheaderscom) | `T3-13` | ✅ | ⏳ |
| 6.2 | Proper HTTP headers in Apache config | [headers guide §3](../security-headers/headers-guide.md#3-add-headers-in-apache-config-lab-server), `scripts/apply-headers.sh` | `T3-14` | ✅ | ⏳ |
| D1 | Security Testing Report (SQLi/XSS/CSRF + screenshots) | [Security-Testing-Report.md](Security-Testing-Report.md) | filled report | ✅ template | ⏳ |
| D2 | GitHub repo with attack scenarios + mitigation notes | this repository | push | ✅ | ⏳ |
| D3 | 8-min video demo of exploitation + fix | [video-script.md](../video/video-script.md) | recorded video + link | ✅ script | ⏳ |
| — | Ethical-use statement | [README §2](../README.md#2-ethical-use-and-authorization) | — | ✅ | ➖ |

## What has been verified
| Item | Status |
|------|--------|
| File presence, fences, links, script/HTML syntax | `scripts/validate-repo.sh` |
| `csrf-poc-server.py`, `rfi-payload-server.py` | Compiled and smoke-tested serving files on loopback in a sandbox; test output deleted |
| `apply-headers.sh` | Syntax-checked only; not run against real Apache |
| All DVWA exploitation, Burp Intruder, header scans | **Not executed** — no DVWA/Apache/Burp available to the author of these docs. Must be run and verified on my Kali/DVWA |
