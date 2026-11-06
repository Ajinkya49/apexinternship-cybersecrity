# Security Testing Report — Task 3 (Web Application Security)

**Author:** Ajinkya **Date:** `____`
**Target:** DVWA on my own lab (`____` — e.g. `192.168.56.20/dvwa/`). **Authorization:** own lab only, never a real site.

> Fill every `____` from my real exploitation and fixes. Payloads shown in the guides are teaching examples — report what I actually typed and what actually happened.

## 1. Scope and method
| Item | Value |
|------|-------|
| DVWA version | `____` |
| Security levels tested | Low ☐ Medium ☐ High ☐ |
| Browser / Burp version | `____` |
| Dates | `____` |

## 2. SQL Injection
**Payload used:** `____`
**Result (Low):** `____`
**Data extracted (describe, don't paste raw credentials verbatim if sensitive even in a lab):** `____`
**Behavior at High / why it's blocked:** `____`
**Fix demonstrated:** prepared statements — `____` (what I observed in DVWA's high-security source)
Evidence: `T3-01`, `T3-02`

## 3. Cross-Site Scripting (XSS)
### Stored
Payload: `____` Result: `____`
### Reflected
URL/payload: `____` Result: `____`
### Mitigation observed
`____` (encoding at High, and/or CSP blocking the payload)
Evidence: `T3-03`–`T3-05`

## 4. CSRF
Request forged: `____`
**Result (Low):** password changed without my explicit action: `____`
**Result (High):** blocked because `____` (token mismatch)
Evidence: `T3-06`, `T3-07`

## 5. File Inclusion
**LFI payload:** `____` **File read:** `____`
**RFI attempt:** `____` **Result:** `____` (succeeded against my own lab-hosted file / blocked by `allow_url_include=Off` — state which, honestly)
**High-security behavior:** `____`
Evidence: `T3-08`–`T3-10`

## 6. Burp Suite Advanced
**Intercept/modify:** what I changed and the result: `____`
**Intruder fuzzing:** payload list used, attack duration, standout result (if any): `____`
**High-security behavior:** `____`
Evidence: `T3-11`, `T3-12`

## 7. Security Headers
**Target scanned:** `____` (public site, or local `curl -I` baseline — state which)
**Before:** `____` **Headers added:** `____` **After:** `____`
Evidence: `T3-13`, `T3-14`

## 8. Summary table
| Vulnerability | Exploited? | Severity (my assessment) | Root cause | Fix demonstrated |
|---------------|-----------|---------------------------|------------|-------------------|
| SQL Injection | `____` | `____` | Untrusted input concatenated into SQL | Prepared statements |
| XSS (Stored) | `____` | `____` | Output not encoded | Output encoding / CSP |
| XSS (Reflected) | `____` | `____` | Output not encoded | Output encoding / CSP |
| CSRF | `____` | `____` | No unpredictable per-request token | Anti-CSRF token |
| LFI | `____` | `____` | Unvalidated file path from user input | Allow-list paths |
| RFI | `____` | `____` | Unvalidated remote URL inclusion | `allow_url_include=Off` + allow-list |
| Missing security headers | `____` | `____` | No CSP/X-Frame-Options/etc. | Added headers |

## 9. Reflection
What I learned: `____` What I'd improve: `____`

## 10. Ethical-use declaration
All exploitation was performed only against DVWA running on a system I own, inside my isolated lab. No real website, app or third party was targeted. Signed: `____`
