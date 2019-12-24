:- use_module(tp2, [room/2, portal_to/5, diagonalizer/2, solve/3]).

% Game
game0(game(room1, room1, pos(1, 1), pos(2, 2))) :-
    retractall(room(_,_)),
    retractall(portal_to(_,_,_,_,_)),
    assert(room(room1, shape(square,   2))).

% Unit tests
:- begin_tests(world0).


test("1nd solution with MaxT = 2") :-
    game0(G),
    solve(G, Path, 2),
    Path = [state(pos(1, 1), room1, nothing),
            state(pos(2, 1), room1, nothing),
            state(pos(2, 2), room1, nothing)],
    !.

:- end_tests(world0).

:- initialization(main).

main :- run_tests, halt.
