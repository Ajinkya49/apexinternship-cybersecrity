# Step 2 — Cross-Site Scripting (XSS)

**DVWA modules:** XSS (Stored), XSS (Reflected). **Security level:** Low.

XSS = injecting script that runs in **another user's browser** because the app reflects or stores untrusted input without encoding it. Only ever test against DVWA in my lab — never a real site.

## 1. Stored XSS
DVWA's **XSS (Stored)** page is a guestbook: name + message, saved and shown to every visitor.

1. In the Message box, enter: `<script>alert('Stored XSS - Ajinkya lab test')</script>`
2. Submit, then reload the page.
*Expected:* the alert fires **every time the page loads**, for any visitor — because the payload was saved to the database and is re-served as HTML, not as text.
3. A more realistic (still harmless, lab-only) payload to discuss: `<script>document.title='XSS-PoC'</script>` — shows impact without an intrusive popup.

## 2. Reflected XSS
DVWA's **XSS (Reflected)** page echoes a `name` query parameter straight back into the page.

```text
http://192.168.56.20/dvwa/vulnerabilities/xss_r/?name=<script>alert('Reflected XSS')</script>
```
*Expected:* the alert fires **only for that one request/URL** — it's not stored, so it would need to be sent to a victim (e.g. a crafted link) to affect them; I don't send it to anyone, I only demonstrate it against my own session.

## 3. What this shows about impact (describe, don't actually do, outside the lab)
In a real attack, instead of `alert()`, the script could read `document.cookie` (session hijacking) or submit a form on the victim's behalf. I do not demonstrate cookie theft against anything but my own local session, and I don't build a working exfiltration harness — the `alert()` proof is sufficient to show the vulnerability exists.

## 4. Mitigation
| Defense | What it does |
|---------|---------------|
| **Output encoding** | Encode user data for the context it's placed in (HTML-escape `<script>` → `&lt;script&gt;`) so it renders as text, not markup |
| **Input validation** | Reject/limit unexpected characters where the field has a known shape (not a substitute for output encoding) |
| **Content-Security-Policy (CSP)** | A response header that tells the browser which script sources are allowed, e.g. `Content-Security-Policy: default-src 'self'; script-src 'self'` blocks inline `<script>` payloads even if one slips through |
| **HttpOnly cookies** | `Set-Cookie: ...; HttpOnly` stops JavaScript (including injected XSS) from reading the cookie via `document.cookie` |

Re-test at **High** security: DVWA's high-security XSS source typically uses `htmlspecialchars()` style encoding — paste the same payload and show it now renders as literal text instead of executing.

### CSP demo (local)
Add to your test page or Apache config (see [security headers](../security-headers/headers-guide.md)):
```
Content-Security-Policy: default-src 'self'
```
Reload the stored-XSS guestbook entry with the header active (if you can add it in front of DVWA, e.g. via a local Apache vhost) and show the browser console blocking the inline script with a CSP violation message.

## 5. Evidence
`T3-03-xss-stored.png`, `T3-04-xss-reflected.png`, `T3-05-xss-mitigation.png` (High-security view or CSP console block).
