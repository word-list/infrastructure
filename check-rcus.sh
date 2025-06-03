#!/bin/bash

FILE="dynamodb.tf"
FREE_TIER_RCU=25
FREE_TIER_WCU=25

READ_TOTAL=$(grep "^\s*read_capacity" "$FILE" | awk '{sum += $NF} END {print sum}')
WRITE_TOTAL=$(grep "^\s*write_capacity" "$FILE" | awk '{sum += $NF} END {print sum}')

if [[ $READ_TOTAL -gt $FREE_TIER_RCU ]]; then 
    READ_WARNING="!! Exceeds free tier limit of $FREE_TIER_RCU"
fi

if [[ $WRITE_TOTAL -gt $FREE_TIER_WCU ]]; then
    WRITE_WARNING="!! Exceeds free tier limit of $FREE_TIER_WCU"
fi

echo "Total Read Capacity Units (RCUs): $READ_TOTAL $READ_WARNING"
echo "Total Write Capacity Units (WCUs): $WRITE_TOTAL $WRITE_WARNING"

if [[ -n "$READ_TOTAL" ]] || [[ -n "$WRITE_TOTAL" ]]; then
    exit 1
fi