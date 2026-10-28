# Linux Command Cheat Sheet

Safe, beginner-oriented reference for Kali/Debian. Practice inside a throw-away directory so nothing important is touched:

```bash
mkdir -p ~/lab-practice && cd ~/lab-practice
```

Permissions get their own page: [linux-permissions.md](linux-permissions.md).

## 1. Navigation and files

| Command | Syntax | Purpose | Safe example |
|---------|--------|---------|--------------|
| `pwd` | `pwd` | Print current directory | `pwd` |
| `ls` | `ls [options] [path]` | List directory contents (`-l` long, `-a` hidden, `-h` human sizes) | `ls -lah` |
| `cd` | `cd [path]` | Change directory (`cd ..` up, `cd ~` home, `cd -` previous) | `cd /etc` |
| `mkdir` | `mkdir [-p] dir` | Create directory (`-p` creates parents) | `mkdir -p notes/day1` |
| `touch` | `touch file` | Create empty file / update timestamp | `touch notes/day1/log.txt` |
| `cat` | `cat file` | Print a whole file | `cat /etc/os-release` |
| `less` | `less file` | Page through a file (`q` quit, `/word` search) | `less /etc/services` |
| `head` / `tail` | `head -n N file` | First / last N lines (`tail -f` follows) | `tail -n 5 /var/log/dpkg.log` |
| `cp` | `cp [-r] src dst` | Copy (`-r` for directories) | `cp log.txt log.bak` |
| `mv` | `mv src dst` | Move or rename | `mv log.bak old-log.txt` |
| `rm` | `rm [-i] file` | Delete. **No recycle bin.** Use `-i` to be asked first | `rm -i old-log.txt` |
| `find` | `find path -name 'pat'` | Search by name/type/size/time | `find ~/lab-practice -name '*.txt'` |
| `grep` | `grep [-ri] 'text' path` | Search inside files (`-r` recursive, `-i` ignore case, `-n` line numbers) | `grep -n 'PRETTY_NAME' /etc/os-release` |
| `wc` | `wc -l file` | Count lines/words | `wc -l /etc/passwd` |
| `echo` | `echo text > file` | Print text; `>` overwrites, `>>` appends | `echo "day1 notes" >> notes/day1/log.txt` |

> ⚠️ Be careful with `rm -r` and wildcards. Never run `rm -rf` on a path you have not printed with `ls` first. This cheat sheet only deletes files inside `~/lab-practice`.

## 2. Permissions and ownership

| Command | Syntax | Purpose | Safe example |
|---------|--------|---------|--------------|
| `chmod` | `chmod mode file` | Change permissions (symbolic `u+x` or octal `640`) | `chmod 640 notes/day1/log.txt` |
| `chown` | `sudo chown user:group file` | Change owner/group (needs root) | `sudo chown $USER:$USER notes/day1/log.txt` |
| `umask` | `umask` | Show default permission mask | `umask` |
| `id` | `id` | Show user, UID, groups | `id` |
| `whoami` | `whoami` | Current user name | `whoami` |
| `sudo` | `sudo command` | Run one command as root | `sudo whoami` |

Details and worked examples: [linux-permissions.md](linux-permissions.md).

## 3. Processes and services

| Command | Syntax | Purpose | Safe example |
|---------|--------|---------|--------------|
| `ps` | `ps aux` | Snapshot of processes | `ps aux \| head` |
| `top` | `top` | Live process view (`q` quits) | `top` |
| `htop` | `htop` | Friendlier `top` (if installed) | `htop` |
| `systemctl` | `systemctl status\|start\|stop <svc>` | Manage services | `systemctl status ssh` |
| `journalctl` | `journalctl -u <svc> -n 20` | Read service logs | `journalctl -u ssh -n 20` |
| `kill` | `kill PID` | Ask a process to stop (SIGTERM) | only on a process *you* started, e.g. a `sleep 300 &` |

Check before stopping/starting services: stopping the wrong one can break networking or your session.

## 3b. System information

| Command | Syntax | Purpose | Safe example |
|---------|--------|---------|--------------|
| `hostname` | `hostname` | Machine name | `hostname` |
| `uname` | `uname -a` | Kernel/architecture | `uname -a` |
| `uptime` | `uptime` | Time since boot, load | `uptime` |
| `df` | `df -h` | Disk space | `df -h` |
| `free` | `free -h` | Memory use | `free -h` |
| `date` | `date` | Current date/time | `date` |
| `man` | `man cmd` | Manual page | `man ls` |
| `history` | `history` | Previously used commands | `history \| tail` |

## 4. Package management (Debian/Kali)

| Command | Purpose | Safe example |
|---------|---------|--------------|
| `sudo apt update` | Refresh package lists | `sudo apt update` |
| `apt list --upgradable` | Show available upgrades | `apt list --upgradable` |
| `sudo apt upgrade` | Install available upgrades | `sudo apt upgrade` |
| `apt search term` | Search packages | `apt search nmap` |
| `apt show pkg` | Package details | `apt show nmap` |
| `sudo apt install pkg` | Install a package | `sudo apt install tree` |
| `sudo apt remove pkg` | Remove a package (keeps config) | `sudo apt remove tree` |
| `dpkg -l` | List installed packages | `dpkg -l \| grep nmap` |
| `dpkg -L pkg` | Files installed by a package | `dpkg -L nmap \| head` |
| `dpkg -S /path` | Which package owns a file | `dpkg -S /usr/bin/nmap` |
| `dpkg -s pkg` | Installation status/version | `dpkg -s openssl` |
| `sudo dpkg -i file.deb` | Install a local `.deb` | only from trusted sources |

`apt` resolves dependencies and downloads from repositories; `dpkg` works on individual `.deb` packages and does not fetch dependencies.

## 5. Networking

| Command | Syntax | Purpose | Safe example |
|---------|--------|---------|--------------|
| `ip addr` | `ip -br addr` | Interfaces and addresses (modern replacement for `ifconfig`) | `ip -br addr` |
| `ifconfig` | `ifconfig [iface]` | Legacy interface info (package `net-tools`) | `ifconfig eth1` |
| `ip route` | `ip route` | Routing table | `ip route` |
| `ip neigh` | `ip neigh` | ARP/neighbour cache | `ip neigh` |
| `ping` | `ping -c N host` | ICMP reachability and RTT | `ping -c 4 127.0.0.1` / `ping -c 4 192.168.56.20` |
| `ss` | `ss -tuln` | Listening sockets (replacement for `netstat`) | `ss -tuln` |
| `netstat` | `netstat -tuln` | Legacy socket listing (`net-tools`) | `netstat -tuln` |
| `traceroute` | `traceroute -n host` | Hop-by-hop path (UDP/ICMP probes with rising TTL) | `traceroute -n 192.168.56.20` |
| `tracepath` | `tracepath host` | Similar, no root needed | `tracepath 192.168.56.20` |
| `hostname -I` | `hostname -I` | All IPv4 addresses | `hostname -I` |
| `getent hosts` | `getent hosts name` | Resolve a name using system config | `getent hosts localhost` |

Useful `ss` flags: `-t` TCP, `-u` UDP, `-l` listening, `-n` numeric, `-p` show process (needs `sudo`). Example: `sudo ss -tulnp`.

**Lab rule:** only ping/traceroute/scan `127.0.0.1` and `192.168.56.0/24` lab machines.

## 6. Text processing and pipes

```bash
cat /etc/passwd | cut -d: -f1 | sort | head   # usernames, sorted, first 10
grep -c 'bash' /etc/passwd                      # count lines mentioning bash
ls -l | wc -l                                   # count entries
command > out.txt 2> err.txt                    # stdout and stderr to files
command | tee out.txt                           # show AND save output (useful for evidence)
```

`tee` is handy for evidence: `ip -br addr | tee ~/evidence-ip.txt`.

## 7. Filesystem layout (FHS quick map)

| Path | Contents |
|------|----------|
| `/` | Root of everything |
| `/home` | User home directories |
| `/root` | Root user's home |
| `/etc` | System configuration |
| `/var/log` | Logs |
| `/usr/bin`, `/bin` | Programs |
| `/tmp` | Temporary files |
| `/dev`, `/proc`, `/sys` | Devices and kernel/process info (virtual) |
| `/opt` | Optional third-party software |

## 8. Safe practice sequence (copy/paste)

```bash
mkdir -p ~/lab-practice/notes && cd ~/lab-practice
echo "hello lab" > notes/hello.txt
ls -l notes
cp notes/hello.txt notes/hello.bak
mv notes/hello.bak notes/hello-copy.txt
find . -name '*.txt'
grep -n 'hello' notes/*.txt
chmod 600 notes/hello.txt && ls -l notes/hello.txt
rm -i notes/hello-copy.txt
```

📸 Evidence: `12-linux-commands.png` (terminal with navigation/search commands), `13-package-management.png` (`apt`/`dpkg` output).
