#!/bin/bash
LOGFILE="/app/data/pokemon_log.txt"
id=1
max=1000

while true; do
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  response=$(curl -s --max-time 10 "https://pokeapi.co/api/v2/pokemon/$id")

  if [ $? -ne 0 ] || [ -z "$response" ]; then
    echo "$timestamp: kunne ikke hente pokemon #$id, prøver igen om 30s"
  else
    name=$(echo "$response" | jq -r '.name')
    echo "=== $timestamp ===" >> "$LOGFILE"
    echo "#$id $name" >> "$LOGFILE"
    echo "$timestamp: tilføjede #$id $name til loggen"
    id=$((id + 1))
    if [ "$id" -gt "$max" ]; then
      id=1
    fi
  fi

  sleep 30
done
