*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= Z*exp(x/Z) <=> x <= z*log(y/z) ; x >= (x1 - M(1-z))/c ; y = 1 + x2; Z = 1
*Synthesis Problem with 5 processes
*Two Periods (t=2)
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

T            /1*2/                        /*Time periods*/

I       /1*5/                            /* Number of process units */
K       /1*15/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */
E       /1*4/                             /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */

;

ALIAS

(T,TAU)
;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

X(K,T)
Z(I,T)
R(I,T)
COST(I,T)
;

POSITIVE VARIABLES

X(K,T)
V(K,D,I,T)
;

BINARY VARIABLES

Z(I,T)
R(I,T)
;

****************************************************** DATA ENTRY *****************************************************

TABLE PC(K,T)              /* Cost coefficient in objective (Cost and revenue of raw material and products, respectively) */
                        1       2
                1       -1      -1
                2       0       0
                3       0       0
                4       0       0
                5       0       0
                6       0       0
                7       5       10
                8       0       0
                9       0       0
                10      0       0
                11      0       0
                12      -2      -1
                13      80      90
                14      285     390
                15      290     405

TABLE FC(I,T)             /* Fixed costs in objective */
                         1       2
                1       -5       -4
                2       -8       -7
                3       -6       -9
                4       -10      -9
                5       -6       -10
;

PARAMETERS BIGM(E,D,I,T) /1*4 .1*2 .1*5 .1*2 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

PARAMETERS
X1_UP(T)
/1 = 40
 2 = 40/

X12_UP(T)
/1 = 30
 2 = 30/
;

BIGM('1','1','1',T) = 1;
BIGM('1','2','1',T) = X1_UP(T);
BIGM('2','2','1',T) = LOG(1+X1_UP(T));

BIGM('1','1','2',T) = 1;
BIGM('1','2','2',T) = X1_UP(T);
BIGM('2','2','2',T) = 1.2*LOG(1+X1_UP(T));

BIGM('1','1','3',T) = 1;
BIGM('2','1','3',T) = 1;
BIGM('1','2','3',T) = 1.2*LOG(1+X1_UP(T));
BIGM('2','2','3',T) = 0.75*1.2*LOG(1+X1_UP(T));

BIGM('1','1','4',T) = 1;
BIGM('1','2','4',T) = 1.2*LOG(1+X1_UP(T));
BIGM('2','2','4',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));

BIGM('1','1','5',T) = 1;
BIGM('2','1','5',T) = 1;
BIGM('3','1','5',T) = 1;
BIGM('4','1','5',T) = 1;
BIGM('1','2','5',T) = 1.2*LOG(1+X1_UP(T));
BIGM('2','2','5',T) = X12_UP(T);
BIGM('3','2','5',T) = MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

TABLE BIGM2_1(I,T)
                        1       2
                1       5       4
                2       8       7
                3       6       9
                4       10      9
                5       6       10
;

TABLE BIGM2_2(I,T)
                         1       2
                1       -5       -4
                2       -8       -7
                3       -6       -9
                4       -10      -9
                5       -6       -10
;


****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1(T),MB2(T),MB3(T),MB4(T)

DISJ_1_1_1(T)
DISJ_1_2_1(T)
DISJ_2_2_1(T)

DISJ_1_1_2(T)
DISJ_1_2_2(T)
DISJ_2_2_2(T)

DISJ_1_1_3(T)
DISJ_2_1_3(T)
DISJ_1_2_3(T)
DISJ_2_2_3(T)

DISJ_1_1_4(T)
DISJ_1_2_4(T)
DISJ_2_2_4(T)

DISJ_1_1_5(T)
DISJ_2_1_5(T)
DISJ_3_1_5(T)
DISJ_4_1_5(T)
DISJ_1_2_5(T)
DISJ_2_2_5(T)
DISJ_3_2_5(T)

DISJ2_1_Synthesis(I,T)
DISJ2_2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T)
;

************************************************************************************************************************
*************************************************** OPTIMIZATION PROBLEM ***********************************************
************************************************************************************************************************

*Note: We multiply, where appropriate, the coefficents in the objective function by 1E3 in order to obtain our obj fn value in $.

Objective.. obj =E= SUM(T,SUM(I,FC(I,T)*R(I,T))) + SUM(T,SUM(K,PC(K,T)*X(K,T)));

*Mass Balances
MB1(T)..    X('1',T)     -    X('2',T)  -    X('3',T)                    =E= 0;
MB2(T)..    X('6',T)     -    X('4',T)  -    X('5',T)                    =E= 0;
MB3(T)..    X('6',T)     -    X('7',T)  -    X('8',T)                    =E= 0;
MB4(T)..    X('8',T)     -    X('9',T)  -    X('10',T) -   X('11',T)     =E= 0;

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
*DISJ_1_1_1(T).. X('4',T) =L= LOG(1+X('2',T)) + BIGM('1','1','1',T)*(1-Z('1',T));
variables X_DISJ_1_1_1(T), Y_DISJ_1_1_1(T), Z_DISJ_1_1_1(T);
Y_DISJ_1_1_1.lo(T) = 1;
Z_DISJ_1_1_1.up(T) = 1;
Z_DISJ_1_1_1.lo(T) = 1;
equation d_DISJ_1_1_1(T);
equation c_DISJ_1_1_1(T);
DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =G= Z_DISJ_1_1_1(T)*exp(X_DISJ_1_1_1(T)/Z_DISJ_1_1_1(T));
c_DISJ_1_1_1(T).. X_DISJ_1_1_1(T) =E= (X('4',T) - BIGM('1','1','1',T)*(1-Z('1',T)))/(1*1);
d_DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =E= 1+X('2',T);
DISJ_1_2_1(T).. X('2',T) =L= BIGM('1','2','1',T)*Z('1',T);
X.up('2',T) = BIGM('1','2','1',T);
DISJ_2_2_1(T).. X('4',T) =L= BIGM('2','2','1',T)*Z('1',T);
X.up('4',T) = BIGM('2','2','1',T);

*DISJ_1_1_2(T).. X('5',T) =L= 1.2*LOG(1+X('3',T)) + BIGM('1','1','2',T)*(1-Z('2',T)) ;
variables X_DISJ_1_1_2(T), Y_DISJ_1_1_2(T), Z_DISJ_1_1_2(T);
Y_DISJ_1_1_2.lo(T) = 1;
Z_DISJ_1_1_2.up(T) = 1;
Z_DISJ_1_1_2.lo(T) = 1;
equation d_DISJ_1_1_2(T);
equation c_DISJ_1_1_2(T);
DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =G= Z_DISJ_1_1_2(T)*exp(X_DISJ_1_1_2(T)/Z_DISJ_1_1_2(T));
c_DISJ_1_1_2(T).. X_DISJ_1_1_2(T) =E= (X('5',T) - BIGM('1','1','2',T)*(1-Z('2',T)) )/(1.2*1);
d_DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =E= 1+X('3',T);
DISJ_1_2_2(T).. X('3',T) =L= BIGM('1','2','2',T)*Z('2',T);
X.up('3',T) = BIGM('1','2','2',T);
DISJ_2_2_2(T).. X('5',T) =L= BIGM('2','2','2',T)*Z('2',T);
X.up('5',T) = BIGM('2','2','2',T);

DISJ_1_1_3(T).. X('13',T) =L= 0.75*X('9',T) + BIGM('1','1','3',T)*(1-Z('3',T));
DISJ_2_1_3(T).. X('13',T) =G= 0.75*X('9',T) - BIGM('2','1','3',T)*(1-Z('3',T));
DISJ_1_2_3(T).. X('9',T) =L= BIGM('1','2','3',T)*Z('3',T);
X.up('9',T) = BIGM('1','2','3',T);
DISJ_2_2_3(T).. X('13',T) =L= BIGM('2','2','3',T)*Z('3',T);
X.up('13',T) = BIGM('2','2','3',T);

*DISJ_1_1_4(T).. X('14',T) =L= 1.5*LOG(1+X('10',T)) + BIGM('1','1','4',T)*(1-Z('4',T)) ;
variables X_DISJ_1_1_4(T), Y_DISJ_1_1_4(T), Z_DISJ_1_1_4(T);
Y_DISJ_1_1_4.lo(T) = 1;
Z_DISJ_1_1_4.up(T) = 1;
Z_DISJ_1_1_4.lo(T) = 1;
equation d_DISJ_1_1_4(T);
equation c_DISJ_1_1_4(T);
DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =G= Z_DISJ_1_1_4(T)*exp(X_DISJ_1_1_4(T)/Z_DISJ_1_1_4(T));
c_DISJ_1_1_4(T).. X_DISJ_1_1_4(T) =E= (X('14',T) - BIGM('1','1','4',T)*(1-Z('4',T)) )/(1.5*1);
d_DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =E= 1+X('10',T);
DISJ_1_2_4(T).. X('10',T) =L= BIGM('1','2','4',T)*Z('4',T);
X.up('10',T) = BIGM('1','2','4',T);
DISJ_2_2_4(T).. X('14',T) =L= BIGM('2','2','4',T)*Z('4',T);
X.up('14',T) = BIGM('2','2','4',T);

DISJ_1_1_5(T).. X('15',T) =L= X('11',T) + BIGM('1','1','5',T)*(1-Z('5',T));
DISJ_2_1_5(T).. X('15',T) =G= X('11',T) - BIGM('2','1','5',T)*(1-Z('5',T));
DISJ_3_1_5(T).. X('15',T) =L= 0.5*X('12',T) + BIGM('3','1','5',T)*(1-Z('5',T));
DISJ_4_1_5(T).. X('15',T) =G= 0.5*X('12',T) - BIGM('4','1','5',T)*(1-Z('5',T));
DISJ_1_2_5(T).. X('11',T) =L= BIGM('1','2','5',T)*Z('5',T);
X.up('11',T) = BIGM('1','2','5',T);
DISJ_2_2_5(T).. X('12',T) =L= BIGM('2','2','5',T)*Z('5',T);
X.up('12',T) = BIGM('2','2','5',T);
DISJ_3_2_5(T).. X('15',T) =L= BIGM('3','2','5',T)*Z('5',T);
X.up('15',T) = BIGM('3','2','5',T);

*Constraints in disjunct 2
DISJ2_1_Synthesis(I,T).. COST(I,T) =L= FC(I,T) + BIGM2_1(I,T)*(1-R(I,T));
DISJ2_2_Synthesis(I,T).. COST(I,T) =G= FC(I,T) - BIGM2_2(I,T)*(1-R(I,T));
*****************

Logic_Z(I,T,TAU)$(ORD(T) LT ORD(TAU))..                   Z(I,T) =L= Z(I,TAU);
Logic_R(I,T,TAU)$(ORD(TAU) NE ORD(T))..                   R(I,T) + R(I,TAU) =L= 1;
Logic_ZR(I,T)..                                           Z(I,T) =L= R(I,T) + Z(I,T-1);

*Design Specifications
D1(T)..  Z('1',T) + Z('2',T)                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1(T)..  -Z('3',T) + Z('1',T) + Z('2',T)                  =G= 0;
L2(T)..  -Z('4',T) + Z('1',T) + Z('2',T)                  =G= 0;
L3(T)..  -Z('5',T) + Z('1',T) + Z('2',T)                  =G= 0;

* Bounds
X.UP('1',T) = 40;
X.UP('12',T) = 30;

MODEL SYNTH_5_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_5_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
