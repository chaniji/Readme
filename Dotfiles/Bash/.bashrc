export PATH="/usr/bin:$PATH"
# ==============================================================================
#  BASH CONFIGURATION (~/.bashrc)
# ==============================================================================
case $- in
*i*) ;;
*) return ;;
esac

# --- [ Environment & Paths ] ---
export PATH="$HOME/.local/bin:$PATH"

# --- [ Shell Options ] ---
shopt -s histappend
shopt -s checkwinsize

# --- [ History Configuration ] ---
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# --- [ Appearance & Prompt ] ---
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

PS1='\[\e[38;5;214m\]> \[\e[0m\]'
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
esac

# --- [ Tool Support: FZF ] ---
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && . /usr/share/doc/fzf/examples/key-bindings.bash

export FZF_CTRL_R_OPTS="
  --color=bg+:#3c3836,bg:#282828,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934
  --layout=reverse
  --border=rounded
  --prompt='❯ '
  --pointer='▶'
  --preview='echo {}' --preview-window=down:3:wrap
"

# FZF find file → open in nvim (Ctrl+F)
fzf-find-nvim() {
  local file
  file=$(fzf --preview="bat --color=always {}" --preview-window=right:50%:wrap)
  [ -n "$file" ] && nvim "$file"
}
bind -x '"\C-f": fzf-find-nvim'

# FZF ripgrep search → open in nvim (Ctrl+G)
fzf-rg-nvim() {
  local result file line
  result=$(rg --color=always --line-number --no-heading . |
    fzf --ansi --delimiter=: \
      --preview="bat --color=always --highlight-line {2} {1}" \
      --preview-window=right:50%:wrap)
  file=$(echo "$result" | awk -F: '{print $1}')
  line=$(echo "$result" | awk -F: '{print $2}')
  [ -n "$file" ] && nvim +"$line" "$file"
}
bind -x '"\C-g": fzf-rg-nvim'

# --- [ Zoxide (smart cd) ] ---
eval "$(zoxide init bash)"

cd() {
  if (($# == 0)); then
    builtin cd ~ || return
  elif [[ -d $1 ]]; then
    builtin cd "$1" || return
  else
    if ! z "$@"; then
      echo "Error: Directory not found"
      return 1
    fi
  fi
}

# --- [ Aliases ] ---
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias bat='batcat'
alias ls='eza --icons --group-directories-first --tree --level=2 --ignore-glob=".git|node_modules|target|__pycache__|dist|build"'
alias la='eza --icons --group-directories-first --tree --level=2 -a --ignore-glob=".git|node_modules|target|__pycache__|dist|build"'
alias ll='eza --icons --group-directories-first -la --git --header --time-style=relative --ignore-glob=".git|node_modules|target|__pycache__|dist|build"'

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# --- [ Completions ] ---
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# --- [ Nix ] ---
# --- [ Autostart: tmux ] ---
if [ -z "$TMUX" ]; then
  tmux attach || tmux new-session
fi

export PATH="$PATH:/opt/nvim/bin"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
