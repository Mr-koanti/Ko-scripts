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
mkdir -p myrecon/{subdomain,takeover,alive/scode,Nuclei-scan,Port_scan,Content-Discovrey/{allcontent,params,vuln,jsfile,vuln-params}}
while read domain; do 
curl -s https://crt.sh/\?q=%25.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u |anew myrecon/subdomain/$domain.txt | httprobe -c 50 | anew myrecon/alive/$domain-livsub.txt;

#you must download Sub-Drill.sh and add  chmod +x its dir bellow
amass enum -passive -d $domain | sort -u  | anew myrecon/subdomain/$domain.txt
'./Sub-Drill.sh' $domain | sort -u  | anew myrecon/subdomain/$domain.txt ;
cat myrecon/subdomain/$domain.txt |httpx -sc -cl -title -td -fr -server -ports 80,8080,8448,433,21,445,3306,1433,3389,22   | anew myrecon/alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew myrecon/alive/$domain-livsub.txt ;
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
SubOver  -l myrecon/subdomain/$domain.txt -v | anew myrecon/takeover/$domain.txt
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
nmap -iL myrecon/subdomain/$domain.txt --script vuln | anew myrecon/Port_scan/$domain.txt
done < $1
#nuclie scan

while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt | anew myrecon/Nuclei-scan/$domain.txt
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
cat myrecon/subdomain/$domain.txt | gau --subs  | anew myrecon/Content-Discovrey/allcontent/$domain.txt
cat myrecon/Content-Discovrey/allcontent/$domain.txt |  uro | anew myrecon/Content-Discovrey/params/$domain-params.txt;
gospider -S alive/$domain-livsub.txt  -c 10 -d 1 | anew myrecon/Content-Discovrey/$domain-allurl.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf xss      | anew myrecon/Content-Discovrey/vuln-params/$domain-xss.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf ssrf     | anew myrecon/Content-Discovrey/vuln-params/$domain-ssrf.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf sqli     | anew myrecon/Content-Discovrey/vuln-params/$domain-sqli.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf redirect | anew myrecon/Content-Discovrey/vuln-params/$domain-openred.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf rce      | anew myrecon/Content-Discovrey/vuln-params/$domain-rce.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf idor     | anew myrecon/Content-Discovrey/vuln-params/$domain-idor.txt

gospider -S myreacon/alive/$domain-livsub.txt  -c 10 -d 1 |anew myrecon/Content-Discovrey/jsfile/$domain.txt
done < $1
#exploit
while read domain; do
cat myrecon/Content-Discovrey/vuln-params/$domain-xss.txt |  kxss | anew myrecon/Content-Discovrey/vuln/$domain-xss.txt
cat myrecon/Content-Discovrey/params/$domain-params.txt |dalfox pipe --custom-payload xss.txt > myrecon/Content-Discovrey/vuln-param>
cat  myrecon/Content-Discovrey/vuln-params/$domain-ssrf.txt | qsreplace  https://www.google.com| anew myrecon/Content-Discovrey/vuln>
done < $1

