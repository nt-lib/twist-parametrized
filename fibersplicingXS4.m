//This is for XS4(13)
SetSeed(2101219762,0);
AttachSpec("TwistParametrized.spec");
N := 78;
gens := [[0, 7, 61, 0], [1, 0, 26, 1], [1, 1, 64, 27], [1, 26, 0, 1], [3, 2, 29, 37], [27, 26, 52, 53], [52, 27, 51, 13], [52, 57, 57, 13], [55, 3, 15, 76]];
//don't need to check lmfdb j-map because we already know rational points from Banwait-Cremona
//now want to explain the final point
ModEC := InitializeModEC(N,gens : Verbose:= true);
pts := PointSearch(ModEC`XG,100);
ModEC`BasePt := pts[1];

Iso, Mx := EllipticCurveQuoCandidates(ModEC);
map1 := FindMapsToEC(ModEC, [[ 0, 0, 0, -1521, -22815 ]],[1]); //This is E1
map2 := FindMapsToEC(ModEC, [[ 0, 0, 0, -36, 81 ]], [1]); //this is E2

X := Domain(map1[1]); //This is Xtilde
pts := PointSearch(X,100);
//[ (0 : 0 : 1 : 1 : 1 : 1/2 : -1/2 : 0 : -1/2 : 1), (-1 : 0 : -1 : 0 : -1 : 2 : 0 : 1 : 0 : 1), (0 : 0 : -1 : 1 : 1 : 1/2 : -1/2 : 0 : -1/2 : 1), (1 : 0 : 1 : 0 : -1 : 2 : 0 : 1 : 0 : 1) ]
psi1 := map1[1];
psi2 := map2[1];
x2 := pts[1];
x3 := pts[2];
x2prime := pts[3];
x3prime := pts[4];

//check that the map to E1 identifies the points above y2 and y3 in the right way
assert psi1(x2) eq psi1(x3);
assert psi1(x2prime) eq psi1(x3prime);

//check that psi2 does not identify any points
assert psi2(x2) ne psi2(x3);
assert psi2(x2) ne psi2(x2prime);
assert psi2(x2) ne psi2(x3prime);
assert psi2(x2prime) ne psi2(x3);
assert psi2(x2prime) ne psi2(x3prime);
assert psi2(x3) ne psi2(x3prime);

//now find the involution and check that the points lie above y2, y3 in the correct manner
P9<[x]> :=  Ambient(X);
i := map<X -> X | [-x[1], -x[2], -x[3], x[4], x[5], x[6], x[7], x[8],x[9],x[10]]>;
assert i(x3) eq x3prime;
assert i(x2) eq x2prime;
b, a  := IsAutomorphism(i);
A := AutomorphismGroup(X, [a]);
C, pi := CurveQuotient(A);
Cplane := PlaneCurve(C);
P2<x,y,z> := Ambient(Cplane);
f := 5*x^4 - 7*x^3*y + 8*x^3*z + 3*x^2*y^2 - 7*x^2*y*z + 4*x^2*z^2 + 2*x*y^3 - 2*x*y^2*z - 5*x*y*z^2 - 3*x*z^3 + 5*y^3*z + y^2*z^2 + 2*y*z^3;
Clmfdb := Curve(P2, f);
print "Computing Isomorphism...";
b, iso := IsIsomorphicPlaneQuartics(Cplane,Clmfdb);
assert b; 
print "Done.";

//Checking that E2 is a modular curve
N := 78;
gens_ec := [[0, 7, 61, 28], [0, 17, 35, 70], [0, 35, 17, 34], [1, 0, 26, 1], [1, 26, 0, 1], [27, 26, 52, 53], [52, 3, 69, 1], [52, 27, 51, 37]];
E2_rec := InitializeModEC(N,gens_ec : Verbose:= true);
E2 := E2_rec`XG;
assert IsIsomorphic(EllipticCurve(E2), EllipticCurve([ 0, 0, 0, -36, 81 ]));

//now check fibers of the map
print "Checking fibers...";
print "Computing psi 1...";
im_2psi1 := psi1(x2);
print "Computing psi2 1...";
im_2psi2 := psi2(x2);
print "Computing preimages...";
fib_psi1 := im_2psi1@@psi1;
fib_psi2 := im_2psi2@@psi2;
fib_int := fib_psi1 meet fib_psi2;
assert Degree(fib_int) eq 1; //only one point
assert RationalPoints(fib_int)[1] eq x2; //the point is x2

print "Compting psi1...";
im_3psi1 := psi1(x3);
print "Compting psi2...";
im_3psi2 := psi2(x3);
print "Computing preimages...";
fib_psi1 := im_3psi1@@psi1;
fib_psi2 := im_3psi2@@psi2;
fib_int := fib_psi1 meet fib_psi2;
assert Degree(fib_int) eq 1; //only one point
assert RationalPoints(fib_int)[1] eq x3; //the point is x3

print "Checking uniqueness of involution...";
//Uniqueness of the involution
X7 := ChangeRing(X, GF(7));
A7 := AutomorphismGroup(X7);
X5 := ChangeRing(X, GF(5));
A5 := AutomorphismGroup(X5);
assert #A7 eq 2;
assert #A5 eq 2;

