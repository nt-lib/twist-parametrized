//the following are the twist isolated j-invariants

J := [ -160855552000/1594323, 3375/64, -24729001, -35937/4, -297756989/2, -882216989/131072, -1680914269/32768, -1273201875, -38575685889/16384, 432, 
-138240, 109503/64, -35817550197738955933474532061609984000/2301619141096101839813550846721, 4543847424/3125, -121, 351/4, -82944, 11225615440/1594323, 
1026895/1024, 210720960000000/16807, -349938025/8, 46969655/32768, 1331/8, -1159088625/2097152, -316368, -18234932071051198464000/48661191875666868481, 
3375/2, 64, 30081024/3125, -162677523113838677, -140625/8, -23788477376, -25/2, -189613868625/128, -9317, -121945/32, -92515041526500, 
-110349050625/1024, 90616364985637924505590372621162077487104/197650497353702094308570556640625, 136878750000, -1723025/4 ];

AttachSpec("TwistParametrized.spec");
Z := OpenImageContext("OpenImage/data-files");

function GL2LevelOfDefinition(G)
    return Characteristic(BaseRing(G));
end function;

//we initailize the images

imgs_ag := AssociativeArray();
imgs := AssociativeArray();
imgs_sl2 :=  AssociativeArray();
for j in J do
    not_exceptional, label, G := FindAgreeableClosure(Z,j);
    assert not not_exceptional;
    N := GL2LevelOfDefinition(G);
    index := ExactQuotient(GL2Size(N),Order(G));
    gens := GL2Generators(G);
    G := GL2FromGenerators(N, index, gens);
    imgs_ag[j] := G;
    G, index, G_SL2 := FindOpenImage(Z,MinimalQuadraticTwist(EllipticCurveFromjInvariant(j)));
    N :=  GL2LevelOfDefinition(G);
    gens := GL2Generators(G);
    G := GL2FromGenerators(N, index, gens);
    imgs[j] := G;
    imgs_sl2[j] := G_SL2;
end for;

Jtable:=[];
Mi:=[];
ctr:=0;
for i:=1 to #J do 
    trnew:=true;
    for j:=i+1 to #J do
      if GL2Level(imgs_ag[J[i]]) ne GL2Level(imgs_ag[J[j]]) then continue; end if;
      if SL2Level(imgs_sl2[J[i]]) ne GL2Level(imgs_sl2[J[j]]) then continue; end if;
      N,G1:=GL2Level(imgs_ag[J[i]]); N,G2:=GL2Level(imgs_ag[J[j]]);
      M,S1:=SL2Level(imgs_sl2[J[i]]); M,S2:=SL2Level(imgs_sl2[J[j]]);
      G:=GL(2,Integers(N)); S:=SL(2, Integers(M));
      tr1,conj_el1:=IsConjugate(G,G1,G2);
      tr2,conj_el2:=IsConjugate(S,S1,S2);
      if tr1 and tr2 then J[i],J[j]; ctr:=ctr+1; trnew:=false; end if;
    end for;
    if trnew then Mi:=Mi cat [G1]; Jtable:=Jtable cat [J[i]]; end if;
end for;  
ctr;

//this will print out the pairs of j-invariants that live in the same twist family
ctr:=0;
Jtable:=[J[1]];
for i:=2 to #J do 
    trnew:=true;
    for j:=1 to i-1 do
      if GL2Level(imgs_ag[J[i]]) ne GL2Level(imgs_ag[J[j]]) then continue; end if;
      if SL2Level(imgs_sl2[J[i]]) ne GL2Level(imgs_sl2[J[j]]) then continue; end if;
      N,G1:=GL2Level(imgs_ag[J[i]]); N,G2:=GL2Level(imgs_ag[J[j]]);
      M,S1:=SL2Level(imgs_sl2[J[i]]); M,S2:=SL2Level(imgs_sl2[J[j]]);
      G:=GL(2,Integers(N)); S:=SL(2, Integers(M));
      tr1,conj_el1:=IsConjugate(G,G1,G2);
      tr2,conj_el2:=IsConjugate(S,S1,S2);
      if tr1 and tr2 then J[i],J[j]; ctr:=ctr+1; trnew:=false; end if;
    end for;
    if trnew then Mi:=Mi cat [G1]; Jtable:=Jtable cat [J[i]]; end if;
end for;  
assert ctr eq 26; //this is the number of pairs of j-invariants (among the 41 twist-isolated j) of elliptic curves whose Galois images lie in the same twist family
#Jtable eq 22; //this is the number of twist families in which all the 41 j lie

/*
//there are 2 groups such that have the same sl_2 index, and sl2 genus, they are candidates that they can be merged
s:={};
for j in Jtable do 
    s:= s join {[GL2Index(imgs_sl2[j]),GL2Genus(imgs_sl2[j])]};
end for;  
s;
*/



// Now we show that the families cannot be merged as they have different sl2 images. This proves that there are no less than 22 twist families in which all the twist isolated j lie 
for i:=2 to #Jtable do 
    for j:=1 to i-1 do
      if [GL2Index(imgs_sl2[Jtable[j]]),GL2Genus(imgs_sl2[Jtable[j]])] eq [GL2Index(imgs_sl2[Jtable[i]]),GL2Genus(imgs_sl2[Jtable[i]])] then Jtable[i],Jtable[j]; 
        M1,S1:=SL2Level(imgs_sl2[Jtable[i]]); M2,S2:=SL2Level(imgs_sl2[Jtable[j]]); 
        if M1 eq M2 then
          S:=SL(2, Integers(M1)); 
          IsConjugate(S,S1,S2);
        else print "false";
        end if;
      end if;
    end for;   
end for;  
