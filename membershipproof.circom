/* U ovom zadatku pravimo aritmetičko kolo pomoću kojeg se dokazuje da list pripada
Merkle Tree-ju dubine N, bez otkrivanja lista. Dakle, list, putanja i susedi se šalju
kao private input, a public input je koren stabla. Susedi predstavlja niz suseda
koje list ima na putu do korena stabla, a putanja je niz nula i jedinica koji daje
informaciju da li se na tom putu susedi nalaze sa leve ili desne strane
(0 znači da je sused sa desne strane, a 1 da je sused sa leve strane)  */

pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/mux1.circom";
include "circomlib/comparators.circom";

template MerkleTreeMembershipProof(N) { 
signal input list;
signal input putanja[N];
signal input susedi[N]; // heševi suseda koji se nalaze na putanji od lista do korena
signal input koren;
signal output odgovor;
/* Zadatak ćemo rešiti tako što ćemo prolaziti kroz putanju od lista do korena
i u svakom koraku ćemo, u zavisnosti sa koje je strane sused,
 računati heš(list, sused) ili heš(sused,list), dok ne dođemo do korena.
 Kada dođemo do korena uporedićemo koren i heš koji smo dobili prolaskom kroz stablo.
 Ako se vrednosti poklapaju, onda naš list zaista pripada stablu. */

component poseidons[N];  
component multiplexers[N];
signal hashes[N+1];
// moramo sve da deklarišemo pre for petlje

hashes[0] <== list;
/* U niz hashes smeštamo heševe vrednosti na putanji od lista do korena.
Ako list pripada stablu onda poslednja vrednost koju upisujemo u taj niz
 treba da se poklopi sa korenom */
for(var i=0; i<N; i++)
{
    putanja[i]*(1-putanja[i])===0;
    //proveravamo da li se u nizu putanja nalaze samo nule i jedinice
    
    poseidons[i] = Poseidon(2);
    multiplexers[i] = MultiMux1(2);
/* Pošto ne važi heš(a,b)=heš(b,a), moramo da utvrdimo
sa koje strane se nalazi naš list, i to radimo pomoću multipleksera.
Koristimo MultiMux1(2), to je multiplekser koji ima 4 ulaza i dva izlaza,
i oba izlaza su određena jednim selektorskim bitom */

    multiplexers[i].c[0][0] <== hashes[i];
    multiplexers[i].c[0][1] <== susedi[i];
    multiplexers[i].c[1][0] <== susedi[i];
    multiplexers[i].c[1][1] <== hashes[i];
    multiplexers[i].s <== putanja[i]; // bit na osnovu kojeg odlučujemo kojim redom heširamo

    poseidons[i].inputs[0] <== multiplexers[i].out[0];
    poseidons[i].inputs[1] <== multiplexers[i].out[1];
    hashes[i+1] <== poseidons[i].out;
}
/* Sada je ostalo samo još da uporedimo da li se poslednja vrednost iz niza hashes poklapa
sa korenom stabla */
component jednaki = IsEqual();
jednaki.in[0] <== koren;
jednaki.in[1] <== hashes[N];
odgovor <== jednaki.out;
}

component main {public [koren ]} = MerkleTreeMembershipProof(2);

//primer inputa:

/* INPUT = {
"list": "9900412353875306532763997210486973311966982345069434572804920993370933366268",
"putanja": ["1","1"],
"susedi": ["14333811951799925926774885301821959013021952046626659497477564929336980550427",
"21114081898029808037446369066386890808499219327603760814259363886440875203594"],
"koren": "18082206648824691976573755102785321790738391063615978985145698498622998022597"
} */

