*Constrained Layout Problem with 4 rectangles and 2 areas
*Convex Hull version

$TITLE Constrained Layout Problem
$OFFSYMXREF
$OFFSYMLIST
$ONINLINE

SETS
I /1*4/ /*Number of rectangles*/
AREA /1*2/ /*Number of areas*/
D1 /1*4/ /*Number of disjuncts for non-overlapping constraints*/
D2 /1*4/ /*Number of constraints in disjuncts for safety constraints*/
;

ALIAS
(I,J,K)
;

PARAMETERS
L(I)
        / 1 = 5
          2 = 7
          3 = 3
          4 = 2/

H(I)
        / 1 = 6
          2 = 5
          3 = 3
          4 = 3/

XBAR(AREA)
         / 1 = 15
           2 = 50/

YBAR(AREA)
         / 1 = 10
           2 = 80/

R(AREA)
         / 1 = 6
           2 = 10/;

PARAMETERS
XMIN(I) /1*4 = 0/
XMAX(I) /1*4 = 0/
YMIN(I) /1*4 = 0/
YMAX(I) /1*4 = 0/;

XMIN(I) = XBAR('1') - R('1') + L(I)/2;
XMAX(I) = XBAR('2') + R('2') - L(I)/2;
YMIN(I) = YBAR('1') - R('1') + H(I)/2;
YMAX(I) = YBAR('2') + R('2') - H(I)/2;

TABLE C(I,J)

             1       2       3       4
      1              300     240     210
      2                      100     150
      3                              120
;

SCALAR  ES  /1E-6/;

VARIABLES
X(I)
Y(I)
V(K,D1,I,J)
VV(K,D1,I,J)
U(AREA,I)
UU(AREA,I)
Z(D1,I,J)
W(AREA,I)
DELX(I,J)
DELY(I,J)
OBJ;

POSITIVE VARIABLES
X(I)
Y(I)
V(K,D1,I,J)
VV(K,D1,I,J)
U(AREA,I)
UU(AREA,I)
DELX(I,J)
DELY(I,J)
;

BINARY VARIABLES
Z(D1,I,J)
W(AREA,I);

EQUATIONS
OBJCH
DIST1(I,J)
DIST2(I,J)
DIST3(I,J)
DIST4(I,J)
DISAGGX_DISJ1(K,I,J)
DISAGGY_DISJ1(K,I,J)
BNDV(K,D1,I,J)
BNDVV(K,D1,I,J)
DISJ1(I,J)
DISJ2(I,J)
DISJ3(I,J)
DISJ4(I,J)
BIN1(I,J)
DISAGGX_DISJ2(I)
DISAGGY_DISJ2(I)
BNDU(AREA,I)
BNDUU(AREA,I)
SAF1(AREA,I)
SAF2(AREA,I)
SAF3(AREA,I)
SAF4(AREA,I)
BIN2(I);

*Objective Function
OBJCH.. OBJ =E= SUM((I,J),C(I,J)*(DELX(I,J) + DELY(I,J)));

*Distance Constraints
DIST1(I,J)$(ORD(I) LT ORD(J)).. DELX(I,J) =G= X(I) - X(J);
DIST2(I,J)$(ORD(I) LT ORD(J)).. DELX(I,J) =G= X(J) - X(I);
DIST3(I,J)$(ORD(I) LT ORD(J)).. DELY(I,J) =G= Y(I) - Y(J);
DIST4(I,J)$(ORD(I) LT ORD(J)).. DELY(I,J) =G= Y(J) - Y(I);

*Disaggregated variables
DISAGGX_DISJ1(K,I,J)$(ORD(I) LT ORD(J) AND (ORD(K) EQ ORD(I) OR ORD(K) EQ ORD(J))).. X(K) =E= SUM(D1,V(K,D1,I,J));
DISAGGY_DISJ1(K,I,J)$(ORD(I) LT ORD(J) AND (ORD(K) EQ ORD(I) OR ORD(K) EQ ORD(J))).. Y(K) =E= SUM(D1,VV(K,D1,I,J));

*Bounds on disaggregated variables
BNDV(K,D1,I,J)$(ORD(I) LT ORD(J) AND (ORD(K) EQ ORD(I) OR ORD(K) EQ ORD(J))).. V(K,D1,I,J) =L= Z(D1,I,J)*XMAX(I);
BNDVV(K,D1,I,J)$(ORD(I) LT ORD(J) AND (ORD(K) EQ ORD(I) OR ORD(K) EQ ORD(J))).. VV(K,D1,I,J) =L= Z(D1,I,J)*YMAX(I);

*Disjunctions - Overlap
DISJ1(I,J)$(ORD(I) LT ORD(J)).. V(I,'1',I,J) - V(J,'1',I,J) =L= (-L(I)/2 - L(J)/2)*Z('1',I,J);
DISJ2(I,J)$(ORD(I) LT ORD(J)).. V(J,'2',I,J) - V(I,'2',I,J) =L= (-L(J)/2 - L(I)/2)*Z('2',I,J);
DISJ3(I,J)$(ORD(I) LT ORD(J)).. VV(I,'3',I,J) - VV(J,'3',I,J) =L= (-H(I)/2 - H(J)/2)*Z('3',I,J);
DISJ4(I,J)$(ORD(I) LT ORD(J)).. VV(J,'4',I,J) - VV(I,'4',I,J) =L= (-H(J)/2 - H(I)/2)*Z('4',I,J);

*Summation of binary variables
BIN1(I,J)$(ORD(I) LT ORD(J)).. SUM(D1,Z(D1,I,J)) =E= 1;

*Disaggregated variables
DISAGGX_DISJ2(I).. X(I) =E= SUM(AREA,U(AREA,I));
DISAGGY_DISJ2(I).. Y(I) =E= SUM(AREA,UU(AREA,I));

*Bounds on disaggregated variables
BNDU(AREA,I).. U(AREA,I) =L= W(AREA,I)*(XBAR(AREA) + R(AREA) - L(I)/2);
BNDUU(AREA,I).. UU(AREA,I) =L= W(AREA,I)*(YBAR(AREA) + R(AREA) - H(I)/2);

*Safety constraints

*Original
*SAF1(AREA,I).. (W(AREA,I)+ES)*(SQR(U(AREA,I)/(W(AREA,I)+ES)) - 2*(L(I)/2 + XBAR(AREA))*U(AREA,I)/(W(AREA,I)+ES) + SQR(L(I)/2 + XBAR(AREA))*W(AREA,I) + SQR(UU(AREA,I)/(W(AREA,I)+ES)) + 2*(H(I)/2 - YBAR(AREA))*UU(AREA,I)/(W(AREA,I)+ES) + SQR(H(I)/2 - YBAR(AREA))*W(AREA,I) - SQR(R(AREA))*W(AREA,I)) =L= 0;
*SAF2(AREA,I).. (W(AREA,I)+ES)*(SQR(U(AREA,I)/(W(AREA,I)+ES)) - 2*(L(I)/2 + XBAR(AREA))*U(AREA,I)/(W(AREA,I)+ES) + SQR(L(I)/2 + XBAR(AREA))*W(AREA,I) + SQR(UU(AREA,I)/(W(AREA,I)+ES)) - 2*(H(I)/2 + YBAR(AREA))*UU(AREA,I)/(W(AREA,I)+ES) + SQR(H(I)/2 + YBAR(AREA))*W(AREA,I) - SQR(R(AREA))*W(AREA,I)) =L= 0;
*SAF3(AREA,I).. (W(AREA,I)+ES)*(SQR(U(AREA,I)/(W(AREA,I)+ES)) + 2*(L(I)/2 - XBAR(AREA))*U(AREA,I)/(W(AREA,I)+ES) + SQR(L(I)/2 - XBAR(AREA))*W(AREA,I) + SQR(UU(AREA,I)/(W(AREA,I)+ES)) + 2*(H(I)/2 - YBAR(AREA))*UU(AREA,I)/(W(AREA,I)+ES) + SQR(H(I)/2 - YBAR(AREA))*W(AREA,I) - SQR(R(AREA))*W(AREA,I)) =L= 0;
*SAF4(AREA,I).. (W(AREA,I)+ES)*(SQR(U(AREA,I)/(W(AREA,I)+ES)) + 2*(L(I)/2 - XBAR(AREA))*U(AREA,I)/(W(AREA,I)+ES) + SQR(L(I)/2 - XBAR(AREA))*W(AREA,I) + SQR(UU(AREA,I)/(W(AREA,I)+ES)) - 2*(H(I)/2 + YBAR(AREA))*UU(AREA,I)/(W(AREA,I)+ES) + SQR(H(I)/2 + YBAR(AREA))*W(AREA,I) - SQR(R(AREA))*W(AREA,I)) =L= 0;

*HR2c
POSITIVE VARIABLE T(AREA,I);
T.UP(AREA,I) = (SQR(XBAR(AREA) + R(AREA) - L(I)/2)) + (SQR(YBAR(AREA) + R(AREA) - H(I)/2));
POSITIVE VARIABLE U_c(AREA,I), UU_c(AREA,I);
U_c.UP(AREA,I) = SQRT(2)*(XBAR(AREA) + R(AREA) - L(I)/2);
UU_c.UP(AREA,I) = SQRT(2)*(YBAR(AREA) + R(AREA) - H(I)/2);
EQUATION SAF_c(AREA,I);
EQUATION SAFc_c(AREA,I), SAFc_cc(AREA,I);
SAF1(AREA,I).. T(AREA,I) - 2*(L(I)/2 + XBAR(AREA))*U(AREA,I) + 2*(H(I)/2 - YBAR(AREA))*UU(AREA,I) + W(AREA,I)*(SQR(L(I)/2 + XBAR(AREA)) + SQR(H(I)/2 - YBAR(AREA)) - SQR(R(AREA))) =L= 0;
SAF2(AREA,I).. T(AREA,I) - 2*(L(I)/2 + XBAR(AREA))*U(AREA,I) - 2*(H(I)/2 + YBAR(AREA))*UU(AREA,I) + W(AREA,I)*(SQR(L(I)/2 + XBAR(AREA)) + SQR(H(I)/2 + YBAR(AREA)) - SQR(R(AREA))) =L= 0;
SAF3(AREA,I).. T(AREA,I) + 2*(L(I)/2 - XBAR(AREA))*U(AREA,I) + 2*(H(I)/2 - YBAR(AREA))*UU(AREA,I) + W(AREA,I)*(SQR(L(I)/2 - XBAR(AREA)) + SQR(H(I)/2 - YBAR(AREA)) - SQR(R(AREA))) =L= 0;
SAF4(AREA,I).. T(AREA,I) + 2*(L(I)/2 - XBAR(AREA))*U(AREA,I) - 2*(H(I)/2 + YBAR(AREA))*UU(AREA,I) + W(AREA,I)*(SQR(L(I)/2 - XBAR(AREA)) + SQR(H(I)/2 + YBAR(AREA)) - SQR(R(AREA))) =L= 0;
SAF_c(AREA,I).. 2*(W(AREA,I)*T(AREA,I)) =G= SQR(U_c(AREA,I)) + SQR(UU_c(AREA,I));
SAFc_c(AREA,I).. U_c(AREA,I) =E= SQRT(2)*U(AREA,I);
SAFc_cc(AREA,I).. UU_c(AREA,I) =E= SQRT(2)*UU(AREA,I);

*Summation of binary variables
BIN2(I).. SUM(AREA,W(AREA,I)) =E= 1;

*Bound Constraints
X.LO(I) = XMIN(I);
Y.LO(I) = YMIN(I);
X.UP(I) = XMAX(I);
Y.UP(I) = YMAX(I);

*Model parameters
MODEL LAYOUT_CH / ALL /;

*OPTION ITERLIM = 100000000;
*OPTION RESLIM = 900;
*OPTION THREADs = 8;
*OPTION OPTCR    = 1E-5 ;
*OPTION LIMROW   = 0 ;
*OPTION LIMCOL   = 0 ;
*OPTION SOLPRINT = OFF ;
*OPTION SYSOUT   = OFF ;

*LAYOUT_CH.OPTFILE = 1;

set      metrics         /
                         obj
                         time
                         node
                         gap
                         /
;
set      mods            /
                         relax
                         full
                         /
;
set      stats           /
                         nvars
                         neqs
                         ndvars
                         /
;


PARAMETER RESULTS(METRICS,MODS), PROB_STATS(STATS);


$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP


*SOLVE LAYOUT_CH USING %RTYPE% MINIMIZING OBJ;

*results('obj','relax') = LAYOUT_CH.objval;
*results('time','relax') = LAYOUT_CH.resusd;

*LAYOUT_CH.OPTFILE = 1;
*LAYOUT_CH.NODLIM = 1000000;


SOLVE LAYOUT_CH USING %TYPE% MINIMIZING OBJ;

