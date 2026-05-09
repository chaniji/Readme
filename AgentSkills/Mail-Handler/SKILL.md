---
name: mail-cli-setup
description: >
  Sets up a complete CLI mail system using isync (mbsync), notmuch, neomutt, and msmtp.
  Use this skill whenever a user wants to set up email in the terminal, read Gmail from CLI,
  send mail with attachments from command line, search/delete/manage mail locally, or
  build an agent that sends mail. Triggers on: "setup CLI mail", "terminal email", "mutt setup",
  "mbsync", "notmuch", "send mail from terminal", "read gmail in terminal", "mail agent".
---

# Mail CLI Setup Skill

A complete guide to setting up a local CLI mail system with Gmail.

## Tools Used

| Tool    | Purpose          | Package     |
|---------|------------------|-------------|
| mbsync  | Receive / Sync   | isync       |
| notmuch | Index / Search   | notmuch     |
| neomutt | Read / Manage    | neomutt     |
| msmtp   | Send             | msmtp       |

---

## PROCESS 1 — Check Available Packages

Before installing, check what's already on the system:

```bash
which mbsync && echo "mbsync ok" || echo "mbsync missing"
which notmuch && echo "notmuch ok" || echo "notmuch missing"
which neomutt && echo "neomutt ok" || echo "neomutt missing"
which msmtp && echo "msmtp ok" || echo "msmtp missing"
```

- If all present → skip to **PROCESS 3 (Setup)**
- If any missing → go to **PROCESS 2 (Install)**

---

## PROCESS 2 — Detect OS and Install

### Detect OS
```bash
cat /etc/os-release | grep ^ID=
```

### Ubuntu / Debian
```bash
sudo apt install isync notmuch neomutt msmtp msmtp-mta
```

### Arch Linux
```bash
sudo pacman -S isync notmuch neomutt msmtp
```

### Fedora / RHEL
```bash
sudo dnf install isync notmuch neomutt msmtp
```

### macOS
```bash
brew install isync notmuch neomutt msmtp
```

After install → go to **PROCESS 3 (Setup)**

---

## PROCESS 3 — Setup (Inputs Required)

Ask the user for:
1. **Gmail address** (e.g. user@gmail.com)
2. **App Password** — 16-char password from Google Account → Security → App Passwords
   - Tell user: spaces in app password must be removed (e.g. `abcd efgh ijkl mnop` → `abcdefghijklmnop`)
3. **Full name** (for display in emails)

Then generate all config files below.

---

## PROCESS 4 — Generate Config Files

### 4a — Create Mail Directory
```bash
mkdir -p ~/Mail
mkdir -p ~/.config/neomutt
```

### 4b — mbsync Config (Receive Mail)
File: `~/.mbsyncrc`
```
IMAPAccount gmail
Host imap.gmail.com
User {EMAIL}
Pass {APP_PASSWORD_NO_SPACES}
TLSType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt

IMAPStore gmail-remote
Account gmail

MaildirStore gmail-local
SubFolders Verbatim
Path ~/Mail/
Inbox ~/Mail/INBOX

Channel gmail
Far :gmail-remote:
Near :gmail-local:
Patterns * ![Gmail]/All Mail
Create Both
Expunge Both
SyncState *
```

### 4c — msmtp Config (Send Mail)
File: `~/.msmtprc`
```
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

account gmail
host           smtp.gmail.com
port           587
from           {EMAIL}
user           {EMAIL}
password       {APP_PASSWORD_NO_SPACES}

account default : gmail
```

Secure it:
```bash
chmod 600 ~/.msmtprc
```

### 4d — neomutt Config (Read & Manage)
File: `~/.config/neomutt/neomuttrc`
```
set realname = "{FULL_NAME}"
set from = "{EMAIL}"

set mbox_type = Maildir
set folder = ~/Mail
set spoolfile = ~/Mail/INBOX
set record = "~/Mail/[Gmail]/Sent Mail"
set trash = "~/Mail/[Gmail]/Trash"
set postponed = "~/Mail/[Gmail]/Drafts"

set sendmail = "/usr/bin/msmtp"
set sendmail_wait = 0

set sort = threads
set sort_aux = reverse-last-date-received
set index_format = "%4C %Z %{%b %d} %-15.15F %s"
```

---

## PROCESS 5 — First Sync & Index

```bash
# pull mail from Gmail
mbsync -a

# setup notmuch
notmuch setup
# Enter: name, email, mail path (~/Mail)

# fix notmuch mail path if needed
notmuch config set database.mail_root ~/Mail
notmuch config set database.path ~/Mail

# index all mail
notmuch new
```

---

## PROCESS 6 — Verify Setup

```bash
# count indexed mail
notmuch count tag:inbox

# open inbox
neomutt -f ~/Mail/INBOX

# test send
echo "Hello!" | msmtp {EMAIL}
```

---

## Daily Use Commands

### Sync New Mail
```bash
mbsync -a && notmuch new
```

### Read Mail
```bash
neomutt -f ~/Mail/INBOX
```

### Send Mail
```bash
echo "Body text" | msmtp -a gmail recipient@example.com
```

### Send with Attachment
```bash
echo "See attached" | neomutt -s "Subject" recipient@example.com -a ~/file.pdf
```

### Search Mail
```bash
notmuch search tag:unread
notmuch search from:someone@gmail.com
notmuch search subject:invoice
notmuch search date:today..
```

### Delete Mail (Local + Gmail)
```bash
# tag for deletion
notmuch tag +deleted from:spam@example.com

# delete files
notmuch search --output=files tag:deleted | xargs rm -f

# reindex and sync back to Gmail
notmuch new && mbsync -a
```

### Delete by Folder Directly
```bash
rm -f ~/Mail/INBOX/cur/filename
rm -f "~/Mail/[Gmail]/Sent Mail/cur/"*
mbsync -a
```

### Auto Sync Every 10 Minutes
```bash
crontab -e
# add:
*/10 * * * * mbsync -a && notmuch new
```

---

## neomutt Key Bindings

| Key   | Action              |
|-------|---------------------|
| j / k | move up / down      |
| Enter | open email          |
| r     | reply               |
| m     | compose new         |
| d     | delete              |
| D     | delete by pattern   |
| $     | sync changes        |
| /     | search              |
| q     | back / quit         |
| ?     | help                |

### Delete Patterns in neomutt
Press `D` then type:
```
~f amazon         # from amazon
~s newsletter     # subject contains newsletter
~d >30d           # older than 30 days
~d >1y            # older than 1 year
```

---

## Common Errors & Fixes

| Error | Fix |
|-------|-----|
| `excess token` in mbsync | Remove spaces from app password |
| `SSLType is deprecated` | Use `TLSType` instead of `SSLType` |
| `cannot load config file` notmuch | Run `notmuch setup` or set mail_root manually |
| `Xapian exception` in notmuch search | Use `ls ~/Mail/folder/` directly instead |
| Gmail blocks login | Enable IMAP in Gmail Settings → Forwarding and POP/IMAP |

---

## Important Notes

- **App Password**: Generate at Google Account → Security → 2-Step Verification → App Passwords
- **Remove spaces** from app password before pasting into config files
- **Enable IMAP** in Gmail settings or mbsync will fail
- **chmod 600** on `.msmtprc` is required for msmtp to work
- `.uidvalidity` and `.mbsyncstate` warning messages from notmuch are normal — not errors
