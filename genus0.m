//Checking which genus 0 curves have no rational special points

class_no1 := [-262537412640768000,
 -147197952000,
 -884736000,
 -12288000,
 -884736,
 -32768,
 -3375,
 0,
 1728,
 8000,
 54000,
 287496,
 16581375];

genus0curves := Read("genus0results.txt");
genus0curves := Split(genus0curves, "\n");


// Define the ring once, outside the function:
P1<x,y> := ProjectiveSpace(Rationals(),1);

parse_line := function(line)

    parts := Split(line, " ");
    label := parts[1]; //easy part
    poly1 := parts[2]; //starts with [ ends with , and get rid of '
    poly1 := eval poly1[3..#poly1-2];
    poly2 := parts[3]; //ends with ]  and get rid of '
    poly2 := eval poly2[2..#poly2-2];
    coeff1 := parts[4];//starts with [ ends with ,and get rid of '
    coeff1 := eval coeff1[3..#coeff1-2];
    coeff2 := parts[5];
    coeff2 := eval coeff2[2..#coeff2-2]; //ends with ]and get rid of '
    polys := [poly1,poly2];
    coeffs := [coeff1, coeff2];
    return label, polys, coeffs;
end function;

procedure ratpointsgenus0(label, polys, coeffs)
    j := map<P1 -> P1 | [polys[1]*coeffs[1], polys[2]*coeffs[2]]>;
    j := Extend(j);
    Write("genus0numpoints.out",label);
    numratCM := #&join[RationalPoints((P1![class_no1[i],1])@@j) : i in [1..#class_no1]];
    numratcusp := #RationalPoints((P1![1,0])@@j);
    ratpts := numratCM+numratcusp;
    Write("genus0numpoints.out",Sprint(ratpts));
end procedure;


for line in genus0curves do
    label, polys, coeffs := parse_line(line);
    ratpointsgenus0(label, polys, coeffs);
end for;


//now for the remaining ones that do not have special points, check that the genus 0 curves that they are twist lifts of do


//8.12.0.h.1 and 8.12.0.g.1 both are twist lifts of 8.6.0.e.1
label := "8.6.0.e.1";
polys := [x^6*(8*x^2-y^2)^3, y^2*x^10];
coeffs:= [-2^2, 1];
ratpointsgenus0(label,polys,coeffs);

//16.16.0.b.1 is a twist lift of 8.8.0.a.1
label := "8.8.0.a.1";
polys := [(x+y)^8*(x^2-12*x*y-18*y^2)*(3*x^2+12*x*y+10*y^2)^3, (x+y)^8*(x^2-2*y^2)^4];
coeffs := [2^6, 1];
ratpointsgenus0(label,polys,coeffs);

//16.48.0.h.1 is a twist lift of 8.24.0.m.1
label := "8.24.0.m.1";
polys := [(2*x-3*y)^24*(2*x^2-3*y^2)^3*(2*x^2-8*x*y+5*y^2)^3*(12*x^4-48*x^3*y+76*x^2*y^2-56*x*y^3+19*y^4)^3, (2*x-3*y)^24*(2*x^2-4*x*y+y^2)^4*(4*x^4-16*x^3*y+36*x^2*y^2-40*x*y^3+17*y^4)^4];
coeffs := [2^6, 1];
ratpointsgenus0(label,polys,coeffs);

//16.48.0.t.2 is a twist lift of 8.24.0.z.1
label := "8.24.0.z.1";
polys := [(2*x-3*y)^24*(2*x^2-4*x*y+5*y^2)^3*(6*x^2-12*x*y+7*y^2)^3*(4*x^4-16*x^3*y+52*x^2*y^2-72*x*y^3+33*y^4)^3, (2*x-3*y)^24*(2*x^2-4*x*y+y^2)^8*(4*x^4-16*x^3*y+36*x^2*y^2-40*x*y^3+17*y^4)^2];
coeffs := [2^6, 1];
ratpointsgenus0(label,polys,coeffs);


