# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# ── aliases ────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias cl='clear'
alias yz='yazi'

# Agent cli
alias hm='hermes'
alias hp='hermes --profile'

# fetch
alias ft='fastfetch'

# 替代 ls（eza）
alias ls='eza --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
# lt [层数] — 默认2层
lt() { eza --tree --icons --level="${1:-2}" }

# 替代 cat（bat）
alias cat='bat'

# 替代 find（fd）
alias fde='fd -e'

# tmux
alias tmux='tmux -u'
alias tm='tmux -u'
alias t='tmux -u'
alias tn='tmux -u new -s'
alias tat='tmux attach -t'
alias ta='tmux attach'
alias tl='tmux ls'
alias tka='tmux kill-server'
alias tkt='tmux kill-session -t'

# ── Powerlevel10k config ──────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── PATH ──────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── zoxide（智能 cd）──────────────────────────────────────
eval "$(zoxide init zsh)"

# ── fzf 按键绑定和补全 ───────────────────────────────────
source <(fzf --zsh)

# ── tmux 自动 attach ──────────────────────────────────────
# 本地终端自动进入 tmux（如果有已有 session 就 attach）
if [[ -z "$TMUX" ]] && [[ -z "$SSH_CONNECTION" ]]; then
  tmux attach 2>/dev/null || tmux
fi
