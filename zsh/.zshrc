# =========================================================
# 1. OH-MY-ZSH SETUP
# =========================================================
export ZSH="$HOME/.oh-my-zsh"

# Tema (Används om du inte kör Starship)
ZSH_THEME="dracula"

# Gör så att tab-completion struntar i om det är bindestreck (-) eller understreck (_)
HYPHEN_INSENSITIVE="true"

# Uppdatera Oh My Zsh automatiskt utan att fråga
zstyle ':omz:update' mode auto

# Plugins
zstyle :omz:plugins:ssh-agent identities id_rsa_4096
plugins=(git ssh-agent z zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# =========================================================
# 2. GRUNDINSTÄLLNINGAR & PATH
# =========================================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=micro
export VISUAL=micro
export LANG=en_US.UTF-8

# Aktivera fzf (Fuzzy Finder) om installerat
source <(fzf --zsh)

# =========================================================
# 3. ALIAS (Genvägar)
# =========================================================
alias nano="micro"
alias rg="rg --smart-case"
alias reload="source ~/.zshrc && echo '🚀 Config laddad!'"
alias memtjuvar="ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 10"

# SSH Servrar
alias router="ssh router"
alias 3145="ssh -p 22456 thomas@192.168.10.10"
alias 3145-2="ssh -p 22456 thomas@192.168.10.11"
alias ubuntuserver="ssh thomas@192.168.122.7 -p 22456"
alias fedoraserver="ssh thomas@192.168.122.41 -p 22456"

# DevOps Docker-genvägar
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlogs="docker logs -f"
alias dclean="docker system prune -af --volumes"

# =========================================================
# 4. ANTECKNINGSSYSTEM (Notes)
# =========================================================
NOTES_DIR=~/notes

# Gå direkt till anteckningarna
alias note="mkdir -p $NOTES_DIR && cd $NOTES_DIR && ls"

# Snabbskapa: n "filnamn"
function n() {
    mkdir -p $NOTES_DIR
    micro "$NOTES_DIR/$1.md"
}

# Sök: ns "sökord"
function ns() {
    if command -v rg &> /dev/null; then
        rg -i "$1" $NOTES_DIR
    else
        grep -rni --color=auto "$1" $NOTES_DIR
    fi
}

# =========================================================
# 5. AUTOMATIK (Venv & Shell Hooks)
# =========================================================

# Auto-aktivera Python venv vid mappsökning
function chpwd() {
    if [ -d ".venv" ]; then
        if [[ "$VIRTUAL_ENV" == "" ]]; then
            source .venv/bin/activate
            echo "🐍 .venv aktiverad!"
        fi
    elif [[ "$VIRTUAL_ENV" != "" ]]; then
        if typeset -f deactivate > /dev/null; then
            deactivate
            echo "👋 .venv avaktiverad"
        fi
    fi
}
chpwd

# =========================================================
# 6. HJÄLPFUNKTIONER (DevOps & Nätverk)
# =========================================================

# Snyggare IP-koll
function myip() {
    local L_IP=$(hostname -I | awk '{print $1}')
    local P_IP=$(curl -s --max-time 2 https://ifconfig.me || echo "Offline")

    echo -e "\e[1;34m╭─ Webb & Nätverk ───────────────────────────╮\e[0m"
    echo -e "\e[1;34m│\e[0m  \e[32m󰩟 Lokal IP:\e[0m  $L_IP"
    echo -e "\e[1;34m│\e[0m  \e[35m󰖟 Publik IP:\e[0m $P_IP"
    echo -e "\e[1;34m╰────────────────────────────────────────────╯\e[0m"
}

# Packa upp allt
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' kan inte packas upp via extract()" ;;
        esac
    else
        echo "'$1' är inte en giltig fil"
    fi
}

# Snabbhjälp/Cheat sheets (t.ex: qs python eller qs tar)
function qs() {
    curl -s "https://cht.sh/$1" | less -R
}

# DevOps Dashboard vid start
function dashboard() {
    echo -e "\e[1;36m🚀 Systemstatus för $HOST\e[0m"

    # RAM-användning
    local RAM=$(free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }')
    echo -e "\e[33m󰍛 RAM-användning:\e[0m $RAM"

    # Diskutrymme (Root)
    local DISK=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "\e[34m󰋊 Diskutrymme:\e[0m    $DISK använt"

    # Docker-status
    if command -v docker &> /dev/null; then
        local D_RUNNING=$(docker ps -q | wc -l)
        if [ "$D_RUNNING" -gt 0 ]; then
            echo -e "\e[32m󰡨 Docker:\e[0m         $D_RUNNING containrar igång"
        else
            echo -e "\e[31m󰡨 Docker:\e[0m         Inga aktiva containrar"
        fi
    fi
    echo ""
}

# Kör dashboard vid interaktiv start
[[ $- == *i* ]] && dashboard
