#!/usr/bin/env bash
# validate-repo.sh - checks the Task-1 submission for required files,
# balanced code fences, and broken relative Markdown links.
# Also reports which evidence files exist (it never creates evidence).
#
# Usage: ./validate-repo.sh        (run from anywhere)
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1
fail=0
ok()   { printf '  [ OK ] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=1; }
warn() { printf '  [TODO] %s\n' "$1"; }

echo "== Required documentation =="
required=(
  README.md notes/01-cybersecurity-basics.md
  lab-setup/lab-setup-guide.md lab-setup/network-design.md
  linux-cheatsheet/linux-cheatsheet.md linux-cheatsheet/linux-permissions.md
  networking/networking-fundamentals.md cryptography/cryptography-fundamentals.md
  tools/tool-familiarization.md
  evidence/EVIDENCE-CHECKLIST.md
  reports/Lab-Setup-Report.md reports/requirements-matrix.md reports/submission-checklist.md
  video/video-script.md
  scripts/lab-verify.sh scripts/openssl-demo.sh scripts/netcat-demo.sh scripts/validate-repo.sh
)
for f in "${required[@]}"; do [ -f "$f" ] && ok "$f" || bad "missing: $f"; done

echo; echo "== Markdown code fences balanced =="
while IFS= read -r f; do
  n=$(grep -c '^```' "$f" || true)
  if [ $((n % 2)) -eq 0 ]; then :; else bad "$f has an odd number of code fences ($n)"; fi
done < <(find . -name '*.md' -not -path './.git/*')
[ $fail -eq 0 ] && ok "all Markdown files have balanced fences"

echo; echo "== Relative links resolve =="
broken=0
while IFS= read -r f; do
  dir="$(dirname "$f")"
  # extract (target) from [text](target); skip http(s), mailto and pure anchors
  grep -oE '\]\([^)]+\)' "$f" | sed -E 's/^\]\(//; s/\)$//' | while IFS= read -r link; do
    case "$link" in http*|mailto:*|\#*) continue ;; esac
    path="${link%%#*}"
    [ -z "$path" ] && continue
    if [ ! -e "$dir/$path" ]; then echo "  [FAIL] $f -> $link"; echo x >> /tmp/.broken_links.$$; fi
  done
done < <(find . -name '*.md' -not -path './.git/*')
if [ -f /tmp/.broken_links.$$ ]; then rm -f /tmp/.broken_links.$$; fail=1; else ok "no broken relative links"; fi

echo; echo "== Script syntax =="
for s in scripts/*.sh; do bash -n "$s" && ok "$s" || bad "$s syntax error"; done

echo; echo "== Evidence (must come from MY lab; this script cannot create it) =="
ev=(01-virtualbox 02-kali 03-host-only-network 04-connectivity 05-wireshark 06-nmap
    07-burpsuite 08-netcat 09-openssl 10-metasploitable 11-dvwa 12-linux-commands
    13-package-management 14-isolation-check)
missing=0
for e in "${ev[@]}"; do
  if ls evidence/"$e".* >/dev/null 2>&1; then ok "evidence/$e.*"; else warn "evidence/$e.png not captured yet"; missing=$((missing+1)); fi
done
ls evidence/terminal-output/*.txt >/dev/null 2>&1 && ok "terminal-output has saved logs" || warn "no saved terminal logs yet (run the scripts in my lab)"
grep -q 'PASTE-VIDEO-LINK-HERE' video/video-script.md && warn "video link placeholder not replaced" || ok "video link replaced"

echo
if [ $fail -ne 0 ]; then echo "RESULT: documentation problems found (see [FAIL])."; exit 1; fi
echo "RESULT: documentation checks passed. Evidence still missing: $missing item(s)."
