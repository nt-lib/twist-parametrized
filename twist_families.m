AttachSpec("TwistParametrized.spec");

load "config.m";

MDSetPythonInterpreter(python_path);

function ReadAgreeableDatafile(filename)
    I:=Open(filename, "r");
    X:=AssociativeArray();
    repeat
        b,y:=ReadObjectCheck(I);
        if b then
            if not y`is_agreeable then
                print y`is_entangled, y`key;
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

function GL2FromZywina(record);
    ZZ := Integers();
    gens := [[ZZ ! a : a in gen]: gen in record`gens];
    return GL2FromGenerators(record`level, record`index, gens);
end function;

data :=  ReadAgreeableDatafile("OpenImage/data-files/agreeable.dat");

infinite := [x`key : x in Values(data) | x`has_infinitely_many_points];
maximal := [x`key : x in Values(data) | x`has_infinitely_many_points and x`index eq data[x`cover_with_same_commutator_subgroup]`index];
infinite := Sort(infinite, func<x,y | 10^10*(data[x]`level-data[y]`level)+data[x]`index-data[y]`index>);
maximal := Sort(maximal, func<x,y | 10^10*(data[x]`level-data[y]`level)+data[x]`index-data[y]`index>);
maximal_Gc := [data[k]`Gc : k in maximal];  //these are representatives of the twist family


lmfdb_data := MDGL2LMFDBLookup([GL2FromZywina(data[k]) : k in maximal]);
lmfdb_data_Gc := MDGL2LMFDBLookup(maximal_Gc);
