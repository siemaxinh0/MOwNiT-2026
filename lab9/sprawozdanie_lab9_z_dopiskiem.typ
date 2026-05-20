#set document(title: "MOwNiT — Laboratorium 9", author: "Hubert Kukla, Maksymilian Siemek")
#set page(margin: 2.4cm, numbering: "1", number-align: center)
#set text(lang: "pl", size: 11pt)
#set par(justify: true, leading: 0.62em)
#set heading(numbering: "1.")
#set figure(numbering: "1")

#align(center)[
  #text(size: 20pt, weight: "bold")[MOwNiT -- Laboratorium 9]\
  #text(size: 15pt)[Równania różniczkowe zwyczajne -- część I]\
  #v(0.6em)
  Data: 06.05.2026\
  Autorzy: Hubert Kukla, Maksymilian Siemek
]

#v(1em)

= Cel ćwiczenia

Celem laboratorium było przećwiczenie podstawowych pojęć związanych z równaniami różniczkowymi zwyczajnymi: sprowadzania równań wyższych rzędów do układów pierwszego rzędu, zamiany problemów nieautonomicznych na autonomiczne oraz analizy zbieżności i stabilności metody Eulera. Ostatnia część ćwiczenia dotyczyła empirycznego wyznaczania rzędu zbieżności na przykładzie problemu o znanym rozwiązaniu dokładnym.

= Zadanie 1. Sprowadzenie równań do układów pierwszego rzędu

W pierwszym zadaniu należało przepisać równania różniczkowe wyższych rzędów jako równoważne układy pierwszego rzędu. Jest to standardowy krok przygotowujący równanie do użycia w solverach numerycznych, które najczęściej operują na wektorze stanu i jego pochodnej.

#figure(
  table(
    columns: (1.1fr, 1.5fr, 2.6fr),
    inset: 5pt,
    align: left,
    table.header([Przypadek], [Zmienne stanu], [Układ pierwszego rzędu]),
    [Van der Pol],
    [$u_0 = y$, $u_1 = y'$],
    [$u'_0 = u_1$, $u'_1 = u_1(1 - u_0^2) - u_0$],
    [Blasius],
    [$u_0 = y$, $u_1 = y'$, $u_2 = y''$],
    [$u'_0 = u_1$, $u'_1 = u_2$, $u'_2 = -u_0 u_2$],
    [Problem dwóch ciał],
    [$u_0 = y_1$, $u_1 = y'_1$, $u_2 = y_2$, $u_3 = y'_2$],
    [$u'_0 = u_1$, $u'_1 = -G M u_0 / (u_0^2 + u_2^2)^(3/2)$, $u'_2 = u_3$, $u'_3 = -G M u_2 / (u_0^2 + u_2^2)^(3/2)$],
  ),
  caption: [Zapis równań z zadania 1 w postaci układów pierwszego rzędu.]
)

W implementacji każda funkcja przyjmuje argumenty `(t, u)` i zwraca tablicę pochodnych. W przypadku problemu dwóch ciał wspólny mianownik $(u_0^2 + u_2^2)^(3/2)$ obliczono tylko raz.

== Wnioski do zadania 1

1. Każde równanie rzędu $k$ można zapisać jako układ $k$ równań pierwszego rzędu przez wprowadzenie kolejnych pochodnych jako nowych zmiennych stanu.
2. Taki zapis jest wygodny numerycznie, ponieważ wszystkie analizowane przypadki można później przekazać do solvera w jednolitej postaci $u' = f(t, u)$.
3. Dla układów fizycznych, takich jak problem dwóch ciał, wektor stanu naturalnie zawiera pozycje oraz prędkości, a przyspieszenia pojawiają się dopiero w prawych stronach równań.

= Zadanie 2. Sprowadzenie problemu do postaci autonomicznej

Dany układ zawierał jawne wystąpienia czasu:

$ y'_1 = y_1 / t + y_2 t $
$ y'_2 = t (y_2^2 - 1) / y_1 $

Aby uzyskać układ autonomiczny, wprowadzono dodatkową zmienną stanu $u_2$, która reprezentuje czas wewnętrzny. Spełnia ona proste równanie $u'_2 = 1$. Po podstawieniu $u_0 = y_1$, $u_1 = y_2$, $u_2 = t$ otrzymujemy:

$ u'_0 = u_0 / u_2 + u_1 u_2 $
$ u'_1 = u_2 (u_1^2 - 1) / u_0 $
$ u'_2 = 1 $

Warunki początkowe również trzeba rozszerzyć. Ponieważ dane jest $y_1(1)=1$ oraz $y_2(1)=0$, startowy wektor stanu ma postać:

$ u(1) = (1, 0, 1) $

== Wnioski do zadania 2

1. Problem nieautonomiczny można sprowadzić do autonomicznego przez potraktowanie czasu jako dodatkowej zmiennej stanu.
2. Po tej operacji prawa strona układu zależy wyłącznie od $u$, a formalny argument czasu przekazywany przez solver nie jest już używany w obliczeniach.
3. Taka technika jest szczególnie przydatna, gdy chcemy stosować metody lub analizę przeznaczoną dla układów autonomicznych.

= Zadanie 3. Weryfikacja rozwiązania i dziedzina

Rozważany był problem początkowy:

$ y' = sqrt(1 - y), y(0) = 0 $

Kandydatem na rozwiązanie była funkcja:

$ y(t) = t(4 - t) / 4 $

Warunek początkowy jest spełniony, ponieważ $y(0)=0$. Pochodna funkcji wynosi:

$ y'(t) = 1 - t / 2 $

Z drugiej strony:

$ 1 - y(t) = 1 - t(4 - t)/4 = (1 - t/2)^2 $

stąd:

$ sqrt(1 - y(t)) = abs(1 - t / 2) $

Równość $y' = sqrt(1-y)$ zachodzi więc tylko wtedy, gdy $1 - t/2 >= 0$, czyli dla $t <= 2$. Ponieważ warunek początkowy jest zadany w punkcie $t=0$ i w zadaniu interesuje nas rozwiązanie w przód, przyjmujemy dziedzinę $[0, 2]$. Maksymalny przedział zawierający punkt początkowy, na którym ta konkretna funkcja spełnia równanie, można zapisać jako $(-infinity, 2]$.

== Wnioski do zadania 3

1. Samo podstawienie funkcji do równania nie wystarcza -- trzeba jeszcze uwzględnić znak pierwiastka.
2. Prawa strona równania jest zawsze nieujemna, dlatego pochodna kandydata na rozwiązanie także musi być nieujemna.
3. Funkcja $y(t)=t(4-t)/4$ spełnia warunek początkowy, ale jako rozwiązanie problemu w przód działa tylko do punktu $t=2$.

= Zadanie 4. Stabilność i zbieżność metody Eulera dla $y'=-5y$

Rozważane równanie ma rozwiązanie dokładne:

$ y(t) = e^(-5t) $

Zaburzenie warunku początkowego również jest mnożone przez $e^(-5t)$, więc z czasem zanika. Problem jest zatem stabilny analitycznie.

Dla jawnej metody Eulera dostajemy rekurencję:

$ y_(n+1) = y_n + h(-5y_n) = (1 - 5h)y_n $

czyli po $n$ krokach:

$ y_n = (1 - 5h)^n y_0 $

Jeżeli $n=h dot t$, to $h=t/n$ i: // !!!!!!!

$ lim_(n -> infinity) (1 - 5t/n)^n = e^(-5t) $

co potwierdza zbieżność metody przy $h -> 0$.

#figure(
  table(
    columns: (1.3fr, 1.8fr, 1.2fr, 2.1fr),
    inset: 5pt,
    align: left,
    table.header([Element analizy], [Wzór / kryterium], [Wynik], [Komentarz]),
    [Jawny Euler, stabilność], [$abs(1 - 5h) <= 1$], [$h=0.5$: $1.5 > 1$], [metoda niestabilna dla zadanego kroku],
    [Jawny Euler, $t=0.5$], [$y_1 = 1 + 0.5 dot (-5)$], [$-1.5$], [wynik zmienia znak i jest bardzo daleki od rozwiązania dokładnego],
    [Niejawny Euler, stabilność], [$y_(n+1) = y_n / (1 + 5h)$], [$1/3.5 approx 0.2857$], [czynnik wzmacniający ma moduł mniejszy od 1],
    [Niejawny Euler, $t=0.5$], [$y_1 = 1/(1 + 2.5)$], [$0.285714$], [metoda stabilna, choć przy dużym kroku niezbyt dokładna],
    [Rozwiązanie dokładne], [$e^(-2.5)$], [$0.082085$], [punkt odniesienia do porównania błędów],
    [Dobór kroku jawnego Eulera], [$abs(y_n - y(t_n)) < 0.001$], [$n=257$, $h approx 0.001946$], [największy krok przy podziale $0.5$ na całkowitą liczbę kroków],
    [Iteracja prosta w metodzie niejawnej], [$abs(phi') = 5h < 1$], [$h < 0.2$], [warunek zbieżności iteracji stałopunktowej],
  ),
  caption: [Najważniejsze wyniki dla równania $y'=-5y$.]
)

#figure(
  image("figures/zad4_porownanie_eulera.png", width: 95%),
  caption: [Porównanie rozwiązania dokładnego z metodą Eulera jawną i niejawną dla kroku $h=0.5$.]
)

Dla punktu (h) metoda bezpośredniej iteracji ma postać $y_(n+1)^(k+1) = y_n - 5h y_(n+1)^(k)$. Jest to odwzorowanie zwężające tylko wtedy, gdy $5h < 1$. Metoda Newtona jest tutaj uzasadniona, ponieważ równanie niejawne jest liniowe względem $y_(n+1)$; w praktyce Newton dochodzi do rozwiązania w jednej iteracji.

== Wnioski do zadania 4

1. Stabilność problemu ciągłego nie gwarantuje stabilności metody numerycznej dla dowolnego kroku.
2. Jawna metoda Eulera jest warunkowo stabilna. Dla $h=0.5$ czynnik wzmacniający ma moduł $1.5$, dlatego rozwiązanie oscyluje i narasta zamiast zanikać.
3. Niejawna metoda Eulera jest dużo odporniejsza dla równania z ujemną stałą $lambda=-5$, ponieważ jej czynnik wzmacniający wynosi $1/(1+5h)$.
4. Żądanie błędu mniejszego niż $0.001$ w punkcie $t=0.5$ wymaga bardzo małego kroku jawnego Eulera: około $0.001946$, czyli $257$ kroków.

= Zadanie 5. Stabilność jawnego Eulera dla układu równań

Układ można zapisać w postaci macierzowej $y' = A y$, gdzie:

$ A = ((-2, 1), (-1, -2)) $

Wartości własne tej macierzy wynoszą:

$ lambda_1 = -2 + i, lambda_2 = -2 - i $

Dla jawnej metody Eulera warunek stabilności dla każdej wartości własnej ma postać:

$ abs(1 + h lambda) <= 1 $

Po podstawieniu $lambda=-2+i$ otrzymujemy:

$ abs((1 - 2h) + i h)^2 <= 1 $

czyli:

$ (1 - 2h)^2 + h^2 <= 1 $
$ 5h^2 - 4h <= 0 $

Dla dodatniego kroku daje to warunek:

$ 0 < h <= 4/5 $

#figure(
  image("figures/zad5_region2.png", width: 78%),
  caption: [Region stabilności jawnej metody Eulera oraz punkty $h lambda$ dla wybranych wartości kroku.]
)

== Wnioski do zadania 5

1. Dla układów liniowych stabilność należy badać przez wartości własne macierzy układu, a nie tylko przez pojedyncze współczynniki równań.
2. Część urojona wartości własnych oznacza składową oscylacyjną, która zawęża praktyczny zakres stabilnych kroków.
3. Metoda Eulera jest stabilna dla tego układu dokładnie dla $0 < h <= 0.8$.

= Zadanie 6. Empiryczny rząd zbieżności metody Eulera

Badany problem miał postać:

$ y' = alpha t^(alpha - 1), y(0)=0 $

a jego rozwiązaniem dokładnym jest:

$ y(t)=t^alpha $

Rozwiązano problem dla $alpha = 2.5, 1.5, 1.1$ oraz kroków $h=0.2$, $0.1$, $0.05$ na przedziale $[0,1]$, czyli dla $t_max = 1.0$. Błąd liczono jako maksymalny błąd bezwzględny w węzłach całej siatki, a nie jako błąd w jednym, z góry ustalonym punkcie czasu. W praktyce dla otrzymanych danych największy błąd wypadał na końcu przedziału, czyli przy $t=1$.

Empiryczny rząd zbieżności wyznaczono ze wzoru:

$ p = log(e_1/e_2) / log(h_1/h_2) $

#figure(
  table(
    columns: (0.8fr, 1.1fr, 1.1fr, 1.1fr, 1.4fr, 1.4fr),
    inset: 5pt,
    align: center,
    table.header([$alpha$], [$e(h=0.2)$], [$e(h=0.1)$], [$e(h=0.05)$], [EOC $0.2 -> 0.1$], [EOC $0.1 -> 0.05$]),
    [$2.5$], [$2.3864 dot 10^(-1)$], [$1.2208 dot 10^(-1)$], [$6.1754 dot 10^(-2)$], [$0.9670$], [$0.9832$],
    [$1.5$], [$1.7539 dot 10^(-1)$], [$8.4236 dot 10^(-2)$], [$4.0830 dot 10^(-2)$], [$1.0581$], [$1.0448$],
    [$1.1$], [$1.8778 dot 10^(-1)$], [$9.1364 dot 10^(-2)$], [$4.4484 dot 10^(-2)$], [$1.0393$], [$1.0383$],
  ),
  caption: [Maksymalny błąd w węzłach oraz empiryczny rząd zbieżności metody Eulera.]
)

#figure(
  image("figures/zad6_eoc_loglog.png", width: 95%),
  caption: [Błąd metody Eulera w skali log-log dla różnych wartości parametru $alpha$.]
)

Dla wszystkich trzech wartości parametru otrzymane wartości EOC są bliskie jedności. Jest to zgodne z oczekiwanym pierwszym rzędem metody Eulera. Dla $alpha < 2$ druga pochodna rozwiązania $y''(t)=alpha(alpha-1)t^(alpha-2)$ jest osobliwa w zerze, co może pogarszać stałą błędu i zachowanie lokalne. W tym eksperymencie, dla błędu maksymalnego liczonego w węzłach na przedziale $[0,1]$, nie zniszczyło to jednak globalnego rzędu zbieżności.

== Wnioski do zadania 6

1. Zmniejszanie kroku dwukrotnie powodowało w przybliżeniu dwukrotne zmniejszenie błędu, co potwierdza rząd pierwszy metody Eulera.
2. Mniejsza regularność rozwiązania przy $t=0$ jest ważna teoretycznie, ale w otrzymanych danych nie spowodowała spadku EOC poniżej $1$.
3. Wykres log-log jest najlepszą wizualizacją tego zadania, ponieważ nachylenie prostych odpowiada empirycznemu rzędowi zbieżności.


Skrypt `wykresy_lab9.py` generuje rysunki użyte w tym sprawozdaniu i może posłużyć jako punkt startowy do przygotowania kolejnych wykresów w Matplotlib.

= Wnioski końcowe

1. Najważniejszą umiejętnością w pierwszej części laboratorium było poprawne zdefiniowanie wektora stanu. Po tej operacji równania o różnym rzędzie można traktować jednolicie jako układy pierwszego rzędu.
2. Analiza stabilności jest niezbędna przed interpretacją wyniku numerycznego. Przykład $y'=-5y$ pokazuje, że metoda formalnie zbieżna może dawać bezsensowne wyniki, jeśli krok jest zbyt duży.
3. Metody niejawne są zwykle droższe obliczeniowo, ale w problemach stabilnościowych pozwalają używać znacznie większych kroków.
4. Empiryczny rząd zbieżności jest wygodnym narzędziem sprawdzania implementacji. W zadaniu 6 otrzymane wartości EOC były zgodne z teorią dla metody Eulera.
5. Wykresy stabilności i błędu w skali logarytmicznej bardzo dobrze uzupełniają obliczenia tabelaryczne, ponieważ pokazują charakter metody, a nie tylko pojedyncze wartości liczbowe.

