#!/usr/bin/env bash
# nmap-scan.sh - lab-only Nmap scan set for Task 2 (TCP SYN, UDP top ports,
# version + OS detection) with all output saved.
# SAFETY: the target must be 127.0.0.1 or inside the lab prefix
# (default 192.168.56.). Anything else is refused.
# Usage: sudo ./nmap-scan.sh [target-ip]   (default 192.168.56.20)
set -u
TARGET="${1:-192.168.56.20}"
LAB_PREFIX="${LAB_PREFIX:-192.168.56.}"

if [[ ! "$TARGET" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then echo "Refusing: '$TARGET' is not a plain IPv4 address."; exit 2; fi
if [[ "$TARGET" != "127.0.0.1" && "$TARGET" != ${LAB_PREFIX}* ]]; then
  echo "Refusing: $TARGET is outside the authorized lab (127.0.0.1 or ${LAB_PREFIX}0/24)."; exit 2
fi
command -v nmap >/dev/null 2>&1 || { echo "nmap not installed (sudo apt install nmap)"; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo (SYN, UDP and OS scans need root)."; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SCRIPT_DIR/../nmap/results-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$OUT"
LOG="$OUT/run-log.txt"

run() { echo; echo "\$ $*"; "$@" 2>&1; echo "[exit status: $?]"; }

{
  echo "Nmap lab scan run"
  echo "Date:    $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Machine: $(hostname)  Target: $TARGET"
  nmap --version | head -n 1
  echo "Reminder: NAT adapter should be disconnected. Findings are observations, not proof of vulnerability."

  run nmap -sn -oA "$OUT/00-host-discovery" "$TARGET"
  run nmap -sS -p- -T4 -oA "$OUT/01-tcp-syn-all-ports" "$TARGET"
  run nmap -sU --top-ports 30 -oA "$OUT/02-udp-top30" "$TARGET"
  run nmap -sS -sV -O -p- -T4 -oA "$OUT/03-full-report" "$TARGET"
} 2>&1 | tee "$LOG"

if command -v xsltproc >/dev/null 2>&1; then
  xsltproc "$OUT/03-full-report.xml" -o "$OUT/03-full-report.html" && echo "HTML report: $OUT/03-full-report.html"
else
  echo "(install xsltproc to convert the XML to HTML: sudo apt install xsltproc)"
fi
echo "Saved to: $OUT"
