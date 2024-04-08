/*
Potapanje brodova (eng. Battleship) je igra koju igraju dva igrača.
Svaki igrač rasporedjuje svoje brodove na kvadratnu tablu

Više o igri možete pročitati ovde: https://en.wikipedia.org/wiki/Battleship_(game)
*/

pragma circom 2.1.6;

include "circomlib/poseidon.circom";
include "circomlib/comparators.circom";
include "circomlib/mux1.circom";

template Tabla(N) {
signal input tabla [N][N];
signal input ii;
signal input jj;
signal output odgovor;
/* prvi pokušaj: jednostavno proveravamo da li se podmornica nalazi
na polju sa koordinatama ii i jj. Ako se nalazi vraćamo 1, u suprotnom vraćamo 0:

component pogodak = IsEqual();
pogodak.in[0] <== tabla[ii][jj];
pogodak.in[1] <== 1;
odgovor <== pogodak.out;

Ovaj kod neće raditi jer ii i jj nisu poznati u trenutku kompilacije,
pa ne smemo da ih koristimo za pristupanje matrici tabla[N][N],
jer mogu da budu van opsega

drugi pokušaj:
signal pogodak;
component polje = Mux1();
for(var i=0; i<N; i++)
{
    for(var j=0; j<N; j++)
    {
        if(i==ii)
        {
            if(j==jj)
            {
               polje.c[0]<==0;
               polje.c[1]<==1;
               polje.s <== tabla[i][j];
               pogodak <== polje.out; 
            }
        }
    }
}
odgovor <== pogodak;       

Ni ovaj kod neće raditi. Neophodno je da aritmetizujemo if-ove.
To radimo koristeći multipleksere. Za multiplekser imamo gotov template
Mux1 u circomlib/mux1.circom
*/

// treći (konačno ispravan) pokušaj:
/* U svakoj iteraciji dvostruke for petlje ćemo proveravati da li smo
naišli na polje koje je gadjao protivnik. Dakle, moramo da izvršimo NxN
provera za obe koordinate. Pošto se deklaracija component-i ne može
vršiti u for petlji, moramo sve componente da deklarišemo pre for petlje  */
component jednakii[N][N];
component jednakij[N][N];
component polje[N][N];
var pogodak = 0;
/* ako hoćemo da budemo maksimalno formalni i da svuda budemo
pokriveni constraint-ovima onda bi umesto var trebalo da koristimo
NxN matricu signala */
for(var i=0; i<N; i++)
{
    for(var j=0; j<N; j++)
    {
        jednakii[i][j]=IsEqual();
        jednakii[i][j].in[0] <==ii;
        jednakii[i][j].in[1] <==i;

        jednakij[i][j]=IsEqual();
        jednakij[i][j].in[0] <==jj;
        jednakij[i][j].in[1] <==j;

        polje[i][j]=Mux1();
        polje[i][j].c[0] <== 0;
        polje[i][j].c[1] <== tabla[i][j];
        polje[i][j].s <== jednakii[i][j].out * jednakij[i][j].out;
/* ako smo naišli na polje koje je gadjao protivnik (tj. ako je selektorski
bit jednak 1), onda je izlaz iz multipleksera vrednost koja se nalazi na tom polju
(tj. vrednost tabla[i][j]), a za sva ostala polja izlaz je 0 */
        pogodak += polje[i][j].out;
/* sabiramo sve izlaze, tj. sabiramo 24 nule i vrednost na polju
koje je gadjao protivnik (dakle, pogodak če imati vrednost 0 ili 1) */
    }
}
odgovor <== pogodak;
}

component main {public [ii, jj]} = Tabla(5);

//primer inputa:

/* INPUT = {
"tabla": [["0","1","1","0","1"],["0","0","0","0","1"],
["1","1","1","0","1"],["0","0","0","0","1"],["0","0","1","1","0"]],
"ii": "1",
"jj": "2"
} */

/*
Ovo je tabla koju šaljemo kao input
0 1 1 0 1
0 0 0 0 1
1 1 1 0 1
0 0 0 0 1
0 0 1 1 0
*/




