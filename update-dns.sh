if [ -z "$ZONE_ID" ]; then 
    echo "ZONE_ID must be defined"
    exit 1
fi 

if [ -z "$DOMAIN_NAME" ]; then
    echo "DOMAIN_NAME must be defined"
    exit 1
fi 

if [ -z "$CLOUDFLARE_API_TOKEN" ]; then 
    echo "CLOUDFLARE_API_TOKEN must be defined"
    exit 1
fi

# Remove existing NS records
echo "Retrieving NS records from $ZONE_ID..."
EXISTING_RECORDS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=NS" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" | jq -r '.result[].id')

echo "Removing NS records from $ZONE_ID..."
for RECORD_ID in $EXISTING_RECORDS; do
    curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json"
done

echo "Retrieving NS records from terraform output..."
NS_RECORDS=$(terraform output -json hosted_zone_ns_records | jq -r '.[]')

echo "Adding NS records to $ZONE_ID..."
for NS in $NS_RECORDS; do
    curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" -H "Content-Type: application/json" \
        --data "{\"type\":\"NS\",\"name\":\"$DOMAIN_NAME\",\"content\":\"$NS\",\"ttl\":300}"
done
