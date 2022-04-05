#!/bin/bash
echo "
██╗  ██╗ ██████╗ ██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
██║ ██╔╝██╔═══██╗██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
█████╔╝ ██║   ██║██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
██╔═██╗ ██║   ██║██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
██║  ██╗╚██████╔╝██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝                                                            
"
echo "This Tool is Created by Mr.koanti"
#dependances:
#anew ==> https://github.com/tomnomnom/anew
#httprobe ==> https://github.com/tomnomnom/httprobe
#httpx ==> go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
#Sub-Dril===> https://github.com/Mr-koanti/Ko-scripts/blob/main/metho/Sub-Drill.sh
mkdir subdomain;mkdir takeover; mkdir alive ; mkdir alive/scode ;mkdir Nuclei-scan; mkdir Port_scan; mkdir -p Content-Discovrey/{allcontent,params,jsfile,vuln-params}
while read domain; do 
curl -s https://crt.sh/\?q=%25.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u |anew subdomain/$domain.txt | httprobe -c 50 | anew alive/$domain-livsub.txt;

#you must download Sub-Drill.sh and add  chmod +x its dir bellow

'/home/mrk/Desktop/metho/Sub-Drill.sh' $domain | sort -u  | anew subdomain/$domain.txt ;
cat subdomain/$domain.txt |httpx -sc -cl -title -td -fr -server -ports 80,8080,8448,433,21,445,3306,1433,3389,22   | anew alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew alive/$domain-livsub.txt ;
#=====================================================================================================================================================\\
#=====================================================================================================================================================\\
done < $1

#check subdomain takeover:
echo "
████████╗ █████╗ ██╗  ██╗███████╗ ██████╗ ██╗   ██╗███████╗██████╗ 
╚══██╔══╝██╔══██╗██║ ██╔╝██╔════╝██╔═══██╗██║   ██║██╔════╝██╔══██╗
   ██║   ███████║█████╔╝ █████╗  ██║   ██║██║   ██║█████╗  ██████╔╝
   ██║   ██╔══██║██╔═██╗ ██╔══╝  ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗
   ██║   ██║  ██║██║  ██╗███████╗╚██████╔╝ ╚████╔╝ ███████╗██║  ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝
                                                                   
"


while read domain; do
SubOver  -l subdomain/$domain.txt -v | anew takeover/$domain.txt
done < $1

#=========================================================================================================================================================\\

echo "
██████╗  ██████╗ ██████╗ ████████╗    ███████╗ ██████╗ █████╗ ███╗   ██╗
██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗████╗  ██║
██████╔╝██║   ██║██████╔╝   ██║       ███████╗██║     ███████║██╔██╗ ██║
██╔═══╝ ██║   ██║██╔══██╗   ██║       ╚════██║██║     ██╔══██║██║╚██╗██║
██║     ╚██████╔╝██║  ██║   ██║       ███████║╚██████╗██║  ██║██║ ╚████║
╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝                                                                        
" 
while read domain; do
nmap -iL subdomain/$domain.txt --script vuln | anew Port_scan/$domain.txt
done < $1
#nuclie scan

while read domain; do
nuclei -l alive/$domain-livsub.txt | anew Nuclei-scan/$domain.txt
done < $1


echo "
                 _             _           ______                                        
                | |           | |          |  _  \                                       
  ___ ___  _ __ | |_ ___ _ __ | |_   ______| | | |___  ___  ___ _____   _____ _ __ _   _ 
 / __/ _ \| '_ \| __/ _ \ '_ \| __| |______| | | / _ \/ __|/ __/ _ \ \ / / _ \ '__| | | |
| (_| (_) | | | | ||  __/ | | | |_         | |/ /  __/\__ \ (_| (_) \ V /  __/ |  | |_| |
 \___\___/|_| |_|\__\___|_| |_|\__|        |___/ \___||___/\___\___/ \_/ \___|_|   \__, |
                                                                                    __/ |
                                                                                   |___/ 
"
while read domain; do
cat subdomain/$domain.txt | gau --subs | anew Content-Discovrey/allcontent/$domain.txt
cat Content-Discovrey/allurl/$domain.txt |  grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tiff|png|woff|woff2|tff|ico|pdf|svg|js|)" | qsreplace -a | anew Content-Discovrey/$domain-params.txt
gospider -S alive/$domain-livsub.txt  -c 10 -d 1 | anew anew Content-Discovrey/$domain-allurl.txt
cat  Content-Discovrey/$domain-params.txt  | gf xss | anew Content-Discovrey/vuln-params/$domain-xss.txt
cat  Content-Discovrey/$domain-params.txt  | gf ssrf | anew Content-Discovrey/vuln-params/$domain-ssrf.txt
cat  Content-Discovrey/$domain-params.txt  | gf sqli | anew Content-Discovrey/vuln-params/$domain-sqli.txt
cat  Content-Discovrey/$domain-params.txt  | gf redirect | anew Content-Discovrey/vuln-params/$domain-openred.txt
cat  Content-Discovrey/$domain-params.txt  | gf rce | anew Content-Discovrey/vuln-params/$domain-rce.txt
cat  Content-Discovrey/$domain-params.txt  | gf idor | anew Content-Discovrey/vuln-params/$domain-idor.txt
done < $1

