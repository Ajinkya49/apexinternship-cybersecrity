# Task 3 — 8-Minute Video Script

**Video link:** `PASTE-VIDEO-LINK-HERE`
**Goal:** demonstrate at least one exploitation **and its fix**, end to end, against my own DVWA.

## Before recording
1. DVWA at Low security, logged in; Burp proxy ready; CSRF PoC server and RFI server scripts tested beforehand (don't debug live).
2. Large terminal/browser zoom, no personal data visible.

## Timeline
| Time | Section | Show | Say | Evidence |
|------|---------|------|-----|----------|
| 0:00–0:30 | Intro | README | "I'm Ajinkya. This is ApexPlanet Task 3, Web Application Security, tested only against DVWA in my own isolated lab." | README |
| 0:30–1:45 | SQLi | Payload + extracted data, then High blocking it | "At Low security this UNION payload reads usernames and password hashes straight out of the users table. At High, DVWA uses a safer query path and the same payload fails." | `T3-01`, `T3-02` |
| 1:45–2:45 | XSS | Stored payload firing, then CSP/encoding blocking it | "This stored payload runs for every visitor because it's saved and re-served as HTML. Proper output encoding — or a Content-Security-Policy — stops it." | `T3-03`–`T3-05` |
| 2:45–3:45 | CSRF | PoC page auto-submitting, password changed; then token blocking it | "This page silently changes my DVWA password using only my existing session. A per-request anti-CSRF token defeats it, because the attacker's page can't predict that token." | `T3-06`, `T3-07` |
| 3:45–4:30 | File Inclusion | LFI reading /etc/passwd; RFI result | "LFI lets the app include an arbitrary local file. RFI tries to include code from a URL I control — real systems block this with allow_url_include off and an allow-list of valid pages." | `T3-08`, `T3-09` |
| 4:30–5:45 | Burp Advanced | Intercept/edit + Intruder grid | "Burp lets me edit any request before it's sent, and Intruder automates trying many values — here against the login form, showing why rate limiting and lockouts matter server-side." | `T3-11`, `T3-12` |
| 5:45–6:45 | Headers | Before/after headers | "Adding X-Frame-Options, nosniff and a Content-Security-Policy closes off several of these attack classes at the browser level." | `T3-13`, `T3-14` |
| 6:45–7:45 | Fix recap | Side-by-side vulnerable vs fixed | "To summarize: prepared statements for SQLi, output encoding and CSP for XSS, anti-CSRF tokens for CSRF, path allow-lists for file inclusion, and security headers across the board." | report §8 |
| 7:45–8:00 | Wrap-up | GitHub repo | "Full report, scripts and evidence are in my GitHub repo. Thanks for watching." | repo |

## After recording
- [ ] About 8 minutes, at least one full exploit-then-fix shown
- [ ] Only my own lab/DVWA visible
- [ ] Link recorded in the repo
