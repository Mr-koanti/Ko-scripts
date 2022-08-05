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
#subdomain enmuration:
while read domain; do
echo "passive subdoomain enum";
#you must download Sub-Drill.sh and add  chmod +x its dir bellow
subfinder -d $domain  | anew myrecon/subdomain/$domain.txt
chaos -d  $domain | anew myrecon/subdomain/$domain.txt
amass enum -passive -d $domain   | anew myrecon/subdomain/$domain.txt
'./Sub-Drill.sh' $domain | anew myrecon/subdomain/$domain.txt ;

echo "ips recon"
#ips recon
shodan search --fields ip_str   ssl:"$domain"  | anew  myrecon/subdomain/$domain-ips.txt
shodan search --fields port   ssl:"$domain" | sort -u | tr "\n" ","| anew myrecon/subdomain/$domain-ports.txt
#passive sub enum
echo "subdomain brute force "
amass enum -active -d $domain -brute -w subdomains-10000.txt -o  myrecon/subdomain/$domain.txt;
echo "live subdoamins"
cat myrecon/subdomain/$domain-ips.txt | httpx -sc -cl -title -td -fr -server -ports 80,81,443,591,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,8443,8834,8888   | anew myrecon/alive/scode/$domain-ip-state.txt | cut -d "[" -f 1 | anew myrecon/alive/$domain-live-ip.txt 
cat myrecon/subdomain/$domain.txt |httpx -sc -cl -title -td -fr -server -ports 80,81,443,591,2082,2087,2095,2096,3000,8000,8001,8008,8080,8083,8443,8834,8888    | anew myrecon/alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew myrecon/alive/$domain-livsub.txt
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
SubOver  -l myrecon/subdomain/$domain.txt -v -a | tee myrecon/takeover/$domain.txt
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
smap -iL myrecon/subdomain/$domain.txt -sV | anew myrecon/Port_scan/$domain.txt
done < $1
#nuclie scan

while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt -es info | anew myrecon/Nuclei-scan/$domain.txt
nuclei -l myrecon/alive/$domain-live-ip.txt -es info | anew myrecon/Nuclei-scan/$domain.txt
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
cat  myrecon/subdomain/$domain.txt | gauplus -b png,jpg,jpeg,css,svf,gif  | anew myrecon/Content-Discovrey/allcontent/$domain.txt;
cat  myrecon/Content-Discovrey/allcontent/$domain.txt |  grep "="  | qsreplace -a | anew myrecon/Content-Discovrey/params/$domain-params.txt;
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf xss      | anew myrecon/Content-Discovrey/vuln-params/$domain-xss.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf ssrf     | anew myrecon/Content-Discovrey/vuln-params/$domain-ssrf.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf sqli     | anew myrecon/Content-Discovrey/vuln-params/$domain-sqli.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf redirect | anew myrecon/Content-Discovrey/vuln-params/$domain-openred.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf rce      | anew myrecon/Content-Discovrey/vuln-params/$domain-rce.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf idor     | anew myrecon/Content-Discovrey/vuln-params/$domain-idor.txt
done < $1
#exploit
while read domain; do
cat myrecon/Content-Discovrey/vuln-params/$domain-xss.txt |  kxss | anew myrecon/Content-Discovrey/vuln/$domain-xss.txt
cat  myrecon/Content-Discovrey/vuln-params/$domain-openred.txt| cut -f 3- -d ':' | qsreplace "https://evil.com" | httpx -silent -status-code -location | anew myrecon/Content-Discovrey/vuln/$domain-openred.txt
done < $1

