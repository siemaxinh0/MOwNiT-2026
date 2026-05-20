#set page(margin: 2.2cm)
#set text(size: 11pt)
#set heading(numbering: "1.")
#set figure(numbering: "1")

#align(center)[#text(size: 17pt, weight: "bold")[MOwNiT - Laboratorium 11]]
#align(center)[#text(size: 14pt, weight: "bold")[Optymalizacja]]
#align(center)[Data: 20.05.2026]
#align(center)[Autor: Hubert Kukla]

= Cel ćwiczenia

Celem laboratorium było przećwiczenie metod optymalizacji numerycznej na trzech przykładach: preconditioningu w funkcji kwadratowej, minimalizacji energii wiszącego łańcucha oraz regresji liniowej rozwiązywanej metodą gradientu prostego. W każdym zadaniu zapisano osobno podpunkty z treści, a wyniki uzupełniono wykresami.

= Zadanie 1. Preconditioning

Dana była funkcja $ f(x,y)=1/2 x^2 + 9/2 y^2 $. Jej gradient i hesjan są równe $ nabla f(x,y) = vec(x, 9y) $ oraz $ H = mat(1, 0; 0, 9) $.

== Podpunkt (a). Gradient prosty z optymalnym krokiem

Dla funkcji kwadratowej zastosowano krok dokładny w kierunku antygradientu:
$ alpha_k = (nabla f(z_k)^T nabla f(z_k))/(nabla f(z_k)^T H nabla f(z_k)) $.
Punkt startowy wynosił $z_0=vec(9,1)$. Algorytm zbiega do minimum $vec(0,0)$, ale bez zmiany zmiennych wykonuje charakterystyczne zygzakowanie między wąskimi poziomicami. Dla przykładu po 11 iteracjach otrzymano w przybliżeniu $x=0.7731$, $y=-0.0859$, $f=0.332041$.

#figure(image("lab11_figures/zad1_contour.png", width: 86%), caption: [Kontury funkcji $f$ i iteracje gradientu prostego z punktu $(9,1)$.])

== Podpunkt (b). Współczynnik uwarunkowania

Wartości własne macierzy $H$ są równe $1$ oraz $9$, dlatego $ kappa_2(H) = lambda_max / lambda_min = 9 $. Duża różnica krzywizn w kierunkach osi $x$ i $y$ tłumaczy powolne zbieganie klasycznego gradientu prostego.

== Podpunkt (c). Macierz L

Wystarczy wziąć diagonalny pierwiastek Cholesky'ego: $ L = mat(1, 0; 0, 3) $ oraz $ L L^T = mat(1, 0; 0, 9) = H $.

== Podpunkt (d). Minimalizacja po zmianie zmiennych

Po podstawieniu $ vec(x', y') = L vec(x, y) $ otrzymujemy $x=x'$ oraz $y=y'/3$, więc $ g(x',y') = f(x', y'/3) = 1/2 (x')^2 + 1/2 (y')^2 $. Hesjan funkcji $g$ jest macierzą jednostkową, a punkt startowy przechodzi w $u_0=vec(9,3)$. Metoda gradientu prostego z dokładnym krokiem ma wtedy $alpha=1$ i dochodzi do $u_1=vec(0,0)$ w jednej iteracji. Ze wzoru $z=L^(-T)u$ dostajemy minimum funkcji wyjściowej: $(x,y)=(0,0)$.

#figure(image("lab11_figures/zad1_preconditioned.png", width: 78%), caption: [Po zmianie zmiennych poziomice są okręgami, więc gradient prosty trafia w minimum w jednej iteracji.])

== Wnioski do zadania 1

1. Współczynnik uwarunkowania równy $9$ powoduje widoczne zygzakowanie metody gradientu prostego.
2. Preconditioning przez $L$ zamienia elipsy poziomic w okręgi.
3. Dla funkcji $g$ problem jest idealnie uwarunkowany i metoda z dokładnym krokiem kończy się po jednej iteracji.

= Zadanie 2. Wiszący łańcuch

Łańcuch opisano przez $n+1=41$ mas punktowych. Końce były ustalone w punktach $(0,0)$ i $(3,1)$, natomiast zmiennymi optymalizacji były współrzędne punktów wewnętrznych. Energia całkowita składała się z energii sprężyn oraz energii grawitacyjnej:
$ V = 1/2 k sum_(i=0)^(n-1) (d_i-L)^2 + m g sum_(i=0)^n y_i $, gdzie $ d_i = sqrt((x_i-x_(i+1))^2 + (y_i-y_(i+1))^2) $.

== Gradient funkcji celu

Dla sprężyny między punktami $i$ i $i+1$ wkład do gradientu punktu $i$ ma postać $ k (d_i-L)/d_i vec(x_i-x_(i+1), y_i-y_(i+1)) $, a wkład do punktu $i+1$ ma przeciwny znak. Do każdej pochodnej po $y_j$ dochodzi dodatkowo składnik $mg$. W implementacji najpierw zsumowano wkłady wszystkich sprężyn, a następnie pozostawiono tylko współrzędne punktów wewnętrznych.

== Podpunkt (a). Stały współczynnik uczenia

Dla stałego kroku użyto $alpha=0.002$. Metoda dochodzi do tej samej energii końcowej, ale wymaga wielu iteracji, ponieważ krok musi być wystarczająco mały, aby nie zdestabilizować sprężyn.

== Podpunkt (b). Współczynnik malejący wykładniczo

Użyto $alpha_t = 0.003 dot 0.98^floor(t/1000)$. Większy krok początkowy przyspiesza zejście z początkowej konfiguracji, a powolne zmniejszanie kroku stabilizuje końcowe iteracje.

== Podpunkt (c). Przeszukiwanie liniowe

Zastosowano backtracking z warunkiem Armijo. Ta wersja sama dobiera krok i w tym eksperymencie wymagała najmniejszej liczby iteracji.

#table(
  columns: (2.6fr, 1fr, 1.4fr, 1.4fr, 1fr, 1fr),
  inset: 5pt,
  [Metoda], [Iteracje], [Energia], [Norma gradientu], [Czas s], [min y],
  [stały krok alpha=0.002], [17330], [-51.458276], [9.996e-06], [1.313], [-4.059], [alpha wykładniczo malejące], [13002], [-51.458276], [9.996e-06], [1.020], [-4.059], [przeszukiwanie liniowe], [4185], [-51.458276], [9.710e-06], [0.980], [-4.059]
)

#figure(image("lab11_figures/zad2_chain_positions.png", width: 86%), caption: [Końcowe położenie mas łańcucha dla trzech wersji gradientu prostego.])

#figure(image("lab11_figures/zad2_energy_history.png", width: 86%), caption: [Zmiana energii potencjalnej w kolejnych iteracjach.])

== Wnioski do zadania 2

1. Wszystkie trzy warianty prowadzą do praktycznie tej samej konfiguracji końcowej i energii około $-51.4583.
2. Najniższy punkt łańcucha ma współrzędną $y$ około $-4.059$, co jest zgodne z intuicją: łańcuch opada pod wpływem grawitacji.
3. Przeszukiwanie liniowe jest najwygodniejsze, bo nie wymaga ręcznego strojenia stałego kroku i w tym uruchomieniu wykonało najmniej iteracji.

= Zadanie 3. Predykcja roku wydania utworu

Problem regresji zapisano jako minimalizację $ F(w)=1/(2m) || A w - y ||_2^2 $. Gradient ma postać $ nabla F(w)=1/m A^T(Aw-y) $. Stałą uczącą wyznaczono z wartości własnych macierzy $A^T A / m$: $ alpha = 2/(lambda_min + lambda_max) $.

W katalogu roboczym nie było oryginalnego pliku z laboratorium 2, dlatego wyniki tabelaryczne pochodzą z trybu demonstracyjnego na danych syntetycznych o skorelowanych cechach. Notebook jest przygotowany tak, aby po dodaniu pliku `YearPredictionMSD.txt` albo zgodnego CSV automatycznie użył rzeczywistego zbioru. W tym uruchomieniu źródło danych to: #emph[dane syntetyczne - brak pliku z laboratorium 2], a macierz treningowa miała rozmiar 5000 x 21.

== Porównanie dokładności i czasu

#table(
  columns: (2.2fr, 1.2fr, 1.2fr, 1.1fr, 1fr),
  inset: 5pt,
  [Metoda], [RMSE test], [MAE test], [Czas s], [Iteracje],
  [najmniejsze kwadraty], [8.1804], [6.6204], [0.0056], [1], [gradient prosty], [8.1803], [6.6204], [0.6606], [5000]
)

#figure(image("lab11_figures/zad3_gd_convergence.png", width: 86%), caption: [Spadek funkcji celu podczas działania gradientu prostego.])

#figure(image("lab11_figures/zad3_prediction_scatter.png", width: 70%), caption: [Porównanie wartości rzeczywistych i predykcji gradientu prostego.])

== Złożoność obliczeniowa

#table(
  columns: (1.7fr, 2fr, 2.5fr),
  inset: 5pt,
  [Metoda], [Koszt teoretyczny], [Komentarz],
  [Najmniejsze kwadraty], [$O(m d^2 + d^3)$], [Koszt zależy głównie od faktoryzacji macierzy projektu. Dla małego $d$ jest bardzo szybka.],
  [Gradient prosty], [$O(T m d)$], [Jedna iteracja jest tania, ale trzeba wykonać $T$ iteracji zależnych od uwarunkowania.]
)

== Wnioski do zadania 3

1. Gradient prosty uzyskał praktycznie taki sam błąd testowy jak metoda najmniejszych kwadratów.
2. Metoda najmniejszych kwadratów jest bezpośrednia i dla małej liczby cech zwykle wygrywa czasowo.
3. Gradient prosty jest atrakcyjny dla bardzo dużych danych, ponieważ jedna iteracja wymaga tylko mnożeń przez $A$ i $A^T$.
4. Dobór kroku z wartości własnych daje stabilną zbieżność bez ręcznego strojenia parametru uczenia.

= Wnioski końcowe

1. Preconditioning może diametralnie poprawić zbieżność gradientu prostego, co najlepiej widać w zadaniu 1.
2. W problemach fizycznych, takich jak wiszący łańcuch, najważniejsze jest poprawne wyprowadzenie gradientu i traktowanie punktów brzegowych jako stałych.
3. Stały krok jest prosty, ale wymaga strojenia; przeszukiwanie liniowe zwykle lepiej adaptuje się do lokalnej geometrii funkcji celu.
4. W regresji liniowej gradient prosty i najmniejsze kwadraty rozwiązują ten sam problem optymalizacyjny, ale różnią się kosztem: metoda bezpośrednia jest szybka dla małego $d$, a gradient prosty skaluje się lepiej iteracyjnie dla dużych zbiorów.
5. Wykresy konturowe, wykresy energii i wykresy zbieżności są dobrym uzupełnieniem samych tabel, ponieważ pokazują mechanikę działania algorytmów.
