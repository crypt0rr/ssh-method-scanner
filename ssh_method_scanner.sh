#!/bin/bash
function singleIP {
read -p "Give IP/DNS to scan: " IP
read -p "Give port to scan: " PORT
	RESULT=$(ssh -o ConnectTimeout=15 -o PreferredAuthentications=none -o StrictHostKeyChecking=no $IP -p $PORT 2>&1)
	if [[ $RESULT == *"password"* ]]; then
		echo "ISSUE: supports password authentication."
	fi
	if [[ $RESULT == *"publickey"* ]]; then
	 	echo "INFO: supports publickey authentication."
	else
		echo "$IP exceeded timeout"
	fi
	echo ""
}

singleIP