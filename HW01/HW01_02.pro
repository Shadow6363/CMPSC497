start(q0).
final(q3).

epsilon(q1, q3).
transition(q0, "one", q1).
transition(q0, "two", q1).
transition(q0, "three", q1).
transition(q0, "four", q1).
transition(q0, "five", q1).
transition(q0, "six", q1).
transition(q0, "seven", q1).
transition(q0, "eight", q1).
transition(q0, "nine", q1).
transition(q0, "ten", q1).
transition(q0, "eleven", q1).
transition(q0, "twelve", q1).

transition(q1, "o'clock", q3).
transition(q1, "-thirty", q3).

transition(q0, "midnight", q3).
transition(q0, "noon", q3).

transition(q0, "quarter to", q2).
transition(q0, "quarter past", q2).
transition(q0, "half past", q2).

transition(q2, "one", q3).
transition(q2, "two", q3).
transition(q2, "three", q3).
transition(q2, "four", q3).
transition(q2, "five", q3).
transition(q2, "six", q3).
transition(q2, "seven", q3).
transition(q2, "eight", q3).
transition(q2, "nine", q3).
transition(q2, "ten", q3).
transition(q2, "eleven", q3).
transition(q2, "twelve", q3).



fsa(String) :-
    start(Word), fsa(String, Word).

fsa([], CurrentState) :-
    final(CurrentState).

fsa([Word|String], CurrentState) :-
    transition(CurrentState, Word, NextState), fsa(String, NextState).

fsa(String, CurrentState) :-
    epsilon(CurrentState, NextState), fsa(String, NextState).