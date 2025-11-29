SetSeed(2101219762,0);
AttachSpec("../Modular/Modular.spec");
Attach("ModCrvToEC.m");
N := 78;
gens := [[0, 7, 61, 0], [1, 0, 26, 1], [1, 1, 64, 27], [1, 26, 0, 1], [3, 2, 29, 37], [27, 26, 52, 53], [52, 27, 51, 13], [52, 57, 57, 13], [55, 3, 15, 76]];
//don't need to check lmfdb j-map because we already know rational points from Banwait-Cremona
//now want to explain the final point
ModEC := InitializeModEC(N,gens);
Iso, Mx := EllipticCurveQuoCandidates(ModEC);
map := FindMapsToEC(ModEC, [[ 0, 0, 0, -1521, -22815 ]],[1]: CheckLocal := false);
X := Domain(map[1]);
 pts := PointSearch(X,100);
// [ (1 : 1 : 0 : 0 : 1 : 0 : 2 : -1 : 0 : 1), (-1 : -1 : 0 : 0 : 1 : 0 : 2 : -1 : 0 : 1), (0 : 1 : 0 : 1/2 : -1 : -1/2 : -1/2 : 0 : 1 : 1), (0 : -1 : 0 : 1/2 : -1 : -1/2 : -1/2 : 0 : 1 : 1) ]
psi := map[1];
assert psi(pts[1]) eq psi(pts[3]);
assert psi(pts[2]) eq psi(pts[2]);
// psi(pts[1]);
// (0 : 1 : 0)
// > psi(pts[2]);
// (1135 : -38215 : 1)
// > psi(pts[3]);
// (0 : 1 : 0)
// > psi(pts[4]);
// (1135 : -38215 : 1)
P9<[x]> :=  Ambient(X);