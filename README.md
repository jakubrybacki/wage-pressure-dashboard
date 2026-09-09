# Quarto Wage Pressure Tracker Dashboard

Interaktywny dashboard analizy presji płacowej w Europie (**Wage Pressure Tracker**) zreplikowany na bazie raportu Looker Studio i wzbogacony o pełną interaktywność, responsywność mobilną oraz eksport danych do CSV.

🌐 **Live Dashboard:** [https://jakubrybacki.github.io/wage-pressure-dashboard/](https://jakubrybacki.github.io/wage-pressure-dashboard/)

---

## 🎨 Paleta kolorystyczna (Looker Studio Theme)

* **Polska (`PL`) – Róż / Magenta (`#d6498b`):** Główny odcień dla Polski.
* **Niemcy (`DE`) – Żółty / Ciepły Amber (`#fec44f`):** Sygnowy odcień Looker Studio dla Niemiec.
* **Hiszpania (`ES`) – Pomarańczowy (`#fe9929`):** Odcień dla Hiszpanii.
* **Holandia (`NL`) – Seledyn / Turkus (`#41b6c4`):** Odcień dla Holandii.
* **Francja (`FR`) – Szmaragdowa zieleń (`#2ca25f`):** Odcień dla Francji.
* **Włochy (`IT`) – Głęboki fiolet (`#6a1b9a`):** Odcień dla Włoch.
* **Tekst, osie i linie pomocnicze:** `#111111` / `#222222` / `#f0f0f0`.

---

## 📑 Sekcje Dashboardu (Zakładki)

1. **`European Overview` (Wzorowane na Slajdzie 1 Looker Studio):**
   * **Scorecards (Karty metryk):** Aktualny poziom wskaźnika MA 12M, zmiana roczna YoY (pkt), szczyt historyczny oraz plakietka statusu (Very High, High, Moderate, Subdued) dla 6 gospodarek.
   * **Główny wykres porównawczy:** Szeregi czasowe PCA (0–100) od 2004 do 2026 r. z możliwością przełączania stopnia wygładzenia:
     - *12-Month Trend (MA 12M)* [Domyślny trend strukturalny]
     - *3-Month Momentum (MA 3M)* [Krótkoterminowe momentum]
     - *Monthly SA Index (Raw)* [Miesięczny odsezonowany indeks]
   * **Tabela podsumowująca (DataTable):** Porównanie poziomu presji, dynamiki rocznej, szczytów i wyjaśnionej wariancji z żółtym nagłówkiem Looker Studio i paskami graficznymi.

2. **`Germany & France` (Wzorowane na Slajdzie 2 Looker Studio):**
   * **Niemcy – Komponenty:** 4 zdeseasonalizowane filary zapytań: `Gehaltserhöhung + Lohnerhöhung`, `Gehaltsverhandlung + Gehalt verhandeln`, `Mindestlohn + Mindestlohn Erhöhung`, `Tarifverhandlung + Tariferhöhung + Tariflohn` (*naprawiono błąd z wersji roboczej Looker Studio, gdzie omyłkowo widniały zapytania hiszpańskie*).
   * **Francja – Komponenty:** `négociation salariale + NAO salaire`, `augmentation SMIC + hausse SMIC`, `revalorisation salariale + revalorisation salaire`, `augmentation de salaire + augmentation salaire`.
   * Ułożenie w 2 pełnowymiarowych rzędach (zgodnie z regułą 2-Element Vertical Stacking).

3. **`Netherlands & Italy` (Wzorowane na Slajdzie 3 Looker Studio):**
   * **Holandia – Komponenty:** `cao loonsverhoging + cao onderhandelingen`, `loonstijging + salarisstijging`, `loonsverhoging + salarisverhoging`, `minimumloon stijging + minimumloon verhoging`.
   * **Włochy – Komponenty:** `adeguamento salariale + adeguamento stipendio`, `aumento stipendio + aumento di stipendio`, `chiedere aumento stipendio + trattativa stipendio`, `rinnovo ccnl + aumenti ccnl`.

4. **`Spain & Poland` (Wzorowane na Slajdzie 4 Looker Studio):**
   * **Hiszpania – Komponenty:** `convenio colectivo subida + subida salarial convenio`, `subida de sueldo + aumento de sueldo + subida salarial`, `subida SMI + subida salario minimo`, `revisión salarial + revalorización salarial`.
   * **Polska – Komponenty:** `podwyżka pensji + podwyżka wynagrodzenia + podwyżka płacy`, `rozmowa o podwyżce + negocjacja pensji + wniosek o podwyżkę`, `wzrost wynagrodzeń + wzrost płac`, `zarobki + ile zarabia + kalkulator wynagrodzeń`.

5. **`Country Explorer` (Interaktywny eksplorator indywidualny):**
   * Natywny selektor kraju (PL, DE, ES, NL, FR, IT) działający bez odświeżania strony.
   * Dynamiczne karty wyników (aktualny trend, dynamika YoY, szczyt, dopasowanie PCA).
   * Wykres syntetycznego indeksu (Raw SA, MA 3M, MA 12M z wypełnieniem).
   * Wykres komponentów dla danego kraju.
   * Wykres słupkowy ładunków czynnikowych (PCA Loadings) i wyjaśnionej wariancji.

6. **`Methodology & PCA Weights`:**
   * **6 dedykowanych wykresów kolumnowych ładunków czynnikowych (PC1 Weights)** – po jednym dla każdego kraju (siatka 3x2), z zachowaniem indywidualnej palety barw Looker Studio (PL: różowy, DE: bursztynowy, ES: pomarańczowy, NL: turkusowy, FR: zielony, IT: fioletowy).
   * Dedykowany eksport CSV dla każdego z wykresów wag.
   * Szczegółowy opis metodyki: pobieranie Big Data z Google Trends, filtr 3M, adaptacyjne odsezonowanie STL (`s.window = 7`), wygładzanie MA 12M, estymacja 1. Głównej Składowej (PC1) i skalowanie Min-Max 0–100.

---

## 📥 Eksport danych do CSV (`[ 📥 CSV ]`)

Pod każdym wykresem znajduje się dedykowany pasek narzędziowy z przyciskiem `[ 📥 CSV ]`. Kliknięcie eksportuje dane widocznych na wykresie serii do formatu CSV zgodnego ze standardem RFC-4180 z kodowaniem UTF-8 z BOM (pełna kompatybilność z polskimi znakami i programem Microsoft Excel).

---

## 📱 Responsywność mobilna (Continuous Scroll)

* Zgodnie ze standardami `.agents/skills/dashboard-standards`, na ekranach smartfonów (szerokość ≤ 768px) dashboard automatycznie przełącza się w tryb **jednolitego strumienia pionowego (continuous vertical scroll)**.
* Sekcje są wyraźnie oddzielone wizualnymi banerami-odznakami (`::before`).
* Kliknięcie pozycji w menu nawigacyjnym płynnie przewija stronę do wybranej sekcji i natychmiast zamyka menu hamburger.
* Natywne kontrolki wyboru posiadają wymuszony rozmiar czcionki `16px`, co zapobiega irytującemu automatycznemu przybliżaniu ekranu w przeglądarce Safari na urządzeniach iOS.

---

## 🛠️ Budowanie dashboardu

Aby wygenerować lub zaktualizować dashboard, wystarczy uruchomić skrypt PowerShell:

```powershell
.\build.ps1
```

Skrypt automatycznie wyrenderuje plik `index.html` przy użyciu Quarto i sprawdzi rozmiar pliku wyjściowego.
