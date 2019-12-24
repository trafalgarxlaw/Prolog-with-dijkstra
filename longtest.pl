% A world where the diagonalizer is not easy to get, but it is still better to
% retrieve it

:- use_module(tp2, [room/2, portal_to/5, diagonalizer/2, solve/3]).

% Game
game3(game(room1, room3, pos(1, 1), pos(10, 10))) :-
    retractall(room(_,_)),
    retractall(portal_to(_,_,_,_,_)),
    retractall(diagonalizer(_,_)),
    assert(room(room1, shape(square, 4))),
    assert(room(room2, shape(square, 2))),
    assert(room(room3, shape(square, 10))),
    assert(portal_to(portal1, room1, room2, pos(1, 2), pos(1, 1))),
    assert(portal_to(portal2, room1, room3, pos(4, 4), pos(1, 1))),
    assert(diagonalizer(room2, pos(2, 1))).

% Unit tests
:- begin_tests(world3).

% There is at least one solution using 24 time units
test("A solution with MaxT = 24") :-
    game3(G),
    solve(G, Path, 24),
    Path = [state(pos(1,1),room1,nothing),
            state(pos(1,2),room1,nothing),
            state(pos(1,1),room2,nothing),
            state(pos(2,1),room2,diagonalizer),
            state(pos(1,1),room2,diagonalizer),
            state(pos(1,2),room1,diagonalizer),
            state(pos(2,3),room1,diagonalizer),
            state(pos(3,4),room1,diagonalizer),
            state(pos(4,4),room1,diagonalizer),
            state(pos(1,1),room3,diagonalizer),
            state(pos(2,2),room3,diagonalizer),
            state(pos(3,3),room3,diagonalizer),
            state(pos(4,4),room3,diagonalizer),
            state(pos(5,5),room3,diagonalizer),
            state(pos(6,6),room3,diagonalizer),
            state(pos(7,7),room3,diagonalizer),
            state(pos(8,8),room3,diagonalizer),
            state(pos(9,9),room3,diagonalizer),
            state(pos(10,10),room3,diagonalizer)],
    !.

% There is no solution using less than 24 time units
test("No solution with MaxT = 23") :-
    game3(G),
    \+ solve(G, _, 23),
    !.

:- end_tests(world3).

:- initialization(main).

main :- run_tests, halt.
