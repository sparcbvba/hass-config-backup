#!/bin/bash

echo "[Info] GitHub Config Backup Add-on start..."

# Lees de instellingen uit Home Assistant
CONFIG_PATH=/data/options.json
REPO=$(jq --raw-output '.github_repo' $CONFIG_PATH)
TOKEN=$(jq --raw-output '.github_token' $CONFIG_PATH)
NAME=$(jq --raw-output '.git_name' $CONFIG_PATH)
EMAIL=$(jq --raw-output '.git_email' $CONFIG_PATH)
INTERVAL=$(jq --raw-output '.commit_interval' $CONFIG_PATH)

# Bouw de URL op inclusief het authenticatietoken
# Let op: Dit vervangt 'https://' door 'https://TOKEN@'
AUTH_REPO="${REPO/https:\/\//https://${TOKEN}@}"

# Ga naar de Home Assistant config map
cd /config || exit 1

# Stel Git in
git config --global user.name "${NAME}"
git config --global user.email "${EMAIL}"
git config --global --add safe.directory /config

# Check of de map al een git repository is
if [ ! -d ".git" ]; then
    echo "[Info] Git repository initialiseren..."
    git init
    git remote add origin "${AUTH_REPO}"
    git branch -M main
else
    echo "[Info] Bestaande repository gevonden. Remote updaten..."
    git remote set-url origin "${AUTH_REPO}"
fi

git config pull.rebase false

echo "[Info] Automatische loop gestart. Controleert elke ${INTERVAL} seconden."

# Start de eindeloze loop
while true; do
    # 1. Haal EERST eventuele wijzigingen van GitHub binnen
    echo "[Info] Controleren op wijzigingen vanuit GitHub..."
    git pull origin main || echo "[Waarschuwing] Kon niet pullen, mogelijk een conflict of netwerkfout."

    # 2. Stage ALLEEN configuration.yaml en de template folder
    if [ -f "configuration.yaml" ]; then
        git add configuration.yaml
    fi
    
    if [ -d "integrations" ]; then
        git add integrations/
    fi

    # Check of de bestanden zijn gewijzigd
    if ! git diff --cached --quiet; then
        echo "[Info] Wijziging(en) gedetecteerd! Bezig met pushen naar GitHub..."
        git commit -m "Automatische backup: $(date +"%Y-%m-%d %H:%M:%S")"
        git push origin main
        echo "[Info] Succesvol gepusht."
    fi

    # Wacht het ingestelde interval (in seconden)
    sleep "${INTERVAL}"
done