pragma circom 2.1.6;

include "circomlib/comparators.circom";

template PogodiBroj () {
signal input pokusaj;
signal input resenje;
signal output odgovor;
component jednaki = IsEqual();
jednaki.in[0] <== pokusaj;
jednaki.in[1] <== resenje;
odgovor <== jednaki.out;
}

component main { public [pokusaj] } = PogodiBroj();
// za inpute koji se ne šalju public se podrazumeva da su private

//primer inputa:

/* INPUT = {
"pokusaj": "4",
"resenje": "5"
} */

/* Kod je ispravan i rešenje se šalje kao private input,
pa je očuvana njegova privatnost. Medjutim Prover može da vara
i da pri svakom pokušaju promeni rešenje (jer je rešenje private,
pa niko ne može da proveri da li ga je Prover menjao).
Da bismo izbegli mogućnost da Prover vara, on mora na početku igre
da se commituje na svoje rešenje tako što će kao public input
da pošalje heš od svog rešenja  */
