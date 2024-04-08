/* resenje i salt su private inputi igrača koji je zamislio broj,
ali je heš(resenje,salt) public i tu vrednost zovemo resenjeCommitment.
Da bi igrač podmetnuo lažno rešenje, morao bi da nađe vrednost salt-a tako da
heš od lažnog rešenja i tog novog salt-a bude jednak resenjeCommitment, a to nije 
moguće uraditi u realnom vremenu. 
*/

pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";

template PogodiBroj () {
signal input pokusaj;
signal input resenje;
signal input resenjeCommitment;
signal input salt;
signal output odgovor;

/* Prvo proveravamo da li je heš(resenje,salt) jednak resenjeCommitment,
tj. proveravamo da li je igrač pokušao da podmetne lažno rešenje */
component hash = Poseidon(2);
hash.inputs[0] <== resenje;
hash.inputs[1] <== salt;
resenjeCommitment === hash.out; 

// Sada proveravamo da li je pokušaj uspešan
component jednaki = IsEqual();
jednaki.in[0] <== pokusaj;
jednaki.in[1] <== resenje;
odgovor <== jednaki.out;
}


component main { public [pokusaj, resenjeCommitment] } = PogodiBroj();

//primer inputa:

/* INPUT = {
"pokusaj": "6",
"resenje": "5",
"salt": "578789985645456879678",
"resenjeCommitment": "18290756784816207199976835344004633283990028741082068901014247095738035526578"
} */
