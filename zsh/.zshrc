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

# Aktivera Solarized färger (Nu pekar vi på filen direkt)
if [[ -f "$HOME/.dir_colors" ]]; then
    eval "$(dircolors -b "$HOME/.dir_colors")"
fi

alias ls='ls --color=auto'

# Aktivera fzf
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
alias media="ssh media"
alias 3145="ssh 3145"
alias proxmox="ssh proxmox"

alias ubuntuserver="ssh thomas@192.168.122.7 -p 22456"
alias fedoraserver="ssh thomas@192.168.122.41 -p 22456"

# DevOps Docker-genvägar
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlogs="docker logs -f"
alias dclean="docker system prune -af --volumes"

# lazydocker & lazygit
alias lg="lazygit"
alias ld="lazydocker"
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


function myip() {
    # Hämta lokal IP snabbt
    local L_IP=$(hostname -I | awk '{print $1}')

    # Hämta Tailscale IP (tystar felmeddelanden om tailscale inte är igång)
    local TS_IP=$(tailscale ip -4 2>/dev/null || echo "Ej aktiv")

    # Hämta publik IP men med en extremt kort timeout (1 sekund)
    local P_IP=$(curl -s --max-time 1 https://ifconfig.me || echo "Offline/Timeout")

    echo -e "\e[1;34m╭─ Webb & Nätverk ───────────────────────────╮\e[0m"
    echo -e "\e[1;34m│\e[0m  \e[32m󰩟 Lokal IP:\e[0m   $L_IP"
    echo -e "\e[1;34m│\e[0m  \e[36m󰖂 Tailscale:\e[0m  $TS_IP"
    echo -e "\e[1;34m│\e[0m  \e[35m󰖟 Publik IP:\e[0m  $P_IP"
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
            *.tar)       tar x f $1      ;;
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

    # Senaste systemuppdatering (Hämtas från din nya timer)
    local LAST_UPDATE=$(systemctl show daily-update.service --property=InactiveExitTimestamp --value)
    if [[ -n "$LAST_UPDATE" && "$LAST_UPDATE" != "n/a" ]]; then
        echo -e "\e[35m󰚰 Senaste update:\e[0m $LAST_UPDATE"
    fi



# CPU Temperatur (Uppdaterad för din hårdvara)
    local TEMP=""

    # 1. Försök använda 'sensors' för att hitta "Package id 0" (Din CPU)
    if command -v sensors &> /dev/null; then
        TEMP=$(sensors | awk '/Package id 0/ {print $4}' | tr -d '+')
    fi

    # 2. Fallback: Om sensors misslyckas, läs från filsystemet
    if [[ -z "$TEMP" ]]; then
        if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
            local TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp)
            TEMP="$((TEMP_RAW / 1000))°C"
        else
            TEMP="N/A"
        fi
    fi

    echo -e "\e[31m CPU Temp:\e[0m       $TEMP"






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


# Visa alla öppna portar och vilka program som kör dem
alias ports="sudo lsof -i -P -n | grep LISTEN"


# Skicka fil till homelab-server (Användning: send fil.txt <3145> eller <media>)
function send() {
    if [ $# -ne 2 ]; then
        echo "Användning: send [fil] [server-alias]"
        return 1
    fi

    local FILE=$1
    local SERVER=$2

    echo -e "\e[34m📤 Skickar $FILE till $SERVER...\e[0m"
    # scp använder samma inställningar som ssh, så dina alias fungerar!
    scp "$FILE" "$SERVER:~/"

    if [ $? -eq 0 ]; then
        echo -e "\e[32m✅ Klar! Filen ligger i hemkatalogen på $SERVER\e[0m"
    else
        echo -e "\e[31m❌ Något gick fel vid överföringen.\e[0m"
    fi
}
