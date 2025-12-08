# Geo Journal (Flutter)

Geo Journal to lekka aplikacja mobilno-webowa napisana we Flutterze (Dart), która pozwala dodawać wpisy z opisem oraz zapisywać do nich bieżącą lokalizację GPS.

Projekt został wykonany w ramach zadania zaliczeniowego z Fluttera.

---

## Zakres funkcjonalny

Aplikacja wykorzystuje GPS urządzenia (pakiet geolocator):

- możliwość pobrania aktualnych współrzędnych,
- zapis lokalizacji razem z dodawanym wpisem,
- obsługa braku lub odmowy uprawnień do lokalizacji.

# Komunikacja z API

Aplikacja łączy się z zewnętrznym API (MockAPI):
- GET /entries – pobieranie wszystkich wpisów,
- POST /entries – dodawanie nowego wpisu.
---

## Widoki aplikacji

1. **Lista wpisów**
- prezentacja zapisanych pozycji,
- widoczne informacje o dacie i lokalizacji,
- obsługa stanów: pusty, ładowanie, błąd.

2. **Szczegóły wpisu**
   - tytuł,
   - opis,
   - data utworzenia,
   - lokalizacja (jeśli została zapisana).

3. **Dodaj wpis**
   - formularz (tytuł, opis),
   - przycisk „Pobierz lokalizację” (GPS),
   - zapis danych do API.

4. **Ustawienia**
   - przełącznik jasny / ciemny motyw aplikacji.

---

## Nawigacja
- z listy do szczegółów (z przekazaniem danych wpisu),
- z listy do dodawania wpisu,
- z listy do ustawień.

---

## Obsługa stanów UX

- **Ładowanie** – wskaźnik CircularProgressIndicator,
- **Pusty stan** – komunikat przy braku wpisów,
- **Błąd API / brak internetu** – komunikat z możliwością ponowienia,
- **Brak uprawnień lokalizacji** – komunikat informujący użytkownika.

---

## Użyte technologie

- Flutter (Dart)
- HTTP (`http`)
- GPS (`geolocator`)
- MockAPI (REST API)

---

## Uruchomienie projektu

### Wymagania
- Flutter SDK
- Android Emulator lub przeglądarka (Chrome)
- VS Code lub Android Studio

### Kroki

```bash
flutter pub get
flutter run
=======
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/VcFknM5q)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=21969001&assignment_repo_type=AssignmentRepo)
# Flutter: Geo Journal

## Cel
Stwórz podstawową aplikację w **Flutter (Dart)** z **natywną funkcją** oraz **komunikacją z API**, zawierającą **3–4 widoki**.

## Zakres i wymagania funkcjonalne
- **Natywna funkcja (min. 1):** wybierz i uzasadnij (np. lokalizacja GPS, aparat/kamera, udostępnianie/clipboard, czujniki).
- **API (min. 1 endpoint):** odczyt listy wpisów lub zapis nowego.
- **Widoki (3–4):**
  1. **Mapa/Lista wpisów** (pin/pozycja lub lista z datą i miejscem).
  2. **Szczegóły wpisu** (opis, zdjęcie/lokalizacja, akcje).
  3. **Dodaj wpis** (formularz: tytuł, opis, przycisk „pobierz lokalizację” **lub** „zrób zdjęcie”).
  4. *(Opcjonalnie)* **Ustawienia** (np. motyw jasny/ciemny).
- **Nawigacja:** przejścia między widokami z przekazaniem identyfikatora.
- **UX:** komunikaty o błędach, pusty stan, stany ładowania.


## Testowanie lokalne (w trakcie developmentu)
- Uruchom na **emulatorze/urządzeniu**.
- Pokaż: dodanie wpisu z **natywną funkcją** (GPS/zdjęcie), pojawienie się na liście/mapie.
- Pokaż komunikację z **API** (pobranie/zapis), zachowanie bez internetu/bez uprawnień.

## Definition of Done (DoD)
- [ ] 3–4 widoki, kompletna nawigacja.
- [ ] Co najmniej 1 **natywna funkcja**.
- [ ] Co najmniej 1 operacja **API** (GET/POST).
- [ ] Stany: ładowanie, błąd, pusty.
- [ ] `README.md`, zrzuty ekranów, min. 3 commity.
