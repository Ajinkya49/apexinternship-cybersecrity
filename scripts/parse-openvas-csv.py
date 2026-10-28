#!/usr/bin/env python3
"""parse-openvas-csv.py - summarise a REAL Greenbone/OpenVAS CSV export.

Export the report from the web UI (Scans -> Reports -> open report -> download as CSV).
This script only counts and tabulates what is in the file; it does not scan.

Severity bands (CVSS v3 qualitative scale):
    Critical 9.0-10.0 | High 7.0-8.9 | Medium 4.0-6.9 | Low 0.1-3.9 | Log/Info 0.0

Usage:
    python3 parse-openvas-csv.py report.csv [top_n]
"""
import csv
import sys
from collections import Counter


def band(score):
    if score >= 9.0:
        return "Critical"
    if score >= 7.0:
        return "High"
    if score >= 4.0:
        return "Medium"
    if score > 0.0:
        return "Low"
    return "Log/Info"


def pick(row, *names):
    """Case-insensitive column lookup with several possible header names."""
    lower = {k.strip().lower(): v for k, v in row.items() if k}
    for n in names:
        if n.lower() in lower:
            return (lower[n.lower()] or "").strip()
    return ""


def main(path, top_n=15):
    try:
        with open(path, newline="", encoding="utf-8-sig") as fh:
            rows = list(csv.DictReader(fh))
    except FileNotFoundError:
        sys.exit(f"File not found: {path}")
    if not rows:
        sys.exit("CSV has no data rows.")

    findings = []
    for r in rows:
        try:
            score = float(pick(r, "CVSS", "Severity") or 0)
        except ValueError:
            score = 0.0
        findings.append({
            "score": score,
            "band": band(score),
            "name": pick(r, "NVT Name", "Name", "Vulnerability"),
            "host": pick(r, "IP", "Host"),
            "port": pick(r, "Port", "Location"),
            "cves": pick(r, "CVEs", "CVE"),
            "solution": pick(r, "Solution Type", "Solution"),
        })

    counts = Counter(f["band"] for f in findings)
    print("# OpenVAS / Greenbone results summary (generated from CSV)\n")
    print(f"* Source file: `{path}`")
    print(f"* Total result rows: {len(findings)}\n")
    print("| Severity | Count |")
    print("|----------|-------|")
    for b in ["Critical", "High", "Medium", "Low", "Log/Info"]:
        print(f"| {b} | {counts.get(b, 0)} |")

    print(f"\n## Top {top_n} findings by score\n")
    print("| # | Score | Severity | Finding | Host:Port | CVEs | Solution type |")
    print("|---|-------|----------|---------|-----------|------|---------------|")
    for i, f in enumerate(sorted(findings, key=lambda x: -x["score"])[:top_n], 1):
        cves = f["cves"][:60] + ("..." if len(f["cves"]) > 60 else "")
        print(f"| {i} | {f['score']} | {f['band']} | {f['name'] or '-'} | "
              f"{f['host'] or '-'}:{f['port'] or '-'} | {cves or '-'} | {f['solution'] or '-'} |")

    print("\n> Scanner results can include false positives and informational items. "
          "Validate findings before reporting them as confirmed.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    main(sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 15)
