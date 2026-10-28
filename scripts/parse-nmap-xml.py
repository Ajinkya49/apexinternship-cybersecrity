#!/usr/bin/env python3
"""parse-nmap-xml.py - turn a REAL Nmap XML file (-oX / -oA) into a Markdown summary.

It only reformats what Nmap recorded. It does not scan anything and it does not
invent results. If a field is missing from the XML it prints "-".

Usage:
    python3 parse-nmap-xml.py scan.xml            # prints Markdown
    python3 parse-nmap-xml.py scan.xml > out.md   # save it
"""
import sys
import xml.etree.ElementTree as ET


def val(x, default="-"):
    return x if x not in (None, "") else default


def main(path):
    try:
        root = ET.parse(path).getroot()
    except (ET.ParseError, FileNotFoundError) as exc:
        sys.exit(f"Cannot read {path}: {exc}")

    print("# Nmap scan summary (generated from XML)\n")
    print(f"* Source file: `{path}`")
    print(f"* Nmap version: `{val(root.get('version'))}`")
    print(f"* Command line: `{val(root.get('args'))}`")
    print(f"* Scan started: `{val(root.get('startstr'))}`")
    fin = root.find("runstats/finished")
    if fin is not None:
        print(f"* Scan finished: `{val(fin.get('timestr'))}` ({val(fin.get('elapsed'))} s)")
        print(f"* Summary line: {val(fin.get('summary'))}")
    print()

    hosts = root.findall("host")
    if not hosts:
        print("_No hosts recorded in this file._")
        return

    for host in hosts:
        status = host.find("status")
        addrs = [a.get("addr") for a in host.findall("address") if a.get("addrtype") in ("ipv4", "ipv6")]
        macs = [f"{a.get('addr')} ({val(a.get('vendor'))})" for a in host.findall("address") if a.get("addrtype") == "mac"]
        names = [h.get("name") for h in host.findall("hostnames/hostname")]
        print(f"## Host {', '.join(addrs) or '-'}\n")
        print(f"* State: **{val(status.get('state') if status is not None else None)}**")
        if names:
            print(f"* Hostnames: {', '.join(names)}")
        if macs:
            print(f"* MAC: {', '.join(macs)}")
        print()

        ports = host.findall("ports/port")
        if ports:
            print("| Port | Proto | State | Service | Product / version | Extra info |")
            print("|------|-------|-------|---------|-------------------|------------|")
            counts = {}
            for p in ports:
                st = p.find("state")
                sv = p.find("service")
                state = val(st.get("state") if st is not None else None)
                counts[state] = counts.get(state, 0) + 1
                prod = " ".join(x for x in [sv.get("product") if sv is not None else None,
                                            sv.get("version") if sv is not None else None] if x) or "-"
                print(f"| {p.get('portid')} | {p.get('protocol')} | {state} | "
                      f"{val(sv.get('name') if sv is not None else None)} | {prod} | "
                      f"{val(sv.get('extrainfo') if sv is not None else None)} |")
            print()
            print("Port state counts: " + ", ".join(f"{k}: {v}" for k, v in sorted(counts.items())))
            extra = host.find("ports/extraports")
            if extra is not None:
                print(f"\nNot shown: {extra.get('count')} ports in state `{extra.get('state')}`.")
        else:
            print("_No port information recorded._")
        print()

        matches = host.findall("os/osmatch")
        if matches:
            print("**OS detection guesses (Nmap's estimate, not a certainty):**\n")
            for m in matches[:3]:
                print(f"* {m.get('name')} (accuracy {m.get('accuracy')}%)")
            print()
        elif host.find("os") is not None:
            print("_OS detection ran but produced no confident match._\n")

        print("> These are observations reported by Nmap. A version banner or open port "
              "is not proof of a vulnerability.\n")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    main(sys.argv[1])
