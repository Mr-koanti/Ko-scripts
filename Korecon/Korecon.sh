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

string="$1"
dirname=$(echo "$string" | tr '.' '\n' | awk '{print length($0), $0}' | sort -nr | head -n1 | awk '{$1=""; print $0}' | sed 's/^[[:space:]]*//')
mkdir -p $dirname/{subdomain,takeover,alive/scode,Nuclei-scan,Port_scan,Content-Discovrey/{allcontent,params,vuln,jsfile,vuln-params,fuzzing,Login-pages}}
#subdomain enmuration:
while read domain; do
echo "passive subdoomain enum";
#you must download Sub-Drill.sh and add  chmod +x its dir bellow
subfinder -d $domain  | anew $dirname/subdomain/$domain.txt
chaos -d  $domain | anew $dirname/subdomain/$domain.txt
'./subdrill.sh' $domain | anew $dirname/subdomain/$domain.txt ;
done <$1
echo "Subdomain Brute Force"
while read domain; do
gobuster dns -d $domain -w subdomain-19k.txt  -t 50 --wildcard -o   $dirname/subdomain/$domain-b.txt;
cat  $dirname/subdomain/$domain-b.txt | cut -d ":" -f 2 |anew $dirname/subdomain/$domain.txt
rm $dirname/subdomain/$domain-b.txt 
done < $1
while read domain; do
echo "live subdoamins"
cat $dirname/subdomain/$domain-ips.txt | httpx -sc -cl -title -td -fr -server   | anew $dirname/alive/scode/$domain-ip-state.txt | cut -d "[" -f 1 | anew $dirname/alive/$domain-live-ip.txt 
cat $dirname/subdomain/$domain.txt | httpx -sc -cl -title -td -fr -server     | anew $dirname/alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew $dirname/alive/$domain-livsub.txt
#=====================================================================================================================================================\\
#=====================================================================================================================================================\\
done < $1

#portScan
#=========================================================================================================================================================\\

echo "Passive Port Scan With Smap" 
while read domain; do
smap -iL $dirname/subdomain/$domain.txt -sV | anew $dirname/Port_scan/$domain.txt
done < $1
#=========================================================================================================================================================\\

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
cat  $dirname/subdomain/$domain.txt | gauplus -b png,jpg,jpeg,css,gif,woff,svg  | anew $dirname/Content-Discovrey/allcontent/$domain.txt;
katana -list  $dirname/subdomain/$domain.txt  -ef css,md,png,jpg,jpeg,gif,woff,svg | anew $dirname/Content-Discovrey/allcontent/$domain.txt;
cat  $dirname/Content-Discovrey/allcontent/$domain.txt |  grep "="  | qsreplace -a | httpx | anew $dirname/Content-Discovrey/params/$domain-params.txt;
cat $dirname/Content-Discovrey/allcontent/$domain.txt | grep "\.js$" | httpx -mc 200 | anew $dirname/Content-Discovrey/jsfile/$domain-js.txt
cat  $dirname/Content-Discovrey/params/$domain-params.txt  | gf xss      | anew $dirname/Content-Discovrey/vuln-params/$domain-xss.txt
cat  $dirname/Content-Discovrey/params/$domain-params.txt  | gf ssrf     | anew $dirname/Content-Discovrey/vuln-params/$domain-ssrf.txt
cat  $dirname/Content-Discovrey/params/$domain-params.txt  | gf redirect | anew $dirname/Content-Discovrey/vuln-params/$domain-openred.txt
cat $dirname/Content-Discovrey/allcontent/$domain.txt | grep -E "(login|register|reset|password|profile|admin|panal|signup|signin|changepassword)" | anew $dirname/Content-Discovrey/Login-pages/$domain.txt
done < $1

echo "fuzzing With FFUF"

while read domain; do
for i in `cat  $dirname/alive/$domain-livsub.txt`; do 
ffuf -u $i/FUZZ -w dicc.txt -fc "403,302" -v -c -se -ac | anew  $dirname/Content-Discovrey/fuzzing/$domain-fuzzing.txt;
done
done < $1

# VULNERABILITY TESTING

#xss scan
echo '                
 __  _____ ___  
 \ \/ / __/ __| 
  >  <\__ \__ \ 
 /_/\_\___/___/ 
                '
while read domain; do
cat $dirname/Content-Discovrey/vuln-params/$domain-xss.txt |  kxss | grep -E --color=always '[<>{}`"'\'' ]' -B 99999 | sed -e 's/^/\x1b[31m
/' -e 's/$/\x1b[0m/' | anew $dirname/Content-Discovrey/vuln/$domain-kxss.txt 
done < $1
#open-redirect
echo "open-redirect#========================================================================================================================================================="

while read domain; do
cat  $dirname/Content-Discovrey/vuln-params/$domain-openred.txt  | 'https://example.com' | httpx -fr -title --match-string 'Example Domain' | anew $dirname/Content-Discovrey/vuln/$domain-openred.txt
done < $1
#information Disclosure
echo "
  _        __         ____  _          _                          
 (_)_ __  / _| ___   |  _ \(_)___  ___| | ___  ___ _   _ _ __ ___ 
 | | '_ \| |_ / _ \  | | | | / __|/ __| |/ _ \/ __| | | | '__/ _ \
 | | | | |  _| (_) | | |_| | \__ \ (__| | (_) \__ \ |_| | | |  __/
 |_|_| |_|_|  \___/  |____/|_|___/\___|_|\___/|___/\__,_|_|  \___|
                                                                  
"
while read domain; do
cat $dirname/Content-Discovrey/jsfile/$domain-js.txt | httpx -mc 200 | nuclei -t ~/nuclei-templates/file/js/js-analyse.yaml,~/nuclei-templates/file/xss/dom-xss.yaml | anew anew $dirname/Content-Discovrey/vuln/$domain-disclousre.txt
done < $1
#ssrf 
echo "
                __ 
  ___ ___ _ __ / _|
 / __/ __| '__| |_ 
 \__ \__ \ |  |  _|
 |___/___/_|  |_|  
                   
"
ssrftoken="3efm1w0h8hk7c3c20xf5egkcw.canarytokens.com"
while read domain; do
cat  $dirname/Content-Discovrey/vuln-params/$domain-ssrf.txt | qsreplace $ssrftoken | httpx  -status-code -location  -fr | anew $dirname/Content-Discovrey/vuln/$domain-ssrf.txt
done < $1
echo "Nuclie-Scan"
while read domain; do
nuclei -l $dirname/alive/$domain-livsub.txt  -as -es info,unknown | anew $dirname/Nuclei-scan/$domain.txt 
done < $1
