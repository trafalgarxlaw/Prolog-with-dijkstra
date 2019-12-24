:- use_module(tp2, [room/2, portal_to/5, diagonalizer/2, solve/3]).

% Game
game2(game(room1, room3, pos(4, 1), pos(3, 4))) :-
    retractall(room(_,_)),
    retractall(portal_to(_,_,_,_,_)),
    retractall(diagonalizer(_,_)),
    assert(room(room1, shape(square,   4))),
    assert(room(room2, shape(diamond,  5))),
    assert(room(room3, shape(triangle, 7))),
    assert(portal_to(portal1, room1, room2, pos(2, 1), pos(1, 3))),
    assert(portal_to(portal2, room1, room3, pos(1, 4), pos(1, 7))),
    assert(portal_to(portal3, room2, room3, pos(4, 4), pos(4, 4))),
    assert(diagonalizer(room1, pos(3, 2))).

% Unit tests
:- begin_tests(world2).



test("1rd solution with MaxT = 10") :-
    game2(G),
    solve(G, Path, 10),
    Path = [state(pos(4,1),room1,nothing),
            state(pos(3,1),room1,nothing),
            state(pos(3,2),room1,diagonalizer),
            state(pos(2,3),room1,diagonalizer),
            state(pos(1,4),room1,diagonalizer),
            state(pos(1,7),room3,diagonalizer),
            state(pos(2,6),room3,diagonalizer),
            state(pos(3,5),room3,diagonalizer),
            state(pos(3,4),room3,diagonalizer)],
    !.



% There is no solution using less than 10 time units
test("No solution with MaxT = 9") :-
    game2(G),
    \+ solve(G, _, 9),
    !.

:- end_tests(world2).

:- initialization(main).

main :- run_tests, halt.
