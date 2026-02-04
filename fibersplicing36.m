//This is for 36.108.6.g.1

SetSeed(1118389250,0); 
AttachSpec("TwistParametrized.spec");

N := 36; 
gens := [[0, 1, 35, 28], [0, 13, 31, 20], [1, 17, 10, 27], [2, 5, 5, 18], [2 ,23, 23, 27], [4, 1, 23, 24]];
ModEC := InitializeModEC(N,gens :Verbose := true);
pts := PointSearch(ModEC`XG,100);
ModEC`BasePt := pts[1];
Iso, Mx := EllipticCurveQuoCandidates(ModEC);  
map1 := FindMapsToEC(ModEC, [[ 0, 0, 0, -27, -918 ]], [1]); //E1
psi1 := map1[1];
map2 := FindMapsToEC(ModEC,  [ 0, 0, 0, -3, -14 ] , [1]); //E2
psi2 := map2[1];
//check fibers
x := pts[1];
fib1 := psi1(x)@@psi1; 
fib2 := psi2(x)@@psi2;
assert Degree(fib1 meet fib2) eq 1; //one point here
assert RationalPoints(fib1 meet fib2)[1] eq x; //also what we are looking for

//check J-map to see that there is only one non-special point, and that we picked the right point above
X := ModEC`XG;
ModEC := ComputeJ(ModEC); //Long time
ratpts := RatPtsFromMaps(N, map1);
j := ModEC`jmap;
assert j(x) eq Scheme(j(x))![-92515041526500, 1]; //(1/4 : 3/4 : 1/2 : -7/4 : 1/2 : 1)
assert j(pts[2]) eq Scheme(j(pts[2]))![0, 1];
assert j(pts[3]) eq Scheme(j(pts[3]))![0, 1];
