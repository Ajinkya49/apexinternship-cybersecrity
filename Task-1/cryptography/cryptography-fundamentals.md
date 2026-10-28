# Cryptography Fundamentals

Study notes and hands-on OpenSSL practice for ApexPlanet Task 1. Everything runs **locally** (files and `127.0.0.1`). Automated version: [`../scripts/openssl-demo.sh`](../scripts/openssl-demo.sh).

> **Expected output blocks below are teaching examples.** Real results (especially keys, salts and ciphertext) will differ on my machine. My actual evidence is `evidence/09-openssl.png` and the log saved by the script in `evidence/terminal-output/`.

## 1. The big picture

| Primitive | Key(s) | Reversible? | Provides | Examples |
|-----------|--------|-------------|----------|----------|
| Hash | none | **No** (one-way) | Integrity / fingerprint | SHA-256, SHA-3, (MD5 — broken) |
| Symmetric encryption | 1 shared secret key | Yes, with the key | Confidentiality (fast, bulk data) | AES-128/256, ChaCha20 |
| Asymmetric encryption | public + private pair | Yes, with the private key | Confidentiality, key exchange | RSA, ECC (ECDH) |
| Digital signature | private signs, public verifies | n/a | Authenticity, integrity, non-repudiation | RSA-PSS/PKCS#1, ECDSA, Ed25519 |
| Certificate | binds a public key to an identity, signed by a CA | n/a | Trust in public keys | X.509 |

## 2. Symmetric vs asymmetric

| | Symmetric | Asymmetric |
|--|-----------|------------|
| Keys | One shared secret | Public key (shareable) + private key (secret) |
| Speed | Very fast | Much slower |
| Typical use | Encrypting files, disk, TLS session data | Key exchange, signatures, certificates |
| Main challenge | Safely sharing the key | Protecting the private key; proving a public key is genuine |
| Typical sizes | AES-256 = 256-bit key | RSA 2048+ bit; ECC ~256-bit |

**Hybrid approach (what TLS does):** use asymmetric cryptography/key agreement to establish a fresh shared secret, then use fast symmetric encryption for the actual data.

## 3. Hashing

A hash function maps any input to a fixed-length fingerprint. Properties: deterministic, fast, one-way, tiny change → completely different output (**avalanche effect**), collision-resistant.

> **Hashing is not encryption.** You cannot "decrypt" a hash; there is no key and no way to recover the original input from the digest (other than guessing inputs). Encryption is reversible with a key; hashing is not.

| Algorithm | Output | Status |
|-----------|--------|--------|
| **MD5** | 128 bits | **Cryptographically broken** — practical collisions exist. Do **not** use for security (signatures, certificates, password storage). Acceptable only for non-security checksums, e.g. spotting accidental corruption |
| SHA-1 | 160 bits | Deprecated — collisions demonstrated |
| **SHA-256** | 256 bits | Secure; widely used for integrity and in certificates |

**Passwords:** do not store plain SHA-256/MD5 of passwords. Use a slow, salted password hash (Argon2, bcrypt, scrypt, PBKDF2).

### Practice

```bash
printf 'hello' > msg.txt
openssl dgst -sha256 msg.txt
openssl dgst -md5 msg.txt
```

Expected shape (these particular digests are the well-known values for the text `hello`, so you can compare):

```text
SHA2-256(msg.txt)= 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824
MD5(msg.txt)= 5d41402abc4b2a76b9719d911017c592
```

Avalanche effect and integrity check:

```bash
printf 'hellp' > msg2.txt            # one letter changed
openssl dgst -sha256 msg2.txt        # completely different digest
cp msg.txt original.txt
openssl dgst -sha256 original.txt > original.sha256
printf ' tampered' >> original.txt
openssl dgst -sha256 original.txt    # digest no longer matches -> modification detected
```

Verify a downloaded file against a published checksum:

```bash
sha256sum kali-linux-*.7z            # compare with the value on the official page
```

## 4. Symmetric encryption with OpenSSL (AES-256-CBC)

```bash
printf 'Secret lab note\n' > plain.txt
openssl rand -hex 16 > demo.pass                       # random passphrase kept in a file
openssl enc -aes-256-cbc -pbkdf2 -salt -in plain.txt -out cipher.enc -pass file:demo.pass
openssl enc -d -aes-256-cbc -pbkdf2 -in cipher.enc -out decrypted.txt -pass file:demo.pass
cat decrypted.txt
```

Command explanation:

| Part | Meaning |
|------|---------|
| `enc` | OpenSSL's symmetric cipher tool |
| `-aes-256-cbc` | AES with a 256-bit key in CBC mode |
| `-pbkdf2` | Derive the key from the passphrase with PBKDF2 (much stronger than old defaults) |
| `-salt` | Random salt so identical inputs give different ciphertext |
| `-d` | Decrypt |
| `-pass file:…` | Read the passphrase from a file (avoids leaving it in shell history/process list; `-pass pass:…` is discouraged) |

Notes:

* A **wrong passphrase fails** with `bad decrypt`, typically.
* CBC provides confidentiality but **no authentication**: tampering may not be detected. Modern systems use authenticated modes (AES-GCM, ChaCha20-Poly1305), which the simple `openssl enc` tool does not support.
* Keep passphrase files private (`chmod 600`) and never commit them (`.gitignore` excludes `*.pass`, `*.key`, `*.pem`, `*.enc`).

## 5. Asymmetric cryptography with OpenSSL (RSA)

```bash
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
chmod 600 private.pem
openssl pkey -in private.pem -pubout -out public.pem

printf 'short asymmetric message' > small.txt
openssl pkeyutl -encrypt -pubin -inkey public.pem -pkeyopt rsa_padding_mode:oaep -in small.txt -out small.enc
openssl pkeyutl -decrypt -inkey private.pem -pkeyopt rsa_padding_mode:oaep -in small.enc -out small.dec
cat small.dec
```

* The **public** key encrypts; only the **private** key decrypts.
* RSA can only encrypt data smaller than the key size (minus padding), so it is used for short secrets such as symmetric keys.
* **OAEP** padding is the modern recommended mode for RSA encryption.
* Never share `private.pem`. Anyone can have `public.pem`.

## 6. Digital signatures

A signature proves who produced a message and that it was not altered. The sender signs the **hash** of the message with the **private** key; anyone verifies with the **public** key.

```bash
printf 'Contract v1' > doc.txt
openssl dgst -sha256 -sign private.pem -out doc.sig doc.txt
openssl dgst -sha256 -verify public.pem -signature doc.sig doc.txt        # -> Verified OK

printf 'Contract v2' > doc-tampered.txt
openssl dgst -sha256 -verify public.pem -signature doc.sig doc-tampered.txt   # -> Verification failure
```

Encryption vs signing: encryption protects *confidentiality* (public key in, private key out); signing protects *authenticity/integrity* (private key in, public key out).

## 7. Digital certificates

A certificate (X.509) is a signed document that says: **"this public key belongs to this subject."** Contents: subject, issuer, validity dates, public key, extensions (e.g. Subject Alternative Names), and the issuer's signature.

* A **Certificate Authority (CA)** vouches for identities. Browsers/OSes ship with trusted root CAs.
* **Chain of trust:** server certificate ← intermediate CA ← root CA (trusted anchor).
* A **self-signed** certificate vouches for itself; fine for local testing, not trusted by browsers by default.

Create and inspect a local self-signed certificate:

```bash
openssl req -x509 -newkey rsa:2048 -nodes -keyout cert.key -out cert.pem -days 30 \
  -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"
openssl x509 -in cert.pem -noout -subject -issuer -dates -fingerprint -sha256
openssl x509 -in cert.pem -noout -text | less
```

Fields to point out in the text output: `Issuer`, `Subject`, `Validity`, `Public Key Algorithm`, `X509v3 Subject Alternative Name`, `Signature Algorithm`.

## 8. SSL/TLS

SSL is obsolete; **TLS** (1.2 and especially 1.3) is the current protocol behind HTTPS. A simplified TLS 1.3 handshake:

1. **ClientHello** — supported versions/ciphers, key share.
2. **ServerHello** — chosen cipher, key share; server sends its **certificate** and proof it holds the private key.
3. Client **validates** the certificate (chain, dates, hostname).
4. Both sides derive **session keys** → everything after is symmetrically encrypted and authenticated.

Local demonstration (loopback only):

```bash
# Terminal 1 - throw-away TLS server on loopback
openssl s_server -accept 127.0.0.1:4433 -cert cert.pem -key cert.key -www

# Terminal 2 - client; -CAfile trusts only my own self-signed cert
openssl s_client -connect 127.0.0.1:4433 -CAfile cert.pem
```

Look for `Protocol`, `Cipher`, and `Verify return code: 0 (ok)` (it verifies because I told the client to trust my own certificate). Stop the server with `Ctrl+C`.

Wireshark tie-in: capture the loopback interface (`lo`) with filter `tls` to see the handshake records; the application data after the handshake is encrypted.

## 9. Common mistakes to avoid

* Calling hashing "encryption", or storing passwords with MD5/SHA-256 only.
* Using MD5 or SHA-1 for anything security-sensitive.
* Using the same key forever, or committing keys to Git.
* Ignoring certificate warnings.
* Rolling your own crypto — use vetted libraries.

## 10. Self-check

1. Why can't an attacker "decrypt" a SHA-256 hash? (No key; one-way function.)
2. Which key signs and which verifies? (Private signs; public verifies.)
3. Why does TLS use both asymmetric and symmetric crypto? (Key establishment/authentication vs fast bulk encryption.)
4. Why is MD5 unsuitable for certificates? (Collision attacks let attackers craft different inputs with the same hash.)
