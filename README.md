Hej Claus. Velkommen til vores opgave :)

Opgave 1: 
For at løse opgaven har vi brugt denne pipeline: 
curl -s https://pokeapi.co/api/v2/pokemon?limit=1000 | \
jq -r '.results[] | "#\(.url | capture("pokemon/([0-9]+)/").string) \(.name)"' >> /app/pokemon_log.txt

Resultatet findes på http://localhost:4000/pokemon

Opgave 2: 



Opgave 3: 
