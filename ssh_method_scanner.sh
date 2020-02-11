#!/bin/bash
function scanner {
	RESULT=$(ssh -o ConnectTimeout=11 -o PreferredAuthentications=none -o StrictHostKeyChecking=no $IP -p $PORT 2>&1)
	messages
}

function messages {
	if [[ $RESULT == *"password"* ]]; then
		echo -e '\e[31m[-] ISSUE: supports password authentication.\e[0m'
	fi
	if [[ $RESULT == *"publickey"* ]]; then
	 	echo -e "\e[32m[+] INFO: supports publickey authentication.\e[0m"
	fi
	if [[ $RESULT == *"unreachable"* ]]; then
	 	echo -e "\e[31m[-] Erorr: target not reachable on port $PORT\e[0m"
	fi
	if [[ $RESULT == *"Bad port"* ]]; then
	 	echo -e "\e[31m[-] Erorr: bad port.\e[0m"
	fi
	if [[ $RESULT == *"timed out"* ]]; then
	 	echo -e "\e[31m[-] Erorr: timed out.\e[0m"
	fi
	echo ""
}

function main {
	read -p "Single (s) or multiple (m) IP/DNS scan: " CHOICE
	if [[ $CHOICE =~ ^[Ss]$ ]]; then
		read -p "Give IP/DNS to scan: " IP
		read -p "Give port to scan: " PORT
		scanner
	elif [[ $CHOICE =~ ^[Mm]$ ]]; then
		read -p "Enter filename containing list of IP/DNS: " IPLIST
		while read IPLIST; do
			IP=$IPLIST
			PORT=22
			if [[ "$IPLIST" == *":"* ]]; then
			  	IP=$(echo $IPLIST | cut -d ':' -f 1)
				PORT=$(echo $IPLIST | cut -d ':' -f 2)
				echo "Result for: $IPLIST"
			else
				echo "Result for: $IPLIST:$PORT"
			fi
		scanner
		done < $IPLIST
	else
		echo -e "\e[31mPlease make a valid choice.\e[0m"
		echo ""; main
	fi		
}

main