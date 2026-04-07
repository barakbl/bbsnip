<p align="center">
  <h1 align="center">✂️ bbsnip</h1>
  <p align="center">
    <strong>Your Alfred snippets, now in the terminal.</strong><br/>
    Fuzzy search, dynamic placeholders, clipboard magic — all from the command line. 🚀
  </p>
  <p align="center">
    <a href="#-install">Install</a> •
    <a href="#-quick-start">Quick Start</a> •
    <a href="#-commands">Commands</a> •
    <a href="#-placeholders">Placeholders</a> •
    <a href="#-use-cases">Use Cases</a> •
    <a href="#-uninstall">Uninstall</a>
  </p>
  <p align="center">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-BSD%203--Clause-blue.svg" alt="License: BSD 3-Clause"/></a>
  </p>
</p>

---

> ⚠️ **Disclaimer:** bbsnip is an **independent, community project**. It is **not affiliated with, endorsed by, or related to** [Alfred](https://www.alfredapp.com/) or Running with Crayons Ltd. Alfred is a registered trademark of Running with Crayons Ltd. bbsnip simply reads the Alfred snippet JSON format as a convenience.

---

## 🎬 What is bbsnip?

bbsnip is a ZSH CLI tool that lets you access, search, and expand text snippets directly from your terminal. It reads [Alfred app](https://www.alfredapp.com/) snippet collections **and** its own standalone snippet store — so you can use it with or without Alfred installed.

### ✨ Highlights

- 🔍 **Fuzzy search** with [fzf](https://github.com/junegunn/fzf) — find any snippet in milliseconds
- 📋 **Clipboard integration** — copy snippets with a keystroke
- 🧩 **Dynamic placeholders** — dates, clipboard, shell commands, user prompts, random values, and more
- 📥 **Pipe JSON via stdin** — extract fields with jq and inject them into templates
- 📦 **Collections** — organize snippets into groups
- 🆕 **Create snippets** from the terminal with an interactive wizard
- 🕒 **History** — browse and re-run past snippet commands
- ⚡ **Tab completion** — full zsh completion for commands, keywords, and collections
- 🏠 **Works standalone** — no Alfred required (uses `~/.config/bbsnip/snippets`)

---

## 📦 Install

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/barakbl/bbsnip/main/install | bash
```

This will:
1. Download `bbsnip` to `~/.local/bin/`
2. Set up the zsh tab completion plugin
3. Add the plugin source to your `~/.zshrc`

Then reload your shell:

```bash
source ~/.zshrc
```

### Manual install

```bash
git clone git@github.com:barakbl/bbsnip.git
cd bbsnip

# Copy the script somewhere on your PATH
cp bbsnip ~/.local/bin/bbsnip
chmod +x ~/.local/bin/bbsnip

# Add tab completion to your .zshrc
echo 'source /path/to/bbsnip.plugin.zsh' >> ~/.zshrc
```

### Dependencies

| Tool | Required | Install |
|------|----------|---------|
| `jq` | ✅ Yes | `brew install jq` |
| `fzf` | 🔶 For search/history | `brew install fzf` |
| `zsh` | ✅ Yes | (you're probably already here 😉) |

---

## 🚀 Quick Start

```bash
# Fuzzy search all your snippets
bbsnip

# List everything
bbsnip list

# Show a snippet by keyword
bbsnip show my_greeting

# Copy straight to clipboard
bbsnip copy my_greeting

# Create a new snippet interactively
bbsnip new
```

---

## 🛠️ Commands

| Command | Description | Example |
|---------|-------------|---------|
| `bbsnip` | Fuzzy search all snippets with fzf | `bbsnip` |
| `bbsnip search` | Same as above | `bbsnip -c emails` |
| `bbsnip list` | List all snippets in a table | `bbsnip list -c obsidian` |
| `bbsnip show <kw>` | Print snippet to stdout (+ clipboard) | `bbsnip show sig_work` |
| `bbsnip copy <kw>` | Copy snippet to clipboard only | `bbsnip copy sig_work` |
| `bbsnip paste <kw>` | Print to stdout AND copy to clipboard | `bbsnip paste sig_work` |
| `bbsnip new` | Interactive snippet creation wizard | `bbsnip new` |
| `bbsnip export` | Export all snippets as JSON | `bbsnip export > all.json` |
| `bbsnip history` | Browse past commands with fzf | `bbsnip history` |
| `bbsnip collections` | List available collections | `bbsnip collections` |
| `bbsnip help` | Show help | `bbsnip help` |

### Global flags

| Flag | Description |
|------|-------------|
| `--clipboard-only` | Copy to clipboard, suppress stdout |
| `-c <name>` | Filter by collection |

### fzf keybindings (in search mode)

| Key | Action |
|-----|--------|
| `Enter` | Print to stdout |
| `Ctrl-Y` | Copy to clipboard |

---

## 🧩 Placeholders

Snippets can contain dynamic placeholders that are expanded when you `show`, `copy`, `paste`, or `search`. They use the `{placeholder}` syntax.

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{date}` | Current date | `Apr 07, 2026` |
| `{time}` | Current time | `14:30:00` |
| `{datetime}` | Date + time | `Apr 07, 2026 14:30:00` |
| `{isodate}` | ISO date | `2026-04-07` |
| `{clipboard}` | Current clipboard content | *(whatever you copied)* |
| `{query}` | Prompts for user input | *(interactive)* |
| `{random:UUID}` | Random UUID | `a1b2c3d4-...` |
| `{random:1..100}` | Random number in range | `42` |
| `{snippet:other_kw}` | Embed another snippet | *(nested expansion)* |
| `{shell: command}` | Run a shell command (with confirmation) | `{shell: whoami}` |
| `{shell.VARNAME}` | Read an environment variable | `{shell.EDITOR}` → `vim` |
| `{stdin: .path}` | Extract from piped JSON via jq | `{stdin: .user.name}` |
| `{options: ["a","b","c"]}` | Pick from a list interactively | *(shows menu)* |

### 📅 Date arithmetic

Add or subtract time from date/time placeholders:

```
{date+7D}           → 7 days from now
{date-1M}           → 1 month ago
{datetime+2h+30m}   → 2 hours and 30 minutes from now
```

### 🎨 Modifiers

Chain modifiers to transform values:

```
{clipboard.uppercase}                → HELLO WORLD
{query.lowercase.trim}               → trimmed lowercase input
{date:long.capitals}                 → April 07, 2026
{stdin: .name.reverse}               → karab
{clipboard.stripnonalphanumeric}     → HelloWorld123
```

Available modifiers: `.uppercase` `.lowercase` `.capitals` `.trim` `.reverse` `.stripdiacritics` `.stripnonalphanumeric`

---

## 💡 Use Cases

### 🔧 DevOps — quick templates

Store your frequently-used commands as snippets and pipe in context:

```bash
# Snippet "k8s_debug" contains:
# kubectl describe pod {stdin: .metadata.name} -n {stdin: .metadata.namespace}

kubectl get pod my-pod -o json | bbsnip show k8s_debug
# → kubectl describe pod my-pod -n production
```

### 📧 Email signatures

```bash
# Snippet "sig_work" contains:
# Best regards,
# {shell.USER} | {date:long}

bbsnip copy sig_work
# Copies: "Best regards,\nbarak | April 07, 2026"
```

### 📝 Obsidian / Markdown callouts

```bash
# Snippet "callout_tip" contains:
# > [!tip] {query}
# > {clipboard}

bbsnip paste callout_tip
# Prompts for a title, wraps your clipboard in a callout block
```

### 🎲 Standup randomizer

```bash
# Snippet "standup_order" contains:
# Today's facilitator: {random:Alice,Bob,Charlie,Dana}

bbsnip show standup_order
# → Today's facilitator: Charlie
```

### 📋 Code review boilerplate

```bash
# Snippet "review_approve" contains:
# ✅ LGTM!
#
# Reviewed by {shell.USER} on {datetime:long}
# {options: ["No concerns","Minor nits — optional","Blocking feedback included"]}

bbsnip copy review_approve
# Interactive: pick your review status, copies formatted message
```

### 🔗 API response templates

```bash
# Snippet "user_summary" contains:
# User: {stdin: .name} ({stdin: .email})
# Role: {stdin: .role.uppercase}
# Last login: {stdin: .last_login}

curl -s https://api.example.com/users/42 | bbsnip show user_summary
# → User: Barak (barak@example.com)
# → Role: ADMIN
# → Last login: 2026-04-06T09:15:00Z
```

### 🆕 Creating snippets from the terminal

```bash
bbsnip new
```

The interactive wizard walks you through:

1. 📂 **Choose a vault** — Alfred snippets dir or bbsnip's own store
2. 📁 **Pick or create a collection** — fuzzy search existing ones
3. 🏷️ **Set a keyword** — the trigger you'll type to find it
4. 📝 **Enter content** — type it, paste from clipboard, go multiline, or open your `$EDITOR`

---

## ⚙️ Configuration

bbsnip works out of the box, but you can customize with environment variables:

```bash
# Alfred snippets directory (auto-detected)
export ALFRED_SNIPPETS_DIR="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/snippets"

# bbsnip's own snippet store
export BBSNIP_SNIPPETS_DIR="$HOME/.config/bbsnip/snippets"

# Max history entries (default: 200)
export BBSNIP_HIST_MAX=200
```

### 📂 Vaults

bbsnip searches **both** Alfred and bbsnip snippet directories together. When creating a new snippet with `bbsnip new`, you choose which vault to save to. No Alfred? No problem — bbsnip's standalone store works independently.

---

## 🗑️ Uninstall

### If installed via the install script

```bash
# Remove the binary
rm -f ~/.local/bin/bbsnip

# Remove the plugin and config
rm -rf ~/.config/bbsnip

# Remove the plugin source from .zshrc
# (delete the lines referencing bbsnip.plugin.zsh)
sed -i '' '/bbsnip/d' ~/.zshrc
```

### If installed manually

Remove the files from wherever you placed them and delete the source line from your `.zshrc`.

### Clean up history (optional)

```bash
rm -f ~/.config/bbsnip/history
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a PR.

---

## 📄 License

This project is licensed under the [BSD 3-Clause License](LICENSE).

---

<p align="center">
  Made with ☕ and a mass of <code>{placeholders}</code><br/>
  <strong>Happy snipping! ✂️</strong>
</p>
