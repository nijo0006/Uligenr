Hej Claus. Velkommen til vores opgave :)

# Uligenr – Pokémon Poller

Hej Claus. Velkommen til vores opgave :)

## Hvad gør projektet

Projektet er en lille "containeriseret toolbox" bestående af to services, der arbejder sammen:

- **`fetcher`** poller PokéAPI (`https://pokeapi.co`) hvert 30. sekund, trækker Pokémon-nummer og -navn ud med `jq`, og tilføjer resultatet – med tidsstempel – til en voksende logfil på en delt volume.
- **`web`** er en lille Flask-app, der læser den samme logfil og serverer indholdet på `/pokemon`.

De to services taler sammen på to måder:
1. `fetcher` tjekker løbende om `web` svarer, ved at curle `http://web/pokemon` – **via servicenavn**, ikke en hårdkodet IP.
2. Begge services deler en Docker-volume (`pokemon_data`), som er stedet `fetcher` skriver til, og `web` læser fra.

Scriptet er bygget til at overleve netværksfejl: hvis `web` ikke er oppe endnu, eller PokéAPI ikke svarer, logger `fetcher` bare fejlen og prøver igen 30 sekunder senere – den crasher ikke.

## Sådan kører du det

```bash
git clone https://github.com/nijo0006/Uligenr.git
cd Uligenr
docker compose up --build
```

Vent 30–60 sekunder (ét til to poll-loops), og åbn derefter:

```
http://localhost:8080/pokemon
```

Du skulle nu se en voksende, tidsstemplet liste med Pokémon-navne og -numre. Genindlæs siden efter et par minutter, og der er kommet flere blokke til.

For at stoppe projektet igen:

```bash
docker compose down
```

(tilføj `-v` hvis du også vil slette den gemte log og starte helt forfra: `docker compose down -v`)

## Filoversigt

| Fil | Ansvar |
|---|---|
| `docker-compose.yml` | Definerer de to services (`web` og `fetcher`), deres build-kontekst, porte og den delte volume |
| `Dockerfile` | Bygger `web`-servicen (Python/Flask) |
| `app.py` | Flask-app; serverer `/` og `/pokemon` ved at læse den delte logfil |
| `requirements.txt` | Python-afhængigheder til `web` (Flask) |
| `Dockerfile.fetcher` | Bygger `fetcher`-servicen (Debian + curl + jq) |
| `fetch_pokemon.sh` | Poller PokéAPI i en løkke, tjekker `web`, og skriver tidsstemplede resultater til logfilen |

## Arkitektur i korte træk

```
fetcher  --curl-->  PokéAPI (eksternt)
fetcher  --skriver-->  delt volume (pokemon_log.txt)
web      --læser-->  delt volume
web      --exposer-->  localhost:8080/pokemon
fetcher  --curl (servicenavn: http://web)-->  web   (helbredstjek)
```

## Gruppemedlemmer

- Nina Lind Johansen
- Stephanie Rone Skjøtt
- Freja Johnna Tromborg
- Frederik Egede Johansen
