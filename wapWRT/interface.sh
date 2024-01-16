#!/bin/sh

# Membaca token dan chat ID dari berkas token.txt
if [ -f "/root/token.txt" ]; then
    IFS=$'\n' read -d '' -r -a lines < "/root/token.txt"
    if [ "${#lines[@]}" -ge 2 ]; then
        BOT_TOKEN="${lines[0]}"
        USER_CHAT_ID="${lines[1]}"
    else
        echo "Berkas token.txt harus memiliki setidaknya 2 baris (token dan chat ID Anda)."
        exit 1
    fi
else
    echo "Berkas token.txt tidak ditemukan."
    exit 1
fi

# Memeriksa status antarmuka wwan0 (modem1)
if ifconfig wwan0 | grep -q "UP BROADCAST RUNNING"; then
    status_modem1="Online ✅"
else
    status_modem1="Offline ❌"
fi

# Memeriksa status antarmuka wlan0 (modem2)
if ifconfig wlan0 | grep -q "UP BROADCAST RUNNING"; then
    status_modem2="Online ✅"
else
    status_modem2="Offline ❌"
fi

# Get data usage for modem1 (wwan0)
modem1_data=$(vnstat -i wwan0 -y 1 --style 0 | sed -n 6p)

# Extract download, upload, and total from modem1 data
download_modem1=$(echo "$modem1_data" | awk '{print $2, $3}')
upload_modem1=$(echo "$modem1_data" | awk '{print $5, $6}')
total_modem1=$(echo "$modem1_data" | awk '{print $8, $9}')

# Get data usage for modem2 (wlan0)
modem2_data=$(vnstat -i wlan0 -y 1 --style 0 | sed -n 6p)

# Extract download, upload, and total from modem2 data
download_modem2=$(echo "$modem2_data" | awk '{print $2, $3}')
upload_modem2=$(echo "$modem2_data" | awk '{print $5, $6}')
total_modem2=$(echo "$modem2_data" | awk '{print $8, $9}')

# Get uptime for modem1 (wwan0)
uptime_modem1=$(ifstatus mm | jq -r '.uptime')

# Get uptime for modem2 (wlan0)
uptime_modem2=$(ifstatus orbit | jq -r '.uptime')

# Menghitung waktu dalam format "0d 5h 32m" untuk modem1
uptime_modem1_seconds=$uptime_modem1
uptime_modem1_days=$((uptime_modem1_seconds / 86400))
uptime_modem1_seconds=$((uptime_modem1_seconds % 86400))
uptime_modem1_hours=$((uptime_modem1_seconds / 3600))
uptime_modem1_seconds=$((uptime_modem1_seconds % 3600))
uptime_modem1_minutes=$((uptime_modem1_seconds / 60))

# Menghitung waktu dalam format "0d 5h 32m" untuk modem2
uptime_modem2_seconds=$uptime_modem2
uptime_modem2_days=$((uptime_modem2_seconds / 86400))
uptime_modem2_seconds=$((uptime_modem2_seconds % 86400))
uptime_modem2_hours=$((uptime_modem2_seconds / 3600))
uptime_modem2_seconds=$((uptime_modem2_seconds % 3600))
uptime_modem2_minutes=$((uptime_modem2_seconds / 60))

# Membuat format waktu yang sesuai
uptime_modem1_format="${uptime_modem1_days}d ${uptime_modem1_hours}h ${uptime_modem1_minutes}m"
uptime_modem2_format="${uptime_modem2_days}d ${uptime_modem2_hours}h ${uptime_modem2_minutes}m"

# Generate the timestamp
timestamp="$(date '+%d-%m-%Y %I:%M %p')"

# Update the message with the new data usage and uptime information
pesan_modems="
────────────────────────
 📊 𝙄𝙉𝙏𝙀𝙍𝙁𝘼𝘾𝙀 𝙎𝙏𝘼𝙏𝙐𝙎 𝙍𝙀𝙋𝙊𝙍𝙏 📊
────────────────────────

📶 𝙈𝙤𝙙𝙚𝙢 1: $status_modem1
📥 𝘿𝙤𝙬𝙣𝙡𝙤𝙖𝙙: $download_modem1
📤 𝙐𝙥𝙡𝙤𝙖𝙙: $upload_modem1
💼 𝙏𝙤𝙩𝙖𝙡: $total_modem1
🕒 𝙐𝙥𝙩𝙞𝙢𝙚: $uptime_modem1_format

📶 𝙈𝙤𝙙𝙚𝙢 2: $status_modem2
📥 𝘿𝙤𝙬𝙣𝙡𝙤𝙖𝙙: $download_modem2
📤 𝙐𝙥𝙡𝙤𝙖𝙙: $upload_modem2
💼 𝙏𝙤𝙩𝙖𝙡: $total_modem2
🕒 𝙐𝙥𝙩𝙞𝙢𝙚: $uptime_modem2_format

────────────────────────
🌐 𝙈𝙤𝙣𝙞𝙩𝙤𝙧𝙞𝙣𝙜 𝙮𝙤𝙪𝙧 𝙙𝙖𝙩𝙖 𝙪𝙨𝙖𝙜𝙚.
────────────────────────
⚙️ 𝙇𝙖𝙨𝙩 𝙪𝙥𝙙𝙖𝙩𝙚: $timestamp
────────────────────────"

# Mengirim notifikasi ke akun Telegram pribadi
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
     -d "chat_id=${USER_CHAT_ID}" \
     -d "text=${pesan_modems}" \
     -d "parse_mode=Markdown"

echo "Pemeriksaan status antarmuka dan penggunaan data selesai."