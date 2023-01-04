#!/bin/bash

# Check if the domain list file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 domain_list_file"
    exit 1
fi

# Create a temporary file to store the IP addresses
temp_file=$(mktemp)

# Read the domain list file
while read domain; do
    # Check if the domain is not empty
    if [ ! -z "$domain" ]; then
        # Get the IP address for the domain
        ip=$(dig +short $domain)
        # Append the IP address to the temporary file
        echo "$ip" >> "$temp_file"
    fi
done < "$1"

# Extract only the unique IP addresses from the temporary file
sort "$temp_file" | uniq > "ip_addresses.txt"

# Remove all strings from the "ip_addresses.txt" file
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" "ip_addresses.txt" > "ip_addresses_filtered.txt"

# Output the contents of the "ip_addresses_filtered.txt" file
cat "ip_addresses_filtered.txt"

# Remove the temporary file
rm "$temp_file"
