#!/usr/bin/env bash
# validate-repo.sh (Task 3) - checks required files, balanced code fences,
# relative links and script syntax; reports missing evidence. Never creates
# evidence itself. Usage: ./validate-repo.sh
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1
fail=0
ok()   { printf '  [ OK ] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=1; }
warn() { printf '  [TODO] %s\n' "$1"; }

echo "== Required documentation =="
for f in README.md sqli/sqli-guide.md xss/xss-guide.md csrf/csrf-guide.md \
         csrf/poc-change-password.html file-inclusion/lfi-rfi-guide.md \
         burp-advanced/burp-advanced-guide.md security-headers/headers-guide.md \
         reports/Security-Testing-Report.md reports/requirements-matrix.md \
         reports/submission-checklist.md evidence/EVIDENCE-CHECKLIST.md \
         video/video-script.md scripts/csrf-poc-server.py scripts/rfi-payload-server.py \
         scripts/apply-headers.sh scripts/validate-repo.sh; do
  [ -f "$f" ] && ok "$f" || bad "missing: $f"
done

echo; echo "== Code fences balanced =="
ok_f=1
while IFS= read -r f; do
  n=$(grep -c '^```' "$f" || true)
  [ $((n % 2)) -ne 0 ] && { bad "$f odd fence count ($n)"; ok_f=0; }
done < <(find . -name '*.md')
[ $ok_f -eq 1 ] && ok "all Markdown balanced"

echo; echo "== Relative links resolve =="
tmp="$(mktemp)"
while IFS= read -r f; do
  dir="$(dirname "$f")"
  grep -oE '\]\([^)]+\)' "$f" | sed -E 's/^\]\(//; s/\)$//' | while IFS= read -r link; do
    case "$link" in http*|mailto:*|\#*) continue ;; esac
    p="${link%%#*}"; [ -z "$p" ] && continue
    [ -e "$dir/$p" ] || { echo "  [FAIL] $f -> $link"; echo x >> "$tmp"; }
  done
done < <(find . -name '*.md')
[ -s "$tmp" ] && fail=1 || ok "no broken relative links"
rm -f "$tmp"

echo; echo "== Script syntax =="
for s in scripts/*.sh; do bash -n "$s" && ok "$s" || bad "$s"; done
for p in scripts/*.py; do python3 -m py_compile "$p" && ok "$p" || bad "$p"; done
rm -rf scripts/__pycache__

echo; echo "== Evidence (must come from MY lab) =="
missing=0
for e in T3-01-sqli-extract T3-02-sqli-prevention T3-03-xss-stored T3-04-xss-reflected \
         T3-05-xss-mitigation T3-06-csrf-attack T3-07-csrf-token-protection T3-08-lfi \
         T3-09-rfi T3-10-fi-mitigation T3-11-burp-intercept-modify T3-12-burp-intruder \
         T3-13-securityheaders-before T3-14-securityheaders-after; do
  if ls evidence/"$e".* >/dev/null 2>&1; then ok "evidence/$e.*"; else warn "evidence/$e.png not captured yet"; missing=$((missing+1)); fi
done
grep -q '____' reports/Security-Testing-Report.md && { warn "report still has ____ fields"; missing=$((missing+1)); } || ok "report filled"
grep -q 'PASTE-VIDEO-LINK-HERE' video/video-script.md && { warn "video link placeholder not replaced"; missing=$((missing+1)); } || ok "video link replaced"

echo
[ $fail -ne 0 ] && { echo "RESULT: documentation problems found."; exit 1; }
echo "RESULT: documentation checks passed. Items still pending from my lab: $missing."
