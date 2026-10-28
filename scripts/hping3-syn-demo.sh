#!/usr/bin/env bash
# hping3-syn-demo.sh - short, rate-limited SYN burst against MY OWN lab VM,
# for Wireshark analysis. This is a traffic-pattern demonstration, not a
# denial-of-service tool.
# Hard limits: lab prefix only, packet count capped at 1000, fixed rate
# (about 100 packets/s), no --flood, no spoofed or random source addresses.
# Usage: sudo ./hping3-syn-demo.sh [target-ip] [count<=1000] [port]
set -u
TARGET="${1:-192.168.56.20}"
COUNT="${2:-500}"
PORT="${3:-80}"
LAB_PREFIX="${LAB_PREFIX:-192.168.56.}"
MAX_COUNT=1000

[[ "$TARGET" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]] || { echo "Refusing: target must be a plain IPv4 address."; exit 2; }
[[ "$TARGET" == ${LAB_PREFIX}* ]] || { echo "Refusing: $TARGET is outside the authorized lab (${LAB_PREFIX}0/24)."; exit 2; }
[[ "$COUNT" =~ ^[0-9]+$ && "$COUNT" -ge 1 && "$COUNT" -le $MAX_COUNT ]] || { echo "Refusing: count must be 1-$MAX_COUNT."; exit 2; }
[[ "$PORT" =~ ^[0-9]+$ && "$PORT" -ge 1 && "$PORT" -le 65535 ]] || { echo "Refusing: invalid port."; exit 2; }
command -v hping3 >/dev/null 2>&1 || { echo "hping3 not installed (sudo apt install hping3)."; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }

echo "About to send $COUNT TCP SYN packets to $TARGET:$PORT at ~100/s (lab VM that I own)."
echo "Checklist: Wireshark capturing on eth1? NAT adapter disconnected? VM snapshot taken?"
read -r -p "Type YES to continue: " ok
[ "$ok" = "YES" ] || { echo "Cancelled."; exit 0; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVIDENCE_DIR="$SCRIPT_DIR/../evidence/terminal-output"
mkdir -p "$EVIDENCE_DIR"
LOG="$EVIDENCE_DIR/hping3-syn-demo-$(date +%Y%m%d-%H%M%S).txt"
{
  echo "hping3 SYN burst  $(date -u '+%Y-%m-%d %H:%M:%S UTC')  from $(hostname)"
  echo "\$ hping3 -S -p $PORT -c $COUNT -i u10000 $TARGET"
  hping3 -S -p "$PORT" -c "$COUNT" -i u10000 "$TARGET" 2>&1
} | tee "$LOG"
echo "Saved: $LOG"
