# ikebrute v1.0
Simply runs through a wordlist of default/common group IDs and parses each hash to a separate file to be cracked offline
</br></br>
Usage:  ./ikebrute.sh [TARGET IP]
</br></br>
Requirements:  ike-scan, psk-crack, and /usr/share/wordlists/rockyou.txt
</br></br>
Future Updates:   1. cat hash files and check for a null value (remove those that are null) </br>
                  2.  Add bruteforce mode to psk-crack for cracking hashes</br>
                  3.  Parse output file for successful cracks
</br></br>
Kevin Gilstrap </br>
Sungard Availability Services, Lead Sr. Penetration Tester </br>
February 14, 2017
