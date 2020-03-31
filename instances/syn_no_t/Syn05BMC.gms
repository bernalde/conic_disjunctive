*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= Z*exp(x/Z) <=> x <= z*log(y/z) ; x >= (x1 - M(1-z))/c ; y = 1 + x2; Z = 1
*Synthesis Problem with 5 processes
*One Period (t=1)
*Big-M Version

$TITLE     Synthesis Problem
$OFFSYMXREF
$OFFSYMLIST
$ONINLINE

*See process flowsheet for stream labeling

************************************************************************************************************************
*************************************************** DECLARATIONS *******************************************************
************************************************************************************************************************


******************************************************* SETS ***********************************************************

SETS

I       /1*5/                            /* Number of process units */
K       /1*15/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */
E       /1*4/                             /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */

;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

X(K)
Z(I)
R(I)
COST(I)
;

POSITIVE VARIABLES

X(K)
V(K,D,I)
;

BINARY VARIABLES

Z(I)
R(I)
;

****************************************************** DATA ENTRY *****************************************************

PARAMETERS
PC(K)              /* Cost coefficient in objective (Cost and revenue of raw material and products, respectively) */
        /       1       0
                2       0
                3       0
                4       0
                5       0
                6       0
                7       5
                8       0
                9       0
                10      0
                11      0
                12      -2
                13      200
                14      250
                15      300/

FC(I)             /* Fixed costs in objective */
        /       1       -5
                2       -8
                3       -6
                4       -10
                5       -6/
;

PARAMETERS BIGM(E,D,I) /1*4 .1*2 .1*5 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

SCALARS
X1_UP /0/
X12_UP /0/;

X1_UP = 10;
X12_UP = 7;

BIGM('1','1','1') = 1;
BIGM('1','2','1') = X1_UP;
BIGM('2','2','1') = LOG(1+X1_UP);

BIGM('1','1','2') = 1;
BIGM('1','2','2') = X1_UP;
BIGM('2','2','2') = 1.2*LOG(1+X1_UP);

BIGM('1','1','3') = 1;
BIGM('2','1','3') = 1;
BIGM('1','2','3') = 1.2*LOG(1+X1_UP);
BIGM('2','2','3') = 0.75*1.2*LOG(1+X1_UP);

BIGM('1','1','4') = 1;
BIGM('1','2','4') = 1.2*LOG(1+X1_UP);
BIGM('2','2','4') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));

BIGM('1','1','5') = 1;
BIGM('2','1','5') = 1;
BIGM('3','1','5') = 1;
BIGM('4','1','5') = 1;
BIGM('1','2','5') = 1.2*LOG(1+X1_UP);
BIGM('2','2','5') = X12_UP;
BIGM('3','2','5') = MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1,MB2,MB3,MB4

DISJ_1_1_1
DISJ_1_2_1
DISJ_2_2_1

DISJ_1_1_2
DISJ_1_2_2
DISJ_2_2_2

DISJ_1_1_3
DISJ_2_1_3
DISJ_1_2_3
DISJ_2_2_3

DISJ_1_1_4
DISJ_1_2_4
DISJ_2_2_4

DISJ_1_1_5
DISJ_2_1_5
DISJ_3_1_5
DISJ_4_1_5
DISJ_1_2_5
DISJ_2_2_5
DISJ_3_2_5

D1,
L1,L2,L3
;

************************************************************************************************************************
*************************************************** OPTIMIZATION PROBLEM ***********************************************
************************************************************************************************************************

*Note: We multiply, where appropriate, the coefficents in the objective function by 1E3 in order to obtain our obj fn value in $.

Objective.. obj =E= SUM(I,FC(I)*Z(I)) + SUM(K,PC(K)*X(K));

*Mass Balances
MB1..    X('1')     -    X('2')  -    X('3')              =E= 0;
MB2..    X('6')     -    X('4')  -    X('5')              =E= 0;
MB3..    X('6')     -    X('7')  -    X('8')              =E= 0;
MB4..    X('8')     -    X('9')  -    X('10') -   X('11') =E= 0;

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
*DISJ_1_1_1.. X('4') =L= LOG(1+X('2')) + BIGM('1','1','1')*(1-Z('1'));
variables X_DISJ_1_1_1, Y_DISJ_1_1_1, Z_DISJ_1_1_1;
Y_DISJ_1_1_1.lo = 1;
Z_DISJ_1_1_1.up = 1;
Z_DISJ_1_1_1.lo = 1;
equation d_DISJ_1_1_1;
equation c_DISJ_1_1_1;
DISJ_1_1_1.. Y_DISJ_1_1_1 =G= Z_DISJ_1_1_1*exp(X_DISJ_1_1_1/Z_DISJ_1_1_1);
c_DISJ_1_1_1.. X_DISJ_1_1_1 =E= (X('4') - BIGM('1','1','1')*(1-Z('1')))/(1*1);
d_DISJ_1_1_1.. Y_DISJ_1_1_1 =E= 1+X('2');
DISJ_1_2_1.. X('2') =L= BIGM('1','2','1')*Z('1');
X.up('2') = BIGM('1','2','1');
DISJ_2_2_1.. X('4') =L= BIGM('2','2','1')*Z('1');
X.up('4') = BIGM('2','2','1');

*DISJ_1_1_2.. X('5') =L= 1.2*LOG(1+X('3')) + BIGM('1','1','2')*(1-Z('2')) ;
variables X_DISJ_1_1_2, Y_DISJ_1_1_2, Z_DISJ_1_1_2;
Y_DISJ_1_1_2.lo = 1;
Z_DISJ_1_1_2.up = 1;
Z_DISJ_1_1_2.lo = 1;
equation d_DISJ_1_1_2;
equation c_DISJ_1_1_2;
DISJ_1_1_2.. Y_DISJ_1_1_2 =G= Z_DISJ_1_1_2*exp(X_DISJ_1_1_2/Z_DISJ_1_1_2);
c_DISJ_1_1_2.. X_DISJ_1_1_2 =E= (X('5') - BIGM('1','1','2')*(1-Z('2')) )/(1.2*1);
d_DISJ_1_1_2.. Y_DISJ_1_1_2 =E= 1+X('3');
DISJ_1_2_2.. X('3') =L= BIGM('1','2','2')*Z('2');
X.up('3') = BIGM('1','2','2');
DISJ_2_2_2.. X('5') =L= BIGM('2','2','2')*Z('2');
X.up('5') = BIGM('2','2','2');

DISJ_1_1_3.. X('13') =L= 0.75*X('9') + BIGM('1','1','3')*(1-Z('3'));
DISJ_2_1_3.. X('13') =G= 0.75*X('9') - BIGM('2','1','3')*(1-Z('3'));
DISJ_1_2_3.. X('9') =L= BIGM('1','2','3')*Z('3');
X.up('9') = BIGM('1','2','3');
DISJ_2_2_3.. X('13') =L= BIGM('2','2','3')*Z('3');
X.up('13') = BIGM('2','2','3');

*DISJ_1_1_4.. X('14') =L= 1.5*LOG(1+X('10')) + BIGM('1','1','4')*(1-Z('4')) ;
variables X_DISJ_1_1_4, Y_DISJ_1_1_4, Z_DISJ_1_1_4;
Y_DISJ_1_1_4.lo = 1;
Z_DISJ_1_1_4.up = 1;
Z_DISJ_1_1_4.lo = 1;
equation d_DISJ_1_1_4;
equation c_DISJ_1_1_4;
DISJ_1_1_4.. Y_DISJ_1_1_4 =G= Z_DISJ_1_1_4*exp(X_DISJ_1_1_4/Z_DISJ_1_1_4);
c_DISJ_1_1_4.. X_DISJ_1_1_4 =E= (X('14') - BIGM('1','1','4')*(1-Z('4')) )/(1.5*1);
d_DISJ_1_1_4.. Y_DISJ_1_1_4 =E= 1+X('10');
DISJ_1_2_4.. X('10') =L= BIGM('1','2','4')*Z('4');
X.up('10') = BIGM('1','2','4');
DISJ_2_2_4.. X('14') =L= BIGM('2','2','4')*Z('4');
X.up('14') = BIGM('2','2','4');

DISJ_1_1_5.. X('15') =L= X('11') + BIGM('1','1','5')*(1-Z('5'));
DISJ_2_1_5.. X('15') =G= X('11') - BIGM('2','1','5')*(1-Z('5'));
DISJ_3_1_5.. X('15') =L= 0.5*X('12') + BIGM('3','1','5')*(1-Z('5'));
DISJ_4_1_5.. X('15') =G= 0.5*X('12') - BIGM('4','1','5')*(1-Z('5'));
DISJ_1_2_5.. X('11') =L= BIGM('1','2','5')*Z('5');
X.up('11') = BIGM('1','2','5');
DISJ_2_2_5.. X('12') =L= BIGM('2','2','5')*Z('5');
X.up('12') = BIGM('2','2','5');
DISJ_3_2_5.. X('15') =L= BIGM('3','2','5')*Z('5');
X.up('15') = BIGM('3','2','5');

*Design Specifications
D1..  Z('1') + Z('2')                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1..  -Z('3') + Z('1') + Z('2')                    =G= 0;
L2..  -Z('4') + Z('1') + Z('2')                    =G= 0;
L3..  -Z('5') + Z('1') + Z('2')                    =G= 0;

* Bounds
X.UP('1') = 10;
X.UP('12') = 7;

MODEL SYNTH_5_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_5_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;