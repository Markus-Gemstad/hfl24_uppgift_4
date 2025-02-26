# ParkMyCar

En parkeringsapp med tillhörande server-api (webservices) och admin-gui.

## Installation

1. Ladda ner hela repot (https://github.com/Markus-Gemstad/hfl24_uppgift_4)
2. Öppna mappen i Visual Studio Code
3. Öppna en terminal i mappen parkmycar_server
4. Starta servern: 'dart run parkmycar_server:server'
5. parkmycar_user (användarappen):
5.1. Starta iOS-simulator eller Android-simulator (bara testat på Mac, appen går även att köra som MacOS-app)
5.2. Kör parkmycar_user i iOS-simulatorn (flutter run)
6. parkmycar_admin (adminappen):
6.1. Kör parkmycar_admin som macOS-app (flutter run)

## Funktioner
### parkmycar_user

- Registrering av nya användare (namn och e-post)
- In-/utloggning (med e-post endast)
- Lägga till fordon
- Ta bort fordon
- Lista egna fordon
- Visa lediga parkeringsplatser
- Starta parkering
- Avsluta parkering
- Visa parkeringshistorik
- Redigera användare (endast namn, e-post är låst)
- Byta mellan mörkt, ljust eller automatiskt (system) tema

### parkmycar_admin

- Responsiv design/layout (för menyer)
- Lägga till nya parkeringsplatser
- Ta bort parkeringsplatser
- Visa alla parkeringsplatser
- Visa aktiva parkeringar
- Antal aktiva parkeringar
- Summerad inkomst från parkeringar
- Populäraste parkeringsplatserna (top 10)
- Redigera användare (endast namn, e-post är låst)
- Byta mellan mörkt, ljust eller automatiskt (system) tema

## Uppgift 4

### Nyheter

- ParkMyCar user: Blocs för "active parking", Parkings, ParkingSpaces och Vehicles
- ParkMyCar admin: Bloc för ParkingSpaces
- Delad funkionalitet (parkmycar_client_shared): HydratedBloc för inloggning (AuthBloc) och HydratedCubit för tema-hantering (ThemeCubit)
- Tester för alla Blocs (ej ThemeCubit) inklusive tester för fel
- Testerna använder Mocktail för att mocka repositories

### Funktioner för VG

- Delade blocs och bloc-widgets mellan användar- & admin-app (AuthBloc och ThemeCubit).
- Optimistiska uppdateringar av GUI: se Fordonssidan (VehicleScreen, användarapp) och Parkeringsplatser (ParkingSpaceScreen, adminapp)
- Tydlig indikering på "sync in progress" som visar när en optimistisk uppdatering av state påbörjat och faktiskt är klar: se ovan
- Persistent lagring av inloggat status och använder (AuthBloc) och valt tema (ThemeCubit)

### Avgränsningar och kända begränsningar

- Hade gärna velat gå "all-in" med Blocs och Cubits, nu är koden rätt blandad, men tiden rann ut
- De gamla testerna (uppg 3) för server verkar inte fungera, inte hunnit felsöka
- Koden för AuthBloc känns lite förvirrad tycker jag, var mitt första Bloc :)
- Kunde inte få debounce för sökningen i ParkingSpacesBloc (både användar- och adminapp) att funka tillsammans med testet
- Inte grundligt undersökt om stateful-widgets kan bytas ut mot stateless hela vägen där nu Blocs används

## Uppgift 3

### Funktioner för VG

- Sökfunktioner för parkeringsplatser
- Redigering av skapat data (fordon i användarappen och parkeringsplatser i admin-appen)
- Mörkt/ljust tema
- Delat kodbibliotek mellan apparna för att återanvända widgets (inloggning, skapa användare, klientrepo, tema)
- Förslag på eget VG-kriterie - Hero-animation :-), finns för Starta parkering i användarappen.

### Avgränsningar och kända begränsningar

- Finns ingen säkerhet i inloggningen, den går på tillgångliga e-postadresser i databasen. Samma användare har full tillgång till båda apparna, dvs finns inget som säger om man är user eller admin. 

- Har valt att se ParkingSpace (parkeringsplats) som en gata med ej definierat antal parkeringplatser vilket gör att en gata aldrig kan markeras som upptagen/ledig. Har tittat på hur det ser ut i tex EasyPark.

- Har valt att man bara kan ha en parkering igång i taget i användarappen (som EasyPark).

- Användarappen är inte byggd för att vara resonsiv, dvs den ändrar inte utformning av menyer etc vid annan bredd.

- Datalagringen har lösa kopplingar (bara id'n som referens till relaterade objekt, ärvt från uppgift 1 och 2). Detta ger en hel del ineffektiva hämtningar av data, tex för statistik och adress till en parkering. Finns heller inget som hindrar en från att ta bort ett objekt som ett annat objekt har en relation till (tex en bil till en parkering). Har lagt in en del TODO-kommenterar i koden för detta.

- En del kod i parkmycar_user skulle sannolikt kunnat lösas snyggare men lärde mig saker vart efter som inte hann ändras, tex växling av skärm/vy för pågående parkering eller lagring av ongoingParking.

- Skulle velat lägga till ett sätt att förlänga en parkeringstid som gått ut men hann inte. Men det visas iaf en röd text när tiden gått ut :-)

- Statistiksidan är inte vacker men den gör det den ska.

