AttachSpec("TwistParametrized.spec");

function ReadAgreeableDatafile(filename)
    I:=Open(filename, "r");
    X:=AssociativeArray();
    repeat
        b,y:=ReadObjectCheck(I);
        if b then
            if not y`is_agreeable then
                // print y`is_entangled, y`key;
                continue;
            end if;
            if y`genus ge 2 then
                y`has_infinitely_many_points := false;
            end if;
            X[y`key]:=y;

        end if;
    until not b;
    return X;
end function;

function GL2FromZywina(record);
    ZZ := Integers();
    gens := [[ZZ ! a : a in gen]: gen in record`gens];
    return GL2FromGenerators(record`level, record`index, gens);
end function;

function GL2LevelOfDefinition(G)
    return Characteristic(BaseRing(G));
end function;

function check_borel(G, N)
    ps := PrimeFactors(N);
    isborel := false;
    for p in ps do
        if p notin [2,3,5,7, 11, 13, 17, 37] then continue; end if;
        B  := GL2Borel(p);
        Gmodp := ChangeRing(G, Integers(p));
        b, _ := GL2IsConjugateSubgroup(B, Gmodp);
        isborel := isborel or b;
    end for;
    return isborel;
end function;

function check_nonsplit(G,N)
    ps := PrimeFactors(N);
    iscartan := false;
    for p in ps do
        if p notin [3,5,7,11] then continue; end if;
        C  := GL2NonsplitCartanNormalizer(p);
        Gmodp := ChangeRing(G, Integers(p));
        b, _ := GL2IsConjugateSubgroup(C, Gmodp);
        iscartan := iscartan or b;
    end for;
    if (N mod 4) eq 0 then
        C  := GL2NonsplitCartanNormalizer(4);
        Gmodp := ChangeRing(G, Integers(4));
        b, _ := GL2IsConjugateSubgroup(C, Gmodp);
        iscartan := iscartan or b;
    end if;
    return iscartan;
end function;

function check_S4(G, N)
    if (N mod 5) eq 0 then
        E := GL2MaximalS4(5);
        Gmodp := ChangeRing(G, Integers(5));
        b5, _ := GL2IsConjugateSubgroup(E, Gmodp);
    else
        b5 := false;
    end if;

    if (N mod 13) eq 0 then
        E := GL2MaximalS4(13);
        Gmodp := ChangeRing(G, Integers(13));
        b13, _ := GL2IsConjugateSubgroup(E, Gmodp);
    else
        b13 := false;
    end if;
    return b5 or b13;
end function;

function check_split(G, N)
    if (N mod 7) eq 0 then
        C := GL2SplitCartanNormalizer(7);
        Gmodp := ChangeRing(G, Integers(7));
        b, _ := GL2IsConjugateSubgroup(C, Gmodp);
        return b;
    else
        return false;
    end if;
end function;

function check_disc(G, N)
    b1 := false;
    b2 := false;
    if (N mod 4) eq 0 then
        H := sub<GL(2, Integers(4))|[[3, 2, 1, 3], [3, 3, 2, 3]]>;
        Gmodp := ChangeRing(G, Integers(4));
        b1, _ := GL2IsConjugateSubgroup(H, Gmodp);
    end if;
    if (N mod 2) eq 0 then
        H := sub<GL(2, Integers(2))| [[0, 1, 1, 1]]>;
        Gmodp := ChangeRing(G, Integers(2));
        b2, _ := GL2IsConjugateSubgroup(H, Gmodp);
    end if;
    return b1 or b2;
end function;

function check_entanglement(G, N)
     b := false;
     if (N mod 6) eq 0 then
        Gmodp := ChangeRing(G, Integers(6));
        H := sub<GL(2, Integers(6))| [[4, 1, 3, 1], [4, 1, 5, 4]]>;
        b, _ := GL2IsConjugateSubgroup(H, Gmodp);
     end if;
     return b;
end function;

function check_gal3(G,N)
    b := false;
    if (N mod 9) eq 0 then
        H := sub<GL(2, Integers(9))| [[1, 0, 0, 5], [2, 3, 6, 8]]>;
        Gmodp := ChangeRing(G, Integers(9));
        b, _ := GL2IsConjugateSubgroup(H, Gmodp);
    end if;
    return b;
end function;

data :=  ReadAgreeableDatafile("OpenImage/data-files/agreeable.dat");
Z := OpenImageContext("OpenImage/data-files");


maximal := [x`key : x in Values(data) | x`has_infinitely_many_points and x`index eq data[x`cover_with_same_commutator_subgroup]`index];
maximal := Sort(maximal, func<x,y | 10^10*(data[x]`level-data[y]`level)+data[x]`index-data[y]`index>);
groups := [];
for i->key in maximal do
    if i eq 1 then continue; end if;
    G := GL2FromZywina(data[key]);
    Append(~groups, G);
end for;
labels := ["1.1.0.a.1","2.2.0.a.1","2.3.0.a.1","2.6.0.a.1","3.3.0.a.1","3.4.0.a.1","3.6.0.b.1","3.12.0.a.1","4.2.0.a.1","4.4.0.a.1","4.6.0.a.1","4.6.0.d.1","4.6.0.b.1","4.6.0.e.1","4.6.0.c.1","4.8.0.b.1","4.12.0.b.1","4.12.0.a.1","4.12.0.d.1","4.24.0.b.1","5.5.0.a.1","5.6.0.a.1","5.10.0.a.1","5.15.0.a.1","5.30.0.b.1","5.30.0.a.1","6.6.0.b.1","6.8.0.a.1","6.9.0.a.1","6.12.0.a.1","6.18.0.b.1","6.24.0.a.1","6.24.0.c.1","6.36.0.a.1","7.8.0.a.1","7.21.0.a.1","7.28.0.a.1","8.8.0.a.1","8.12.0.v.1","8.12.0.z.1","8.12.0.s.1","8.12.0.t.1","8.12.0.n.1","8.12.0.o.1","8.12.0.h.1","8.12.0.q.1","8.12.0.g.1","8.12.0.w.1","8.16.0.a.1","8.24.0.q.1","8.24.0.bi.1","8.24.0.t.1","8.24.0.bj.1","8.24.0.bp.1","8.24.0.f.1","8.24.0.bq.1","8.24.0.i.1","8.24.0.bf.1","8.24.0.be.1","8.24.0.bt.1","8.24.0.bn.1","8.24.0.bh.1","8.24.0.bc.1","8.24.0.bo.1","8.24.0.bs.1","9.9.0.a.1","9.12.0.a.1","9.12.0.b.1","9.18.0.a.1","9.18.0.d.1","9.27.0.a.1","9.27.0.b.1","9.36.0.b.1","10.10.0.a.1","10.18.0.a.1","10.30.0.a.1","11.55.1.b.1","12.8.0.a.1","12.12.0.q.1","12.18.0.l.1","12.18.0.k.1","12.24.0.d.1","12.24.0.g.1","12.24.0.f.1","12.36.0.h.1","12.36.0.j.1","12.36.0.k.1","12.36.0.e.1","13.14.0.a.1","14.16.0.a.1","15.15.1.a.1","15.18.0.a.1","15.30.1.a.1","15.45.1.a.1","16.16.0.b.1","16.16.0.a.1","16.24.1.l.1","16.24.0.j.1","16.24.0.g.1","16.48.0.h.1","16.48.0.c.1","16.48.0.t.2","16.48.0.t.1","16.48.1.ch.1","16.48.0.n.1","16.48.1.cs.1","16.48.1.bv.1","16.48.1.df.1","16.48.1.bq.1","16.48.0.m.2","16.48.1.dc.1","16.48.1.de.1","16.48.0.m.1","16.48.0.h.2","16.48.0.c.2","16.48.0.i.1","16.48.1.bl.1","16.48.1.cg.1","16.48.1.cc.1","18.24.0.c.1","18.24.0.b.1","18.36.0.a.1","20.10.0.a.1","20.20.1.c.1","21.63.1.a.1","24.36.0.cj.1","24.36.0.cg.1","24.36.1.gl.1","24.36.1.fw.1","24.48.1.mk.1","25.30.0.a.1","27.36.0.a.1","28.16.0.a.1","30.30.1.a.1","32.48.0.f.2","32.48.0.f.1","36.24.0.b.1","36.36.1.e.1"];

isolated_js := [-2^10*3^3*5, -2^10*3^4, -(3^3*11^3)/2^2, (3^2*23^3)/2^6, (3^3*5^3)/2^6, -(5^2*41^3)/2^2, (5*59^3)/2^10, -(17^2*101^3)/2, -(17*373^3)/2^17, -2^4*3^2*13^3, 2^4*3^3, -(2^21*3^3*5^3*7*13^3*23^3*41^3*179^3*409^3)/79^16, -(2^18*3*5^3*13^3*41^3*107^3)/17^16, -11*131^3, -11^2, (2^12*3^3*5^7*29^3)/7^5, -7*137^3*2083^3, -7*11^3, -(5^2*241^3)/2^3, -(5*29^3)/2^5, -(5^2)/2, (5*211^3)/2^15, -(2^12*5^3*11*13^4)/3^13, (2^4*5*13^4*17^3)/3^13, (2^18*3^3*13^4*127^3*139^3*157^3*283^3*929)/(5^13*61^13), -(3^3*5^4*11^3*17^3)/2^10, -(29^3*41^3)/2^15, (11^3)/2^3, -(3^3*5^3*383^3)/2^7, -(3^3*13*479^3)/2^14, -(3^2*5^6)/2^3, -(3^2*5^3*101^3)/2^21, (3^3*13)/2^2, (3^3*5^3)/2, 2^4*3^2*5^7*23^3, (2^16*3^3*17)/5^5, (2^10*3^2*79^3)/5^5, -2^2*3^7*5^3*439^3, -3^3*5^4*11*19^3, -2^6*719^3, 2^6];
imgs_ag := [];
for j in isolated_js do
    not_exceptional, label, G := FindAgreeableClosure(Z,j);
    assert not not_exceptional;
    N := GL2LevelOfDefinition(G);
    index := ExactQuotient(GL2Size(N),Order(G));
    gens := GL2Generators(G);
    G := GL2FromGenerators(N, index, gens);
    Append(~imgs_ag, G);
end for;
groups cat:= imgs_ag;
labels cat:= ["12.24.1.h.1", "12.24.1.g.1", "12.32.1.b.1", "12.32.1.b.1", "12.48.1.q.1", "20.24.1.g.1", "20.24.1.g.1", "17.18.1.a.1", "17.18.1.a.1", "60.40.2.a.1", "60.40.2.a.1", "16.64.2.a.1", "16.64.2.a.1", "44.24.2.a.1", "44.24.2.a.1", "25.75.2.a.1", "37.38.2.a.1", "37.38.2.a.1", "120.48.3.c.1", "120.48.3.c.1", "120.48.3.c.1", "120.48.3.c.1", "13.91.3.a.1", "13.91.3.a.1", "13.91.3.a.1", "20.60.3.w.1", "120.72.3.gqp.1", "120.72.3.gqp.1", "28.64.3.b.1", "28.64.3.b.1", "168.64.3.a.1", "168.64.3.a.1", "168.64.3.a.1", "168.64.3.a.1", "100.100.4.d.1", "20.120.6.a.1", "20.120.6.a.1", "36.108.6.g.1", "30.120.7.e.1", "360.108.7.?.?", "360.108.7.?.?"];

borel := {};
nonsplit := {};
ex := {};
split := {};
disc := {};
entanglement := {};
gal3 := {};


for i->G in groups do
    if i eq 1 then continue; end if;
    N := GL2Level(G);
    b_borel := check_borel(G, N);
    b_ns := check_nonsplit(G, N);
    b_ex := check_S4(G,N);
    b_sp := check_split(G, N);
    b_disc := check_disc(G, N);
    b_ent := check_entanglement(G, N);
    b_gal3 := check_gal3(G, N);

    if b_borel then
        Include(~borel, labels[i]);
    end if;
    if b_ns then
        Include(~nonsplit, labels[i]);
    end if;
    if b_ex then
        Include(~ex, labels[i]);
    end if;
    if b_sp then
        Include(~split, labels[i]);
    end if;
    if b_disc then
        Include(~disc, labels[i]);
    end if;
    if b_ent then
        Include(~entanglement, labels[i]);
    end if;
    if b_gal3 then
        Include(~gal3, labels[i]);
    end if;
end for;
print "Borel:", borel;
print "Nonsplit:", nonsplit;
print "Ex:", ex;
print "Split:", split;
print "Disc:", disc;
print "Entanglement:", entanglement;    
print "Gal3:", gal3;
only_borel := borel diff (nonsplit diff ex diff split diff disc diff entanglement diff gal3);
only_nonsplit := nonsplit diff (borel diff ex diff split diff disc diff entanglement);
only_ex := ex diff (borel diff nonsplit diff split diff disc diff entanglement diff gal3);
only_split := split diff (borel diff nonsplit diff ex diff disc diff entanglement diff gal3);
only_disc := disc diff (borel diff nonsplit diff ex diff split diff entanglement diff gal3);
only_entanglement := entanglement diff (borel diff nonsplit diff ex diff split diff disc diff gal3);
only_gal3 := gal3 diff (borel diff nonsplit diff ex diff split diff disc diff entanglement);
print "Only Borel:", only_borel;
print "Only Nonsplit:", only_nonsplit;
print "Only Ex:", only_ex;    
print "Only Split:", only_split;
print "Only Disc:", only_disc;
print "Only Entanglement:", only_entanglement;
print "Only Gal3:", only_gal3;

/*
Borel: { 8.16.0.a.1, 12.36.0.j.1, 20.24.1.g.1, 6.12.0.a.1, 13.14.0.a.1, 8.24.0.t.1, 4.8.0.b.1, 16.16.0.a.1, 25.30.0.a.1, 16.48.1.cg.1, 16.48.1.ch.1, 8.24.0.bq.1, 21.63.1.a.1, 4.12.0.d.1, 12.36.0.h.1, 8.12.0.v.1, 30.30.1.a.1, 16.48.0.i.1, 360.108.7.?.?, 6.18.0.b.1, 8.24.0.be.1, 44.24.2.a.1, 8.12.0.h.1, 12.48.1.q.1, 28.64.3.b.1, 8.12.0.z.1, 8.12.0.t.1, 8.24.0.q.1, 12.32.1.b.1, 16.64.2.a.1, 8.24.0.bi.1, 32.48.0.f.1, 16.48.1.de.1, 24.48.1.mk.1, 16.24.0.g.1, 12.24.0.g.1, 5.5.0.a.1, 11.55.1.b.1, 4.6.0.d.1, 9.9.0.a.1, 4.12.0.a.1, 8.12.0.n.1, 16.48.1.bv.1, 37.38.2.a.1, 8.12.0.s.1, 18.24.0.c.1, 4.4.0.a.1, 32.48.0.f.2, 27.36.0.a.1, 8.8.0.a.1, 8.24.0.bo.1, 16.48.0.m.1, 8.24.0.bf.1, 24.36.0.cj.1, 8.24.0.bp.1, 12.18.0.l.1, 8.24.0.i.1, 8.12.0.g.1, 12.36.0.k.1, 8.12.0.q.1, 15.15.1.a.1, 30.120.7.e.1, 16.48.0.m.2, 120.48.3.c.1, 6.24.0.c.1, 12.36.0.e.1, 6.9.0.a.1, 9.12.0.a.1, 16.48.0.h.1, 8.24.0.bj.1, 25.75.2.a.1, 16.48.0.c.1, 16.24.1.l.1, 10.10.0.a.1, 24.36.0.cg.1, 12.18.0.k.1, 12.12.0.q.1, 12.24.1.g.1, 4.6.0.a.1, 16.48.0.t.1, 4.12.0.b.1, 16.48.1.bq.1, 24.36.1.gl.1, 6.8.0.a.1, 8.24.0.f.1, 9.27.0.b.1, 16.48.0.h.2, 20.60.3.w.1, 168.64.3.a.1, 16.48.0.c.2, 6.24.0.a.1, 16.48.0.n.1, 8.24.0.bh.1, 16.48.1.df.1, 8.24.0.bc.1, 16.48.0.t.2, 16.48.1.cc.1, 12.24.0.f.1, 16.48.1.bl.1, 8.24.0.bt.1, 3.6.0.b.1, 6.36.0.a.1, 2.3.0.a.1, 18.24.0.b.1, 3.3.0.a.1, 17.18.1.a.1, 60.40.2.a.1, 6.6.0.b.1, 16.48.1.dc.1, 5.30.0.b.1, 16.24.0.j.1, 8.24.0.bn.1, 12.24.0.d.1, 120.72.3.gqp.1, 4.6.0.b.1, 4.6.0.e.1, 16.48.1.cs.1, 2.2.0.a.1, 8.12.0.o.1 }
Nonsplit: { 20.60.3.w.1, 9.27.0.a.1, 20.120.6.a.1, 30.120.7.e.1, 24.36.1.fw.1, 12.32.1.b.1, 9.27.0.b.1, 8.24.0.bf.1, 6.24.0.c.1, 7.28.0.a.1, 16.16.0.b.1, 9.18.0.a.1, 5.15.0.a.1, 360.108.7.?.?, 12.18.0.l.1, 12.36.0.h.1, 12.36.0.k.1, 120.72.3.gqp.1, 16.48.1.bl.1, 12.36.0.j.1, 6.12.0.a.1, 9.12.0.b.1, 12.48.1.q.1, 8.24.0.bo.1, 2.6.0.a.1, 4.2.0.a.1, 36.108.6.g.1, 4.6.0.c.1, 6.8.0.a.1, 12.8.0.a.1, 24.36.1.gl.1, 21.63.1.a.1, 24.36.0.cj.1, 12.12.0.q.1, 13.91.3.a.1, 16.64.2.a.1, 15.45.1.a.1, 28.64.3.b.1, 20.24.1.g.1, 8.12.0.w.1, 24.36.0.cg.1, 8.24.0.bs.1, 16.48.1.dc.1, 60.40.2.a.1, 16.24.0.g.1, 36.36.1.e.1, 168.64.3.a.1, 12.24.1.g.1, 12.24.0.f.1, 5.6.0.a.1, 20.20.1.c.1, 3.4.0.a.1, 15.30.1.a.1, 10.30.0.a.1, 36.24.0.b.1, 15.18.0.a.1, 7.8.0.a.1, 16.48.0.m.1, 15.15.1.a.1, 3.6.0.b.1, 20.10.0.a.1, 14.16.0.a.1 }
Ex: { 20.120.6.a.1, 14.16.0.a.1, 20.10.0.a.1, 13.91.3.a.1, 9.36.0.b.1, 5.30.0.b.1, 4.24.0.b.1, 120.48.3.c.1, 10.18.0.a.1, 17.18.1.a.1, 18.36.0.a.1, 15.30.1.a.1, 100.100.4.d.1, 5.10.0.a.1, 60.40.2.a.1, 5.15.0.a.1, 44.24.2.a.1, 28.16.0.a.1 }
Split: { 7.21.0.a.1 }
Disc: { 16.48.0.h.1, 12.24.1.g.1, 8.12.0.q.1, 12.32.1.b.1, 6.6.0.b.1, 11.55.1.b.1, 4.6.0.c.1, 8.24.0.bq.1, 12.18.0.k.1, 2.3.0.a.1, 6.18.0.b.1, 4.12.0.b.1, 18.36.0.a.1, 8.16.0.a.1, 16.48.0.h.2, 4.12.0.a.1, 4.4.0.a.1, 60.40.2.a.1, 9.36.0.b.1, 4.12.0.d.1, 32.48.0.f.1, 16.48.1.de.1, 17.18.1.a.1, 13.14.0.a.1, 27.36.0.a.1, 4.8.0.b.1, 16.64.2.a.1, 16.48.1.bq.1, 8.24.0.bi.1, 168.64.3.a.1, 3.12.0.a.1, 44.24.2.a.1, 18.24.0.c.1, 28.64.3.b.1, 8.24.0.bp.1 }
Entanglement: { 12.24.1.h.1, 5.30.0.a.1, 6.24.0.a.1, 36.36.1.e.1, 28.16.0.a.1, 36.108.6.g.1 }
Gal3: { 9.27.0.b.1 }
Only Borel: { 6.36.0.a.1, 17.18.1.a.1, 8.12.0.z.1, 18.24.0.b.1, 16.24.1.l.1, 24.48.1.mk.1, 4.6.0.d.1, 4.12.0.b.1, 16.48.0.c.2, 16.16.0.a.1, 32.48.0.f.1, 8.12.0.q.1, 8.12.0.n.1, 28.64.3.b.1, 16.48.1.bv.1, 37.38.2.a.1, 9.27.0.b.1, 25.30.0.a.1, 4.8.0.b.1, 12.24.1.g.1, 120.48.3.c.1, 16.48.0.n.1, 8.24.0.bq.1, 12.24.0.d.1, 8.8.0.a.1, 8.24.0.bn.1, 32.48.0.f.2, 4.12.0.a.1, 8.24.0.bj.1, 6.18.0.b.1, 25.75.2.a.1, 8.12.0.t.1, 8.24.0.f.1, 5.30.0.b.1, 8.24.0.be.1, 2.2.0.a.1, 168.64.3.a.1, 6.24.0.a.1, 9.12.0.a.1, 16.48.0.t.1, 8.24.0.q.1, 16.64.2.a.1, 8.24.0.bt.1, 16.48.0.i.1, 4.12.0.d.1, 12.24.0.g.1, 8.24.0.bp.1, 8.24.0.bi.1, 16.48.1.de.1, 4.4.0.a.1, 16.48.1.cs.1, 12.36.0.e.1, 16.48.0.t.2, 16.48.0.m.2, 6.6.0.b.1, 9.9.0.a.1, 10.10.0.a.1, 4.6.0.b.1, 8.12.0.s.1, 27.36.0.a.1, 8.12.0.h.1, 8.24.0.t.1, 16.48.1.cg.1, 8.16.0.a.1, 44.24.2.a.1, 8.24.0.i.1, 12.32.1.b.1, 6.9.0.a.1, 16.48.1.cc.1, 2.3.0.a.1, 18.24.0.c.1, 3.3.0.a.1, 16.48.0.h.1, 12.18.0.k.1, 8.24.0.bh.1, 8.12.0.g.1, 16.48.1.df.1, 30.30.1.a.1, 4.6.0.e.1, 60.40.2.a.1, 4.6.0.a.1, 16.48.1.ch.1, 8.12.0.v.1, 8.12.0.o.1, 13.14.0.a.1, 5.5.0.a.1, 16.24.0.j.1, 16.48.0.h.2, 16.48.0.c.1, 16.48.1.bq.1, 11.55.1.b.1, 8.24.0.bc.1 }
Only Nonsplit: { 12.8.0.a.1, 16.64.2.a.1, 4.2.0.a.1, 5.15.0.a.1, 13.91.3.a.1, 2.6.0.a.1, 9.18.0.a.1, 20.10.0.a.1, 168.64.3.a.1, 36.36.1.e.1, 16.16.0.b.1, 20.120.6.a.1, 15.45.1.a.1, 24.36.1.fw.1, 14.16.0.a.1, 7.8.0.a.1, 60.40.2.a.1, 15.18.0.a.1, 12.24.1.g.1, 7.28.0.a.1, 28.64.3.b.1, 8.24.0.bs.1, 36.108.6.g.1, 5.6.0.a.1, 12.32.1.b.1, 20.20.1.c.1, 9.27.0.a.1, 15.30.1.a.1, 9.12.0.b.1, 3.4.0.a.1, 10.30.0.a.1, 8.12.0.w.1, 36.24.0.b.1, 4.6.0.c.1 }
Only Ex: { 20.120.6.a.1, 14.16.0.a.1, 20.10.0.a.1, 13.91.3.a.1, 9.36.0.b.1, 4.24.0.b.1, 10.18.0.a.1, 17.18.1.a.1, 18.36.0.a.1, 100.100.4.d.1, 15.30.1.a.1, 5.10.0.a.1, 60.40.2.a.1, 5.15.0.a.1, 44.24.2.a.1, 28.16.0.a.1 }
Only Split: { 7.21.0.a.1 }
Only Disc: { 4.6.0.c.1, 168.64.3.a.1, 16.64.2.a.1, 3.12.0.a.1, 12.32.1.b.1, 9.36.0.b.1, 17.18.1.a.1, 18.36.0.a.1, 28.64.3.b.1, 60.40.2.a.1, 12.24.1.g.1, 44.24.2.a.1 }
Only Entanglement: { 12.24.1.h.1, 5.30.0.a.1, 36.36.1.e.1, 28.16.0.a.1, 36.108.6.g.1 }
Only Gal3: { 9.27.0.b.1 }
*/