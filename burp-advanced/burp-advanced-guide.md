# Step 5 — Burp Suite Advanced

Builds on [Task 1's Burp basics](../../Task-1/tools/tool-familiarization.md#3-burp-suite-community-edition). Target: DVWA only, proxy on `127.0.0.1:8080`.

## 1. Intercept and modify a login request
1. Burp: **Proxy → Intercept on**. Firefox proxied through Burp (see Task 1 setup).
2. Go to DVWA login, submit any username/password.
3. In Burp's intercepted request, **edit** the `username`/`password` POST body fields (e.g. change the password value before forwarding) and click **Forward**.
4. Observe DVWA's response to the modified request (it should fail login, since you don't actually have valid alternate credentials — the point is showing that **the client doesn't control what's "真" valid, the request is just data I can edit before it's sent**).
5. Turn **Intercept off** to keep browsing normally.

Also demonstrate with **Repeater**: send the captured login POST to Repeater, tweak a field, resend, and compare responses side by side without needing the browser at all.

## 2. Fuzzing with Intruder (Community Edition — rate-limited, but functional for a demo)
Target: DVWA's **Brute Force** module with Security = Low (it's designed for this exercise; using DVWA's own training credentials, not real accounts).

1. Capture a login POST to `vulnerabilities/brute/` in Burp (via Proxy).
2. Send to **Intruder**. Clear existing payload markers, mark just the `password` field value as the injection point (`§password§`).
3. **Payloads** tab: Payload type = *Simple list*; paste a small list of common test passwords (5–10 entries is enough for a demo — e.g. `password`, `admin`, `123456`, `letmein`, `qwerty`). Do not use a huge list; Community Edition is throttled and this is a demo, not a real brute force.
4. **Start attack.** Community Edition runs it single-threaded and rate-limited — expect it to take a bit.
5. Sort results by **Length** or **Status**: the response for a correct guess is usually a different length/status than the failures (DVWA's Low-security brute force doesn't lock out or delay attempts, which is itself the finding).

*Expected:* one row stands out (different response length), corresponding to the correct password for the DVWA test account, if it happens to be in your list — the point is demonstrating the Intruder workflow (payload markers → attack → compare responses) rather than guaranteeing a hit.

## 3. What this demonstrates
* Burp proves the client/browser **never has final authority** over a request — anything it sends can be intercepted, replayed or automated.
* The real defenses are server-side: rate limiting, account lockout after N failures, CAPTCHA, MFA — not "the form only allows valid-looking input," because Burp bypasses the form entirely.
* Re-run the same Intruder attack at DVWA's **High** security (which adds a CSRF token + session-bound anti-automation to the brute-force page) and show it now fails without first fetching a fresh token per request — tie this back to [CSRF tokens](../csrf/csrf-guide.md#4-mitigation-summary).

## 4. Evidence
`T3-11-burp-intercept-modify.png` (intercepted/edited request + Repeater comparison), `T3-12-burp-intruder.png` (Intruder results grid with one differing row highlighted).
