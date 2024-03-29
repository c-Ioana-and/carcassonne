:- dynamic detailed_mode_disabled/0.
:- ensure_loaded('files.pl').



% tile/2
% tile(Index, Tile)
%
% Fiecare soluție a predicatului tile este o corespondență între index
% (numărul piesei în lista din enunț) și reprezentarea internă a piesei
% respective.
%
% Puteți alege orice reprezentare doriți, în așa fel încât să puteți
% reprezenta toate piesele din enunț.
%
% Orice muchie a unei piese este o cetate, un drum, sau o pajiște.
% Pot exista cel mult 1 drum și cel mult 2 castele pe aceeași piesă.
%
% Reprezentarea trebuie să poată fi rotită (vezi predicatul ccw/3 mai
% jos) pentru a produce reprezentarea piesei rotite cu 90 de grade.
%
% Trebuie să definiți reprezentări pentru fiecare dintre cele 16 piese
% din enunțul temei.
%
% Exemplu: apelul tile(1, T1). trebuie să lege T1 la reprezentarea pe
% care o faceți pentru piesa 1. Această reprezentare poate fi transmisă
% celorlalte predicate din temă, pentru a întreba, de exemplu, ce se
% află pe muchia de nord a piesei 1, sau dacă piesa 1 se potrivește cu o
% altă piesă.
tile(1, T1) :- T1 = [c, c, c, p, c].
tile(2, T2) :- T2 = [c, c, c, d, c].
tile(3, T3) :- T3 = [c, c, c, p, p].
tile(4, T4) :- T4 = [c, c, p, p, p].
tile(5, T5) :- T5 = [c, p, p, c, p].
tile(6, T6) :- T6 = [c, p, c, c, p].
tile(7, T7) :- T7 = [c, p, p, p, p].
tile(8, T8) :- T8 = [c, c, c, d, d]. 
tile(9, T9) :- T9 = [c, p, p, d, d].
tile(10, T10) :- T10 = [c, d, p, d, p].
tile(11, T11) :- T11 = [c, d, d, p, d].
tile(12, T12) :- T12 = [c, d, d, d, d].
tile(13, T13) :- T13 = [p, p, d, d, d].
tile(14, T14) :- T14 = [p, d, d, p, d].
tile(15, T15) :- T15 = [p, d, d, d, d].
tile(16, T16) :- T16 = [d, d, d, d, d].

% at/3
% at(+Tile, +Direction, ?What)
%
% Predicatul este adevărat dacă pe piesa Tile are pe muchia de pe
% direcția Direction o entitate de tipul What.
%
% Directions este una dintre n, e, s, w (vezi predicatul directions/1
% din utils.pl).
%
% Entitatea (What) este una dintre c, d, sau p. reprezentând cetate,
% drum, sau pajiște.
%
% De exemplu, piesa 4 are cetate în nord și în este, și pajiște în sud
% și vest. Iar piesa 10 are cetate în nord, drum în este și sud, și
% pajiște în vest.
%
% Dacă What nu este legat, trebuie legat la entitatea care se află pe
% muchia din direcția Dir.

at(L, Dir, What) :- directions(D), nth0(N, D, Dir), N >= 2, N1 is N + 1, nth0(N1, L, What).
at(L, Dir, What) :- directions(D), nth0(N, D, Dir), N < 2, nth0(N, L, What).

% atL/3
% atL(+Tile, +Directions, +What)
%
% Predicatul este adevărat dacă piesa Tile are entitatea what pe toate
% direcțiile din lista Directions, cu aceleași valori pentru entități și
% direcții ca și la predicatul at/3.
%
% De exemplu, predicatul este adevărat pentru reprezentarea piesei 1,
% pentru lista [w,n,e], și pentru entitatea c. Este adevărat de asemenea
% pentru reprezentarea piesei 14, pentru lista [e,w], și pentru
% entitatea d.
%
% Atenție! Pentru ca predicatul să fie adevărat, nu este nevoie ca în
% Directions să fie *toate* direcțiile pe care se află entitatea
% respectivă, pot fi doar o submulțime a acestora.
% De exemplu, la piesa 14, predicatul este adevărat pentru entitatea d
% și pentru oricare dintre listele [w], [e] sau [e,w].

% verific pentru toate directiile din lista Directions daca exista entitatea What
atL(Tile, Dirs, What) :- forall(member(X, Dirs), at(Tile, X, What)).

% hasTwoCitadels/1
% hasTwoCitadels(+Tile)
%
% Predicatul întoarce adevărat dacă pe piesă există două cetăți diferite
% (ca în piesele 4 și 5).

% daca in mijloc am pus o cetate, atunci exista doar o cetate pe piesa, deci predicatul este fals
hasTwoCitadels(Tile) :- findall(X, (member(X, [n, e, s, w]), at(Tile, X, c)), Rez), length(Rez, N), N >= 2, \+ nth0(2, Tile, c).

% ccw/3
% ccw(+Tile, +Rotation, -RotatedTile)
% Predicatul este adevărat dacă RotatedTile este reprezentarea piesei cu
% reprezentarea Tile, dar rotită de Rotation ori, în sens trigonometric.
%
% De exemplu, dacă T4 este reprezentarea piesei 4, atunci ccw(4, 1, R)
% va lega R la reprezentarea unei piese care are pajiște la nord și
% vest, și cetate la est și sud.
%
% Pentru piesele cu simetrie, reprezentarea unora dintre rotații este
% identică cu piesa inițială.
% De exemplu, la piesele 5, 6 și 14, rotirea cu Rotation=2 va duce la o
% reprezentare identică cu piesa inițială, și la fel rezultatele pentru
% Rotation=1 și Rotation=3 vor fi identice.
% La piesa 16, orice rotire trebuie să aibă aceeași reprezentare cu
% reprezentarea inițială.

% daca Rotation este 0, atunci RotatedTile este egal cu Tile
ccw(Tile, 0, Tile).
ccw([N, E, M, S, V], Rot, RotatedTile) :-
    Rot > 0,
    Rot1 is Rot - 1,
    ccw([E, S, M, V, N], Rot1, RotatedTile).

% rotations/2
% rotations(+Tile, -RotationPairs)
%
% Predicatul leagă RotationPairs la o listă de perechi
% (Rotation, RotatedTile)
% în care Rotation este un număr de rotații între 0 și 3 inclusiv și
% RotatedTile este reprezentarea piesei Tile rotită cu numărul respectiv
% de rotații.
%
% Rezultatul trebuie întotdeauna să conțină perechea (0, Tile).
%
% IMPORTANT:
% Rezultatul nu trebuie să conțină rotații duplicate. De exemplu, pentru
% piesele 5,6 și 14 rezultatul va conține doar 2 perechi, iar pentru
% piesa 16 rezultatul va conține o singură pereche.
%
% Folosiți recursivitate (nu meta-predicate).

% creez mai intai toate rotatiile posibile, fara a tine cont de duplicate
rotateWithN(Tile, 3, [RotatedTile]) :- ccw(Tile, 3, RotatedTile).
rotateWithN(Tile, N, List) :- N < 4, ccw(Tile, N, RotatedTile), N1 is N + 1, rotateWithN(Tile, N1, Rez), List = [RotatedTile | Rez].

% dupa aceea, asignezi numarul de rotatii fiecarei rotatii
addNrRotations(_, [], []).
addNrRotations(Tile, [H | T], Rez) :-
    (ccw(Tile, 0, H)) -> Rez = [(0, H) | Rest], addNrRotations(Tile, T, Rest);
    (ccw(Tile, 1, H)) -> Rez = [(1, H) | Rest], addNrRotations(Tile, T, Rest);
    (ccw(Tile, 2, H)) -> Rez = [(2, H) | Rest], addNrRotations(Tile, T, Rest);
    Rez = [(3, H) | Rest], addNrRotations(Tile, T, Rest).

% cu sort scap de duplicate
rotations(Tile, RotationPairs) :- rotateWithN(Tile, 0, Rez), addNrRotations(Tile, Rez, Rez1), sort(Rez1, RotationPairs).

% match/3
% match(+Tile, +NeighborTile, +NeighborDirection)
%
% Predicatul întoarce adevărat dacă NeighborTile poate fi pusă în
% direcția NeighborDirection față de Tile și se potrivește, adică muchia
% comună este de același fel.
%
% De exemplu, dacă T2 este reprezentarea piesei 2, iar T16 este
% reprezentarea piesei 16, atunci match(T2, T16, s) este adevărat.
%
% Similar, pentru piesele 8 și 10, este adevărat
% ccw(T8, 3, T8R), match(T8R, T10, w).
%
% Puteți folosi predicatul opposite/2 din utils.pl.

match(Tile, NeighborTile, NeighborDirection) :- 
    opposite(NeighborDirection, D2), at(Tile, NeighborDirection, What), at(NeighborTile, D2, What).

% findRotation/3
% findRotation(+Tile, +Neighbors, -Rotation)
%
% Predicatul leagă Rotation la rotația (între 0 și 3 inclusiv) pentru
% piesa cu reprezentarea Tile, astfel încât piesa să se potrivească cu
% vecinii din Neighbors.
%
% Neighbors este o listă de perechi (NeighborTile, NeighborDirection) și
% specifică că pe direcția NeighborDirection se află piesa cu
% reprezentarea NeighborTile. Este posibil ca Neighbors să conțină mai
% puțin de 4 elemente.
%
% Se vor da toate soluțiile care duc la potrivire.
%
% De exemplu, pentru piesa 11, dacă la nord se află piesa 14 rotită o
% dată (drumul este vertical), iar la sud se află piesa 2 rotită de 2
% ori (drumul este spre nord), atunci posibilele rotații pentru piesa 11
% sunt 1 sau 3, deci findRotation trebuie să aibă 2 soluții, în care
% leagă R la 1, și la 3.
% În același exemplu, dacă am avea și piesa 1 ca vecin spre est, atunci
% soluția de mai sus s-ar reduce doar la rotația 3.
%
% Hint: Prolog face backtracking automat. Folosiți match/3.

% gasesc toate rotatiile posibile pentru Tile
findRotation(Tile, Neighbors, Rotation) :-
    matchWithAll(RotatedTile, Neighbors),
    rotations(Tile, RotationPairs),
    member((Rotation, RotatedTile), RotationPairs).

% matchWithAll/3
% matchWithAll(+Tile, +Neighbors)

% verific pentru fiecare vecin daca se potriveste cu Tile
matchWithAll(_, []).
matchWithAll(Tile, [(NeighborTile, NeighborDirection) | T]) :- 
    match(Tile, NeighborTile, NeighborDirection),
    matchWithAll(Tile, T).


%%%%%%%%%%%%%%%%%%%%%%%%%% Etapa 2


%% TODO
% emptyBoard/1
% emptyBoard(-Board)
%
% Leagă Board la reprezentarea unei table goale de joc (nu a fost
% plasată încă nicio piesă).
emptyBoard(Board) :- Board = [].

%% TODO
% boardSet/4
% boardSet(+BoardIn, +Pos, +Tile, -BoardOut)
%
% Predicatul întoarce false dacă se încearcă plasarea unei piese pe o
% poziție pe care este deja o piesă, pe o poziție fără muchie comună
% cu o piesă existentă, sau într-un loc unde piesa nu se potrivește cu
% vecinii săi.
%
% Pentru o tablă goală, predicatul reușește întotdeauna, și poziția Pos
% devine singura de pe tablă.
%
% Poziția este dată ca un tuplu (X, Y).
boardSet(Board, (X, Y), Tile, BoardOut) :- 
    \+ boardGet(Board, (X, Y), _),
    BoardOut = [(X, Y, Tile) | Board].
boardSet(emptyBoard, (X, Y), Tile, BoardOut) :- BoardOut = [(X, Y, Tile)].

%% TODO
% boardGet/3
% boardGet(+Board, +Pos, -Tile)
%
% Predicatul leagă Tile la reprezentarea piesei de pe tabla Board, de la
% poziția Pos. Poziția este dată ca un tuplu (X, Y).
%
% Dacă la poziția Pos nu este nicio piesă, predicatul eșuează.
boardGet(Board, (X, Y), Tile) :- member((X, Y, Tile), Board).

%% TODO
% boardGetLimits/5
% boardGetLimits(+Board, -XMin, -Ymin, -XMax, -YMax)
%
% Predicatul leagă cele 4 argumente la coordonatele x-y extreme la
% care există piese pe tablă.
%
% Pentru o tablă goală, predicatul eșuează.
%
% Hint: max_list/2 și min_list/2
boardGetLimits(Board, XMin, YMin, XMax, YMax) :- 
    findall(X, member((X, _, _), Board), XList),
    findall(Y, member((_, Y, _), Board), YList),
    max_list(XList, XMax),
    min_list(XList, XMin),
    max_list(YList, YMax),
    min_list(YList, YMin).

%% TODO
% canPlaceTile/3
% canPlaceTile(+Board, +Pos, +Tile)
%
% Întoarce adevărat dacă este o mișcare validă plasarea piese Tile la
% poziția Pos pe tabla Board. Poziția este dată ca un tuplu (X, Y).
%
% O mișcare este validă dacă tabla este goală sau dacă:
% - poziția este liberă;
% - poziția este adiacentă (are o muchie comună) cu o piesă deja
% existentă pe tablă;
% - piesa se potrivește cu toți vecinii deja existenți pe tablă.
%
% Hint: neighbor/3 și directions/1 , ambele din utils.pl
canPlaceTile(emptyBoard, _, _).
canPlaceTile(Board, (X, Y), Tile) :- 
    \+ boardGet(Board, (X, Y), _),
    neighbor((X, Y), _, (X1, Y1)),
    boardGet(Board, (X1, Y1), _),
    checkNeighbors(Board, Tile, (X, Y)).

checkNeighbors(Board, Tile, (X, Y)) :- 
    % create the list of neighbors
    directions(D),
    findall((NeighborTile, Dir), (member(Dir, D), neighbor((X, Y), Dir, (X1, Y1)), boardGet(Board, (X1, Y1), NeighborTile)), Neighbors),
    % check if the tile matches with all the neighbors
    matchWithAll(Tile, Neighbors).
    

%% TODO
% getAvailablePositions/2
% getAvailablePositions(+Board, -Positions)
%
% Predicatul leagă Positions la o listă de perechi (X, Y)
% a tuturor pozițiilor de pe tabla Board unde se pot pune piese (poziții
% libere vecine pe o muchie cu piese existente pe tablă).
%
% Pentru o tablă goală, predicatul eșuează.
%
% Hint: between/3 (predefinit) și neighbor/3 din utils.pl
%
% Atenție! Și în afara limitelor curente există poziții disponibile.
getAvailablePositions(emptyBoard, _) :- false.
getAvailablePositions(Board, Positions) :- 
    boardGetLimits(Board, XMin, YMin, XMax, YMax),
    XMin1 is XMin - 1,
    XMax1 is XMax + 1,
    YMin1 is YMin - 1,
    YMax1 is YMax + 1,
    findall((X, Y), (between(XMin1, XMax1, X), between(YMin1, YMax1, Y), canPlaceTile(Board, (X, Y), _)), Positions1),
    sort(Positions1, Positions).    % scot duplicatele


%% TODO
% findPositionForTile/4
% findPositionForTile(+Board, +Tile, -Position, -Rotation)
%
% Predicatul are ca soluții toate posibilele plasări pe tabla Board ale
% piesei Tile, legând Position la o pereche (X, Y) care reprezintă
% poziția și Rotation la un număr între 0 și 3 inclusiv, reprezentând de
% câte ori trebuie rotită piesa ca să se potrivească.
%
% Unele piese se pot potrivi cu mai multe rotații pe aceeași poziție și
% acestea reprezintă soluții diferite ale predicatului, dar numai dacă
% rotațiile duc la rezultate diferite.
%
% Dacă tabla este goală, predicatul leagă Position la (0, 0) și Rotation
% la 0.
%
% De exemplu, dacă pe tablă se află doar piesa 11, la vest de ea piesa 9
% se potrivește cu rotația 1 sau 2 - două soluții diferite. Pentru
% plasarea la vest de piesa 11 a piesei 16 însă există o singură soluție
% - rotație 0.
%
% În ieșirea de la teste, rezultatele vor fi asamblate ca
% (X,Y):Rotation.

findPositionForTile([], _, (0, 0), 0).
findPositionForTile(Board, Tile, (X, Y), Rotation) :- 
    getAvailablePositions(Board, Positions),
    member((X, Y), Positions),
    rotations(Tile, RotationPairs),
    member((Rotation, RotatedTile), RotationPairs),
    canPlaceTile(Board, (X, Y), RotatedTile).

