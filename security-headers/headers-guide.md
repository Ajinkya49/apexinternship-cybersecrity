# Step 6 — Web Security Headers

## 1. Analyze with securityheaders.com
securityheaders.com needs a **publicly reachable** URL, so it cannot scan my lab's private `192.168.56.x` address directly. Two honest options:

**Option A (recommended for this task):** scan a site I already own/control that's actually public (e.g. a GitHub Pages site or personal portfolio I'm allowed to test), and use that as the "before" baseline.

**Option B:** explain the headers locally instead — use `curl -I` against DVWA and compare field-by-field against what securityheaders.com checks for, documenting that the live scan step specifically needs a public target. Either is fine; be honest about which one you did.
```bash
curl -I http://192.168.56.20/dvwa/login.php
```

## 2. Headers securityheaders.com checks, and what each does
| Header | Purpose |
|--------|---------|
| `Strict-Transport-Security` (HSTS) | Forces browsers to use HTTPS for this site for a given time, preventing downgrade to plain HTTP |
| `Content-Security-Policy` | Restricts where scripts/styles/frames can load from — major XSS mitigation (see [XSS guide](../xss/xss-guide.md#4-mitigation)) |
| `X-Frame-Options` / `frame-ancestors` (CSP) | Prevents the page being embedded in a hidden `<iframe>` on another site (clickjacking) |
| `X-Content-Type-Options: nosniff` | Stops the browser guessing content types in a way that can turn data into executable script |
| `Referrer-Policy` | Controls how much of the URL is leaked to the next site when a user clicks a link |
| `Permissions-Policy` | Restricts browser features (camera, geolocation, etc.) the page can use |

## 3. Add headers in Apache config (lab server)
Enable the module and add headers in the DVWA vhost (adjust the vhost file path for your setup, e.g. `/etc/apache2/sites-available/000-default.conf` or DVWA's own vhost):
```apache
# inside the <VirtualHost> block
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "SAMEORIGIN"
Header always set Referrer-Policy "no-referrer-when-downgrade"
Header always set Content-Security-Policy "default-src 'self'"
# HSTS only makes sense once the site is actually served over HTTPS:
# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"
```
```bash
sudo a2enmod headers
sudo systemctl restart apache2
curl -I http://192.168.56.20/dvwa/login.php   # confirm the new headers appear
```
**Caution:** a strict CSP can break DVWA's own inline scripts (some DVWA pages rely on inline JS). If DVWA stops working, that's expected — note it in the report as "the strict policy breaks this intentionally-insecure app's own inline scripts, which illustrates why CSP has to be designed alongside the app, not bolted on blindly," then loosen it for the rest of the exercises (`script-src 'self' 'unsafe-inline'`) while noting the trade-off.

## 4. Evidence
`T3-13-securityheaders-before.png` (scan result or `curl -I` baseline — whichever you actually did), `T3-14-securityheaders-after.png` (headers added, re-scanned/re-curled).
