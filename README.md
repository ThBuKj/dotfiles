# Dotfiles 🐧

Detta repository innehåller mina personliga konfigurationsfiler och scripts för en snabb och effektiv Linux-utvecklingsmiljö (Fedora).

Projektet fungerar främst som backup och referens, men är strukturerat för att enkelt kunna replikera min setup på nya system.

---

## 🛠 Systemöverblick

OS: Fedora Linux  
Skal: Zsh (med Oh My Zsh)  
Terminal: WezTerm (GPU-accelererad)  
Editor: VS Code & Micro (terminal)  
Hårdvara: Logitech MX Master 4 via logiops  

---

## 📁 Innehåll i zsh/

### .zshrc (hjärtat i setupen)

Min shell-konfiguration är optimerad för DevOps- och Python-utveckling.

### Funktioner

DevOps Dashboard  
Visar RAM, Disk och Docker-status varje gång terminalen öppnas.

Auto-venv  
Aktiverar Python `.venv` automatiskt när du går in i en projektmapp.

Anteckningssystem  
n [namn] – skapa/öppna markdown-anteckning i ~/notes  
ns [ord] – snabb sökning i alla anteckningar med ripgrep  
note – gå direkt till anteckningsmappen  

Nätverk  
myip – snygg vy av lokal och publik IP-adress.

Smart sök & navigation  
fzf (Ctrl+R) – fuzzy-sökning i historiken  
z – hoppa snabbt till mappar du ofta besöker  
extract – packa upp valfri komprimerad fil  
qs [ämne] – hämta cheat sheets direkt i terminalen  

Docker-alias  
dps – tabellvy över körande containrar  
dlogs – följ loggar  
dclean – städa bort oanvända containrar och volumes  

---

## 📁 Innehåll i config/

WezTerm (.wezterm.lua)  
Tema: Dracula (High Contrast)  
Alt + H/J – dela fönster  
Alt + Pilar – navigera mellan paneler  

VS Code (keybindings.json)  
Ctrl + Enter – kör Python-kod i terminalen  
Alt + H – split screen  
Alt + Pilar – navigera mellan flikar  

Micro (settings.json)  
Modern terminal-editor med Dracula-tema, sparad undo-historik och automatisk mappskapande.

Logitech (logid.cfg)  
Avancerad konfiguration för gester, tumhjul (volym) och snabb växling mellan workspaces.

---

## 📁 Innehåll i scripts/

create-python-projekt  

Bash-script som automatiserar start av nya Python-projekt:
- Skapar mappstruktur
- Initierar Git
- Skapar .venv
- Skapar GitHub-repo via gh CLI

---

## 🚀 Installation

### 1. Installera baspaket (Fedora)

sudo dnf install zsh micro ripgrep git gh logiops fzf

### 2. Länka konfigurationsfiler

cp ~/dotfiles/zsh/.zshrc ~/.zshrc  
ln -s ~/dotfiles/config/wezterm/.wezterm.lua ~/.wezterm.lua  
ln -s ~/dotfiles/config/micro/settings.json ~/.config/micro/settings.json  
ln -s ~/dotfiles/config/vscode/keybindings.json ~/.config/Code/User/keybindings.json  

### 3. Aktivera Logitech-gesturer (kräver sudo)

sudo ln -s ~/dotfiles/config/logitech/logid.cfg /etc/logid.cfg  
sudo systemctl enable --now logid  

### 4. Ladda om konfigurationen

source ~/.zshrc
