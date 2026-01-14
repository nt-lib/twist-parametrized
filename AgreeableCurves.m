//For each twist isolated j-invariant, find the corresponding modular curve in the LMFDB
//i.e. compute G_j then G_j^ag, and then compute the canonical generators as well as the level, genus, and index
//we then use sage to compute the label in the LMFDB


//Note that for some j-invariants the EllipticCurveFromjInvariant(j) gives an error, so it's better to input your favorite E

AttachSpec("OpenImage/OpenImage.spec");
AttachSpec("Magma/magma.spec");
path := OpenImageContext("OpenImage/data-files");

function ComputeGL2Data(E)
    G,_,_ := FindOpenImage(path, E);
    G_ag := GL2AgreeableClosure(G);
    gens := GL2CanonicalGenerators(G_ag);
    level := GL2Level(G_ag);
    genus := GL2Genus(G_ag);
    index := GL2Index(G_ag);
    return gens, level, genus, index;
end function;

function ComputeGL2Data(j)
    E := EllipticCurveFromjInvariant(j);
    G,_,_ := FindOpenImage(path, E);
    G_ag := GL2AgreeableClosure(G);
    gens := GL2CanonicalGenerators(G_ag);
    level := GL2Level(G_ag);
    genus := GL2Genus(G_ag);
    index := GL2Index(G_ag);
    return gens, level, genus, index;
end function;

function PrimeFactorizationString(n)
    if n eq 1 then
        return "1";
    elif n eq -1 then
        return "-1";
    end if;
    
    factors := Factorization(Abs(n));
    result := [];
    
    for pair in factors do
        p := pair[1];
        e := pair[2];
        if e eq 1 then
            Append(~result, Sprint(p));
        else
            Append(~result, Sprint(p) cat "^" cat Sprint(e));
        end if;
    end for;
    
    fac_str := Join(result, "*");
    if n lt 0 then
        fac_str := "-" cat fac_str;
    end if;
    
    return fac_str;
end function;

procedure GetLabel(gens, level, genus, index, jinv)
    code := [];
    code := [ "import lmfdb", "from lmfdb import db" ];
    search_str := "db.gps_gl2zhat_fine.lucky({'level':";
    search_str := search_str cat Sprint(level) cat ",'index':";
    search_str := search_str cat Sprint(index) cat ",'genus':";
    search_str := search_str cat Sprint(genus) cat ",'canonical_generators':";
    search_str := search_str cat Sprint(gens) cat "},projection=\"label\")";
    Append(~code, search_str);
    code := Join(code, "\n");
    fname := "sage_script_" cat PrimeFactorizationString(Numerator(jinv)) cat "_" cat PrimeFactorizationString(Denominator(jinv)) cat ".sage";
    Write(fname, code);
    // sage_code := Pipe("sage -q " cat fname, "");
    // label := eval(sage_code);
    // return label;
end procedure;

// Process a single j-invariant (for use with GNU parallel)
// Usage: magma -b jinv:="value" AgreeableCurves.m
if assigned seq then
    SetColumns(0);
    SetAutoColumns(false);
    seq := eval seq;
    inputs := Split(Read("table_j_invariants.txt"), "\n");
    input := inputs[seq];
    jinv := eval input;
    jinv := Rationals()!jinv;
    gens, level, genus, index := ComputeGL2Data(jinv);
    GetLabel(gens, level, genus, index, jinv);
end if;

    // parallel --joblog joblogoct15 --shuf --timeout 10000 --eta -j8   magma -b seq:={} AgreeableCurves.m ::: {1..41} -> outputoct15.out