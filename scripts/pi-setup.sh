# Installationsscript för shell-setup på Raspberry Pi OS Lite

set -e  # Avsluta vid fel

echo "=== Uppdaterar paketlistan ==="
sudo apt update

echo "=== Installerar zsh, micro och tree ==="
sudo apt install -y zsh micro tree

echo "=== Installerar Oh My Zsh ==="
# Kolla om oh-my-zsh redan finns
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh är redan installerat, hoppar över..."
else
    # Installera utan att byta shell automatiskt (vi gör det efteråt)
    sh -c "$(curl -fsSL
https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "=== Lägger till custom config i .zshrc ==="
# Lägg till custom-inställningar om de inte redan finns
if ! grep -q "CUSTOM CONFIG" "$HOME/.zshrc"; then
    cat >> "$HOME/.zshrc" << 'EOF'

# === CUSTOM CONFIG ===
PROMPT='%F{green}%m%f %F{magenta}%c:%f '      # PROMPT='%F{magenta}%m%f %F{green}%c:%f '
export EDITOR=micro
export VISUAL=micro
export PATH="$HOME/.local/bin:$PATH"
EOF
    echo "Custom config tillagd"
else
    echo "Custom config finns redan, hoppar över..."
fi

echo "=== Sätter zsh som default shell ==="
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s $(which zsh)
    echo "Zsh är nu din default shell (kräver ny inloggning)"
else
    echo "Zsh är redan default shell"
fi ~/.oh-my-zsh"

PROMPT='%F{green}%m%f %F{magenta}%c:

echo ""
echo "=== Klart! ==="
echo "Logga ut och in igen för att använda zsh"
  echo "Eller kör: exec zsh"
