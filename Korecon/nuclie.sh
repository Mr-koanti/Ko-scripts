#!/bin/bash
mkdir nuclei
nuclei -l $1 -t /home/mrk/nuclei-templates/takeovers/ -c 50 | anew nuclei/tackover.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/cves/ -c 50 | anew nuclei/cve.txt 
nuclei -l $1 -t /home/mrk/nuclei-templates/cnvd/ -c 50  | anew nuclei/cnvd.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/file/ -c 50 | anew nuclei/files.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/vulnerabilities/ -c 50 | anew nuclei/vulun.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/default-logins/ -c 50 | anew nuclei/login.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/exposed-panels/ -c 50 | anew nuclei/exposed-panal.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/exposures/ -c 50 | anew nuclei/exposure.txt
nuclei -l $1 -t /home/mrk/nuclei-templates/misconfiguration/  -c 50 | anew nuclei/misconfig.txt

