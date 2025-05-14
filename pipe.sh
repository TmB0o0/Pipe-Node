
#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

install_node() {
  echo "🔧 Установка ноды..."
  read -rp "Нажми Enter, чтобы вернуться в меню..."
}

check_status() {
  echo "🔍 Проверка статуса..."
  read -rp "Нажми Enter, чтобы вернуться в меню..."
}

update_node() {
  DOWNLOAD_URL="https://dl.pipecdn.app/v0.2.8/pop"

  if [ -z "$DOWNLOAD_URL" ]; then
    read -rp "🔗 Вставь ссылку на новую версию pop: " DOWNLOAD_URL
  fi

  if [ -z "$DOWNLOAD_URL" ]; then
    echo "❌ Ссылка не указана. Выход..."
    return
  fi

  POP_BIN_DIR="/opt/pop"
  WORK_DIR="/var/lib/pop"
  POP_BIN="$POP_BIN_DIR/pop"

  echo "📦 Скачиваем pop с $DOWNLOAD_URL..."
  curl -L -o pop "$DOWNLOAD_URL" || { echo "❌ Ошибка при скачивании"; return; }

  echo "🔧 Делаем pop исполняемым..."
  chmod +x ./pop

  echo "📁 Перемещаем pop в $POP_BIN_DIR..."
  sudo mkdir -p "$POP_BIN_DIR"
  sudo mv ./pop "$POP_BIN"

  echo "🔐 Устанавливаем capability для портов 80/443..."
  sudo setcap 'cap_net_bind_service=+ep' "$POP_BIN"

  echo "📂 Переходим в рабочую директорию: $WORK_DIR"
  cd "$WORK_DIR" || { echo "❌ Рабочая директория не найдена"; return; }

  echo "🔄 Выполняем pop --refresh..."
  "$POP_BIN" --refresh

  echo "✅ Готово! Обновление завершено."
  read -rp "Нажми Enter, чтобы вернуться в меню..."
}

remove_node() {
  echo "🧹 Удаление ноды..."
  read -rp "Нажми Enter, чтобы вернуться в меню..."
}

view_logs() {
  echo "📜 Логи (screen attach)..."
  screen -r pop || echo "❌ Screen pop не найден"
  read -rp "Нажми Enter, чтобы вернуться в меню..."
}

while true; do
  clear
  echo -e "\n${GREEN}PIPE MANAGEMENT MENU${RESET}\n"
  echo -e "Current pop version: Pipe PoP Cache Node 0.2.1\n"
  echo -e "1. 🛠️  Install Node"
  echo -e "2. 🔗 Check Status"
  echo -e "3. 🧊 Update Node"
  echo -e "4. 🧹 Remove Node"
  echo -e "5. 📜 View Logs (screen attach)"
  echo -e "6. ❌ Exit\n"

  read -rp "$(echo -e "Choose an option: ")" OPTION

  case $OPTION in
    1) install_node ;;
    2) check_status ;;
    3) update_node ;;
    4) remove_node ;;
    5) view_logs ;;
    6)
      echo -e "${GREEN}Exiting script. Goodbye!${RESET}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid choice. Please select 1–6.${RESET}"
      read -rp "Press Enter to return to menu..."
      ;;
  esac
done
