:- use_module(tp2, [room/2, portal_to/5, diagonalizer/2, solve/3]).

% Game
game1(game(room1, room3, pos(4, 1), pos(3, 4))) :-
    retractall(room(_,_)),
    retractall(portal_to(_,_,_,_,_)),
    assert(room(room1, shape(square,   4))),
    assert(room(room2, shape(diamond,  5))),
    assert(room(room3, shape(triangle, 7))),
    assert(portal_to(portal1, room1, room2, pos(2, 1), pos(1, 3))),
    assert(portal_to(portal2, room1, room3, pos(1, 4), pos(1, 7))),
    assert(portal_to(portal3, room2, room3, pos(4, 4), pos(4, 4))).

% Unit tests
:- begin_tests(world1).

% There are three solutions whose time is 13


test("1rd solution with MaxT = 13") :-
    game1(G),
    solve(G, Path, 13),
    Path = [state(pos(4,1),room1,nothing),
            state(pos(3,1),room1,nothing),
            state(pos(2,1),room1,nothing),
            state(pos(1,3),room2,nothing),
            state(pos(2,3),room2,nothing),
            state(pos(3,3),room2,nothing),
            state(pos(4,3),room2,nothing),
            state(pos(4,4),room2,nothing),
            state(pos(4,4),room3,nothing),
            state(pos(3,4),room3,nothing)],
    !.

% There are no solution using less than 13 time units
test("No solution with MaxT = 12") :-
    game1(G),
    \+ solve(G, _, 12),
    !.

:- end_tests(world1).

:- initialization(main).

main :- run_tests, halt.
