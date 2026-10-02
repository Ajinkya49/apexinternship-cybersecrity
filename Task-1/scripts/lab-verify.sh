#!/usr/bin/env bash
# lab-verify.sh - run ON KALI to collect REAL connectivity evidence.
#
# What it does (read-only checks; no scanning beyond a short service check
# of the lab target):
#   identity, interfaces, routes, ping, traceroute, listening ports,
#   and an optional Nmap service check of a few well-known ports.
#
# SAFETY GUARD: the target must be 127.0.0.1 or inside the lab subnet
# (default 192.168.56.0/24). Anything else is refused.
#
# Usage:  ./lab-verify.sh [target-ip]          (default 192.168.56.20)
#         LAB_PREFIX="192.168.56." ./lab-verify.sh 192.168.56.20
set -u

TARGET="${1:-192.168.56.20}"
LAB_PREFIX="${LAB_PREFIX:-192.168.56.}"

# --- guard -------------------------------------------------------------
if [[ ! "$TARGET" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
  echo "Refusing: '$TARGET' is not a plain IPv4 address (hostnames/DNS not allowed)."; exit 2
fi
if [[ "$TARGET" != "127.0.0.1" && "$TARGET" != ${LAB_PREFIX}* ]]; then
  echo "Refusing: $TARGET is outside the authorized lab (127.0.0.1 or ${LAB_PREFIX}0/24)."
  echo "This script only checks systems I own inside the isolated Host-Only lab."
  exit 2
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVIDENCE_DIR="$SCRIPT_DIR/../evidence/terminal-output"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG="$EVIDENCE_DIR/lab-verify-$STAMP.txt"
mkdir -p "$EVIDENCE_DIR"

step() {
  echo
  echo "---- $1 ----"
  echo "\$ ${*:2}"
  "${@:2}" 2>&1
  echo "[exit status: $?]"
}
have() { command -v "$1" >/dev/null 2>&1; }

{
  echo "Lab verification run"
  echo "Date:    $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Machine: $(hostname)  User: $(whoami)"
  echo "Target:  $TARGET (authorized lab range: 127.0.0.1 or ${LAB_PREFIX}0/24)"

  step "Kernel / OS"          uname -a
  step "Interfaces (brief)"   ip -br addr
  step "Routing table"        ip route
  step "Neighbour (ARP) cache" ip neigh
  step "Ping target (4 packets)" ping -c 4 -W 2 "$TARGET"

  if have traceroute; then
    step "Traceroute (numeric)" traceroute -n -w 2 -q 1 -m 5 "$TARGET"
  elif have tracepath; then
    step "Tracepath"            tracepath -n -m 5 "$TARGET"
  else
    echo; echo "---- traceroute/tracepath not installed (sudo apt install traceroute) ----"
  fi

  step "Listening sockets on THIS machine" ss -tuln

  if have nmap; then
    # Service/version check of 4 well-known ports on the lab target only.
    # Output reports what the services ANNOUNCE; it is not proof of a vulnerability.
    step "Nmap service check (lab target only)" nmap -sT -sV -p 21,22,23,80 "$TARGET"
  else
    echo; echo "---- nmap not installed (sudo apt install nmap) ----"
  fi

  echo
  echo "End of run. Output above is from THIS machine at the time shown."
} 2>&1 | tee "$LOG"

echo
echo "Saved: $LOG"
