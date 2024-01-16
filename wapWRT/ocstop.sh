#!/bin/bash

service openclash stop

# READ AUTH
if [ -f "/root/TgBotWRT/AUTH" ]; then
    BOT_TOKEN=$(head -n 1 /root/TgBotWRT/AUTH)
    CHAT_ID=$(tail -n 1 /root/TgBotWRT/AUTH)
else
    echo "Berkas AUTH tidak ditemukan."
    exit 1
fi

# Buat pesan notifikasi
MSG="➤ 𝙎𝙏𝙊𝙋 𝙊𝙋𝙀𝙉𝘾𝙇𝘼𝙎𝙃 𝙎𝙐𝘾𝘾𝙀𝙎𝙎𝙁𝙐𝙇 ❌"

# Mengirim pesan ke akun Telegram pribadi