#!/bin/bash

# ┌─────────────────────────────────────────────────────────┐
# │               NMAP SCAN by Leerot                │
# └─────────────────────────────────────────────────────────┘

cat << 'EOF'
 ___           _______       _______       ________      ________      _________   
|\  \         |\  ___ \     |\  ___ \     |\   __  \    |\   __  \    |\___   ___\ 
\ \  \        \ \   __/|    \ \   __/|    \ \  \|\  \   \ \  \|\  \   \|___ \  \_| 
 \ \  \        \ \  \_|/__   \ \  \_|/__   \ \   _  _\   \ \  \\\  \       \ \  \  
  \ \  \____    \ \  \_|\ \   \ \  \_|\ \   \ \  \\  \|   \ \  \\\  \       \ \  \ 
   \ \_______\   \ \_______\   \ \_______\   \ \__\\ _\    \ \_______\       \ \__\
    \|_______|    \|_______|    \|_______|    \|__|\|__|    \|_______|        \|__|
EOF




if [ -z "$1" ]; then
 echo "[X] You must enter the argument like IP."
 echo "Example: ./scan.sh 10.10.10.10"
 exit 1
fi

ip="$1"
scan_file="nmap-scan-$ip.txt"
ports_services="ports_services-$ip.txt"

#### ports
echo "[*] Obtained open ports ..."
sudo nmap -p- --open -sS -n -Pn --min-rate 5000 -oN "$scan_file" "$ip"

#### open ports scan
echo "[*] Extract open ports"
open_ports=$(grep -Po '^\d+(?=/tcp\s+open)' "$scan_file" | paste -sd, -)

echo ""

if [ -z "$open_ports" ]; then
 echo "[X] Ports open not found."
 exit 1
fi

echo "[+] Ports open found: $open_ports"

echo ""

#### port's services
sudo nmap -sCV -p$open_ports $ip -oN "$ports_services"

echo "[+] File obtained:"
echo " - $scan_file"
echo " - $ports_services"