//Should be run in twist-parametrized directory

AttachSpec("TwistParametrized.spec");


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

//data :=  ReadAgreeableDatafile("data-files/agreeable.dat");


data :=  ReadAgreeableDatafile("OpenImage/data-files/agreeable.dat");

function GL2LevelOfDefinition(G)
    return Characteristic(BaseRing(G));
end function;

function GL2AgreeableClosure2(G, ag_level)
    G := GL2Project(G, ag_level);
    G := GL2IncludeScalars(G);
    return G;
end function;


function GenerateGroup(A)
    N:=A`level;
    G:=sub<GL(2, Integers(N))|A`gens>;
    return G;
end function;

function IsTwistParametrized(G : G_SL2:=0)
    // Warning!! If this function returns true then we do not know if it is
    // actually parametrized. However, if it returns false we are sure it is
    // isolated.
    //print "computing level and indices";
    if Type(G_SL2) eq RngIntElt and G_SL2 eq 0 then
        G_SL2 := SL2Intersection(G);
    end if;

    N:= GL2Level(G);
    index := GL2Index(G);
    sl2_N, G_SL2 := SL2Level(G_SL2);
    sl2_index := SL2Index(G_SL2);
    NN := LCM(#BaseRing(G), sl2_N);
    GG := GL2Lift(G, NN);

    base_groups := [];
    for a in data do
        //a`key;
        if N mod a`level ne 0 then continue; end if;
        if index mod a`index ne 0 then continue; end if;

        if not (a`is_agreeable and a`genus le 1 and a`has_infinitely_many_points) then
           continue;
        end if;
        if a`commutator_index mod sl2_index ne 0 then continue; end if;


        if a`level eq 1 then
            H := GL(2, Integers(NN));
            HH := H;
        else
            H:=a`G;
            HH:=GL2Lift(H, NN);
        end if;

        if not IsConjugateSubgroup(GL(2, Integers(NN)), HH, GG) then continue; end if;

        CM:=CommutatorSubgroup(HH);
        CM := SL2Project(G_SL2, sl2_N);
        if not IsConjugateSubgroup(GL(2, Integers(sl2_N)), G_SL2, CM) then
            continue;
        end if;

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


Z := OpenImageContext("OpenImage/data-files");

// t[1] is an potentially exceptional j invariant
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

isolated_j := [];
todo := AssociativeArray();
for j in exceptional_j do
    G := imgs_ag[j];
    print j, Integers()! GL2Level(G),  GL2Index(G);
    time parametrized, groups := IsTwistParametrized(G: G_SL2 := imgs_sl2[j]);
    if parametrized then
        todo[j] := groups;
    else
        Append(~isolated_j, j);
    end if;
end for;

print Sort([[GL2Genus(imgs_ag[j]),j] : j in Keys(todo)]);

// the following prints problematic stuff
// GL2Index(imgs_ag[j])/c`index  shouldn't happen since this means
// the agreeable closure has infinitely many rational points
print [[j] cat [GL2Index(imgs_ag[j])/c`index : c in todo[j]] : j in Keys(todo)];

problematic_j := [ 68769820673/16, 78608, 2048, 16974593/256 ];

// can't be a mistake up to conjugacy since all groups are conjugete to their
// transpose
print [<j,GL2IsConjugateSubgroup(imgs_ag[j],GL2Transpose(imgs_ag[j]))> : j in problematic_j]; 
print [[j,GL2Genus(imgs_ag[j]),GL2Level(imgs_ag[j]),GL2Index(imgs_ag[j])] : j in problematic_j];


parametrized := [];
for j in Keys(todo) do
print j;
G := imgs[j];
Nag, Gag2 := GL2Level(imgs_ag[j]);
N := GL2LevelOfDefinition(G);
//N, G := GL2Level(GL2IncludeNegativeOne(G));
Nag, Gag := GL2Level(GL2AgreeableClosure2(G,Nag));
Gsl := imgs_sl2[j];
Nsl := SL2Level(Gsl);
b,curves := IsTwistParametrized(Gag: G_SL2 := Gsl);
NN := LCM(Nag,Nsl);
for a in curves do
  //print Nag,Nsl,a`level,  Gag eq Gag2, Gag eq GL2Transpose(Gag2);
  //print GL2IsConjugateSubgroup(Gag, Gag2);
  //print GL2IsConjugateSubgroup(Gag2, Gag);
  assert NN mod a`level eq 0;
end for;
//end for;

GL2NN := GL(2,Integers(NN));
GL2Nsl := GL(2,Integers(Nsl));

for a in curves do
H := a`G;
HH := GL2Lift(H, NN);
GGag := GL2Lift(Gag, NN);
CMH := CommutatorSubgroup(GL2Project(HH,Nsl));

for i in [1..10] do;
  g0 := Random(GL2NN);
  g := GL2ConjugateSubgroup(HH, GGag^g0);
  //ggsl := ChangeRing(g0*g,Integers(Nsl));
  ggsl := GL2Nsl ! (g0*g);
  assert GGag^(g0*g) subset HH;
  if CMH subset Gsl^(ggsl) then
    print "parametrized!", j;
    Append(~parametrized, j);
    break;
  end if;
end for;
end for;
end for;

todo2 := {x : x in parametrized | not x in problematic_j};
assert #todo2 eq 31;

everywhere_parametrized := [];
todo3 := [];
for j in todo2 do
  b,l,G := FindAgreeableClosure(Z,j);
  GL2N := GL(2,Integers(GL2Level(G)));
  assert  GL2Genus(G) eq  GL2Genus(GL2Transpose(G));
  j_info := [sprint(n) : n in [GL2Index(G), GL2Level(G), GL2Genus(G)]] cat [c : c in l | c ne "1A0-1a"];
  overgroups := MinimalOvergroups(GL2N,G);
  //print j_info;
  genera :=  {Integers() ! GL2Genus(GL2AgreeableClosure(H)) : H in overgroups};
  if genera eq {0} then
    Append(~everywhere_parametrized, j);
  else
    Append(~todo3,j);
  end if;
  print "overgroups",  Integers() ! GL2Level(G), #overgroups,  genera;
end for;


for j in todo3 do
	b,l,G := FindAgreeableClosure(Z,j);
	tr,gps:= CheckIntermediate(G);
	j,tr,gps;
end for;
	



//the below is old stuff
/*

overgroups 48 1 { 0 }
overgroups 18 2 { 0 }
overgroups 72 2 { 0 }
overgroups 72 2 { 0 }
overgroups 18 2 { 0 }
overgroups 48 1 { 0 }
overgroups 72 2 { 0 }
overgroups 30 2 { 0 }
overgroups 24 1 { 0 }
overgroups 14 1 { 0 }
overgroups 24 1 { 0 }
overgroups 72 2 { 0 }
overgroups 30 2 { 0 }
overgroups 32 1 { 1 }
overgroups 48 1 { 1 }
overgroups 32 1 { 1 }
overgroups 15 1 { 1 }
overgroups 44 1 { 1 }
overgroups 84 2 { 1 }
overgroups 168 1 { 1 }
overgroups 120 1 { 1 }
overgroups 48 1 { 1 }
overgroups 120 2 { 1 }
overgroups 24 3 { 0, 1 }
overgroups 24 3 { 0, 1 }
overgroups 24 2 { 0, 1 }
overgroups 60 2 { 1, 2 }
overgroups 120 2 { 1, 2 }
overgroups 72 4 { 0, 1, 2 }
overgroups 40 3 { 0, 1, 2 }
overgroups 72 5 { 3, 4, 6 }


{ -6357235796156406771/32768, -44789760, -21024576, 
-227920097737283556595145924109375/602486784535040403801858901, -5000, 
-631595585199146625/218340105584896, -131375418677056/177978515625, -216, 
-47675785945529664000/929293739471222707, 141526649406897/1973822685184, 
339071334684521624665810041360384000/480250763996501976790165756943041, 
5088980530576216000/4177248169415651, 2048, 1906624/729, 4096, 4374, 4913, 
806764685224507983/56693912375296, 16974593/256, 78608, 110592, 419904, 
15084602497088704/8303765625, 82881856/27, 777228872334890625/60523872256, 
16974593, 215694547296795302321664/4177248169415651, 550731776, 68769820673/16, 
15786448344, 38477541376, 24992518538304, 6225959949099011451/32768, 
66735540581252505802048, 6838755720062350457411072 }


//j := 2048;
parametrized := [];
for j in Keys(todo) do
print j;
G := imgs[j];
Nag, Gag2 := GL2Level(imgs_ag[j]);
N := GL2LevelOfDefinition(G);
//N, G := GL2Level(GL2IncludeNegativeOne(G));
Nag, Gag := GL2Level(GL2AgreeableClosure2(G,Nag));
Gsl := imgs_sl2[j];
Nsl := SL2Level(Gsl);
b,curves := IsTwistParametrized(Gag: G_SL2 := Gsl);
NN := LCM(Nag,Nsl);
for a in curves do
  //print Nag,Nsl,a`level,  Gag eq Gag2, Gag eq GL2Transpose(Gag2);
  //print GL2IsConjugateSubgroup(Gag, Gag2);
  //print GL2IsConjugateSubgroup(Gag2, Gag);
  assert NN mod a`level eq 0;
end for;
//end for;

GL2NN := GL(2,Integers(NN));
GL2Nsl := GL(2,Integers(Nsl));

for a in curves do
H := a`G;
HH := GL2Lift(H, NN);
GGag := GL2Lift(Gag, NN);
CMH := CommutatorSubgroup(GL2Project(HH,Nsl));

for i in [1..10] do;
  g0 := Random(GL2NN);
  g := GL2ConjugateSubgroup(HH, GGag^g0);
  //ggsl := ChangeRing(g0*g,Integers(Nsl));
  ggsl := GL2Nsl ! (g0*g);
  assert GGag^(g0*g) subset HH;
  if CMH subset Gsl^(ggsl) then
    print "parametrized!", j;
    Append(~parametrized, j);
    break;
  end if;
end for;
end for;
end for;





X1 := [];
for j in exceptional_j do
    G := imgs[j];
    N :=  GL2LevelOfDefinition(G);

    if N ge 250 then continue; end if;

    print "j, level", j, N;

    time N1 := GL2Level(G);
    time N2 := GL2Level(GL2IncludeNegativeOne(G));
    contains_neg_one := GL2ContainsNegativeOne(G);
    print "level change", N1/N2, contains_neg_one;
    assert  N1/N2 eq 1;

    /*
    time Gag := GL2AgreeableClosure(G);
    if j in Keys(imgs_ag) then
        Gag1 := imgs_ag[j];
        NGag :=  GL2Level(Gag);
        GL2N := GL(2,Integers(GL2LevelOfDefinition(Gag)));

        NGag1 := GL2Level(Gag1);
        assert NGag eq NGag1;
        print NGag, NGag1, GL2Index(Gag), GL2Index(Gag1);
        print GL2N ! [-1,0,0,-1] in Gag;
        print "Gag equality",GL2Project(Gag, NGag) eq GL2Project(imgs_ag[j], NGag1);
        assert GL2IsConjugateSubgroup(Gag,Gag1);
    end if;
    *  /

    time parametrized := IsTwistParametrized(G);
    if parametrized then
        Append(~X1, G);
    end if;
    parametrized; N; GL2Index(G);
end for;
*/


