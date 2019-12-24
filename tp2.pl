:- module(tp2, [room/2,in_shape/2, portal_to/5, diagonalizer/2, solve/3]).

% Travail pratique 2 : Déplacement d'un agent intelligent
%
% Dans ce deuxième travail pratique, il s'agit d'implémenter un « agent
% intelligent » qui explore un ensemble de pièces (rooms) liées par des
% téléporteurs (portals).
%
%
% @author Yassine Hasnaoui (HASY04089702)

% Prédicats dynamiques
:- dynamic room/2, portal_to/5, diagonalizer/2.


%% odd(+Number) is det
%Indique si un nombre est impaire.
%  
%  @param Number Un nombre.
odd(Number) :-
      \+ (Number mod 2 =:= 0).
%% incr(+X,-X1) is det
% Incremente X1 de 1.
%  
%  @param X Le nombre a incrementé
%  @param X1 Son incrementation
incr(X, X1) :-
    X1 is X+1.
    
%% xor(+A,+B) is det
%Implementation d'un XOR logique.
%  
%  @param A L'expression A
%  @param B L'expression B
and(A,B) :- A,B.
or(A,B) :- A;B.
nand(A,B) :- not(and(A,B)).
nor(A,B) :- not(or(A,B)).
xor(A,B) :- or(A,B), nand(A,B).

%Allowed Shapes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% square(+Dimension:int) is nondet
% Definie les pieces qui sont autorisé
% dans le jeu de sorte que la dimension d'une piece carre sois positive,
% d'une piece diamond impair ainsi que celle d'une piece tirangulaire.
%  
%  @param Dimension La dimension souhaité de la piece.
%Definition des regles d'une Forme square ou Dimension est superieur a 0.
square(Dimension):- 
     Dimension >=0.
%Definition des regles d'une Forme ayant une apparance de diamant ou Dimension doit etre impair.
diamond(Dimension):- 
     Dimension >=0,
     odd(Dimension).
%Defitnition des regles d'une Frome triangulaire ou Dimension doit etre impair.
triangle(Dimension) :- 
     Dimension >=0,
     odd(Dimension).



%Représentation des formes%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% shape(+Shape,+Dimension:int) is nondet
%  Definie les formes de pieces qui sont possibles dans le jeu
%  selon la forme et la dimension.
%
%  @param Shape La forme souhaité de la piece.
%  @param Dimension La dimension souhaité de la piece.
%Definition d'une forme carré selon sa Dimension.
shape(square,Dimension) :- square(Dimension).
%Definition d'une forme Diamond selon sa Dimension.
shape(diamond,Dimension) :- diamond(Dimension) .
%Definition d'une forme triangulaire selon sa Dimension.
shape(triangle,Dimension) :- triangle(Dimension).


%%%%Definition of the boundaries of the shapes%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% in_shape(pos(Line,Column),shape(Shape,Dimension)) ) is nondet
%
%  Verifie si une position est dans une forme definie en argument.
%
%  @param pos(Line,Column) La position a verifier.
%  @param shape(square,Dimension) La forme de la piece.
%Definition d'une forme carré selon sa Dimension.
in_shape(pos(Line,Column), shape(square,Dimension)) :-
     Dimension >= 0,
     between(1, Dimension, Line),between(1, Dimension, Column),
     shape(square,Dimension).

in_shape(pos(Line,Column), shape(triangle,Dimension)) :-
     Dimension >= 0,
     Middle is (div(Dimension,2) + 1),
     between(1, Dimension, Column),
     between(1, Middle, Line),
     shape(triangle,Dimension),
     Start is (Line), End is (Dimension - Start + 1 ),
     findall(Element, between(Start,End,Element), Column_Range),
     member(Column, Column_Range).


in_shape(pos(Line,Column), shape(diamond,Dimension)) :-
     Dimension >= 0,
     between(1, Dimension, Line),between(1, Dimension, Column),
     shape(diamond,Dimension),
     Middle is (div(Dimension,2) + 1),
     findall(Element, between(Middle,Dimension,Element), LowerRange),
     (member(Line,LowerRange) -> Start is (Line - Middle + 1), End is (Dimension - Start + 1 ) ; Start is (Middle - Line + 1),  End is (Dimension - Start + 1 )  ),
     findall(List, between(Start,End,List), Column_Range),
     member(Column, Column_Range).
%%%%%%%Definition of a state%%%%%%%%%%%%
%etats
%% state(pos(Line,Column) , Index, Item) is nondet
%
%  Definie un etat indiquant une position, l'index de la piece et un item
%  si la piece a la position a l'interieur de la piece existe.
%
%  @param pos(Line,Column) La position.
%  @param Index Index unique d'une piece.
%  @param Item l'item possedé.
state(pos(Line,Column) , Index, _) :-
          room(Index,Shape),
          in_shape(pos(Line,Column), Shape).


%%%%%%%%%%%Definition of edges%%%%%%%%%%%%%
%
%% edge(+State1, -State2, -Time) is nondet
%
% Definie un chemin entre l'etat 1 et l'etat 2 selon de l'item possede a l'etat 1 et selon
% l'existance d'un teleporteur a cette position. Retourne le cout du deplacement.
%
%  @param State1 La position initial 
%  @param State2 Une position possible
%  @param Time Cout de deplacement de l'etat 1 a l'etat 2.

%Possesion d'un diagonaliseur
diagEdge(state(pos(Line,Column),Index,nothing),
     state(pos(Line,Column),Index,diagonalizer),
     1) :- 
     diagonalizer(Index, pos(Line, Column)), %verifie si un diagonaliseur existe a cette position
     state(pos(Line,Column) ,Index,diagonalizer).

%un pas dans la meme piece avec diagonaliseur
edge(state(pos(From_Line,From_Column),Index,diagonalizer),
     state(pos(To_Line,To_Column),Index,diagonalizer),
     1) :- 
     state(pos(From_Line,From_Column) ,Index,diagonalizer),
     state(pos(To_Line,To_Column) ,Index,diagonalizer),
     number(From_Line),number(From_Column),%verifie si la position initiale a ete instancier
     Right is From_Column+1, Left is From_Column-1, Up is From_Line+1, Down is From_Line-1,
     member(To_Line,[From_Line,Up,Down]), member(To_Column,[From_Column,Left,Right]).
  
%un pas dans la meme piece sans diagonaliseur
edge(state(pos(From_Line,From_Column),Index,nothing),
     state(pos(To_Line,To_Column),Index,Item),
     Time) :- 
     number(From_Line),number(From_Column),
     Right is From_Column+1, Left is From_Column-1, Up is From_Line+1, Down is From_Line-1,
     xor((member(From_Line,[To_Line])->   member(To_Column,[Left,Right])),
     (member(From_Column,[To_Column]) -> member(To_Line,[Up,Down]))),
     (diagEdge(state(pos(To_Line, To_Column), Index, nothing), state(pos(To_Line, To_Column), Index, diagonalizer), Time)->
     Item = diagonalizer, Time = 1 % le temps est egale a 1 car en le prend en meme temps qu'on se deplace.
     ;Time = 1,Item = nothing),
     state(pos(From_Line,From_Column) ,Index,_),
     state(pos(To_Line,To_Column),Index,_).

% utilisation d'un portal avec diagonalizer
edge(state(pos(From_Line,From_Column),FromIndex,diagonalizer),
     state(pos(To_Line,To_Column),ToIndex,diagonalizer),
     3) :- 
     portal_to(_, FromIndex, ToIndex, pos(From_Line, From_Column), pos(To_Line, To_Column)).
 
 % utilisation d'un portal sans diagonalizer
 edge(state(pos(From_Line,From_Column),FromIndex,nothing),
     state(pos(To_Line,To_Column),ToIndex,nothing),
     3) :- 
     portal_to(_, FromIndex, ToIndex, pos(From_Line, From_Column), pos(To_Line, To_Column)).

%%%%%%%%%Definition of an Arc%%%%%%%%%%%%%%%%%
%% arcs(+State1, -State2, -Time) is nondet
%
% Definie un arc entre l'etat 1 et l'etat 2 si un chemin existe entre ces deux etats.
%
%  @param State1 La position initial 
%  @param State2 Une position possible
%  @param Time Cout de deplacement de l'etat 1 a l'etat 2.

arcs(From_state, To_state, Time) :- edge(From_state, To_state, Time).
arcs(From_state, To_state, Time) :- edge(To_state, From_state, Time).

% Dijkstra ----------------------------------------------------------------

% L'algorithme de dijkstra utilise une list key-value dans son
% Implementation.
% key represente le temps minimal du chemin
% value represente la liste du chemin parcourus
shortest_path(From, To, Path, Time) :-
	dijkstra([0-[From]], To, RPath, Time),
	reverse(RPath, Path).

% Ici, on est rendu au bout de notre chemin (to)
dijkstra([Time-[To|RPath] |_], To, [To|RPath], Time).

% On cherche le meilleur candidat puis on recommence
dijkstra(Visited, To, RPath, Time) :-
  best_candidate(Visited, BestCandidate), % au debut, Visited est une liste contenant notre etat de depart.
  dijkstra([BestCandidate|Visited], To, RPath, Time).

% Calcul du meilleur candidat
best_candidate(VisitedPaths, BestCandidate) :-
	findall( %trouver tout les chemins potentielle de letat courant.
		CheminPotentiel,
	  	(	member(Len-[State1|Path], VisitedPaths),%pour l'etat courant dans paths, 
		    arcs(State1, State2, Time),       %voir les chemins possibles
		    \+ is_visited(VisitedPaths, State2),%Si l'etat 2 na pas ete visitee
	    	NewTime is Len + Time,                %alors on calcule le nouveau temp.
	    	CheminPotentiel = NewTime-[State2,State1|Path] % on ajoute le chemin POTENTIEL state1 vers state2 a la liste des chemins.
    	),                                         % Avec le nouveau Temps ajouté par ce chemin.
        Candidates
	),
  	
     minimum(Candidates, BestCandidate). %on a besoin de tout les candidats ne depassend pas la limite

% Minimum d'une liste
% Ici, keysort trie une liste key->[value] selon key. Il en extrait alors la plus petite pair du 
% tableau (Min).
% ex: minimum([0-[3,2], 4-[1]], M).  ---->  M = 0-[3, 2].
minimum(List, Min) :-
	keysort(List, [Min|_]).
     %member(Chemin,List).

% Vérifie si un sommet a été visité
% Ici, State represente un etat dans une room. chaque state est sois visité, sois ne l'est pas encore.
% memberchk verifie s'il y a une paire de la forme _-[U|_] dans la liste de chemins Paths.
is_visited(VisitedPaths, State) :-
	memberchk(_-[State|_], VisitedPaths).
%----------------------------------------------------------------------
 
%main

%% solve(game(+Starting_room,+Ending_room,+Starting_Position,+Ending_Position),-Path,+MaxT) is nondet
%
%  Predicat princiapale permetant de trouver les chemins ayant un temp de deplacement moindre que MaxT entre un etat de
%  depart et un etat finale.
%
%  @param State1 La position initial 
%  @param State2 Une position possible
%  @param Time Cout de deplacement de l'etat 1 a l'etat 2.

solve(game(Starting_room,Ending_room,Starting_Position,Ending_Position), Path, MaxT) :-

     findall(Paths,
            (shortest_path((state(Starting_Position, Starting_room, nothing)), state(Ending_Position, Ending_room, _), Paths, Time), Time =<MaxT),
            PathList),
     member(Path, PathList).


