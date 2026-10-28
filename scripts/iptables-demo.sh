#!/usr/bin/env bash
# iptables-demo.sh - reversible firewall demo for Task 2 (run ON KALI).
# All rules live in ONE dedicated chain (LABDEMO) that is jumped to only for
# traffic arriving on the Host-Only interface (default eth1), so NAT/update
# traffic and loopback are never touched. "cleanup" removes everything.
#
# Usage (as root):
#   ./iptables-demo.sh block-port [port]   drop inbound TCP to one port (default 8080)
#   ./iptables-demo.sh scan-defense        log + drop sources that send >=15 SYNs in 10 s
#   ./iptables-demo.sh status              show chain, counters and recent log lines
#   ./iptables-demo.sh cleanup             remove the chain and the jump
# Optional: IFACE=eth1 ./iptables-demo.sh ...
set -u
IFACE="${IFACE:-eth1}"
CHAIN="LABDEMO"
CMD="${1:-}"

[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }
command -v iptables >/dev/null 2>&1 || { echo "iptables not found (sudo apt install iptables)."; exit 1; }
ip link show "$IFACE" >/dev/null 2>&1 || { echo "Interface $IFACE not found. Set IFACE=<host-only interface>."; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/../firewall"
mkdir -p "$BACKUP_DIR"

ensure_chain() {
  if iptables -L "$CHAIN" -n >/dev/null 2>&1; then iptables -F "$CHAIN"; else iptables -N "$CHAIN"; fi
  iptables -C INPUT -i "$IFACE" -j "$CHAIN" 2>/dev/null || iptables -I INPUT 1 -i "$IFACE" -j "$CHAIN"
  # Never break established sessions (e.g. my own SSH/GUI sessions).
  iptables -A "$CHAIN" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
}

case "$CMD" in
  block-port)
    PORT="${2:-8080}"
    [[ "$PORT" =~ ^[0-9]+$ && "$PORT" -ge 1 && "$PORT" -le 65535 ]] || { echo "Invalid port."; exit 2; }
    iptables-save > "$BACKUP_DIR/iptables-before-$(date +%Y%m%d-%H%M%S).rules"
    ensure_chain
    iptables -A "$CHAIN" -p tcp --dport "$PORT" -j DROP
    echo "Rule added: inbound TCP/$PORT on $IFACE is DROPped (scanners will see it as 'filtered')."
    ;;
  scan-defense)
    iptables-save > "$BACKUP_DIR/iptables-before-$(date +%Y%m%d-%H%M%S).rules"
    ensure_chain
    iptables -A "$CHAIN" -p tcp --syn -m recent --name labscan --set
    iptables -A "$CHAIN" -p tcp --syn -m recent --name labscan --update --seconds 10 --hitcount 15 \
             -j LOG --log-prefix "LAB-PORTSCAN: " --log-level 4
    iptables -A "$CHAIN" -p tcp --syn -m recent --name labscan --update --seconds 10 --hitcount 15 -j DROP
    echo "Scan defense active on $IFACE: >=15 new SYNs from one source in 10 s are logged and dropped."
    echo "Note: this also throttles legitimate bursts from the same source. Lab demo only."
    ;;
  status)
    iptables -L "$CHAIN" -n -v --line-numbers 2>/dev/null || echo "(chain $CHAIN does not exist)"
    echo; echo "Recent LAB-PORTSCAN log lines:"
    (journalctl -k --no-pager 2>/dev/null || dmesg) | grep 'LAB-PORTSCAN' | tail -n 5 || true
    ;;
  cleanup)
    while iptables -D INPUT -i "$IFACE" -j "$CHAIN" 2>/dev/null; do :; done
    iptables -F "$CHAIN" 2>/dev/null; iptables -X "$CHAIN" 2>/dev/null
    echo "Removed chain $CHAIN and its jump. Firewall is back to its previous state."
    ;;
  *)
    sed -n '2,15p' "$0"; exit 2 ;;
esac
