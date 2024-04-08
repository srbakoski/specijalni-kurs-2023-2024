pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";

template PogodiBroj () {
signal input pokusaj;
signal input resenje;
signal input resenjeCommitment;
signal output odgovor;
component hash = Poseidon(1);
// za računanje heša koristimo gotov template Poseidon iz circomlib/poseidon.circom:
hash.inputs[0] <== resenje;
resenjeCommitment === hash.out; /* proveravamo da li je igrač pokušao da vara, odnosno
da podmetne broj koji nije prvobitno zamislio */
component jednaki = IsEqual();
jednaki.in[0] <== pokusaj;
jednaki.in[1] <== resenje;
odgovor <== jednaki.out;
}


component main { public [pokusaj, resenjeCommitment] } = PogodiBroj();

//primer inputa:

/* INPUT = {
"pokusaj": "5",
"resenje": "5",
"resenjeCommitment": "19065150524771031435284970883882288895168425523179566388456001105768498065277"
} */

/* Pošto se igra sastoji u pogađanju celog broja izmedju 1 i 100,
heširanje nije dovoljna zaštita rešenja, jer igrač koji pogadja broj može
redom da hešira brojeve od 1 do 100 dok ne naidje na broj čiji je heš jednak
vrednosti resenjeCommitment (resenjeCommitment je public input). Da bismo
onemogućili igrača da na taj način sazna rešenje, neophodno je da "posolimo"
rešenje, odnosno da uvedemo veliki broj koji ćemo zvati salt
*/