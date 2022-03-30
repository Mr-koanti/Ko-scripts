#!/bin/bash

while read domain; do 
'/home/mrk/Desktop/bugbounty/methodolgy/my scripts/Sub-Drill.sh' $domain | sort -u  | httpx -sc -cl -ports 80,8080,8448,433,21,445,3306,1433,3389,22 | anew alive/scode/$domain-statecode.txt | cut -d "[" -f 1 | anew alive/$domain-livsub.txt
done < $1
