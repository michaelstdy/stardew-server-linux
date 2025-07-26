#!/bin/bash

GAME_DIR="/root/Steam/steamapps/common/Stardew Valley"

echo "Launching Stardew Valley with SMAPI..."

if [ -f "${GAME_DIR}/StardewModdingAPI" ]; then
    cd "$GAME_DIR" && ./StardewModdingAPI
else
    echo "Error: 'StardewModdingAPI' not found."
    echo "Please ensure Stardew Valley and SMAPI are installed correctly by running /root/setup-steam.sh"
    exit 1
fi