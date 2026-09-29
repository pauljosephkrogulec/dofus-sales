#!/bin/sh
set -e

# Tant que le frontend n'est pas initialisé (issue #4), on garde le conteneur
# en vie au lieu de le faire échouer, pour que `docker compose up` reste vert.
if [ ! -f package.json ]; then
    echo "frontend/package.json introuvable : frontend pas encore initialisé."
    exec tail -f /dev/null
fi

# node_modules vit dans un volume nommé : (ré)installer si vide
if [ ! -d node_modules/.bin ]; then
    npm install --no-audit --no-fund
fi

exec "$@"
