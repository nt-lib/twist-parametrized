//For each twist isolated j-invariant, find the corresponding modular curve in the LMFDB
//i.e. compute G_j then G_j^ag, and then compute the canonical generators as well as the level, genus, and index
//we then use sage to compute the label in the LMFDB

twist_isolated := [-2^10*3^3*5, -2^10*3^4, -2^9*3^3, -(3^3*11^3)/2^2, (3^2*23^3)/2^6, -(5^2*41^3)/2^2, (3^3*5^3)/2^6, (5*59^3)/2^10, -(17^2*101^3)/2, -(17*373^3)/2^17, -(3^3*37^3*47)/2^10, -2^2*3^2, -2^4*3^2*13^3, -(2^6*5^4*19^3*263*5113^3)/7^20, 2^4*3^3, -(2^21*3^3*5^3*7*13^3*23^3*41^3*179^3*409^3)/79^16, -(2^18*3*5^3*13^3*41^3*107^3)/17^16, -11*131^3, -11^2, (2^12*3^3*5^7*29^3)/7^5, -7*137^3*2083^3, -7*11^3, -(5^2*241^3)/2^3, -(5*29^3)/2^5, -(5^2)/2, (5*211^3)/2^15, -(2^12*5^3*11*13^4)/3^13, (2^4*5*13^4*17^3)/3^13, (2^18*3^3*13^4*127^3*139^3*157^3*283^3*929)/(5^13*61^13), -(3^3*5^4*11^3*17^3)/2^10, -(29^3*41^3)/2^15, (11^3)/2^3, -(3^3*5^3*383^3)/2^7, -(3^3*13*479^3)/2^14, -(3^2*5^6)/2^3, -(3^2*5^3*101^3)/2^21, (3^3*13)/2^2, (3^3*5^3)/2, (3^3*5*7^5)/2^7, (2^16*3^3*17)/5^5, (2^10*3^2*79^3)/5^5, -2^2*3^7*5^3*439^3, -3^3*5^4*11*19^3, -2^6*719^3, 2^6];
AttachSpec("OpenImage/OpenImage.spec");
AttachSpec("Magma/magma.spec");
path := "OpenImage/data-files/agreeable.dat";

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

function GetLabel(gens, level, genus, index, j)
    code := [];
    code := [ "import lmfdb", "from lmfdb import db" ];
    search_str := "db.gps_gl2zhat_fine.lucky({'level':";
    search_str := search_str cat Sprint(level) cat ",'index':";
    search_str := search_str cat Sprint(index) cat ",'genus':";
    search_str := search_str cat Sprint(genus) cat ",'canonical_generators':";
    search_str := search_str cat Sprint(gens) cat "},projection=\"label\")";
    Append(~code, search_str);
    code := Join(code, "\n");
    fname := Sprintf("sage_script_%o.sage", j);
    Write(fname, code : Overwrite);
    sage_code := Pipe("sage -q " cat fname, "");
    label := eval(sage_code);
    return label;
end function;

for j in twist_isolated do
    gens, level, genus, index := ComputeGL2Data(j);
    label := GetLabel(gens, level, genus, index, j);
    print j, label;
end for;