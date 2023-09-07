#!/bin/sh

country_code='JP'
ipv4_list="/var/db/v4jp.ipset"
apnic_url="http://ftp.apnic.net/stats/apnic/delegated-apnic-latest"

# clear ipv4 database
:> ${ipv4_list}

# Fetch the latest delegated-apnic-latest and create the IP address database
curl -s ${apnic_url} | \
awk -F"|" -v country="$country_code" '$2 == country && $3 == "ipv4" { print $4, 32-log($5)/log(2) }' | \
while read -r IPADDR FLTCIDR; do
    echo "${IPADDR}/${FLTCIDR}" >> ${ipv4_list}
done
