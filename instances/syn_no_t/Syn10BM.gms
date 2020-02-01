*Synthesis Problem with 10 processes
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

I       /1*10/                            /* Number of process units */
K       /1*25/                            /* Number of streams */
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
                13      0
                14      0
                15      0
                16      0
                17      0
                18      0
                19      0
                20      200
                21      250
                22      200
                23      200
                24      500
                25      350/

FC(I)             /* Fixed costs in objective */
        /       1       -5
                2       -8
                3       -6
                4       -10
                5       -6
                6       -7
                7       -4
                8       -5
                9       -2
                10      -4/
;

PARAMETERS BIGM(E,D,I) /1*4 .1*2 .1*10 = 0/;

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

BIGM('1','1','6') = 1;
BIGM('1','2','6') = 0.75*1.2*LOG(1+X1_UP);
BIGM('2','2','6') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));

BIGM('1','1','7') = 1;
BIGM('1','2','7') = 0.75*1.2*LOG(1+X1_UP);
BIGM('2','2','7') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));

BIGM('1','1','8') = 1;
BIGM('1','2','8') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));
BIGM('2','2','8') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));

BIGM('1','1','9') = 1;
BIGM('2','1','9') = 1;
BIGM('1','2','9') = MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('2','2','9') = 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

BIGM('1','1','10') = 1;
BIGM('2','1','10') = 1;
BIGM('1','2','10') = MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('2','2','10') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1,MB2,MB3,MB4,MB5,MB6

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

DISJ_1_1_6
DISJ_1_2_6
DISJ_2_2_6

DISJ_1_1_7
DISJ_1_2_7
DISJ_2_2_7

DISJ_1_1_8
DISJ_1_2_8
DISJ_2_2_8

DISJ_1_1_9
DISJ_2_1_9
DISJ_1_2_9
DISJ_2_2_9

DISJ_1_1_10
DISJ_2_1_10
DISJ_1_2_10
DISJ_2_2_10

D1,
L1,L2,L3,L4,L5,L6,L7,L8,L9,L10
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
MB5..    X('13')    -    X('16') -    X('17')             =E= 0;
MB6..    X('15')    -    X('18') -    X('19') -   X('20') =E= 0;

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
DISJ_1_1_1.. X('4') =L= LOG(1+X('2')) + BIGM('1','1','1')*(1-Z('1'));
DISJ_1_2_1.. X('2') =L= BIGM('1','2','1')*Z('1');
X.up('2') = BIGM('1','2','1');
DISJ_2_2_1.. X('4') =L= BIGM('2','2','1')*Z('1');
X.up('4') = BIGM('2','2','1');

DISJ_1_1_2.. X('5') =L= 1.2*LOG(1+X('3')) + BIGM('1','1','2')*(1-Z('2')) ;
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

DISJ_1_1_4.. X('14') =L= 1.5*LOG(1+X('10')) + BIGM('1','1','4')*(1-Z('4')) ;
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

DISJ_1_1_6.. X('21') =L= 1.25*LOG(1+X('16')) + BIGM('1','1','6')*(1-Z('6')) ;
DISJ_1_2_6.. X('16') =L= BIGM('1','2','6')*Z('6');
X.up('16') = BIGM('1','2','6');
DISJ_2_2_6.. X('21') =L= BIGM('2','2','6')*Z('6');
X.up('21') = BIGM('2','2','6');

DISJ_1_1_7.. X('22') =L= 0.9*LOG(1+X('17')) + BIGM('1','1','7')*(1-Z('7')) ;
DISJ_1_2_7.. X('17') =L= BIGM('1','2','7')*Z('7');
X.up('17') = BIGM('1','2','7');
DISJ_2_2_7.. X('22') =L= BIGM('2','2','7')*Z('7');
X.up('22') = BIGM('2','2','7');

DISJ_1_1_8.. X('23') =L= LOG(1+X('14')) + BIGM('1','1','8')*(1-Z('8')) ;
DISJ_1_2_8.. X('14') =L= BIGM('1','2','8')*Z('8');
X.up('14') = BIGM('1','2','8');
DISJ_2_2_8.. X('23') =L= BIGM('2','2','8')*Z('8');
X.up('23') = BIGM('2','2','8');

DISJ_1_1_9.. X('24') =L= 0.9*X('18') + BIGM('1','1','9')*(1-Z('9'));
DISJ_2_1_9.. X('24') =G= 0.9*X('18') - BIGM('2','1','9')*(1-Z('9'));
DISJ_1_2_9.. X('18') =L= BIGM('1','2','9')*Z('9');
X.up('18') = BIGM('1','2','9');
DISJ_2_2_9.. X('24') =L= BIGM('2','2','9')*Z('9');
X.up('24') = BIGM('2','2','9');

DISJ_1_1_10.. X('25') =L= 0.6*X('19') + BIGM('1','1','10')*(1-Z('10'));
DISJ_2_1_10.. X('25') =G= 0.6*X('19') - BIGM('2','1','10')*(1-Z('10'));
DISJ_1_2_10.. X('19') =L= BIGM('1','2','10')*Z('10');
X.up('19') = BIGM('1','2','10');
DISJ_2_2_10.. X('25') =L= BIGM('2','2','10')*Z('10');
X.up('25') = BIGM('2','2','10');

*Design Specifications
D1..  Z('1') + Z('2')                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1..  -Z('3') + Z('6') + Z('7')                    =G= 0;
L2..  -Z('4') + Z('8')                             =G= 0;
L3..  -Z('3') + Z('1') + Z('2')                    =G= 0;
L4..  -Z('4') + Z('1') + Z('2')                    =G= 0;
L5..  -Z('5') + Z('1') + Z('2')                    =G= 0;
L6..  -Z('6') + Z('3')                             =G= 0;
L7..  -Z('7') + Z('3')                             =G= 0;
L8..  -Z('8') + Z('4')                             =G= 0;
L9..  -Z('9') + Z('5')                             =G= 0;
L10.. -Z('10') + Z('5')                            =G= 0;

* Bounds
X.UP('1') = 10;
X.UP('12') = 7;

MODEL RETRO_8_SYNTH_10_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE RETRO_8_SYNTH_10_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
