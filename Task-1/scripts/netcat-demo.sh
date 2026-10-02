#!/usr/bin/env bash
# netcat-demo.sh - localhost-only Netcat client/server demonstration.
#
# Starts a listener on 127.0.0.1, connects to it as a client, sends one
# line, and shows that the listener received it. Then shows what a port
# check looks like against a CLOSED local port. Nothing leaves this machine.
#
# Usage:  cd Task-1/scripts && ./netcat-demo.sh [port]
# Default port: 4444 (loopback only).
set -u

PORT="${1:-4444}"
CLOSED_PORT=$((PORT + 1))
HOST="127.0.0.1"          # fixed on purpose: this demo never targets anything else
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVIDENCE_DIR="$SCRIPT_DIR/../evidence/terminal-output"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG="$EVIDENCE_DIR/netcat-demo-$STAMP.txt"
RECV="$(mktemp)"
LISTEN_PID=""
cleanup() { rm -f "$RECV"; [ -n "$LISTEN_PID" ] && kill "$LISTEN_PID" 2>/dev/null; }
trap cleanup EXIT

mkdir -p "$EVIDENCE_DIR"
command -v nc >/dev/null 2>&1 || { echo "nc (netcat) not found. Try: sudo apt install netcat-traditional"; exit 1; }

# Netcat flavours differ. Traditional netcat needs "-p" for the listen port;
# OpenBSD netcat and ncat take the port as a plain argument.
HELP="$(nc -h 2>&1 || true)"
if echo "$HELP" | grep -qiE 'OpenBSD|Ncat'; then
  LISTEN_CMD=(nc -l "$PORT");     FLAVOUR="OpenBSD/ncat-style"
else
  LISTEN_CMD=(nc -l -p "$PORT");  FLAVOUR="traditional-style"
fi

{
  echo "Netcat localhost demo"
  echo "Date:   $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Host:   $(hostname)   User: $(whoami)"
  echo "Flavour detected: $FLAVOUR"

  echo
  echo "1) Start a listener on $HOST:$PORT (background, writes to a temp file)"
  echo "\$ ${LISTEN_CMD[*]} > received.txt &"
  "${LISTEN_CMD[@]}" > "$RECV" 2>/dev/null &
  LISTEN_PID=$!
  sleep 1

  echo
  echo "2) Confirm the port is listening"
  echo "\$ ss -tln | grep :$PORT"
  ss -tln 2>/dev/null | grep ":$PORT" || echo "(not visible - this netcat flavour may bind differently)"

  echo
  echo "3) Connect as a client and send one line"
  echo "\$ echo 'hello from the netcat client' | nc $HOST $PORT"
  echo 'hello from the netcat client' | timeout 5 nc "$HOST" "$PORT" 2>&1 || true
  sleep 1

  echo
  echo "4) What the listener received"
  echo "\$ cat received.txt"
  cat "$RECV"

  echo
  echo "5) Port check against a CLOSED local port (-z scan mode, -v verbose)"
  echo "\$ nc -zv $HOST $CLOSED_PORT"
  timeout 5 nc -zv "$HOST" "$CLOSED_PORT" 2>&1 || echo "(connection refused / failed - expected: nothing listens on $CLOSED_PORT)"

  echo
  echo "Done. Everything stayed on $HOST."
} 2>&1 | tee "$LOG"

echo
echo "Saved log: $LOG"
