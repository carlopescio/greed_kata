/* [SWI]Prolog implementation of the greed kata by @CarloPescio */
/* Much simpler version (no strategy/structure) after Haskell version by @xpmatteo */

scoreSortedRoll([1,1,1|R],S) :- scoreSortedRoll(R,S1), S is 1000+S1,!.
scoreSortedRoll([X,X,X|R],S) :- scoreSortedRoll(R,S1), S is 100 * X + S1,!.
scoreSortedRoll([1|R],S) :- scoreSortedRoll(R,S1), S is 100 + S1,!.
scoreSortedRoll([5|R],S) :- scoreSortedRoll(R,S1), S is 50 + S1,!.
scoreSortedRoll([_|R],S) :- scoreSortedRoll(R,S),!.
scoreSortedRoll([],0).

greedScore(R,N) :- sort(0,@=<,R,S),scoreSortedRoll(S,N).

/* test cases, exec with run_tests. */
:- use_module(library(plunit)).
:- begin_tests(greed).
test(case55553) :- greedScore([5,5,5,5,3],550).
test(case23462) :- greedScore([2,3,4,6,2],0).
test(case34533) :- greedScore([3,4,5,3,3],350).
test(case15124) :- greedScore([1,5,1,2,4],250).
test(case55555) :- greedScore([5,5,5,5,5],600).
:- end_tests(greed).






