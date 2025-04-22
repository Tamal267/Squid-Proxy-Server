#!/bin/bash

while IFS= read connection; do
	  user_host="${connection%:*}" 
    user="${user_host%@*}"      
    host="${user_host#*@}"     
    port="${connection#*:}"   

    echo "Configuring $i..."
    ssh-keyscan -p "$port" "$host" >> ~/.ssh/known_hosts 2>/dev/null
    sshpass -p "$PASS" ssh-copy-id -f -o StrictHostKeyChecking=no -p "$port" "$user_host"
done < hosts.txt

echo "SSH key deployment complete."
