//The code can be run using the repository https://github.com/rouseja/ModCrvToEC
//Or we can pre-load the map from the saved code
//note that for some reason the code is random so you have to set the random seed
//This is for 36.108.6.g.1

SetSeed(1258402571,21268947);
AttachSpec("TwistParametrized.spec");

N := 36; 
gens := [[0, 1, 35, 28], [0, 13, 31, 20], [1, 17, 10, 27], [2, 5, 5, 18], [2 ,23, 23, 27], [4, 1, 23, 24]];
ModEC := InitializeModEC(N,gens :Verbose := true);
pts := PointSearch(ModEC`XG,100);
ModEC`BasePt := pts[1];
Iso, Mx := EllipticCurveQuoCandidates(ModEC); 
map1 := FindMapsToEC(ModEC, [[ 0, 0, 0, -27, -918 ]], [1]); 
psi := map1[1];
map2 := FindMapsToEC(ModEC,  [ 0, 0, 0, -3, -14 ] , [1]);
psi2 := map2[1];


//Commented out code below is in case you want to compare with the random seed version above, and for posterity in case anything breaks. Better to load the Mayle-Rouse code.

P5<x,y,z,w,t,u> := ProjectiveSpace(Rationals(), 5);
// Xeqns := [
// -x^2 - 2*x*y - y^2 - x*z - y*z + z^2 - z*w - 2*x*t - 2*y*t - 2*z*t + w*t - t^2 - x*u - y*u - 2*t*u,
// 5*x^2 + y^2 - x*z - y*z + z^2 + x*w + 2*z*w + w^2 - x*t + z*t - w*t - 3*t^2 + 2*x*u + y*u + z*u + w*u + t*u - u^2,
// -2*x^2 + 2*y^2 - 7*x*z + 4*y*z + z^2 + z*w + x*t + y*t + 2*z*t - t^2 - 2*x*u + y*u + w*u - 2*u^2,
// -2*x^2 - x*y + y^2 - x*z + 2*y*z + 4*z^2 + x*w + y*w + 3*z*w + x*t + y*t - 4*z*t - 2*w*t + 2*t^2 - 4*x*u - y*u + w*u - 2*u^2,
// -2*x^2 + 2*x*y - 2*y^2 + x*z + 3*z^2 - 3*x*w + 2*y*w + z*w - w^2 + 3*x*t - 2*y*t - 2*z*t + w*t + 2*t^2 - 4*y*u + 2*z*u + 2*w*u - 4*t*u - u^2,
// x*y + y^2 - 7*x*z - 2*y*z - 4*z^2 - 5*x*w - 2*y*w - 2*z*w + w^2 + 4*x*t + y*t - 2*z*t - 2*w*t + x*u + y*u + 2*z*u - 2*w*u
// ];
// X := Curve(P5, Xeqns);
// E := EllipticCurve([ 0, 0, 0, -27, -918 ]);
// psi_eqns := [
// -3858*w^3 - 48768*x*w*t + 36876*y*w*t - 18007*z*w*t - 9325*w^2*t + 107898*x*t^2 - 9132*y*t^2 + 17449*z*t^2 + 24620*w*t^2 - 26842*t^3 + 76599*x*w*u - 1326*y*w*u - 19799*z*w*u - 19208*w^2*u - 89313*x*t*u - 32610*y*t*u + 144597*z*t*u + 75019*w*t*u - 57320*t^2*u + 50097*x*u^2 + 27264*y*u^2 - 46306*z*u^2 + 6843*w*u^2 + 7957*t*u^2 + 18905*u^3,
// -7458*w^3 - 110058*x*w*t + 98424*y*w*t + 66436*z*w*t - 10538*w^2*t + 184794*x*t^2 - 93726*y*t^2 - 323898*z*t^2 - 6640*w*t^2 + 29750*t^3 + 11904*x*w*u + 3096*y*w*u - 62278*z*w*u - 25570*w^2*u - 102066*x*t*u - 29652*y*t*u + 247690*z*t*u + 92544*w*t*u - 187258*t^2*u + 91224*x*u^2 + 22434*y*u^2 + 15752*z*u^2 + 24838*w*u^2 + 45128*t*u^2 + 11052*u^3,
// -546*w^3 - 7814*x*w*t + 6864*y*w*t - 5285*z*w*t - 1583*w^2*t + 13178*x*t^2 - 5240*y*t^2 - 14895*z*t^2 + 750*w*t^2 + 542*t^3 + 3663*x*w*u + 114*y*w*u - 4623*z*w*u - 3998*w^2*u - 12531*x*t*u - 9614*y*t*u + 21675*z*t*u + 13757*w*t*u - 15754*t^2*u + 8267*x*u^2 + 4400*y*u^2 - 6992*z*u^2 + 3297*w*u^2 - 4913*t*u^2 + 2593*u^3
// ];
// psi := map<X->E |psi_eqns>;

X := ModEC`XG;

ModEC := ComputeJ(ModEC);
ratpts := RatPtsFromMaps(N, map1);
RatPtsJInvs(ModEC,ratpts);
//{* (-92515041526500 : 1), (0 : 1)^^2 *}


