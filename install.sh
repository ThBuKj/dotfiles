#!/bin/bash
# =========================================================
# DOTFILES INSTALLER
# Skapar symlinks från ~/dotfiles till hemkatalogen
# =========================================================

set -e  # Avbryt vid fel

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Färger för output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╭─────────────────────────────────────────╮${NC}"
echo -e "${BLUE}│  🔗 Dotfiles Installer                 │${NC}"
echo -e "${BLUE}╰─────────────────────────────────────────╯${NC}\n"

# Funktion: Skapa symlink
link_file() {
    local source="$1"
    local target="$2"

    # Om target redan är en symlink till rätt plats, skippa
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo -e "${GREEN}✓${NC} $target (redan länkad)"
        return
    fi

    # Om target existerar (och inte är rätt symlink), backa upp
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}📦${NC} Backar upp: $target → $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    # Skapa symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓${NC} Länkad: $target → $source"
}

# =========================================================
# FILMAPPNINGAR (lägg till fler här!)
# =========================================================

echo -e "${BLUE}🔧 Skapar symlinks...${NC}\n"

# ZSH
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# WezTerm
link_file "$DOTFILES_DIR/config/wezterm/.wezterm.lua" "$HOME/.wezterm.lua"

# Micro editor (om den finns)
if [ -d "$DOTFILES_DIR/config/micro" ]; then
    link_file "$DOTFILES_DIR/config/micro" "$HOME/.config/micro"
fi

# Lägg till fler här efter behov:
# link_file "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
# link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# =========================================================
# SLUTRAPPORT
# =========================================================

echo -e "\n${GREEN}╭─────────────────────────────────────────╮${NC}"
echo -e "${GREEN}│  ✅ Installation klar!                  │${NC}"
echo -e "${GREEN}╰─────────────────────────────────────────╯${NC}\n"

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}📦 Backup skapad i:${NC} $BACKUP_DIR"
fi

echo -e "${BLUE}💡 Tips:${NC}"
echo -e "  • Ladda om zsh: ${YELLOW}source ~/.zshrc${NC}"
echo -e "  • WezTerm laddar om automatiskt"
echo -e "  • Lägg till fler filer i install.sh efter behov\n"
