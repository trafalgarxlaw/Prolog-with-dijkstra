# Travail pratique 2 - Déplacement d'un agent intelligent

## Description

Dans ce deuxième travail pratique, je dois implémenter un « agent intelligent » qui explore un ensemble de pièces (*rooms*) liées par des téléporteurs (portals).

Plus précisément, il s'agit de modéliser et implémenter un agent intelligent qui évolue dans un monde composé de pièces, connectées par des téléporteurs.

Voir l'énoncer pour plus de détails [ici](https://gitlab.info.uqam.ca/inf6120-aut2019/inf6120-aut2019-tp2-enonce/blob/master/README.md)


## Auteur

yacin

## Fonctionnement

Voici une explication sur le fonctionnement du projet.

- Pour faire tourner le projet de façon interactive, vous pouvez utiliser le prédicat principal solve/3 pour résoudre le chemin le plus court entre deux états.
  
- Référer à la section dépendance pour connaître les logicielles nécessaires au bon fonctionnement du programme.

Il ne faut pas oublier de créer les différents *room* du jeu, incluant les téléporteurs et les diagonaliser si vous le souhaitez. Ceci peut être fait avec des assertions dynamiques.

Voici un exemple :
Supposons que nous voulons 3 *rooms* : Un carré 10x10, un diamond 3x3 et un triangle 3x3. Nous voulons aussi des téléporteurs permettant d'accéder à chacune de ces *room* ainsi qu'un diagonaliseur.

Voici comment procéder pour créer cet environnement.

**Creation des rooms :**
```
assert(room(room1, shape(square,   10))).
assert(room(room2, shape(diamond,  3))).
assert(room(room3, shape(triangle, 3))).
```

**creation des teleporteurs :**
```
assert(portal_to(portal1, room1, room2, pos(1, 2), pos(2, 2))).
assert(portal_to(portal2, room2, room3, pos(2, 1), pos(1, 3))).
```

**creation d'un diagonaliseur :**
```
assert(diagonalizer(room2, pos(2, 3))).
```

**Resolution du plus court chemin :**
```
?- solve(game(room1, room1, pos(1, 1), pos(10, 10)),Path,100).
```
Le programme vous donnera alors **Deux** solutions: (ne donne pas toutes les solutions à cause d'un bug de backtracking, voire l'état du projet)

**Dans la première solution, il va chercher le diagonaliser dans la deuxième pièce, ce qui réduit considérablement sont temps de parcours.**
```
Path = [state(pos(1,1),room1,nothing),
        state(pos(1,2),room1,nothing),
        state(pos(2,2),room2,nothing),
        state(pos(2,3),room2,diagonalizer),
        state(pos(2,2),room2,diagonalizer),
        state(pos(1,2),room1,diagonalizer),
        state(pos(2,3),room1,diagonalizer),
        state(pos(3,4),room1,diagonalizer),
        state(pos(4,5),room1,diagonalizer),
        state(pos(5,6),room1,diagonalizer),
        state(pos(6,7),room1,diagonalizer),
        state(pos(7,8),room1,diagonalizer),
        state(pos(8,9),room1,diagonalizer),
        state(pos(9,10),room1,diagonalizer),
        state(pos(10,10),room1,diagonalizer)] ;
```
**Dans la deuxième solution, il fait son parcours sans aller chercher le diagonaliser, sont temps de parcours est donc plus lent.**
```
Path = [state(pos(1,1),room1,nothing),
        state(pos(2,1),room1,nothing),
        state(pos(3,1),room1,nothing),
        state(pos(3,2),room1,nothing),
        state(pos(3,3),room1,nothing),
        state(pos(4,3),room1,nothing),
        state(pos(4,4),room1,nothing),
        state(pos(5,4),room1,nothing),
        state(pos(5,5),room1,nothing),
        state(pos(6,5),room1,nothing),
        state(pos(6,6),room1,nothing),
        state(pos(7,6),room1,nothing),
        state(pos(7,7),room1,nothing),
        state(pos(8,7),room1,nothing),
        state(pos(8,8),room1,nothing),
        state(pos(9,8),room1,nothing),
        state(pos(9,9),room1,nothing),
        state(pos(10,9),room1,nothing),
        state(pos(10,10),room1,nothing)].
```

- Afin de lancer les tests automatiques, tapez : `make test`
- Un dernier test qui prend un temps un peu plus long à s'exécuter peut aussi être lancé avec : `make longtest`


## Contenu du projet
Fichiers contenus dans le dépôt

- tp2.pl
- Makefile
- test0.pl
- test1.pl
- test2.pl
- longtest.pl


## Dépendances
Pour utiliser et lancer le programme, il faut installer [Swi-prolog.](https://www.swi-prolog.org/Download.html)


## Références

**stackoverflow.com**

## État du projet

Actuellement, le projet trouve UNE seule solution possible utilisant l'algorithme de dijkstra (le chemin le plus court).

Pour que tous les chemins soient trouvés, il faudrait revoir l'implémentation d'un de mes arcs (edge), car il y a un petit bug qui bloque le backtracking ce qui empêche la résolution de tous les chemins possible.

Par manque de temps, d'expérience et d'intérêt pour ce langage que je connais depuis peu, il m'a été impossible de le déboguer 

**(Je comprends pourquoi il n'est pas très utilisé sur le marché)**

**Note**: Des tests ont été modifiés (supprimé) afin d'illustrer une seule solution pour un temps minimal. Ceux initialement fournis échouent à l'exception d'une solution par tests.