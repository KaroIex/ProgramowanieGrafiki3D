Usuwając współrzędne i kolory dwóch wierzchołków oszczędzamy:
2 * 6 * sizeof(GLhalf) = 2 * 6 * 4 bytes = 48 byte'ów

Rozmiar 9 indeksów (elementów wektora indices) wynosi:
9 * sizeof(GLushort) = 9 * 2 bytes = 18 byte'ów

Czyli oszczędzamy 48 - 18 = 30 byte'ów.
W heapie (tam lądują elementy wektorów). Tworząc nowy wektor wziąć pod uwagę można jeszcze 24 byte'y (sizeof(std::vector<GLushort>, tj. pointery po 8 byte'ów początku, końca i capacity wektora) które lądują na stacku. Wtedy mamy 30 - 24 = 6 byte'ów. Jest to jednak śliskie, valgrindem nie udało mi się tego dowieść empirycznie, alokator mnie trolował/niewystarczająco znam temat. Do analizy zachowania alokatora mógłbym użyc Godbolta, ale za chwilę deadline złożenia projektu.

Jak zaoszczędzić więcej pamięci:
Można naruszyć integralność domku - kolorując go na jednolity kolor lub używając gradientu dla wierzchołkow dachu. Tak moglibysmy zaoszczędzić kolejne 48 bajtów (usunęlibyśmy kolejne dwie pozycje wierzchołka+kolor)

Nie naruszając integralności domku:
Wg dokumentacji https://www.khronos.org/opengl/wiki/Small_Float_Formats oraz https://www.khronos.org/opengl/wiki/Vertex_Specification można skorzystać z GLhalf w miejscu GLfloat w atrybutach wierzchołków. GLhalf waży 2 byte'y. Tracilibyśmy na precyzji, ale to nie byłoby istotne dla wartości x,y,z,r,g,b naszego domku.
Korzystając z half-precision floatów okroilibyśmy wagę wektora vertices o połowę, z 168 bajtów na 84 bajty (czyli sumując z 30 bajtami z indeksów - zaoszczędzilibyśmy 114 bajtów).

Dodatkowo zastanawiałem się nad rozbiciem wektora vertices na wektory positions i colors (i np. złączyć je w struct). W ten sposób moglibyśmy zindeksować jeszcze dwa x,y,z, oraz osobno zindeksować kolory - zostałyby tylko jeden czerwony i jeden zielony:
{1.0f, 0.0f, 0.0f,
0.0f, 1.0f, 0.0f};

Na oko jednak gra nie wydaje mi się warta świeczki. Taka optymalizacja mogłaby mieć sens tylko dla trudniejszego projektu niż domek (z większą ilością atrybutów wierzchołków) lub w systemach wbudowanych z baaardzo ograniczonymi zasobami. Nie miałem okazji też potwierdzić tego w kodzie, równie dobrze wcale bym nie zoptymalizował zbytnio/w ogóle pamięci, a tylko dopisał sporo linii kodu.
