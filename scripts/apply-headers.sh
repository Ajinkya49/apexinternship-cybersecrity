#!/usr/bin/env bash
# apply-headers.sh - adds a small, documented set of security headers to an
# Apache vhost (lab server only) and reloads Apache. Makes a dated backup
# of the vhost file first and never touches anything but that one file.
#
# Usage: sudo ./apply-headers.sh /etc/apache2/sites-available/000-default.conf
set -u
VHOST="${1:-}"
[ -n "$VHOST" ] && [ -f "$VHOST" ] || { echo "Usage: sudo $0 /path/to/vhost.conf"; exit 2; }
[ "$(id -u)" -eq 0 ] || { echo "Run with sudo."; exit 1; }

cp "$VHOST" "${VHOST}.bak-$(date +%Y%m%d-%H%M%S)"
echo "Backup written next to the original."

if grep -q 'X-Content-Type-Options' "$VHOST"; then
  echo "Headers already present in $VHOST - not duplicating. Edit it by hand if you want to change them."
  exit 0
fi

HEADERS='
    # --- Added by apply-headers.sh (Task 3) ---
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set Referrer-Policy "no-referrer-when-downgrade"
    Header always set Content-Security-Policy "default-src '"'"'self'"'"' '"'"'unsafe-inline'"'"'"
    # --- end Task 3 headers ---
'
# Insert just before the closing </VirtualHost>, in the FIRST matching block only.
awk -v hdrs="$HEADERS" '
  /<\/VirtualHost>/ && !done { print hdrs; done=1 }
  { print }
' "$VHOST" > "${VHOST}.tmp" && mv "${VHOST}.tmp" "$VHOST"

a2enmod headers >/dev/null 2>&1 || true
apachectl configtest && systemctl reload apache2 && echo "Headers added and Apache reloaded." \
  || { echo "Config test failed - restoring backup."; cp "${VHOST}."*.bak-* "$VHOST"; exit 1; }
