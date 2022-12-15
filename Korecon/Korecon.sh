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
mkdir -p myrecon/{subdomain,takeover,alive/scode,Nuclei-scan,Port_scan,Content-Discovrey/{allcontent,params,vuln,jsfile,vuln-params,fuzzing}}
#subdomain enmuration:
while read domain; do
echo "passive subdoomain enum";
#you must download Sub-Drill.sh and add  chmod +x its dir bellow
subfinder -d $domain  | anew myrecon/subdomain/$domain.txt
chaos -d  $domain | anew myrecon/subdomain/$domain.txt
amass enum -passive -d $domain   | anew myrecon/subdomain/$domain.txt
'./subdrill.sh' $domain | anew myrecon/subdomain/$domain.txt ;
done <$1
while read domain ; do
#IP Address recon______________________________________________________________________________________________________________________________________________________
ehco "IP Address recon"
uncover -q "'ssl:$domain'" -e shodan  | anew  myrecon/subdomain/$domain-ips.txt
#passive sub enum
done <$1
#Subdomain Brute Force______________________________________________________________________________________________________________________________________________________
echo "Subdomain Brute Force______________________________________________________________________________________________________________________________________________________"
while read domain; do
echo "subdomain brute force "
amass enum -active -d $domain -brute -w subdomains-10000.txt -o  myrecon/subdomain/$domain-b.txt;
cat  myrecon/subdomain/$domain-b.txt | anew myrecon/subdomain/$domain.txt
rm myrecon/subdomain/$domain-b.txt 
done < $1
#Live Subdomain:
#=========================================================================================================================================================\\

while read domain; do
echo "live subdoamins"
cat myrecon/subdomain/$domain-ips.txt | httpx -sc -cl -title -td -fr -server   | anew myrecon/alive/scode/$domain-ip-state.txt | cut -d "[" -f 1 | anew myrecon/alive/$domain-live-ip.txt 
cat myrecon/subdomain/$domain.txt | httpx -sc -cl -title -td -fr -server     | anew myrecon/alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew myrecon/alive/$domain-livsub.txt
#=====================================================================================================================================================\\
#=====================================================================================================================================================\\
done < $1

#portScan
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
#Fuzz
while read domain; do
for i in `cat  myrecon/alive/$domain-livsub.txt`; do 
ffuf -u $i/FUZZ -w dicc.txt -fc 403,302 -v -c -se -ac | anew  myrecon/Content-Discovrey/fuzzing/$domain-fuzzing.txt;
done
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
cat  myrecon/subdomain/$domain.txt | gauplus -b png,jpg,jpeg,css,gif,woff,svg  | anew myrecon/Content-Discovrey/allcontent/$domain.txt;
cat  myrecon/Content-Discovrey/allcontent/$domain.txt |  grep "="  | qsreplace -a | anew myrecon/Content-Discovrey/params/$domain-params.txt;
cat myrecon/Content-Discovrey/allcontent/$domain.txt | grep "\.js" | anew myrecon/Content-Discovrey/jsfile/$domain-js.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf xss      | anew myrecon/Content-Discovrey/vuln-params/$domain-xss.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf ssrf     | anew myrecon/Content-Discovrey/vuln-params/$domain-ssrf.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf sqli     | anew myrecon/Content-Discovrey/vuln-params/$domain-sqli.txt
cat  myrecon/Content-Discovrey/params/$domain-params.txt  | gf redirect | anew myrecon/Content-Discovrey/vuln-params/$domain-openred.txt
done < $1
#xss scan
while read domain; do
cat myrecon/Content-Discovrey/vuln-params/$domain-xss.txt |  kxss | anew myrecon/Content-Discovrey/vuln/$domain-kxss.txt 
done < $1
#open-redirect
while read domain; do
cat  myrecon/Content-Discovrey/vuln-params/$domain-openred.txt| cut -f 3- -d ':' | qsreplace "https://evil.com" | httpx  -status-code -location  -fr | anew myrecon/Content-Discovrey/vuln/$domain-openred.txt
cat myrecon/subdomain/$domain.txt | httpx -status-code -location  -fr -path /evil.com,///evil.com,////evil.com | anew myrecon/Content-Discovrey/vuln/$domain-openred-root.txt
done < $1
#information Disclosure
while read domain; do
cat myrecon/Content-Discovrey/jsfile/$domain-js.txt | httpx -mc 200 |nuclei -t ~/nuclei-templates/exposures/ | anew anew myrecon/Content-Discovrey/vuln/$domain-disclousre.txt
done < $1
#ssrf 
ssrftoken=1brzkl83d6vjn3herkeymon07.canarytokens.com
while read domain; do
cat  myrecon/Content-Discovrey/vuln-params/$domain-ssrf.txt| cut -f 3- -d ':' | qsreplace $ssrftoken | httpx  -status-code -location  -fr | anew myrecon/Content-Discovrey/vuln/$domain-ssrf.txt
done < $1
#http-smuggling
while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt -tags smuggling | anew myrecon/Content-Discovrey/vuln/$domain-smuggling.txt
done < $1
#crlf 
while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt -tags crlf | anew myrecon/Content-Discovrey/vuln/$domain-crlf.txt
done < $1
# cache-poisoning  
while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt -id cache-poisoning  | anew myrecon/Content-Discovrey/vuln/$domain-cache-poisoning.txt
done < $1
#cve_scan
while read domain; do
nuclei -l myrecon/alive/$domain-livsub.txt -tags cve | anew myrecon/Nuclei-scan/$domain-cve.txt
nuclei -l myrecon/alive/$domain-live-ip.txt -tags cve | anew myrecon/Nuclei-scan/$domain-cve-ip.txt
done < $1
