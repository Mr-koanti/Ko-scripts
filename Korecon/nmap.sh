#!/bin/bash
mkdir vulnport
nmap -iL $1 --script vuln | anew vulnport/$1.txt
