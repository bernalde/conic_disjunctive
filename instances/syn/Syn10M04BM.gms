*Synthesis Problem with 10 processes
*Four Periods (t=4)
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

T            /1*4/                        /*Time periods*/

I       /1*10/                            /* Number of process units */
K       /1*25/                            /* Number of streams */
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
                        1       2       3        4
                1       -1      -1      -1       -1
                2       0       0       0        0
                3       0       0       0        0
                4       0       0       0        0
                5       0       0       0        0
                6       0       0       0        0
                7       5       10      5        10
                8       0       0       0        0
                9       0       0       0        0
                10      0       0       0        0
                11      0       0       0        0
                12      -2      -1      -2       -1
                13      0       0       0        0
                14      0       0       0        0
                15      0       0       0        0
                16      0       0       0        0
                17      0       0       0        0
                18      0       0       0        0
                19      0       0       0        0
                20      80      90      120      100
                21      285     390     350      300
                22      290     405     190      340
                23      280     400     430      260
                24      290     300     240      310
                25      350     250     300      400

TABLE FC(I,T)             /* Fixed costs in objective */
                         1       2       3        4
                1       -5       -4      -6       -3
                2       -8       -7      -6       -5
                3       -6       -9      -4       -3
                4       -10      -9      -5       -6
                5       -6       -10     -6       -9
                6       -7       -7      -4       -2
                7       -4       -3      -2       -8
                8       -5       -6      -7       -4
                9       -2       -5      -2       -6
                10      -4       -7      -4       -7
;

PARAMETERS BIGM(E,D,I,T) /1*4 .1*2 .1*10 .1*4 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

PARAMETERS
X1_UP(T)
/1 = 40
 2 = 40
 3 = 40
 4 = 40/

X12_UP(T)
/1 = 30
 2 = 30
 3 = 30
 4 = 30/
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

BIGM('1','1','6',T) = 1;
BIGM('1','2','6',T) = 0.75*1.2*LOG(1+X1_UP(T));
BIGM('2','2','6',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));

BIGM('1','1','7',T) = 1;
BIGM('1','2','7',T) = 0.75*1.2*LOG(1+X1_UP(T));
BIGM('2','2','7',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));

BIGM('1','1','8',T) = 1;
BIGM('1','2','8',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));
BIGM('2','2','8',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));

BIGM('1','1','9',T) = 1;
BIGM('2','1','9',T) = 1;
BIGM('1','2','9',T) = MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('2','2','9',T) = 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

BIGM('1','1','10',T) = 1;
BIGM('2','1','10',T) = 1;
BIGM('1','2','10',T) = MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('2','2','10',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

TABLE BIGM2_1(I,T)
                        1       2      3       4
                1       5       4      6       3
                2       8       7      6       5
                3       6       9      4       3
                4       10      9      5       6
                5       6       10     6       9
                6       7       7      4       2
                7       4       3      2       8
                8       5       6      7       4
                9       2       5      2       6
                10      4       7      4       7
;

TABLE BIGM2_2(I,T)
                         1       2       3        4
                1       -5       -4      -6       -3
                2       -8       -7      -6       -5
                3       -6       -9      -4       -3
                4       -10      -9      -5       -6
                5       -6       -10     -6       -9
                6       -7       -7      -4       -2
                7       -4       -3      -2       -8
                8       -5       -6      -7       -4
                9       -2       -5      -2       -6
                10      -4       -7      -4       -7
;


****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1(T),MB2(T),MB3(T),MB4(T),MB5(T),MB6(T)

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

DISJ_1_1_6(T)
DISJ_1_2_6(T)
DISJ_2_2_6(T)

DISJ_1_1_7(T)
DISJ_1_2_7(T)
DISJ_2_2_7(T)

DISJ_1_1_8(T)
DISJ_1_2_8(T)
DISJ_2_2_8(T)

DISJ_1_1_9(T)
DISJ_2_1_9(T)
DISJ_1_2_9(T)
DISJ_2_2_9(T)

DISJ_1_1_10(T)
DISJ_2_1_10(T)
DISJ_1_2_10(T)
DISJ_2_2_10(T)

DISJ2_1_Synthesis(I,T)
DISJ2_2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T),L4(T),L5(T),L6(T),L7(T),L8(T),L9(T),L10(T)
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
MB5(T)..    X('13',T)    -    X('16',T) -    X('17',T)                   =E= 0;
MB6(T)..    X('15',T)    -    X('18',T) -    X('19',T) -   X('20',T)     =E= 0;

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
DISJ_1_1_1(T).. X('4',T) =L= LOG(1+X('2',T)) + BIGM('1','1','1',T)*(1-Z('1',T));
DISJ_1_2_1(T).. X('2',T) =L= BIGM('1','2','1',T)*Z('1',T);
X.up('2',T) = BIGM('1','2','1',T);
DISJ_2_2_1(T).. X('4',T) =L= BIGM('2','2','1',T)*Z('1',T);
X.up('4',T) = BIGM('2','2','1',T);

DISJ_1_1_2(T).. X('5',T) =L= 1.2*LOG(1+X('3',T)) + BIGM('1','1','2',T)*(1-Z('2',T)) ;
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

DISJ_1_1_4(T).. X('14',T) =L= 1.5*LOG(1+X('10',T)) + BIGM('1','1','4',T)*(1-Z('4',T)) ;
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

DISJ_1_1_6(T).. X('21',T) =L= 1.25*LOG(1+X('16',T)) + BIGM('1','1','6',T)*(1-Z('6',T)) ;
DISJ_1_2_6(T).. X('16',T) =L= BIGM('1','2','6',T)*Z('6',T);
X.up('16',T) = BIGM('1','2','6',T);
DISJ_2_2_6(T).. X('21',T) =L= BIGM('2','2','6',T)*Z('6',T);
X.up('21',T) = BIGM('2','2','6',T);

DISJ_1_1_7(T).. X('22',T) =L= 0.9*LOG(1+X('17',T)) + BIGM('1','1','7',T)*(1-Z('7',T)) ;
DISJ_1_2_7(T).. X('17',T) =L= BIGM('1','2','7',T)*Z('7',T);
X.up('17',T) = BIGM('1','2','7',T);
DISJ_2_2_7(T).. X('22',T) =L= BIGM('2','2','7',T)*Z('7',T);
X.up('22',T) = BIGM('2','2','7',T);

DISJ_1_1_8(T).. X('23',T) =L= LOG(1+X('14',T)) + BIGM('1','1','8',T)*(1-Z('8',T)) ;
DISJ_1_2_8(T).. X('14',T) =L= BIGM('1','2','8',T)*Z('8',T);
X.up('14',T) = BIGM('1','2','8',T);
DISJ_2_2_8(T).. X('23',T) =L= BIGM('2','2','8',T)*Z('8',T);
X.up('23',T) = BIGM('2','2','8',T);

DISJ_1_1_9(T).. X('24',T) =L= 0.9*X('18',T) + BIGM('1','1','9',T)*(1-Z('9',T));
DISJ_2_1_9(T).. X('24',T) =G= 0.9*X('18',T) - BIGM('2','1','9',T)*(1-Z('9',T));
DISJ_1_2_9(T).. X('18',T) =L= BIGM('1','2','9',T)*Z('9',T);
X.up('18',T) = BIGM('1','2','9',T);
DISJ_2_2_9(T).. X('24',T) =L= BIGM('2','2','9',T)*Z('9',T);
X.up('24',T) = BIGM('2','2','9',T);

DISJ_1_1_10(T).. X('25',T) =L= 0.6*X('19',T) + BIGM('1','1','10',T)*(1-Z('10',T));
DISJ_2_1_10(T).. X('25',T) =G= 0.6*X('19',T) - BIGM('2','1','10',T)*(1-Z('10',T));
DISJ_1_2_10(T).. X('19',T) =L= BIGM('1','2','10',T)*Z('10',T);
X.up('19',T) = BIGM('1','2','10',T);
DISJ_2_2_10(T).. X('25',T) =L= BIGM('2','2','10',T)*Z('10',T);
X.up('25',T) = BIGM('2','2','10',T);

*Constraints in disjunct 2
DISJ2_1_Synthesis(I,T).. COST(I,T) =L= FC(I,T) + BIGM2_1(I,T)*(1-R(I,T));
DISJ2_2_Synthesis(I,T).. COST(I,T) =G= FC(I,T) - BIGM2_2(I,T)*(1-R(I,T));
*****************

Logic_Z(I,T,TAU)$(ORD(T) LT ORD(TAU))..                   Z(I,T) =L= Z(I,TAU);
Logic_R(I,T,TAU)$(ORD(TAU) NE ORD(T))..                   R(I,T) + R(I,TAU) =L= 1;
Logic_ZR(I,T)..                                           Z(I,T) =L= R(I,T) + Z(I,T-1) + Z(I,T-2) + Z(I,T-3);

*Design Specifications
D1(T)..  Z('1',T) + Z('2',T)                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1(T)..  -Z('3',T) + Z('6',T) + Z('7',T)                  =G= 0;
L2(T)..  -Z('4',T) + Z('8',T)                             =G= 0;
L3(T)..  -Z('3',T) + Z('1',T) + Z('2',T)                  =G= 0;
L4(T)..  -Z('4',T) + Z('1',T) + Z('2',T)                  =G= 0;
L5(T)..  -Z('5',T) + Z('1',T) + Z('2',T)                  =G= 0;
L6(T)..  -Z('6',T) + Z('3',T)                             =G= 0;
L7(T)..  -Z('7',T) + Z('3',T)                             =G= 0;
L8(T)..  -Z('8',T) + Z('4',T)                             =G= 0;
L9(T)..  -Z('9',T) + Z('5',T)                             =G= 0;
L10(T).. -Z('10',T) + Z('5',T)                            =G= 0;

* Bounds
X.UP('1',T) = 40;
X.UP('12',T) = 30;

MODEL SYNTH_10_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_10_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
