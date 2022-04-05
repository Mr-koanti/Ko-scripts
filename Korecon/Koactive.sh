#!/bin/bash
echo "▄ •▄          ▄▄▄·  ▄▄· ▄▄▄▄▄▪   ▌ ▐·▄▄▄ .  .▄▄ · ▄• ▄▌▄▄▄▄· 
█▌▄▌▪ ▄█▀▄   ▐█ ▀█ ▐█ ▌▪•██  ██ ▪█·█▌▀▄.▀·  ▐█ ▀. █▪██▌▐█ ▀█▪
▐▀▀▄·▐█▌.▐▌  ▄█▀▀█ ██ ▄▄ ▐█.▪▐█·▐█▐█•▐▀▀▪▄  ▄▀▀▀█▄█▌▐█▌▐█▀▀█▄
▐█.█▌▐█▌.▐▌  ▐█ ▪▐▌▐███▌ ▐█▌·▐█▌ ███ ▐█▄▄▌  ▐█▄▪▐█▐█▄█▌██▄▪▐█
·▀  ▀ ▀█▄▀▪   ▀  ▀ ·▀▀▀  ▀▀▀ ▀▀▀. ▀   ▀▀▀    ▀▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
echo "This Tool is Created by Mr.koanti"
mkdir subdomain; mkdir alive ; mkdir alive/scode 
while read domain; do 
curl -s https://crt.sh/\?q=%25.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u |anew subdomain/$domain-sub.txt | httprobe -c 50 | anew alive/$domain-livsub.txt
done < $1
