#!/usr/bin/env bash set -euo pipefail

setup_improved.sh

Təkmilləşdirilmiş setup script — rənglər, gecikmələr və animasiyalar əlavə edildi.

İstifadə: chmod +x setup_improved.sh && ./setup_improved.sh

--- Rənglər ---

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' BLUE='\033[0;34m' MAGENTA='\033[0;35m' CYAN='\033[0;36m' RESET='\033[0m' BOLD='\033[1m'

--- Sıxlıq / yavaşlıq (istifadəyə görə dəyişdirin) ---

STEP_DELAY=0.6   # mərhələ arası gecikmə SPINNER_DELAY=0.08

--- Cleanup on Ctrl+C ---

cleanup() { printf "\n${YELLOW}İstənilən vaxt dayandırıldı. Təmizlənir...${RESET}\n" exit 2 } trap cleanup INT TERM

--- Utility: mərkəzləşdirilmiş, rəngli çıxış ---

cecho() {

cecho "${GREEN}" "  Mətn..."

color="$1"; shift printf "%b\n" "${color}$*${RESET}" }

--- Spinner (prosesin arxasında çalışdığı halda göstər) ---

spinner() { local pid=$1 local delay=${SPINNER_DELAY} local spinstr='|/-\' local i=0 while kill -0 "$pid" 2>/dev/null; do printf "\r%s %s" "${CYAN}${spinstr:i:1}${RESET}" "Yüklənir..." i=$(( (i + 1) % ${#spinstr} )) sleep "$delay" done printf "\r" }

--- Başlıq / banner (rəngli) ---

cecho "$MAGENTA$BOLD" "ㅤㅤ⚠ Başlanır" sleep $STEP_DELAY

--- Progres mərhələləri ---

cecho "$CYAN" "ㅤㅤㅤ1%" sleep $STEP_DELAY cecho "$CYAN" "ㅤㅤㅤㅤㅤ10%" sleep $STEP_DELAY cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤ20%" sleep $STEP_DELAY cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ30%" sleep $STEP_DELAY cecho "$CYAN" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ40%" sleep $STEP_DELAY cecho "$YELLOW" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ50%" sleep $STEP_DELAY

cecho "$GREEN" "ㅤㅤㅤSəbr elə — yüklənir..." sleep $STEP_DELAY

Daha uzun ASCII art-i rənglə göstərmək üçün burada nümunə baner:

cat <<'BANNER' ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⠶⠶⠶⠶⢦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ... (banner qısaldıldı) BANNER

sleep $STEP_DELAY cecho "$GREEN" "ㅤㅤ📚 Kitabxanaların yuklənməsi..."

--- Pip quraşdırma (requirements.txt yoxlanışı) ---

if command -v pip3 >/dev/null 2>&1; then if [ -f requirements.txt ]; then # pip prosesini arxa plana at və spinner göstər cecho "$BLUE" "    pip3 install -r requirements.txt başaldıldı (səssiz mod)..." pip3 install -r requirements.txt --quiet & PIP_PID=$! spinner $PIP_PID wait $PIP_PID || { cecho "$RED" "pip quraşdırması uğursuz oldu."; exit 1; } cecho "$GREEN" "     ☑️ Uğurla yükləndi." else cecho "$YELLOW" "    requirements.txt tapılmadı — pip quraşdırılmadı." fi else cecho "$RED" "pip3 sisteminizdə tapılmadı. Zəhmət olmasa pip / python3 quraşdırın." exit 1 fi

sleep $STEP_DELAY cecho "$MAGENTA" "ㅤㅤ⚕ başlanıldı | Log..." sleep $STEP_DELAY cecho "$CYAN" "ㅤㅤLogging...." cecho "$GREEN" "    Loglar yüklənir..." sleep $STEP_DELAY cecho "$GREEN" "     ☑️ Uğurla yükləndi."

Simulyasiya edilmiş terminal girişi göstəricisi

cecho "$YELLOW" "ㅤㅤ⚠ Termux giriş (əgər Termux istifadə edirsinizsə)" cecho "$YELLOW" "       60%" sleep $STEP_DELAY cecho "$YELLOW" "          70%" sleep $STEP_DELAY cecho "$YELLOW" "ㅤㅤㅤㅤㅤㅤㅤㅤㅤ80%" sleep $STEP_DELAY cecho "$YELLOW" "ㅤㅤ ㅤㅤㅤㅤㅤㅤㅤㅤ 90%" sleep $STEP_DELAY cecho "$GREEN" "ㅤㅤㅤ ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ100%" sleep $STEP_DELAY

cecho "$GREEN" "       ./root/ai/aiteknoloji/start/"

Nəticə və təmizlik

sleep 0.4 cecho "$MAGENTA$BOLD" "  ✔️ Bütün mərhələlər tamamlandı."

Əlavə: əgər istifadəçi "bash start" istəyirsə — seçim təqdim edin

if [ -f ./start ]; then cecho "$CYAN" "Start faylı tapıldı — işə salmaq istəsiniz? (y/N)" read -r -n 1 -s answer || true printf "\n" if [[ "$answer" =~ [Yy] ]]; then cecho "$GREEN" "Start işə salınır..." bash ./start else cecho "$YELLOW" "Start işə salınmadı. Sizə lazım olsa ./start ilə işlədə bilərsiniz." fi fi

exit 0

