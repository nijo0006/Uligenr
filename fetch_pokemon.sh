#!/bin/bash
while true; do
  echo "Henter data fra PokeAPI..."
  curl -s --max-time 10 "https://pokeapi.co/api/v2/pokemon?limit=1000" | \
    jq -r '.results[] | "#\(.url | split("/")[-2]) \(.name)"' > /app/data/pokemon_log.txt

  status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://web/pokemon)
  if [ "$status" == "200" ]; then
    echo "$(date): web svarer 200 OK"
  elif [ "$status" == "000" ]; then
    echo "$(date): kunne ikke nå web endnu"
  else
    echo "$(date): web svarede status $status"
  fi

  sleep 30
done