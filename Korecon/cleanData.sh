#!/bin/bash

gau $1 | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tiff|png|woff|woff2|tff|ico|pdf|svg|js|)" | qsreplace -a | anew gau-data.txt
