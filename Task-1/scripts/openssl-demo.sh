#!/usr/bin/env bash
# openssl-demo.sh - local-only cryptography demonstration (no network access).
#
# Demonstrates: hashing, symmetric encryption, asymmetric key pair,
# RSA encrypt/decrypt, digital signature, self-signed certificate,
# and a local TLS handshake on 127.0.0.1.
#
# Safe: everything stays on this machine in ./openssl-demo-workdir
# (git-ignored). Output is also saved to evidence/terminal-output/.
#
# Usage:  cd Task-1/scripts && ./openssl-demo.sh
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EVIDENCE_DIR="$SCRIPT_DIR/../evidence/terminal-output"
WORK="$SCRIPT_DIR/openssl-demo-workdir"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG="$EVIDENCE_DIR/openssl-demo-$STAMP.txt"

mkdir -p "$EVIDENCE_DIR" "$WORK"
cd "$WORK" || exit 1

command -v openssl >/dev/null 2>&1 || { echo "openssl not found"; exit 1; }

run() {
  # Print the command, run it, show output. Keeps the log self-explanatory.
  echo
  echo "\$ $*"
  # Filter OpenSSL's key-generation progress dots so the log stays readable.
  "$@" 2>&1 | grep -v -E '^[.+*]+$'
  return "${PIPESTATUS[0]}"
}

section() { echo; echo "=================================================="; echo "$*"; echo "=================================================="; }

{
  echo "OpenSSL local demo"
  echo "Date:     $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
  echo "Host:     $(hostname)"
  echo "User:     $(whoami)"
  openssl version

  section "1. Hashing (one-way; NOT encryption)"
  printf 'hello' > msg.txt
  run openssl dgst -sha256 msg.txt
  run openssl dgst -md5 msg.txt
  echo "-- Avalanche effect: change one character ('hello' -> 'hellp') --"
  printf 'hellp' > msg2.txt
  run openssl dgst -sha256 msg2.txt
  echo "-- Integrity check: modify the file, hash changes --"
  cp msg.txt original.txt
  openssl dgst -sha256 original.txt | tee original.sha256
  printf ' tampered' >> original.txt
  run openssl dgst -sha256 original.txt

  section "2. Symmetric encryption (AES-256-CBC, same key both ways)"
  # Passphrase generated randomly and kept only in the git-ignored workdir.
  openssl rand -hex 16 > demo.pass
  printf 'Secret lab note: Task 1 symmetric demo\n' > plain.txt
  run openssl enc -aes-256-cbc -pbkdf2 -salt -in plain.txt -out cipher.enc -pass file:demo.pass
  echo "-- Ciphertext is unreadable binary; first bytes (hex): --"
  head -c 32 cipher.enc | od -An -tx1
  run openssl enc -d -aes-256-cbc -pbkdf2 -in cipher.enc -out decrypted.txt -pass file:demo.pass
  echo "-- Decrypted content: --"
  cat decrypted.txt
  echo "-- Wrong key fails: --"
  echo "wrong-passphrase" > wrong.pass
  run openssl enc -d -aes-256-cbc -pbkdf2 -in cipher.enc -out should-fail.txt -pass file:wrong.pass
  echo "(exit status expected non-zero: bad decrypt)"

  section "3. Asymmetric keys (RSA 2048): public encrypts, private decrypts"
  run openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
  chmod 600 private.pem
  run openssl pkey -in private.pem -pubout -out public.pem
  printf 'short asymmetric message' > small.txt
  run openssl pkeyutl -encrypt -pubin -inkey public.pem -pkeyopt rsa_padding_mode:oaep -in small.txt -out small.enc
  run openssl pkeyutl -decrypt -inkey private.pem -pkeyopt rsa_padding_mode:oaep -in small.enc -out small.dec
  echo "-- Decrypted: --"
  cat small.dec; echo
  echo "(RSA only encrypts short data; in practice it protects a symmetric key.)"

  section "4. Digital signature (private key signs, public key verifies)"
  printf 'Contract v1' > doc.txt
  run openssl dgst -sha256 -sign private.pem -out doc.sig doc.txt
  run openssl dgst -sha256 -verify public.pem -signature doc.sig doc.txt
  echo "-- Tamper with the document and verify again: --"
  printf 'Contract v2' > doc-tampered.txt
  run openssl dgst -sha256 -verify public.pem -signature doc.sig doc-tampered.txt
  echo "(expected: Verification failure)"

  section "5. Self-signed certificate for localhost"
  run openssl req -x509 -newkey rsa:2048 -nodes -keyout cert.key -out cert.pem -days 30 \
      -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
  chmod 600 cert.key
  echo "-- Certificate summary: --"
  run openssl x509 -in cert.pem -noout -subject -issuer -dates -fingerprint -sha256

  section "6. Local TLS handshake on 127.0.0.1:4433"
  echo "Starting a throw-away local TLS server (loopback only)..."
  openssl s_server -accept 127.0.0.1:4433 -cert cert.pem -key cert.key -www >/dev/null 2>&1 &
  SERVER_PID=$!
  sleep 1
  echo "\$ openssl s_client -connect 127.0.0.1:4433 -CAfile cert.pem (summary lines)"
  echo | openssl s_client -connect 127.0.0.1:4433 -CAfile cert.pem 2>&1 \
    | grep -E 'Protocol|Cipher is|Verification|Verify return code|subject=|issuer=' | head -n 10
  kill "$SERVER_PID" 2>/dev/null
  wait "$SERVER_PID" 2>/dev/null

  section "Done"
  echo "Working files: $WORK  (contains private keys - do NOT commit; .gitignore excludes them)"
} 2>&1 | tee "$LOG"

echo
echo "Saved log: $LOG"
