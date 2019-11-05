*Constrained Layout Problem with 5 rectangles and 2 areas
*Big-M version

$TITLE Constrained Layout Problem
$OFFSYMXREF
$OFFSYMLIST
$ONINLINE

SETS
I /1*5/ /*Number of rectangles*/
AREA /1*2/ /*Number of areas*/
D1 /1*4/ /*Number of disjuncts for non-overlapping constraints*/
D2 /1*4/ /*Number of constraints in disjuncts for safety constraints*/
;

ALIAS
(I,J)
;

PARAMETERS
L(I)
        / 1 = 5
          2 = 7
          3 = 3
          4 = 2
          5 = 9/

H(I)
        / 1 = 6
          2 = 5
          3 = 3
          4 = 3
          5 = 7/

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
XMIN(I) /1*5 = 0/
XMAX(I) /1*5 = 0/
YMIN(I) /1*5 = 0/
YMAX(I) /1*5 = 0/;

XMIN(I) = XBAR('1') - R('1') + L(I)/2;
XMAX(I) = XBAR('2') + R('2') - L(I)/2;
YMIN(I) = YBAR('1') - R('1') + H(I)/2;
YMAX(I) = YBAR('2') + R('2') - H(I)/2;

PARAMETER
M1(D1,I,J) /1*4 .1*5 .1*5 = 0/;

M1('1',I,J)$(ORD(I) LT ORD(J)) = XMAX(I) + L(I)/2 - XMIN(J) + L(J)/2;
M1('2',I,J)$(ORD(I) LT ORD(J)) = XMAX(J) + L(J)/2 - XMIN(I) + L(I)/2;
M1('3',I,J)$(ORD(I) LT ORD(J)) = YMAX(I) + H(I)/2 - YMIN(J) + H(J)/2;
M1('4',I,J)$(ORD(I) LT ORD(J)) = YMAX(J) + H(J)/2 - YMIN(I) + H(I)/2;

PARAMETER
M2(D2,AREA,I) /1*4 .1*2 .1*5 = 0/;

M2('1','1','1') = SQR(XMAX('1') - L('1')/2 - XBAR('1')) + SQR(YMAX('1') + H('1')/2 - YBAR('1')) - SQR(R('1'));
M2('2','1','1') = SQR(XMAX('1') - L('1')/2 - XBAR('1')) + SQR(YMAX('1') - H('1')/2 - YBAR('1')) - SQR(R('1'));
M2('3','1','1') = SQR(XMAX('1') + L('1')/2 - XBAR('1')) + SQR(YMAX('1') + H('1')/2 - YBAR('1')) - SQR(R('1'));
M2('4','1','1') = SQR(XMAX('1') + L('1')/2 - XBAR('1')) + SQR(YMAX('1') - H('1')/2 - YBAR('1')) - SQR(R('1'));

M2('1','2','1') = SQR(XMIN('1') - L('1')/2 - XBAR('2')) + SQR(YMIN('1') + H('1')/2 - YBAR('2')) - SQR(R('2'));
M2('2','2','1') = SQR(XMIN('1') - L('1')/2 - XBAR('2')) + SQR(YMIN('1') - H('1')/2 - YBAR('2')) - SQR(R('2'));
M2('3','2','1') = SQR(XMIN('1') + L('1')/2 - XBAR('2')) + SQR(YMIN('1') + H('1')/2 - YBAR('2')) - SQR(R('2'));
M2('4','2','1') = SQR(XMIN('1') + L('1')/2 - XBAR('2')) + SQR(YMIN('1') - H('1')/2 - YBAR('2')) - SQR(R('2'));

M2('1','1','2') = SQR(XMAX('2') - L('2')/2 - XBAR('1')) + SQR(YMAX('2') + H('2')/2 - YBAR('1')) - SQR(R('1'));
M2('2','1','2') = SQR(XMAX('2') - L('2')/2 - XBAR('1')) + SQR(YMAX('2') - H('2')/2 - YBAR('1')) - SQR(R('1'));
M2('3','1','2') = SQR(XMAX('2') + L('2')/2 - XBAR('1')) + SQR(YMAX('2') + H('2')/2 - YBAR('1')) - SQR(R('1'));
M2('4','1','2') = SQR(XMAX('2') + L('2')/2 - XBAR('1')) + SQR(YMAX('2') - H('2')/2 - YBAR('1')) - SQR(R('1'));

M2('1','2','2') = SQR(XMIN('2') - L('2')/2 - XBAR('2')) + SQR(YMIN('2') + H('2')/2 - YBAR('2')) - SQR(R('2'));
M2('2','2','2') = SQR(XMIN('2') - L('2')/2 - XBAR('2')) + SQR(YMIN('2') - H('2')/2 - YBAR('2')) - SQR(R('2'));
M2('3','2','2') = SQR(XMIN('2') + L('2')/2 - XBAR('2')) + SQR(YMIN('2') + H('2')/2 - YBAR('2')) - SQR(R('2'));
M2('4','2','2') = SQR(XMIN('2') + L('2')/2 - XBAR('2')) + SQR(YMIN('2') - H('2')/2 - YBAR('2')) - SQR(R('2'));

M2('1','1','3') = SQR(XMAX('3') - L('3')/2 - XBAR('1')) + SQR(YMAX('3') + H('3')/2 - YBAR('1')) - SQR(R('1'));
M2('2','1','3') = SQR(XMAX('3') - L('3')/2 - XBAR('1')) + SQR(YMAX('3') - H('3')/2 - YBAR('1')) - SQR(R('1'));
M2('3','1','3') = SQR(XMAX('3') + L('3')/2 - XBAR('1')) + SQR(YMAX('3') + H('3')/2 - YBAR('1')) - SQR(R('1'));
M2('4','1','3') = SQR(XMAX('3') + L('3')/2 - XBAR('1')) + SQR(YMAX('3') - H('3')/2 - YBAR('1')) - SQR(R('1'));

M2('1','2','3') = SQR(XMIN('4') - L('3')/2 - XBAR('2')) + SQR(YMIN('3') + H('3')/2 - YBAR('2')) - SQR(R('2'));
M2('2','2','3') = SQR(XMIN('4') - L('3')/2 - XBAR('2')) + SQR(YMIN('3') - H('3')/2 - YBAR('2')) - SQR(R('2'));
M2('3','2','3') = SQR(XMIN('4') + L('3')/2 - XBAR('2')) + SQR(YMIN('3') + H('3')/2 - YBAR('2')) - SQR(R('2'));
M2('4','2','3') = SQR(XMIN('4') + L('3')/2 - XBAR('2')) + SQR(YMIN('3') - H('3')/2 - YBAR('2')) - SQR(R('2'));

M2('1','1','4') = SQR(XMAX('4') - L('4')/2 - XBAR('1')) + SQR(YMAX('4') + H('4')/2 - YBAR('1')) - SQR(R('1'));
M2('2','1','4') = SQR(XMAX('4') - L('4')/2 - XBAR('1')) + SQR(YMAX('4') - H('4')/2 - YBAR('1')) - SQR(R('1'));
M2('3','1','4') = SQR(XMAX('4') + L('4')/2 - XBAR('1')) + SQR(YMAX('4') + H('4')/2 - YBAR('1')) - SQR(R('1'));
M2('4','1','4') = SQR(XMAX('4') + L('4')/2 - XBAR('1')) + SQR(YMAX('4') - H('4')/2 - YBAR('1')) - SQR(R('1'));

M2('1','2','4') = SQR(XMIN('4') - L('4')/2 - XBAR('2')) + SQR(YMIN('4') + H('4')/2 - YBAR('2')) - SQR(R('2'));
M2('2','2','4') = SQR(XMIN('4') - L('4')/2 - XBAR('2')) + SQR(YMIN('4') - H('4')/2 - YBAR('2')) - SQR(R('2'));
M2('3','2','4') = SQR(XMIN('4') + L('4')/2 - XBAR('2')) + SQR(YMIN('4') + H('4')/2 - YBAR('2')) - SQR(R('2'));
M2('4','2','4') = SQR(XMIN('4') + L('4')/2 - XBAR('2')) + SQR(YMIN('4') - H('4')/2 - YBAR('2')) - SQR(R('2'));

M2('1','1','5') = SQR(XMAX('5') - L('5')/2 - XBAR('1')) + SQR(YMAX('5') + H('5')/2 - YBAR('1')) - SQR(R('1'));
M2('2','1','5') = SQR(XMAX('5') - L('5')/2 - XBAR('1')) + SQR(YMAX('5') - H('5')/2 - YBAR('1')) - SQR(R('1'));
M2('3','1','5') = SQR(XMAX('5') + L('5')/2 - XBAR('1')) + SQR(YMAX('5') + H('5')/2 - YBAR('1')) - SQR(R('1'));
M2('4','1','5') = SQR(XMAX('5') + L('5')/2 - XBAR('1')) + SQR(YMAX('5') - H('5')/2 - YBAR('1')) - SQR(R('1'));

M2('1','2','5') = SQR(XMIN('5') - L('5')/2 - XBAR('2')) + SQR(YMIN('5') + H('5')/2 - YBAR('2')) - SQR(R('2'));
M2('2','2','5') = SQR(XMIN('5') - L('5')/2 - XBAR('2')) + SQR(YMIN('5') - H('5')/2 - YBAR('2')) - SQR(R('2'));
M2('3','2','5') = SQR(XMIN('5') + L('5')/2 - XBAR('2')) + SQR(YMIN('5') + H('5')/2 - YBAR('2')) - SQR(R('2'));
M2('4','2','5') = SQR(XMIN('5') + L('5')/2 - XBAR('2')) + SQR(YMIN('5') - H('5')/2 - YBAR('2')) - SQR(R('2'));



TABLE C(I,J)

             1       2       3       4       5
      1              300     240     210     50
      2                      100     150     30
      3                              120     25
      4                                      60
;

VARIABLES
X(I)
Y(I)
Z(D1,I,J)
W(AREA,I)
DELX(I,J)
DELY(I,J)
OBJ;

POSITIVE VARIABLES
X(I)
Y(I)
D(I,J)
DELX(I,J)
DELY(I,J)
;

BINARY VARIABLES
Z(D1,I,J)
W(AREA,I);

EQUATIONS
OBJBM
DIST1(I,J)
DIST2(I,J)
DIST3(I,J)
DIST4(I,J)

DISJ1(I,J)
DISJ2(I,J)
DISJ3(I,J)
DISJ4(I,J)
BIN1(I,J)

SAF1(AREA,I)
SAF2(AREA,I)
SAF3(AREA,I)
SAF4(AREA,I)
BIN2(I);

*Objective Function
OBJBM.. OBJ =E= SUM((I,J),C(I,J)*(DELX(I,J) + DELY(I,J)));

*Distance Constraints
DIST1(I,J)$(ORD(I) LT ORD(J)).. DELX(I,J) =G= X(I) - X(J);
DIST2(I,J)$(ORD(I) LT ORD(J)).. DELX(I,J) =G= X(J) - X(I);
DIST3(I,J)$(ORD(I) LT ORD(J)).. DELY(I,J) =G= Y(I) - Y(J);
DIST4(I,J)$(ORD(I) LT ORD(J)).. DELY(I,J) =G= Y(J) - Y(I);

*Disjunctions - Overlap
DISJ1(I,J)$(ORD(I) LT ORD(J)).. X(I) + L(I)/2  =L= X(J) - L(J)/2 + M1('1',I,J)*(1-Z('1',I,J));
DISJ2(I,J)$(ORD(I) LT ORD(J)).. X(J) + L(J)/2  =L= X(I) - L(I)/2 + M1('2',I,J)*(1-Z('2',I,J));
DISJ3(I,J)$(ORD(I) LT ORD(J)).. Y(I) + H(I)/2  =L= Y(J) - H(J)/2 + M1('3',I,J)*(1-Z('3',I,J));
DISJ4(I,J)$(ORD(I) LT ORD(J)).. Y(J) + H(J)/2  =L= Y(I) - H(I)/2 + M1('4',I,J)*(1-Z('4',I,J));

*Summation of binary variables
BIN1(I,J)$(ORD(I) LT ORD(J)).. SUM(D1,Z(D1,I,J)) =E= 1;

*Safety constraints
SAF1(AREA,I).. SQR(X(I) - L(I)/2 - XBAR(AREA)) + SQR(Y(I) + H(I)/2 - YBAR(AREA)) =L= SQR(R(AREA)) + M2('1',AREA,I)*(1-W(AREA,I));
SAF2(AREA,I).. SQR(X(I) - L(I)/2 - XBAR(AREA)) + SQR(Y(I) - H(I)/2 - YBAR(AREA)) =L= SQR(R(AREA)) + M2('2',AREA,I)*(1-W(AREA,I));
SAF3(AREA,I).. SQR(X(I) + L(I)/2 - XBAR(AREA)) + SQR(Y(I) + H(I)/2 - YBAR(AREA)) =L= SQR(R(AREA)) + M2('3',AREA,I)*(1-W(AREA,I));
SAF4(AREA,I).. SQR(X(I) + L(I)/2 - XBAR(AREA)) + SQR(Y(I) - H(I)/2 - YBAR(AREA)) =L= SQR(R(AREA)) + M2('4',AREA,I)*(1-W(AREA,I));

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


SOLVE LAYOUT_CH USING %RTYPE% MINIMIZING OBJ;

results('obj','relax') = LAYOUT_CH.objval;
results('time','relax') = LAYOUT_CH.resusd;

*LAYOUT_CH.OPTFILE = 1;
*LAYOUT_CH.NODLIM = 1000000;


SOLVE LAYOUT_CH USING %TYPE% MINIMIZING OBJ;

