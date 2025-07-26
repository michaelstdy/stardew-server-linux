#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

cd ~
echo -e "${CYAN}--- Stardew Valley Setup Script (from Environment) ---${NC}"

echo -e "\n${YELLOW}--> Step 1: Checking and installing dependencies...${NC}"
apt-get update
apt-get install -y lib32gcc-s1 wget unzip
echo -e "${GREEN}Dependencies ready.${NC}"

STEAMCMD_DIR="/root/steamcmd"
echo -e "\n${YELLOW}--> Step 2: Setting up SteamCMD...${NC}"
if [ ! -f "${STEAMCMD_DIR}/steamcmd.sh" ]; then
    echo "SteamCMD not found, starting download..."
    mkdir -p "$STEAMCMD_DIR"
    cd "$STEAMCMD_DIR"
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
    tar -xvzf steamcmd_linux.tar.gz
    rm steamcmd_linux.tar.gz
    cd ~
    echo -e "${GREEN}SteamCMD setup successful.${NC}"
else
    echo -e "${GREEN}SteamCMD already exists, skipping download.${NC}"
fi

echo -e "\n${YELLOW}--> Step 3: Checking Stardew Valley installation...${NC}"
GAME_DIR="/root/Steam/steamapps/common/Stardew Valley"

if [ -f "$GAME_DIR/Stardew Valley" ]; then
    echo -e "${GREEN}Stardew Valley is already installed. Skipping Steam download.${NC}"
else
    if [ -z "$STEAM_USER" ] || [ -z "$STEAM_PASS" ]; then
        echo -e "${RED}ERROR: STEAM_USER or STEAM_PASS environment variables are not set in docker-compose.yml!${NC}"
        exit 1
    fi

    echo -e "Stardew Valley not found. Starting automatic login process..."
    echo -e "Using username: ${CYAN}${STEAM_USER}${NC}"

    echo -e "\n${YELLOW}ATTENTION: If prompted, TYPE YOUR STEAM GUARD CODE and press [Enter].${NC}"

    STEAM_COMMANDS="+login $STEAM_USER $STEAM_PASS +app_update 413150 validate +quit"
    "${STEAMCMD_DIR}/steamcmd.sh" $STEAM_COMMANDS

    if [ ! -d "$GAME_DIR" ]; then
        echo -e "\n${RED}ERROR: Game directory still not found. Check your credentials in docker-compose.yml.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Stardew Valley installed successfully!${NC}"
fi

echo -e "\n${YELLOW}--> Step 4: Downloading & installing SMAPI automatically...${NC}"
wget https://github.com/Pathoschild/SMAPI/releases/download/4.3.2/SMAPI-4.3.2-installer.zip -O SMAPI.zip
unzip -o SMAPI.zip -d SMAPI_Installer
cd SMAPI_Installer/SMAPI*/

echo "Stardew path is: ${GAME_DIR}"
./install\ on\ Linux.sh
echo -e "${GREEN}SMAPI installation complete.${NC}"

cd ~
rm -f SMAPI.zip
rm -rf SMAPI_Installer

echo -e "\n${GREEN}===========================================${NC}"
echo -e "${GREEN}  INSTALLATION PROCESS COMPLETE! 🎮  ${NC}"
echo -e "${GREEN}===========================================${NC}"