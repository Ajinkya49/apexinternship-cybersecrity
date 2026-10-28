# Linux Permissions Explained

All examples run inside `~/lab-practice`. None are destructive.

```bash
mkdir -p ~/lab-practice/perm-demo && cd ~/lab-practice/perm-demo
```

## 1. Reading `ls -l`

```bash
echo "report draft" > report.txt
ls -l report.txt
```

Typical shape of the output (**expected example, not my captured result** — owner/date will differ):

```text
-rw-r--r-- 1 kali kali 13 Jan  1 10:00 report.txt
│└┬┘└┬┘└┬┘   │    │    │
│ │  │  │    │    │    └ size / date / name
│ │  │  │    │    └ group
│ │  │  │    └ owner
│ │  │  └ other (everyone else): r--
│ │  └ group: r--
│ └ owner (user): rw-
└ file type: - file, d directory, l symlink
```

| Letter | On a file | On a directory |
|--------|-----------|----------------|
| `r` (4) | read contents | list names inside |
| `w` (2) | modify contents | create/delete/rename entries inside |
| `x` (1) | execute as program | enter (`cd`) and access items inside |

Octal value = sum per class: `rw-` = 4+2 = **6**, `r--` = **4**, `r-x` = 5, `rwx` = 7, `---` = 0.

## 2. `chmod` — change permissions

**Symbolic:** who (`u` user/owner, `g` group, `o` other, `a` all) + operator (`+`, `-`, `=`) + permission.

```bash
chmod u+x report.txt       # give the owner execute
chmod go-r report.txt      # remove read from group and others
chmod a=r report.txt       # everyone read-only
ls -l report.txt
```

**Octal:**

```bash
chmod 600 report.txt       # rw-------  private file (owner only)
chmod 640 report.txt       # rw-r-----  owner rw, group read
chmod 644 report.txt       # rw-r--r--  typical document
chmod 700 report.txt       # rwx------  private script
chmod 755 report.txt       # rwxr-xr-x  typical shared program
```

## 3. Realistic scenarios

### 3.1 A private notes file

```bash
echo "lab IP plan: kali .10, meta2 .20" > ip-plan.txt
chmod 600 ip-plan.txt
ls -l ip-plan.txt          # -rw------- : only I can read/write
```

### 3.2 A script I want to run

```bash
printf '#!/bin/bash\necho "hello from script"\n' > hello.sh
ls -l hello.sh             # no x yet
./hello.sh                 # fails: Permission denied
chmod +x hello.sh
./hello.sh                 # now runs
```

The "Permission denied" you see in the third command is a *good thing to screenshot*: it shows permissions doing their job.

### 3.3 A shared project directory

```bash
mkdir shared
chmod 750 shared           # owner rwx, group r-x, others none
ls -ld shared              # drwxr-x---
```

Directories need `x` to be entered. A directory with `r` but no `x` lets you list names but not open files.

## 4. `chown` — change owner and group

Only root can give files to someone else, so `sudo` is required. Use your *own* account to keep it harmless:

```bash
sudo chown $USER:$USER report.txt     # owner and group set to me (no visible change if already so)
ls -l report.txt
id                                     # shows my user and groups
```

Syntax forms:

```bash
chown alice file         # owner only
chown alice:staff file   # owner and group
chown :staff file        # group only
chgrp staff file         # group only (alternative)
```

> Do not run `chown -R` on system directories such as `/etc` or `/usr`. It can break your OS.

## 5. Special bits (awareness only)

| Bit | Example | Meaning | Security note |
|-----|---------|---------|---------------|
| setuid (`4xxx`, `s` in user x) | `/usr/bin/passwd` | Runs as the file's owner | Misconfigured setuid root programs are a classic privilege-escalation path |
| setgid (`2xxx`) | shared directories | New files inherit the directory's group | Useful for team folders |
| sticky (`1xxx`, `t`) | `/tmp` | Only owner can delete their files in a shared dir | Prevents users deleting each other's temp files |

View them (read-only, harmless):

```bash
ls -l /usr/bin/passwd
ls -ld /tmp
```

## 6. Defensive habits

* Prefer `600/640/700/750` over `777`. **`chmod 777` gives everyone full control and is almost never correct.**
* Private keys must be `600` (OpenSSH and OpenSSL tooling often refuse looser modes).
* Give users the least access that lets them do their job.
* Review unexpected setuid files: `find / -perm -4000 -type f 2>/dev/null` (read-only listing; it only reads metadata).

## 7. Mini quiz

1. What does `-rwxr-x--- ` mean in octal? (Answer: 750)
2. Why can you not `cd` into a directory with mode `r--`? (No `x` bit)
3. Which command lets only you read a file? (`chmod 600 file`)

## 8. Cleanup

```bash
cd ~ && rm -r ~/lab-practice/perm-demo
```

(Safe: it only removes the demo folder created above. Double-check the path first with `ls ~/lab-practice`.)
