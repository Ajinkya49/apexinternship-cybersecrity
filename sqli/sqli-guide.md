# Step 1 — SQL Injection (DVWA)

**DVWA module:** SQL Injection. **Security level for exploitation:** Low (then repeat at Medium/High to see what prevention looks like).

## 1. Install/confirm DVWA
Already covered in [Task 1 §6](../../Task-1/lab-setup/lab-setup-guide.md#step-6--dvwa). Confirm:
```bash
curl -I http://192.168.56.20/dvwa/login.php
```
Log in (`admin`/`password`), set **DVWA Security = Low**, open **SQL Injection**.

## 2. Understand the vulnerable query (conceptual)
DVWA's low-security SQLi page typically builds a query like:
```sql
SELECT first_name, last_name FROM users WHERE user_id = '$id';
```
If `$id` is inserted into the SQL text without sanitization, I can change the query's *meaning*, not just its value.

## 3. Exploit: extract data
Try these in the "User ID" field (observe each response before moving to the next):

| Input | What it does |
|-------|--------------|
| `1` | Normal lookup — baseline |
| `1' OR '1'='1` | Makes the WHERE clause always true → returns all rows instead of one |
| `' UNION SELECT user, password FROM users -- -` | Appends a second query that reads the `users` table's credentials into the same result columns |
| `' UNION SELECT table_name, column_name FROM information_schema.columns WHERE table_name='users' -- -` | Enumerates column names without guessing |

Record: the exact input, the raw response (DVWA shows it inline), and in your own words what changed about the query's logic.

## 4. SQLi variants to note (for the report, not all need separate exploitation)
* **Error-based** — DB error messages leak schema/data.
* **UNION-based** — what I used above.
* **Blind boolean-based** — `' AND 1=1 -- -` vs `' AND 1=2 -- -`, inferring truth from page differences (DVWA's "SQL Injection (Blind)" module).
* **Blind time-based** — e.g. `' AND SLEEP(5) -- -`, inferring truth from response delay.

## 5. Repeat at Medium and High
* **Medium:** input is a dropdown (numeric, via POST) — show that the UI restricts input but the underlying query is often still unsafe if hit directly (e.g. with Burp Repeater, see [Burp Advanced](../burp-advanced/burp-advanced-guide.md)).
* **High:** typically session-token-gated and uses a safer query path — show that the same payload now fails, and explain why.

## 6. Mitigation: prepared statements
The concept (parameterized query — input is always data, never SQL text):
```python
# Vulnerable (string built from user input)
query = "SELECT first_name, last_name FROM users WHERE user_id = '" + user_id + "'"

# Prepared statement (DB driver keeps the query shape fixed)
cursor.execute("SELECT first_name, last_name FROM users WHERE user_id = %s", (user_id,))
```
DVWA's **High** security source (`vulnerabilities/sqli/source/high.php`) is a good real example to open and quote the structure of (in your own words, describing what it does) — e.g. it uses `mysqli_real_escape_string` and a bound/limited query path. Additional defenses to mention: least-privilege DB accounts, input validation/allow-lists, generic error messages (don't leak DB errors to users), a WAF as a secondary layer (not a substitute for fixing the code).

## 7. Evidence
`T3-01-sqli-extract.png` (payload + extracted data, Low), `T3-02-sqli-prevention.png` (same payload failing at High, or the High source code open).
