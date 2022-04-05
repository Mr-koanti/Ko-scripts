#!/bin/bash
while getopts d: flag
do
    case "${flag}" in
        d) domain=${OPTARG};;
    esac
done

echo "domain ===> : $domain";
echo "▄ •▄          ▄▄▄·  ▄▄· ▄▄▄▄▄▪   ▌ ▐·▄▄▄ .  .▄▄ · ▄• ▄▌▄▄▄▄· 
█▌▄▌▪ ▄█▀▄   ▐█ ▀█ ▐█ ▌▪•██  ██ ▪█·█▌▀▄.▀·  ▐█ ▀. █▪██▌▐█ ▀█▪
▐▀▀▄·▐█▌.▐▌  ▄█▀▀█ ██ ▄▄ ▐█.▪▐█·▐█▐█•▐▀▀▪▄  ▄▀▀▀█▄█▌▐█▌▐█▀▀█▄
▐█.█▌▐█▌.▐▌  ▐█ ▪▐▌▐███▌ ▐█▌·▐█▌ ███ ▐█▄▄▌  ▐█▄▪▐█▐█▄█▌██▄▪▐█
·▀  ▀ ▀█▄▀▪   ▀  ▀ ·▀▀▀  ▀▀▀ ▀▀▀. ▀   ▀▀▀    ▀▀▀▀  ▀▀▀ ·▀▀▀▀ 
"
echo "This Tool is Created by Mr.koanti"
curl -s https://crt.sh/\?q=%25.${domain}\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u |anew ${domain}_sub.txt | httprobe -c 50 | anew ${domain}_livsub.txt
