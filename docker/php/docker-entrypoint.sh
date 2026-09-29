#!/bin/sh
set -e

# Installe les dépendances au premier démarrage (backend monté en volume)
if [ -f composer.json ] && [ ! -f vendor/autoload.php ]; then
    composer install --prefer-dist --no-progress --no-interaction
fi

exec "$@"
