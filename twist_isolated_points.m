//Should be run in twist-parametrized directory

AttachSpec("TwistParametrized.spec");
Z := OpenImageContext("OpenImage/data-files");

function ReadAgreeableDatafile(filename)
  I:=Open(filename, "r");
  X:=AssociativeArray();
  repeat
    b,y:=ReadObjectCheck(I);
    if b then
       X[y`key]:=y;
    end if;
  until not b;
  return X;
end function;

data :=  ReadAgreeableDatafile("OpenImage/data-files/agreeable.dat");

function GL2LevelOfDefinition(G)
    return Characteristic(BaseRing(G));
end function;

function GL2AgreeableClosure2(G, ag_level)
    G := GL2Project(G, ag_level);
    G := GL2IncludeScalars(G);
    return G;
end function;


function IsTwistParametrized(G)
    //This function checks whether X_G is twist parametrized
	Gag:=GL2AgreeableClosure(G);
	N,Gag:= GL2Level(Gag);
	assert N eq GL2LevelOfDefinition(Gag);
	index:=GL2Index(Gag);
	G2:=GL(2,Integers(N));

    base_groups := [];
    for a in data do
        //a`key;
        if N mod a`level ne 0 then continue; end if; //necessary if Gag is contained in H
        if index mod a`index ne 0 then continue; end if; //necessary if Gag is contained in H

        if not (a`is_agreeable and a`genus le 1 and a`has_infinitely_many_points) then
           continue;
        end if;
        //if a`commutator_index mod sl2_index ne 0 then continue; end if;


        if a`level eq 1 then
            H := GL(2, Integers(N));
            HH := H;
        else
            H:=a`G;
            HH:=GL2Lift(H, N);
        end if;
		tr,conj_el:=IsConjugateSubgroup(G2, HH, Gag);
        if not tr then continue; end if;
		Gag:=Conjugate(Gag,conj_el);
        if not IsNormal(HH,Gag) then continue; end if;
		if not IsAbelian(HH/Gag) then continue; end if;
        Append(~base_groups,a);
    end for;
    if #base_groups eq 0 then
        return false, base_groups;
    end if;
    return true, base_groups;
end function;


function CheckIntermediate(G)
// The input is an agreeable group G, with finitely many points and twist parametrized. We want to check that whether there exists an agreeable overgroup H, G<H, with finitely many points, and which is not twist parametrized. 
G_SL2 := SL2Intersection(G);

N:= GL2Level(G);
index := GL2Index(G);
sl2_N, G_SL2 := SL2Level(G_SL2);
sl2_index := SL2Index(G_SL2);
NN := LCM(N, sl2_N);
GG := GL2Lift(G, NN);

surprise_groups := [];
    for a in data do
        //a`key;
        if N mod a`level ne 0 then continue; end if;
        if index mod a`index ne 0 then continue; end if;

        if (not (a`is_agreeable)) or (a`genus le 1 and (a`has_infinitely_many_points)) then
           continue;
        end if;
        //if a`commutator_index mod sl2_index ne 0 then continue; end if;


        if a`level eq 1 then
            H := GL(2, Integers(NN));
            HH := H;
        else
            H:=a`G;
            HH:=GL2Lift(H, NN);
        end if;

        if not IsConjugateSubgroup(GL(2, Integers(NN)), HH, GG) then continue; end if;

        if IsTwistParametrized(HH) then
            continue;
        end if;

        Append(~surprise_groups,a);
    end for;
    if #surprise_groups eq 0 then
        return false, surprise_groups;
    end if;
    return true, surprise_groups;
end function;



keys:=SetToSequence(Keys(data));
A1:=data[keys[1]];




// t[1] is a potentially exceptional j invariant
// t[2] is a bolean that is true if t[1] is NOT exceptional
// See the documentation FindAgreeableClosure for more info what t[3] and
// t[4] mean.

exceptional_j := [t[1] : t in Z["ExceptionalAgreeableClosures"] | not t[2]];
imgs_ag := AssociativeArray();
imgs := AssociativeArray();
imgs_sl2 :=  AssociativeArray();
for j in exceptional_j do
    not_exceptional, label, G := FindAgreeableClosure(Z,j);
    assert not not_exceptional;
    N := GL2LevelOfDefinition(G);
    index := ExactQuotient(GL2Size(N),Order(G));
    gens := GL2Generators(G);
    G := GL2FromGenerators(N, index, gens);
    imgs_ag[j] := G;
    G, index, G_SL2 := FindOpenImage(Z,EllipticCurveFromjInvariant(j));
    N :=  GL2LevelOfDefinition(G);
    gens := GL2Generators(G);
    G := GL2FromGenerators(N, index, gens);
    imgs[j] := G;
    imgs_sl2[j] := G_SL2;
end for;

// We now check which j invariants are isolated. We check whether X_G^ag is twist parametirzed or isolated

isolated_j := [];
todo := AssociativeArray();
for j in exceptional_j do
    G := imgs_ag[j];
    print j, Integers()! GL2Level(G),  GL2Index(G);
    time parametrized, groups := IsTwistParametrized(G);
    if parametrized then
        todo[j] := groups;
    else
        Append(~isolated_j, j);
    end if;
end for;

assert #isolated_j eq 41;
assert #todo eq 40;

// so 41 isolated, 40 parametirzed
// we will see that there are 4 j-invariants that shouldn't be in the parametirzed ones



print Sort([[GL2Genus(imgs_ag[j]),j] : j in Keys(todo)]);

// the following prints problematic stuff, 4 j-invariants in Zywina's files that shouldn't be there
// GL2Index(imgs_ag[j])/c`index  shouldn't happen since this means
// the agreeable closure has infinitely many rational points
print [[j] cat [GL2Index(imgs_ag[j])/c`index : c in todo[j]] : j in Keys(todo)];

problematic_j := [ 68769820673/16, 78608, 2048, 16974593/256 ];

// can't be a mistake up to conjugacy since all groups are conjugete to their
// transpose
print [<j,GL2IsConjugateSubgroup(imgs_ag[j],GL2Transpose(imgs_ag[j]))> : j in problematic_j]; 
print [[j,GL2Genus(imgs_ag[j]),GL2Level(imgs_ag[j]),GL2Index(imgs_ag[j])] : j in problematic_j];

assert problematic_j subset [j: j in Keys(todo)];
parametrized := [];
todo2 := {x : x in Keys(todo) | not x in problematic_j};
assert #todo2 eq 36;

//We still need to check whether there is some X_H which is twist isolated for G<=H
everywhere_parametrized := [];
surprise_j:=[];
for j in todo2 do
	b,l,G := FindAgreeableClosure(Z,j);
	tr,gps:= CheckIntermediate(G);
	j,tr,gps;
	if tr then Append(~surprise_j,j);
		else Append(~everywhere_parametrized,j);
	end if;
end for;
assert #surprise_j eq 0;
assert #everywhere_parametrized eq #todo2;



