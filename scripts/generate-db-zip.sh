#!/usr/bin/env zsh

echo "[veekun-pokedex] Creating Veekun DB in ./var/assets/src/veekun-pokedex.sqlite"

VEEKUN_DB=./pokedex.sqlite

# Generate veekun sqlite
if [[ ! -f "${VEEKUN_DB}" ]]; then
  VEEKUN_DIR="./"
  VEEKUN_DB_SRC="${VEEKUN_DIR}/pokedex/data/pokedex.sqlite"

  if [[ ! -f "${VEEKUN_DB_SRC}" ]]; then
    cd "${VEEKUN_DIR}" || exit 1
    VEEKUN_DIR="$(pwd)" # use abs path for docker run
    docker build --rm -t veekun/pokedex "${VEEKUN_DIR}"
    docker run --rm \
      -e TERM=xterm-256color \
      --name "veekun-pokedex-$(date +%Y%m%d-%H%M%S)" \
      --mount type=bind,source="${VEEKUN_DIR}/pokedex/data",target=/app/pokedex/data \
      veekun/pokedex setup -v # generate SQLite DB
    cd - || exit 1
  fi

  if [[ ! -f "${VEEKUN_DB_SRC}" ]]; then
    echo "[veekun-pokedex] SQLite file not found. Aborting..."
    exit 1
  fi
fi

echo "[veekun-pokedex] Veekun SQLite DB generated. Creating a zip file..."

cd "${VEEKUN_DIR}/pokedex/data"
zip ./pokedex.sqlite.zip ./pokedex.sqlite
cd -

echo "[veekun-pokedex] pokedex.sqlite.zip created."