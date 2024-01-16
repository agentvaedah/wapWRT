#!/bin/bash

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi

# Fungsi untuk mengambil data download, upload, dan total dari vnstat
get_daily_bandwidth() {
    vnstat_output=$(vnstat -i br-lan -d 1 --style 0 | sed -n 6p)
    download=$(echo "$vnstat_output" | awk '{print $5, $6}')
    upload=$(echo "$vnstat_output" | awk '{print $2, $3}')
    total=$(echo "$vnstat_output" | awk '{print $8, $9}')
    
    echo "
➤ 𝗕𝗔𝗡𝗗𝗪𝗜𝗗𝗧𝗛 𝗗𝗔𝗜𝗟𝗬 𝗥𝗘𝗣𝗢𝗥𝗧 📊

📥 𝗗𝗢𝗪𝗡𝗟𝗢𝗔𝗗: $download
📤 𝗨𝗣𝗟𝗢𝗔𝗗: $upload
📊 𝗧𝗢𝗧𝗔𝗟: $total
⏰ 𝗟𝗔𝗦𝗧 𝗨𝗣𝗗𝗔𝗧𝗘: $(date +'%d-%m-%Y %I:%M %p')

➤ 𝘾𝙝𝙚𝙘𝙠𝙚𝙙 𝙗𝙮 WAP 𝘿𝙚𝙫𝙚𝙡𝙤𝙥𝙚𝙧 😈
"
}

# Main program
get_ip_info
MSG=$(get_daily_bandwidth)

# Mengirim pesan ke akun Telegram pribadi
curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d text="GUNAKANALAH INTERNET DENGAN BIJAK DAN TAAT ATURAN 🔥🔥🔥 "