#!/bin/bash
read -p "Enter your Domain:==>  " ssrf
while read domain; do
cat  Content-Discovrey/vuln-params/$domain-xss.txt | httpx | kxss | anew Content-Discovrey/vuln/$domain-xss.txt
cat Content-Discovrey/params/$domain-params.txt | httpx |dalfox pipe --custom-payload xss.txt > anew Content-Discovrey/vuln-/$domain-dalfox.txt
cat  Content-Discovrey/vuln-params/$domain-ssrf.txt | qsreplace  $ssrf| anew Content-Discovrey/vuln-params/$domain-urlssrf.txt ; ffuf -u "FUZZ"  -mc 200 -w Content-Discovrey/vuln-params/$domain-urlssrf.txt | anew /Content-Discovrey/vuln-/$domain-ssrf.txt
python3 sqli-scanner/sqli-scanner.py -f Content-Discovrey/vuln-params/$domain-sqli.txt  | anew Content-Discovrey/vuln-/$domain-sqli.txt
done < $1