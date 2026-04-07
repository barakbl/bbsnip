# =============================================================================
# bbsnip ZSH Completion Plugin
# Provides tab completion for the bbsnip command.
#
# Usage: source /path/to/bbsnip.plugin.zsh
# =============================================================================

: ${ALFRED_SNIPPETS_DIR:="$HOME/Library/Application Support/Alfred/Alfred.alfredpreferences/snippets"}
: ${BBSNIP_SNIPPETS_DIR:="$HOME/.config/bbsnip/snippets"}

_bbsnip_comp_keywords() {
  local collection="$1"
  for base in "$ALFRED_SNIPPETS_DIR" "$BBSNIP_SNIPPETS_DIR"; do
    local dir="$base"
    [[ -n "$collection" ]] && dir="$dir/$collection"
    [[ -d "$dir" ]] || continue
    find "$dir" -name '*.json' ! -name 'info.plist' 2>/dev/null | while IFS= read -r f; do
      jq -r '.alfredsnippet.keyword // empty' "$f" 2>/dev/null
    done
  done | sort -u
}

_bbsnip_comp_collections() {
  local found=false
  for base in "$ALFRED_SNIPPETS_DIR" "$BBSNIP_SNIPPETS_DIR"; do
    [[ -d "$base" ]] || continue
    found=true
    for d in "$base"/*(N/); do
      basename "$d"
    done
  done | sort -u
  $found || return 1
}

_bbsnip() {
  local -a subcmds
  subcmds=(
    'search:Fuzzy search snippets with fzf'
    'new:Create a new snippet (interactive)'
    'list:List all snippets'
    'show:Show snippet content'
    'copy:Copy snippet to clipboard'
    'paste:Print snippet and copy to clipboard'
    'export:Export snippets as JSON'
    'history:Browse and re-run past commands'
    'collections:List available collections'
    'help:Show help'
  )

  _arguments -C \
    '-h[Show help]' \
    '--help[Show help]' \
    '--clipboard-only[Copy to clipboard only, no stdout]' \
    '-c[Filter by collection]:collection:($(_bbsnip_comp_collections))' \
    '1:command:->cmd' \
    '*::arg:->args'

  case "$state" in
    cmd)
      _describe 'command' subcmds
      ;;
    args)
      case "${words[1]}" in
        show|copy|paste)
          _arguments \
            '-h[Show help]' \
            '--help[Show help]' \
            '-c[Filter by collection]:collection:($(_bbsnip_comp_collections))' \
            '1:keyword:($(_bbsnip_comp_keywords))'
          ;;
        new|history)
          _arguments \
            '-h[Show help]' \
            '--help[Show help]'
          ;;
        list|search|export)
          _arguments \
            '-h[Show help]' \
            '--help[Show help]' \
            '-c[Filter by collection]:collection:($(_bbsnip_comp_collections))'
          ;;
      esac
      ;;
  esac
}

compdef _bbsnip bbsnip
