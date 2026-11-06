# Task 3 Evidence Checklist
**Never fabricate evidence.** No screenshots exist in this folder yet — every item is USER ACTION REQUIRED.

| ☐ | File | Capture | Guide |
|---|------|---------|-------|
| ☐ | `T3-01-sqli-extract.png` | SQLi payload + extracted data (Low) | [sqli](../sqli/sqli-guide.md) |
| ☐ | `T3-02-sqli-prevention.png` | Same payload failing at High / prepared-statement source | [sqli](../sqli/sqli-guide.md) |
| ☐ | `T3-03-xss-stored.png` | Stored XSS firing on page reload | [xss](../xss/xss-guide.md) |
| ☐ | `T3-04-xss-reflected.png` | Reflected XSS via URL parameter | [xss](../xss/xss-guide.md) |
| ☐ | `T3-05-xss-mitigation.png` | High-security encoding, or CSP blocking in console | [xss](../xss/xss-guide.md) |
| ☐ | `T3-06-csrf-attack.png` | PoC page auto-submitting, password changed | [csrf](../csrf/csrf-guide.md) |
| ☐ | `T3-07-csrf-token-protection.png` | High source with token field; PoC failing | [csrf](../csrf/csrf-guide.md) |
| ☐ | `T3-08-lfi.png` | `/etc/passwd` read via LFI | [file-inclusion](../file-inclusion/lfi-rfi-guide.md) |
| ☐ | `T3-09-rfi.png` | Own lab file included, or `allow_url_include=Off` result | [file-inclusion](../file-inclusion/lfi-rfi-guide.md) |
| ☐ | `T3-10-fi-mitigation.png` | High-security file-inclusion behavior | [file-inclusion](../file-inclusion/lfi-rfi-guide.md) |
| ☐ | `T3-11-burp-intercept-modify.png` | Intercepted/edited request + Repeater | [burp-advanced](../burp-advanced/burp-advanced-guide.md) |
| ☐ | `T3-12-burp-intruder.png` | Intruder results grid | [burp-advanced](../burp-advanced/burp-advanced-guide.md) |
| ☐ | `T3-13-securityheaders-before.png` | Baseline scan/curl | [security-headers](../security-headers/headers-guide.md) |
| ☐ | `T3-14-securityheaders-after.png` | Headers added, re-checked | [security-headers](../security-headers/headers-guide.md) |

## Placeholder policy
If I can't capture something, I leave the file absent and mark it "not done" in [requirements-matrix.md](../reports/requirements-matrix.md) — no edited/downloaded/generated images.
