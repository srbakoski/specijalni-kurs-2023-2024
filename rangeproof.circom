/* U ovom zadatku pravimo aritmetičko kolo koje proverava da li se broj nalazi
u zadatom intervalu, bez otkrivanja vrednosti broja. Dakle, broj se šalje kao
private input, a public inputi su heš tog broja i granice intervala. */

pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";

/* N je maksimalan broj bitova broja za koji proveravamo da li se
nalazi u zadatom intervalu. Ograničeni smo na brojeve manje od
21888242871839275222246405745257275088548364400416034343698204186575808495617
(odnosno brojeve koji se mogu zapisati sa manje od 253 bita),
jer je to red skalarnog polja eliptičke krive BN254 nad kojom radi Circom */

template RangeProof(N) {
assert(N <= 252); 
signal input broj;
signal input commitment;
signal input donjaGranica;
signal input gornjaGranica;
signal output odgovor;

component hash = Poseidon(1);
hash.inputs[0] <== broj;
// racunamo heš broja
commitment === hash.out;
// proveravamo da li je Prover promenio broj na koji se commitovao
component provera1 = LessThan(N);
component provera2 = GreaterThan(N);
/* LessThan i GreaterThan se nalaze u circomlib/comparators.circom
LessThan vraća 1 ako je prvi broj manji od drugog, inače vraća 0
GreaterThan vraća 1 ako je prvi broj veći od drugog, inače vraća 0 */
provera1.in[0] <== broj;
provera1.in[1] <== gornjaGranica;
provera2.in[0] <== broj;
provera2.in[1] <== donjaGranica;
odgovor <== provera1.out * provera2.out;
// provera1.out * provera2.out je 1 akko je broj u zadatom intervalu
}

component main { public [commitment,donjaGranica, gornjaGranica] } = RangeProof(10);
// broj je private input

//primer inputa:

/* INPUT = {
"broj": "27",
"commitment": "3090449945362578885698525831403001132226322149412971827901701818601612083800",
"donjaGranica": "18",
"gornjaGranica": "65"
} */

/* Napomena: Isto kao u zadatku sa pogadjanjem broja, neophodno je dodati salt na broj,
jer bi u suprotnom za male brojeve na osnovu heša moglo da se zaključi koji broj je u pitanju */



