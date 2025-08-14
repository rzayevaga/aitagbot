#!/usr/bin/env bash
set -euo pipefail

# İstifadə: chmod +x setup.sh && ./setup.sh

# --- Rənglər ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'
BOLD='\033[1m'

STEP_DELAY=0.6
SPINNER_DELAY=0.08

cleanup() {
  printf "\n${YELLOW}İstənilən vaxt dayandırıldı. Təmizlənir...${RESET}\n"
  exit 2
}
trap cleanup INT TERM

cecho() {
  color="$1"; shift
  printf "%b\n" "${color}$*${RESET}"
}

spinner() {
  local pid=$1
  local delay=${SPINNER_DELAY}
  local spinstr='|/-\\'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "${CYAN}${spinstr:i:1}${RESET}" "Yüklənir..."
    i=$(( (i + 1) % ${#spinstr} ))
    sleep "$delay"
  done
  printf "\r"
}

cecho "$MAGENTA$BOLD" "ㅤㅤ⚠ Başlanır"
sleep $STEP_DELAY

cecho "$CYAN" "ㅤㅤㅤ1%"
sleep $STEP_DELAY
cecho "$CYAN" "ㅤㅤㅤㅤㅤ10%"
sleep $STEP_DELAY
cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤ20%"
sleep $STEP_DELAY
cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ30%"
sleep $STEP_DELAY
cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ40%"
sleep $STEP_DELAY
cecho "$YELLOW" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ50%"
sleep $STEP_DELAY

cecho "$GREEN" "ㅤㅤㅤSəbr elə — yüklənir..."
sleep $STEP_DELAY

cat <<'BANNER'
⠀⠀⠀⠀⠀⠀⠀           ⠀⠀⢀⣠⣤⠶⠶⠶⠶⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠛⠁⠀⠀⠀⠀⠀⠀⠈⠙⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⣠⡴⠞⠛⠉⠉⣩⣍⠉⠉⠛⠳⢦⣄⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⣴⡿⣧⣀⠀⢀⣠⡴⠋⠙⢷⣄⡀⠀⣀⣼⢿⣦⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣧⡾⠋⣷⠈⠉⠉⠉⠉⠀⠀⠀⠀⠉⠉⠋⠉⠁⣼⠙⢷⣼⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣇⠀⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡟⠀⣸⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣹⣆⠀⢻⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡟⠀⣰⣏⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠞⠋⠁⠙⢷⣄⠙⢷⣀⠀⠀⠀⠀⠀⠀⢀⡴⠋⢀⡾⠋⠈⠙⠻⢦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⠹⢦⡀⠙⠳⠶⢤⡤⠶⠞⠋⢀⡴⠟⠀⠀⠀⠀⠀⠀⠙⠻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⠋⠀⠀⢀⣤⣤⣤⣤⣤⣤⣤⣿⣦⣤⣤⣤⣤⣤⣤⣴⣿⣤⣤⣤⣤⣤⣤⣤⡀⠀⠀⠙⣧⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⠏⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⢠⣴⠞⠛⠛⠻⢦⡄⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠸⣇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⡟⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⢶⣄⣠⡶⣦⣿⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⢻⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣾⠁⠀⠀⠀⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⢻⣿⠶⠟⠻⠶⢿⡿⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠈⣿⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⢾⣄⣹⣦⣀⣀⣴⢟⣠⡶⠀⠀⠀⠀⠀⠀⣼⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⣭⣭⡿⠛⠁⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠘⣧⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⢿⡀⠀⠀⠀⠀⠀⠀⣀⡴⠞⠋⠙⠳⢦⣀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⢰⡏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⢿⣄⣀⠀⠀⢀⣤⣼⣧⣤⣤⣤⣤⣤⣿⣭⣤⣤⣤⣤⣤⣤⣭⣿⣤⣤⣤⣤⣤⣼⣿⣤⣄⠀⠀⣀⣠⡾⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠛⠻⢧⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠼⠟⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣷⣶⣶⣶⣶⣶⣶⣿⣷⣶⣿⣿⣾⣿⣶⣶⣿⣿⣷⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⣿⣷⣷⣿⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣷⣶⣿⣿
BANNER

sleep $STEP_DELAY
cecho "$GREEN" "ㅤㅤ📚 Kitabxanaların yüklənməsi..."

# --- Python3 və pip3 yoxlaması və quraşdırılması ---
install_python_pip() {
  cecho "$YELLOW" "Python3 və/və ya pip3 tapılmadı — quraşdırma başlayır..."
  
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y
    sudo apt install -y python3 python3-pip
  elif command -v pkg >/dev/null 2>&1; then
    pkg update -y
    pkg install -y python python-pip
  else
    cecho "$RED" "❌ Paket meneceri tapılmadı (apt/pkg). Manual quraşdırın."
    exit 1
  fi
}

if ! command -v python3 >/dev/null 2>&1; then
  cecho "$RED" "python3 tapılmadı."
  install_python_pip
fi

if ! command -v pip3 >/dev/null 2>&1; then
  cecho "$RED" "pip3 tapılmadı."
  install_python_pip
fi

# --- requirements.txt yoxlanması və quraşdırılması ---
if [ -f requirements.txt ]; then
  cecho "$BLUE" "    pip3 install -r requirements.txt başladı (səssiz mod)..."
  pip3 install -r requirements.txt --quiet &
  PIP_PID=$!
  spinner $PIP_PID
  wait $PIP_PID || { cecho "$RED" "pip quraşdırması uğursuz oldu."; exit 1; }
  cecho "$GREEN" "     ☑️ Uğurla yükləndi."
else
  cecho "$YELLOW" "requirements.txt tapılmadı — pip quraşdırılmadı."
fi

sleep $STEP_DELAY
cecho "$MAGENTA" "ㅤㅤ⚕ başlanıldı | Log..."
sleep $STEP_DELAY
cecho "$CYAN" "ㅤㅤLogging...."
cecho "$GREEN" "    Loglar yüklənir..."
sleep $STEP_DELAY
cecho "$GREEN" "     ☑️ Uğurla yükləndi."

cecho "$YELLOW" "ㅤㅤ⚠ Termux giriş (əgər Termux istifadə edirsinizsə)"
cecho "$YELLOW" "       60%"
sleep $STEP_DELAY
cecho "$YELLOW" "          70%"
sleep $STEP_DELAY
cecho "$YELLOW" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤ80%"
sleep $STEP_DELAY
cecho "$YELLOW" "ㅤㅤ ㅤㅤㅤㅤㅤㅤㅤㅤ 90%"
sleep $STEP_DELAY
cecho "$GREEN" "ㅤㅤㅤ ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ100%"
sleep $STEP_DELAY

cecho "$GREEN" "       ./root/ai/aiteknoloji/start/"
sleep 0.4
cecho "$MAGENTA$BOLD" "  ✔️ Bütün mərhələlər tamamlandı."

# --- API məlumatlarını istə və config.py-yə yaz ---
cecho "$CYAN" "🔑 Zəhmət olmasa API məlumatlarını daxil edin:"
read -rp "API_ID: " API_ID
while ! [[ "$API_ID" =~ ^[0-9]+$ ]]; do
  cecho "$RED" "❌ API_ID yalnız rəqəmlərdən ibarət olmalıdır."
  read -rp "API_ID: " API_ID
done

read -rp "API_HASH: " API_HASH
while [[ -z "$API_HASH" ]]; do
  cecho "$RED" "❌ API_HASH boş ola bilməz."
  read -rp "API_HASH: " API_HASH
done

read -rp "BOT_TOKEN: " BOT_TOKEN
while [[ -z "$BOT_TOKEN" ]]; do
  cecho "$RED" "❌ BOT_TOKEN boş ola bilməz."
  read -rp "BOT_TOKEN: " BOT_TOKEN
done

CONFIG_FILE="config.py"
cat > "$CONFIG_FILE" <<EOF
from os import getenv

API_ID = int(getenv("API_ID", "$API_ID")) # get my.telegram.org/apps
API_HASH = getenv("API_HASH", "$API_HASH") # get my.telegram.org/apps
BOT_TOKEN = getenv("BOT_TOKEN", "$BOT_TOKEN") # Get from @botfather on telegram
EOF

cecho "$GREEN" "✅ Config faylı uğurla yaradıldı: $CONFIG_FILE"

# Start script seçimi
if [ -f ./start ]; then
  cecho "$CYAN" "Start faylı tapıldı — işə salmaq üçün klaviaturada y toxunun. (y/N)"
  read -r -n 1 -s answer || true
  printf "\n"
  if [[ "$answer" =~ [Yy] ]]; then
    cecho "$GREEN" "Start işə salınır..."
    bash ./start
  else
    cecho "$YELLOW" "Start işə salınmadı. ./start ilə işlədə bilərsiniz."
  fi
fi

exit 0
