//The genus 7 curve is a twist lift of 45.54.2.c.1 with j = 2^6 and j = -2^{6}* 719^{3}

P<x,y,z,w>:=ProjectiveSpace(Rationals(),3);
P1 := ProjectiveSpace(Rationals(), 1);
eqns := [x^2*y+x*y^2-y^3+2*x*y*z+y^2*z-x*z^2-y*z^2+x^2*w-x*y*w+x*z*w+2*y*z*w-y*w^2, 2*x*y*z+4*y^2*z+y*z^2-z^3+x*z*w+2*z^2*w-z*w^2, x^2*y+3*x*y^2+y^3-x*y*z-y^2*z+y*z^2+x*y*w+x*z*w-2*y*z*w-x*w^2+y*w^2, 2*x*y^2+4*y^3+y^2*z-y*z^2+x*y*w+2*y*z*w-y*w^2, 2*x*y*w+4*y^2*w+y*z*w-z^2*w+x*w^2+2*z*w^2-w^3, x^2*y+3*x*y^2-y^3-2*x*y*z+2*y^2*z-2*y*z^2+z^3+3*x*y*w-5*y^2*w+2*y*z*w-2*z^2*w-y*w^2+z*w^2];
C := Curve(P, eqns);
j := [524288*x^11-393216000*x^6*z*w^4+349606678976000*x^6*w^5-5845345729344000*x^5*z*w^5+41826106495104000*x^5*w^6-172955982144896000*x^4*z*w^6+422735903949696000*x^4*w^7+682379830120270000*x^3*z*w^7-28219919760618904000*x^3*w^8+148222428765510098500*x^2*z*w^8+543756614183501717250*x^2*w^9-349606678976000*x*z^10+5237394871552000*x*z^9*w-33558317783936000*x*z^8*w^2+123027337857280000*x*z^7*w^3-303618861118464000*x*z^6*w^4-909735242881998000*x*z^5*w^5+25624994760165526000*x*z^4*w^6-96282472461319754500*x*z^3*w^7-815389408270960164750*x*z^2*w^8-872234578946567934750*x*z*w^9+843771338272418271875*x*w^10-2819140495730402988750*y^2*w^9-2038609285120000*y*z^10+36161614433280000*y*z^9*w-284955444386240000*y*z^8*w^2+1322573667144320000*y*z^7*w^3-4043066048471680000*y*z^6*w^4-222194368918640000*y*z^5*w^5+167013523547855790000*y*z^4*w^6-1021129009133749400000*y*z^3*w^7-2456841392578417050000*y*z^2*w^8+4418528069912087189375*y*z*w^9-2545455301805132826250*y*w^10+607954003520000*z^11-11763858253440000*z^10*w+102860845176320000*z^9*w^2-540545439650560000*z^8*w^3+1910030875745280000*z^7*w^4-2135082179980670000*z^6*w^5-49188929765208960000*z^5*w^6+385611150700917427500*z^4*w^7+415732779987187183750*z^3*w^8-1624054516971997609375*z^2*w^9+707360583748789097500*z*w^10+165212824103272410625*w^11, 524288*x^6*z*w^4+51775314432*x^6*w^5-1163591223808*x^5*z*w^5+11218859516928*x^5*w^6-62053799990272*x^4*z*w^6+209128601756672*x^4*w^7-247729923707760*x^3*z*w^7-6752972500147328*x^3*w^8+50281099145815852*x^2*z*w^8+139285068973805702*x^2*w^9-51775314432*x*z^10+1073550372864*x*z^9*w-9476354737152*x*z^8*w^2+46942785218560*x*z^7*w^3-147547694184448*x*z^6*w^4+46045864337264*x*z^5*w^5+6558273787052432*x*z^4*w^6-37348714382011244*x*z^3*w^7-231626554530349322*x*z^2*w^8-208149550675627162*x*z*w^9+215622370423538825*x*w^10-794822239011850890*y^2*w^9-301911587840*y*z^10+7092602536960*y*z^9*w-73269315079680*y*z^8*w^2+440126987146240*y*z^7*w^3-1715301898869760*y*z^6*w^4+2918071160155520*y*z^5*w^5+37884113014675280*y*z^4*w^6-333198481623412800*y*z^3*w^7-547575612321543600*y*z^2*w^8+1106400999356018685*y*z*w^9-669910326405324190*y*w^10+90036656640*z^11-2260254254080*z^10*w+25333408906240*z^9*w^2-168255011281920*z^8*w^3+741117060008960*z^7*w^4-1791658730375440*z^6*w^5-9490678558622720*z^5*w^6+116800724571438180*z^4*w^7+70280848192898130*z^3*w^8-396709896349780125*z^2*w^9+169529527139833620*z*w^10+50785108494572515*w^11];
jmap := map<C->P1 | [j[1]*(-1), j[2]]>;


smallpts := PointSearch(C, 1000);
exists(Q1){Q : Q in smallpts | jmap(Q) eq P1![2^6,1] };
exists(Q2){Q : Q in smallpts | jmap(Q) eq P1![-2^6 * 719^3,1]};


//show that there are no rational points other than the ones we expect. 
j1 := P1![2^6,1] ;
j2 := P1![-2^6 * 719^3,1];
inv_im1 := j1 @@jmap;
inv_im2 := j2 @@jmap;
assert Dimension(inv_im1) eq 0;
ratpts := RationalPoints(inv_im1);
assert #RationalPoints(inv_im1) eq 2;
//even though there are 2 points in the preimage, only one has the right j-invariant: that's what the following logical statement is saying
assert Eltseq(jmap(C!Eltseq(ratpts[1]))) eq Eltseq(j1) or Eltseq(jmap(C!Eltseq(ratpts[2]))) eq Eltseq(j1) and not(Eltseq(jmap(C!Eltseq(ratpts[1]))) eq Eltseq(j1) and Eltseq(jmap(C!Eltseq(ratpts[2]))) eq Eltseq(j1));

assert Dimension(inv_im2) eq 0;
assert #RationalPoints(inv_im2) eq 2;
ratpts := RationalPoints(inv_im2);
//even though there are 2 points in the preimage, only one has the right j-invariant
assert Eltseq(jmap(C!Eltseq(ratpts[1]))) eq Eltseq(j2) or Eltseq(jmap(C!Eltseq(ratpts[2]))) eq Eltseq(j2) and not(Eltseq(jmap(C!Eltseq(ratpts[1]))) eq Eltseq(j1) and Eltseq(jmap(C!Eltseq(ratpts[2]))) eq Eltseq(j2));


A := AutomorphismGroup(C);
jmap((A.1)(Q1)); //cusp after applying automorphism
jmap((A.2)(Q1)); //

jmap((A.1)(Q2)); //cusp after applying automorphism
jmap((A.2)(Q2)); //