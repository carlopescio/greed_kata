/* [SWI]Prolog implementation of the greed kata by @CarloPescio */
/* The strategy I'm using might be unusual so yeah, I added comments :-) */

/* score for single faces */
score(single(F),100) :- F = 1,!.
score(single(F),50) :- F = 5,!.
score(single(_),0).
/* score for pair is just two * single*/
score(pair(F),S) :- score(single(F),H),S is 2*H.
/* score for triple */
score(triple(F),1000) :- F = 1,!.
score(triple(F),S) :- S is 100*F.
/* squeeze together 2 single in a pair, single + pair in triple */
squeeze(single(F),single(F),pair(F)).
squeeze(pair(F),single(F),triple(F)).
/* squeeze a roll if possible, assume sorting by face */
squeezeSortedRoll([F1,F2|Fs],R) :- squeeze(F1,F2,Y),squeezeSortedRoll([Y|Fs],R),!.
squeezeSortedRoll([F1|Fs],[F1|R]) :- squeezeSortedRoll(Fs,R).
squeezeSortedRoll([],[]).
/* the score of a squeezed roll is now just the sum of the scores */
scoreSqueezedRoll([],0).
scoreSqueezedRoll([F|Fs],S) :- score(F,S1),scoreSqueezedRoll(Fs,S2),S is S1+S2.
/* so a greedy score is the score of a sorted - squeezed roll */
greedyScore(R,N) :- sort(0,@=<,R,S),squeezeSortedRoll(S,Q),scoreSqueezedRoll(Q,N).

/* roll factory :-) for convenience */
rollFromFaces([],[]).
rollFromFaces([F|Fs], [single(F)|R]) :- rollFromFaces(Fs,R).
/* even more convenience */
greedyScoreFromFaces(F,S) :- rollFromFaces(F,R),greedyScore(R,S).

/* test cases, exec with run_tests. */
:- use_module(library(plunit)).
:- begin_tests(greedy).
test(case55553) :- greedyScoreFromFaces([5,5,5,5,3],550).
test(case23462) :- greedyScoreFromFaces([2,3,4,6,2],0).
test(case34533) :- greedyScoreFromFaces([3,4,5,3,3],350).
test(case15124) :- greedyScoreFromFaces([1,5,1,2,4],250).
test(case55555) :- greedyScoreFromFaces([5,5,5,5,5],600).
:- end_tests(greedy).






