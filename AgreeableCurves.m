//For each twist isolated j-invariant, find the corresponding modular curve in the LMFDB
//i.e. compute G_j then G_j^ag, and then compute the canonical generators as well as the level, genus, and index
//we then use sage to compute the label in the LMFDB

// twist_isolated := [-2^10*3^3*5, -2^10*3^4, -2^9*3^3, -(3^3*11^3)/2^2, (3^2*23^3)/2^6, -(5^2*41^3)/2^2, (3^3*5^3)/2^6, (5*59^3)/2^10, -(17^2*101^3)/2, -(17*373^3)/2^17, -(3^3*37^3*47)/2^10, -2^2*3^2, -2^4*3^2*13^3, -(2^6*5^4*19^3*263*5113^3)/7^20, 2^4*3^3, -(2^21*3^3*5^3*7*13^3*23^3*41^3*179^3*409^3)/79^16, -(2^18*3*5^3*13^3*41^3*107^3)/17^16, -11*131^3, -11^2, (2^12*3^3*5^7*29^3)/7^5, -7*137^3*2083^3, -7*11^3, -(5^2*241^3)/2^3, -(5*29^3)/2^5, -(5^2)/2, (5*211^3)/2^15, -(2^12*5^3*11*13^4)/3^13, (2^4*5*13^4*17^3)/3^13, (2^18*3^3*13^4*127^3*139^3*157^3*283^3*929)/(5^13*61^13), -(3^3*5^4*11^3*17^3)/2^10, -(29^3*41^3)/2^15, (11^3)/2^3, -(3^3*5^3*383^3)/2^7, -(3^3*13*479^3)/2^14, -(3^2*5^6)/2^3, -(3^2*5^3*101^3)/2^21, (3^3*13)/2^2, (3^3*5^3)/2, (3^3*5*7^5)/2^7, (2^16*3^3*17)/5^5, (2^10*3^2*79^3)/5^5, -2^2*3^7*5^3*439^3, -3^3*5^4*11*19^3, -2^6*719^3, 2^6];
AttachSpec("OpenImage/OpenImage.spec");
AttachSpec("Magma/magma.spec");
path := OpenImageContext("OpenImage/data-files");

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
    inputs := Split(Read("twistisolatedplain.txt"), "\n");
    input := inputs[seq];
    jinv := eval input;
    jinv := Rationals()!jinv;
    gens, level, genus, index := ComputeGL2Data(jinv);
    GetLabel(gens, level, genus, index, jinv);
end if;

    // parallel --joblog joblogoct15 --shuf --timeout 10000 --eta -j8   magma -b seq:={} AgreeableCurves.m ::: {1..46} -> outputoct15.out