#!/usr/bin/env bash
# validate-repo.sh (Task 2) - checks required files, balanced code fences,
# relative links and script syntax. Reports which evidence is still missing.
# It never creates evidence. Usage: ./validate-repo.sh
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 1
fail=0
ok()   { printf '  [ OK ] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=1; }
warn() { printf '  [TODO] %s\n' "$1"; }

echo "== Required documentation =="
for f in README.md recon/recon-guide.md nmap/nmap-guide.md openvas/openvas-guide.md \
         wireshark/packet-analysis-guide.md firewall/iptables-guide.md \
         reports/Nmap-Scan-Report.md reports/OpenVAS-Vulnerability-Report.md \
         reports/requirements-matrix.md reports/submission-checklist.md \
         evidence/EVIDENCE-CHECKLIST.md video/video-script.md \
         scripts/nmap-scan.sh scripts/hping3-syn-demo.sh scripts/iptables-demo.sh scripts/validate-repo.sh; do
  [ -f "$f" ] && ok "$f" || bad "missing: $f"
done

echo; echo "== Code fences balanced =="
fences_ok=1
while IFS= read -r f; do
  n=$(grep -c '^```' "$f" || true)
  if [ $((n % 2)) -ne 0 ]; then bad "$f has an odd number of code fences ($n)"; fences_ok=0; fi
done < <(find . -name '*.md')
[ $fences_ok -eq 1 ] && ok "all Markdown files balanced"

echo; echo "== Relative links resolve =="
tmp="$(mktemp)"
while IFS= read -r f; do
  dir="$(dirname "$f")"
  grep -oE '\]\([^)]+\)' "$f" | sed -E 's/^\]\(//; s/\)$//' | while IFS= read -r link; do
    case "$link" in http*|mailto:*|\#*) continue ;; esac
    path="${link%%#*}"; [ -z "$path" ] && continue
    [ -e "$dir/$path" ] || { echo "  [FAIL] $f -> $link"; echo x >> "$tmp"; }
  done
done < <(find . -name '*.md')
if [ -s "$tmp" ]; then fail=1; else ok "no broken relative links"; fi
rm -f "$tmp"

echo; echo "== Script syntax =="
for s in scripts/*.sh; do bash -n "$s" && ok "$s" || bad "$s"; done

echo; echo "== Evidence (must come from MY lab) =="
missing=0
for e in T2-01-recon-passive T2-02-recon-active T2-03-nmap-tcp T2-04-nmap-udp T2-05-nmap-version-os \
         T2-06-openvas-dashboard T2-07-openvas-results T2-08-wireshark-http-dns \
         T2-09-wireshark-ftp-credentials T2-10-wireshark-syn-flood T2-11-iptables-baseline \
         T2-12-iptables-blocked T2-13-iptables-scan-blocked; do
  if ls evidence/"$e".* >/dev/null 2>&1; then ok "evidence/$e.*"; else warn "evidence/$e.png not captured yet"; missing=$((missing+1)); fi
done
ls -d nmap/results-* >/dev/null 2>&1 && ok "nmap results folder present" || { warn "no nmap/results-* folder yet (run scripts/nmap-scan.sh)"; missing=$((missing+1)); }
ls openvas/*.pdf >/dev/null 2>&1 && ok "OpenVAS PDF present" || { warn "no exported OpenVAS PDF in openvas/"; missing=$((missing+1)); }
grep -q '____' reports/Nmap-Scan-Report.md && { warn "Nmap report still has ____ fields"; missing=$((missing+1)); } || ok "Nmap report filled"
grep -q '____' reports/OpenVAS-Vulnerability-Report.md && { warn "OpenVAS report still has ____ fields"; missing=$((missing+1)); } || ok "OpenVAS report filled"
grep -q 'PASTE-VIDEO-LINK-HERE' video/video-script.md && { warn "video link placeholder not replaced"; missing=$((missing+1)); } || ok "video link replaced"

echo
[ $fail -ne 0 ] && { echo "RESULT: documentation problems found (see [FAIL])."; exit 1; }
echo "RESULT: documentation checks passed. Items still pending from my lab: $missing."
