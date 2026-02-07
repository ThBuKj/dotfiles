#!/bin/bash
# Stoppa scriptet omedelbart om ett kommando misslyckas
set -e

# Kontrollera om GitHub CLI ('gh') är installerat
if ! command -v gh &> /dev/null; then
    echo "Fel: GitHub CLI ('gh') är inte installerat."
    echo "För att använda den automatiska GitHub-funktionen, installera det först med:"
    echo "sudo apt/dnf install gh && gh auth login"
    exit 1
fi

# Steg 1: Fråga efter och navigera till rätt plats
read -r -p "Ange sökväg för projektet: " -e -i "$HOME/Python" PROJECT_PATH

if [ ! -d "$PROJECT_PATH" ]; then
    echo "Fel: Mappen '$PROJECT_PATH' finns inte. Skapa den först."
    exit 1
fi

echo "Navigerar till \"$PROJECT_PATH\"..."
cd "$PROJECT_PATH"

# Steg 2: Fråga efter projektnamn
read -r -p "Vad ska projektet heta? " PROJEKTNAMN

if [ -z "$PROJEKTNAMN" ]; then
    echo "Fel: Inget projektnamn angavs. Avbryter."
    exit 1
fi

if [ -d "$PROJEKTNAMN" ]; then
    echo "Fel: Mappen '$PROJEKTNAMN' finns redan i '$PROJECT_PATH'. Avbryter."
    exit 1
fi

# Steg 3: Skapa projektmapp och gå in i den
echo "Skapar projektet \"$PROJEKTNAMN\"..."
mkdir "$PROJEKTNAMN"
cd "$PROJEKTNAMN"

# Steg 4: Initiera Git och gör första commit (VI FLYTTAR COMMIT TILL SENARE)
echo "Initierar Git-repository..."
git init -b main

# Steg 5: Skapa mappstruktur och tomma filer
echo "Skapar mappstruktur och filer..."
mkdir -p src tests
touch README.md .gitignore requirements.txt main.py src/__init__.py tests/test_kod.py

# Steg 6: Fyll .gitignore
echo "Skapar .gitignore..."
{
    echo ".venv/"
    echo "__pycache__/"
    echo ".vscode/"
    echo ".idea/"
    echo ".env"
} > .gitignore

# Steg 7: Fyll requirements.txt
touch requirements.txt

# Steg 8: Fyll README.md
echo "Skapar README.md..."
{
    echo "# $PROJEKTNAMN"
    echo ""
    echo "En kort beskrivning av vad det här projektet gör."
} > README.md

# Steg 9: Skapa virtuell miljö
echo "Skapar virtuell miljö..."
python3 -m venv .venv

# Steg 10: Lägg till filer och gör första commit
echo "Gör första commit..."
git add .
git commit -m "Initial commit: Skapa projektstruktur"

# --- NYTT AUTOMATISKT STEG ---
# Steg 11: Skapa GitHub repo och ladda upp koden
echo ""
read -r -p "Vill du skapa ett GitHub repository för '$PROJEKTNAMN'? (j/n) " CREATE_REPO
if [[ "$CREATE_REPO" =~ ^[Jj]$ ]]; then
    
    read -p "Ska repot vara 'public' eller 'private'? " REPO_VISIBILITY
    
    if [ "$REPO_VISIBILITY" != "public" ] && [ "$REPO_VISIBILITY" != "private" ]; then
        echo "Ogiltigt val. Välj 'public' eller 'private'. Avbryter."
        exit 1
    fi

    echo "Skapar ett $REPO_VISIBILITY repository på GitHub..."
    # Detta kommando gör allt: skapar repo, lägger till remote och pushar
    gh repo create "$PROJEKTNAMN" --"$REPO_VISIBILITY" --source=. --push
    
    echo ""
    echo "-----------------------------------------------------"
    echo " Klart! Projektet är skapat lokalt OCH på GitHub!"
    echo " URL: $(gh repo view --json url -q .url)"
    echo "-----------------------------------------------------"
else
    echo ""
    echo "-----------------------------------------------------"
    echo " Klart! Projektet '$PROJEKTNAMN' är skapat lokalt."
    echo "-----------------------------------------------------"
fi

echo ""
echo "ATT GÖRA NU:"
echo ""
echo "1. Aktivera den virtuella miljön:"
echo "   source .venv/bin/activate"
echo ""
echo "2. Börja koda!"
echo ""
