/* [SWI]Prolog implementation of the greed kata by @CarloPescio */
/* The strategy I'm using might be unusual so yeah, I added comments :-) */
/* extended with (2,6) = 2000 */

/* score for single faces */
score(single(1),100) :- !.
score(single(5),50) :- !.
score(single(_),0).
/* score for pair is just 2 * single */
score(pair(2,6),2000) :- !.
score(pair(F),S) :- score(single(F),H),S is 2*H.
/* score for triple */
score(triple(1),1000) :- !.
score(triple(F),S) :- S is 100*F.
/* squeeze together 2 single in a pair, or single + pair in triple */
squeeze(single(F),single(F),pair(F)).
squeeze(pair(F),single(F),triple(F)).
/* squeeze a roll if possible, assume sorting by face */
squeezeSortedRoll([single(2)|W6],[pair(2,6)|R]) :- member(single(6),W6),select(single(6),W6,Wo6),squeezeSortedRoll(Wo6,R),!.
squeezeSortedRoll([F1,F2|Fs],R) :- squeeze(F1,F2,Y),squeezeSortedRoll([Y|Fs],R),!.
squeezeSortedRoll([F1|Fs],[F1|R]) :- squeezeSortedRoll(Fs,R).
squeezeSortedRoll([],[]).
/* the score of a squeezed roll is now just the sum of the scores */
scoreSqueezedRoll([],0).
scoreSqueezedRoll([F|Fs],S) :- score(F,S1),scoreSqueezedRoll(Fs,S2),S is S1+S2.
/* so a greed score is the score of a sorted - squeezed roll */
greedScore(R,N) :- sort(0,@=<,R,S),squeezeSortedRoll(S,Q),scoreSqueezedRoll(Q,N).

/* roll factory :-) for convenience */
rollFromFaces([],[]).
rollFromFaces([F|Fs], [single(F)|R]) :- rollFromFaces(Fs,R).
/* even more convenience */
greedScoreFromFaces(F,S) :- rollFromFaces(F,R),greedScore(R,S).

/* test cases, exec with run_tests. */
:- use_module(library(plunit)).
:- begin_tests(greed).
test(case55553) :- greedScoreFromFaces([5,5,5,5,3],550).
test(case23432) :- greedScoreFromFaces([2,3,4,3,2],0).
test(case34533) :- greedScoreFromFaces([3,4,5,3,3],350).
test(case15124) :- greedScoreFromFaces([1,5,1,2,4],250).
test(case55555) :- greedScoreFromFaces([5,5,5,5,5],600).
test(case23456) :- greedScoreFromFaces([2,3,4,5,6],2050).
test(case22566) :- greedScoreFromFaces([2,2,5,6,6],4050).
:- end_tests(greed).






