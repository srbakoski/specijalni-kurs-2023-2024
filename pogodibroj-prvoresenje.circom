/* Igru igraju dva igrača. Jedan igrač zamisli ceo broj od 1 do 100, a drugi
igrač pokušava da pogodi taj broj. Cilj nam je napravimo ovu igru
poštenom, a da ujedno igrač koji je zamislio broj ne mora da otkrije taj broj  */

pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";

template PogodiBroj () {
signal input pokusaj;
signal input resenje;
signal output odgovor;
component jednaki = IsEqual(); 
/* koristimo gotov template IsEqual iz circomlib/comparators.circom:
template IsEqual() {
    signal input in[2];
    signal output out;

    component isz = IsZero();

    in[1] - in[0] ==> isz.in;

    isz.out ==> out;
} */
jednaki.in[0] <== pokusaj;
jednaki.in[1] <== resenje;
/*
IsEqual prima dve vrednosti i kao izlaznu vrednost daje 1 ako su
ulazne vrednosti jednake, a u suprotnom daje 0
*/
odgovor <== jednaki.out;
}

component main { public [pokusaj, resenje] } = PogodiBroj();

//primer inputa:

/* INPUT = {
"pokusaj": "6",
"resenje": "5"
} */

/* Kod je ispravan, ali je problem je što se rešenje šalje 
kao public input, pa nije očuvana privatnost rešenja */






