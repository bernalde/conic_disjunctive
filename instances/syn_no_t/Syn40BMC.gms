*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= Z*exp(x/Z) <=> x <= z*log(y/z) ; x >= (x1 - M(1-z))/c ; y = 1 + x2; Z = 1
*Synthesis Problem with 40 processes
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

I       /1*40/                            /* Number of process units */
K       /1*90/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */
E       /1*4/                             /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */
;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj
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
        /       1       -1
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
                20      0
                21      0
                22      0
                23      0
                24      0
                25      0
                26      0
                27      0
                28      0
                29      -10
                30      -5
                31      0
                32      0
                33      0
                34      0
                35      0
                36      0
                37      40
                38      15
                39      10
                40      30
                41      35
                42      20
                43      25
                44      15
                45      0
                46      0
                47      0
                48      0
                49      0
                50      0
                51      0
                52      30
                53      0
                54      0
                55      0
                56      0
                57      -1
                58      0
                59      0
                60      0
                61      0
                62      0
                63      0
                64      0
                65      0
                66      0
                67      0
                68      0
                69      0
                70      0
                71      0
                72      0
                73      0
                74      -5
                75      -1
                76      0
                77      0
                78      0
                79      0
                80      0
                81      0
                82      120
                83      140
                84      90
                85      80
                86      285
                87      290
                88      280
                89      290
                90      350/

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
                10      -4
                11      -3
                12      -7
                13      -3
                14      -2
                15      -4
                16      -2
                17      -3
                18      -5
                19      -2
                20      -1
                21      -2
                22      -9
                23      -5
                24      -2
                25      -10
                26      -4
                27      -7
                28      -4
                29      -2
                30      -8
                31      -9
                32      -3
                33      -5
                34      -5
                35      -6
                36      -2
                37      -6
                38      -3
                39      -5
                40      -9/
;

PARAMETERS BIGM(E,D,I) /1*4 .1*2 .1*40 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

SCALARS
X1_UP /0/
X12_UP /0/
X29_UP /0/
X30_UP /0/
X57_UP /0/
X74_UP /0/
X75_UP /0/;

X1_UP = 40;
X12_UP = 30;
X29_UP = 20;
X30_UP = 20;
X57_UP = 30;
X74_UP = 25;
X75_UP = 25;

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

BIGM('1','1','11') = 1;
BIGM('1','2','11') = MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('2','2','11') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));

BIGM('1','1','12') = 1;
BIGM('2','1','12') = 1;
BIGM('3','1','12') = 1;
BIGM('4','1','12') = 1;
BIGM('1','2','12') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
BIGM('2','2','12') = X29_UP;
BIGM('3','2','12') = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)))), X29_UP);

BIGM('1','1','13') = 1;
BIGM('1','2','13') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
BIGM('2','2','13') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)))));

BIGM('1','1','14') = 1;
BIGM('1','2','14') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
BIGM('2','2','14') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))));

BIGM('1','1','15') = 1;
BIGM('2','1','15') = 1;
BIGM('1','2','15') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
BIGM('2','2','15') = X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('3','2','15') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))), 0.65*LOG(1+ (X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

BIGM('1','1','16') = 1;
BIGM('2','1','16') = 1;
BIGM('1','2','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('2','2','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

BIGM('1','1','17') = 1;
BIGM('2','1','17') = 1;
BIGM('1','2','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
BIGM('2','2','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

BIGM('1','1','18') = 1;
BIGM('1','2','18') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
BIGM('2','2','18') = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

BIGM('1','1','19') = 1;
BIGM('1','2','19') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
BIGM('2','2','19') = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

BIGM('1','1','20') = 1;
BIGM('1','2','20') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
BIGM('2','2','20') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

BIGM('1','1','21') = 1;
BIGM('1','2','21') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
BIGM('2','2','21') = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

BIGM('1','1','22') = 1;
BIGM('1','2','22') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
BIGM('2','2','22') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

BIGM('1','1','23') = 1;
BIGM('2','1','23') = 1;
BIGM('1','2','23') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
BIGM('2','2','23') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

BIGM('1','1','24') = 1;
BIGM('1','2','24') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
BIGM('2','2','24') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

BIGM('1','1','25') = 1;
BIGM('2','1','25') = 1;
BIGM('3','1','25') = 1;
BIGM('4','1','25') = 1;
BIGM('1','2','25') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
BIGM('2','2','25') = X57_UP;
BIGM('3','2','25') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

BIGM('1','1','26') = 1;
BIGM('1','2','26') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
BIGM('2','2','26') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

BIGM('1','1','27') = 1;
BIGM('1','2','27') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
BIGM('2','2','27') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

BIGM('1','1','28') = 1;
BIGM('1','2','28') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
BIGM('2','2','28') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));

BIGM('1','1','29') = 1;
BIGM('2','1','29') = 1;
BIGM('1','2','29') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('2','2','29') = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

BIGM('1','1','30') = 1;
BIGM('2','1','30') = 1;
BIGM('1','2','30') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('2','2','30') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

BIGM('1','1','31') = 1;
BIGM('1','2','31') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('2','2','31') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));

BIGM('1','1','32') = 1;
BIGM('2','1','32') = 1;
BIGM('3','1','32') = 1;
BIGM('4','1','32') = 1;
BIGM('1','2','32') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
BIGM('2','2','32') = X74_UP;
BIGM('3','2','32') = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))))), X74_UP);

BIGM('1','1','33') = 1;
BIGM('1','2','33') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
BIGM('2','2','33') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));

BIGM('1','1','34') = 1;
BIGM('1','2','34') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
BIGM('2','2','34') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))));

BIGM('1','1','35') = 1;
BIGM('2','1','35') = 1;
BIGM('1','2','35') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
BIGM('2','2','35') = X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('3','2','35') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))), 0.65*LOG(1+X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

BIGM('1','1','36') = 1;
BIGM('2','1','36') = 1;
BIGM('1','2','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('2','2','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

BIGM('1','1','37') = 1;
BIGM('2','1','37') = 1;
BIGM('1','2','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
BIGM('2','2','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

BIGM('1','1','38') = 1;
BIGM('1','2','38') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
BIGM('2','2','38') = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

BIGM('1','1','39') = 1;
BIGM('1','2','39') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
BIGM('2','2','39') = 0.80*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

BIGM('1','1','40') = 1;
BIGM('1','2','40') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
BIGM('2','2','40') = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1,MB2,MB3,MB4,MB5,MB6,MB7,MB8,MB9,MB10,
MB11,MB12,MB13,MB14,MB15,MB16,MB17,MB18,MB19,MB20,MB21

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

DISJ_1_1_11
DISJ_1_2_11
DISJ_2_2_11

DISJ_1_1_12
DISJ_2_1_12
DISJ_3_1_12
DISJ_4_1_12
DISJ_1_2_12
DISJ_2_2_12
DISJ_3_2_12

DISJ_1_1_13
DISJ_1_2_13
DISJ_2_2_13

DISJ_1_1_14
DISJ_1_2_14
DISJ_2_2_14

DISJ_1_1_15
DISJ_2_1_15
DISJ_1_2_15
DISJ_2_2_15
DISJ_3_2_15

DISJ_1_1_16
DISJ_2_1_16
DISJ_1_2_16
DISJ_2_2_16

DISJ_1_1_17
DISJ_2_1_17
DISJ_1_2_17
DISJ_2_2_17

DISJ_1_1_18
DISJ_1_2_18
DISJ_2_2_18

DISJ_1_1_19
DISJ_1_2_19
DISJ_2_2_19

DISJ_1_1_20
DISJ_1_2_20
DISJ_2_2_20

DISJ_1_1_21
DISJ_1_2_21
DISJ_2_2_21

DISJ_1_1_22
DISJ_1_2_22
DISJ_2_2_22

DISJ_1_1_23
DISJ_2_1_23
DISJ_1_2_23
DISJ_2_2_23

DISJ_1_1_24
DISJ_1_2_24
DISJ_2_2_24

DISJ_1_1_25
DISJ_2_1_25
DISJ_3_1_25
DISJ_4_1_25
DISJ_1_2_25
DISJ_2_2_25
DISJ_3_2_25

DISJ_1_1_26
DISJ_1_2_26
DISJ_2_2_26

DISJ_1_1_27
DISJ_1_2_27
DISJ_2_2_27

DISJ_1_1_28
DISJ_1_2_28
DISJ_2_2_28

DISJ_1_1_29
DISJ_2_1_29
DISJ_1_2_29
DISJ_2_2_29

DISJ_1_1_30
DISJ_2_1_30
DISJ_1_2_30
DISJ_2_2_30

DISJ_1_1_31
DISJ_1_2_31
DISJ_2_2_31

DISJ_1_1_32
DISJ_2_1_32
DISJ_3_1_32
DISJ_4_1_32
DISJ_1_2_32
DISJ_2_2_32
DISJ_3_2_32

DISJ_1_1_33
DISJ_1_2_33
DISJ_2_2_33

DISJ_1_1_34
DISJ_1_2_34
DISJ_2_2_34

DISJ_1_1_35
DISJ_2_1_35
DISJ_1_2_35
DISJ_2_2_35
DISJ_3_2_35

DISJ_1_1_36
DISJ_2_1_36
DISJ_1_2_36
DISJ_2_2_36

DISJ_1_1_37
DISJ_2_1_37
DISJ_1_2_37
DISJ_2_2_37

DISJ_1_1_38
DISJ_1_2_38
DISJ_2_2_38

DISJ_1_1_39
DISJ_1_2_39
DISJ_2_2_39

DISJ_1_1_40
DISJ_1_2_40
DISJ_2_2_40

D1,
L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20
L21,L22,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54;
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
MB7..    X('23')    -    X('27') -    X('28')             =E= 0;
MB8..    X('31')    -    X('24') -    X('30')             =E= 0;
MB9..    X('25')    -    X('32') -    X('33')             =E= 0;
MB10..   X('26')    -    X('34') -    X('35') -   X('36') =E= 0;

*Connecting Stream between flowsheets
MB11..   X('45')    -    X('46')                          =E= 0;

MB12..    X('46')     -    X('47')  -    X('48')                =E= 0;
MB13..    X('51')     -    X('49')  -    X('50')                =E= 0;
MB14..    X('51')     -    X('52')  -    X('53')                =E= 0;
MB15..    X('53')     -    X('54')  -    X('55') -   X('56')    =E= 0;
MB16..    X('58')     -    X('61')  -    X('62')                =E= 0;
MB17..    X('60')     -    X('63')  -    X('64') -   X('65')    =E= 0;
MB18..    X('68')     -    X('72')  -    X('73')                =E= 0;
MB19..    X('76')     -    X('69')  -    X('75')                =E= 0;
MB20..    X('70')     -    X('77')  -    X('78')                =E= 0;
MB21..    X('71')     -    X('79')  -    X('80') -   X('81')    =E= 0;

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

*DISJ_1_1_6.. X('21') =L= 1.25*LOG(1+X('16')) + BIGM('1','1','6')*(1-Z('6')) ;
variables X_DISJ_1_1_6, Y_DISJ_1_1_6, Z_DISJ_1_1_6;
Y_DISJ_1_1_6.lo = 1;
Z_DISJ_1_1_6.up = 1;
Z_DISJ_1_1_6.lo = 1;
equation d_DISJ_1_1_6;
equation c_DISJ_1_1_6;
DISJ_1_1_6.. Y_DISJ_1_1_6 =G= Z_DISJ_1_1_6*exp(X_DISJ_1_1_6/Z_DISJ_1_1_6);
c_DISJ_1_1_6.. X_DISJ_1_1_6 =E= (X('21') - BIGM('1','1','6')*(1-Z('6')) )/(1.25*1);
d_DISJ_1_1_6.. Y_DISJ_1_1_6 =E= 1+X('16');
DISJ_1_2_6.. X('16') =L= BIGM('1','2','6')*Z('6');
X.up('16') = BIGM('1','2','6');
DISJ_2_2_6.. X('21') =L= BIGM('2','2','6')*Z('6');
X.up('21') = BIGM('2','2','6');

*DISJ_1_1_7.. X('22') =L= 0.9*LOG(1+X('17')) + BIGM('1','1','7')*(1-Z('7')) ;
variables X_DISJ_1_1_7, Y_DISJ_1_1_7, Z_DISJ_1_1_7;
Y_DISJ_1_1_7.lo = 1;
Z_DISJ_1_1_7.up = 1;
Z_DISJ_1_1_7.lo = 1;
equation d_DISJ_1_1_7;
equation c_DISJ_1_1_7;
DISJ_1_1_7.. Y_DISJ_1_1_7 =G= Z_DISJ_1_1_7*exp(X_DISJ_1_1_7/Z_DISJ_1_1_7);
c_DISJ_1_1_7.. X_DISJ_1_1_7 =E= (X('22') - BIGM('1','1','7')*(1-Z('7')) )/(0.9*1);
d_DISJ_1_1_7.. Y_DISJ_1_1_7 =E= 1+X('17');
DISJ_1_2_7.. X('17') =L= BIGM('1','2','7')*Z('7');
X.up('17') = BIGM('1','2','7');
DISJ_2_2_7.. X('22') =L= BIGM('2','2','7')*Z('7');
X.up('22') = BIGM('2','2','7');

*DISJ_1_1_8.. X('23') =L= LOG(1+X('14')) + BIGM('1','1','8')*(1-Z('8')) ;
variables X_DISJ_1_1_8, Y_DISJ_1_1_8, Z_DISJ_1_1_8;
Y_DISJ_1_1_8.lo = 1;
Z_DISJ_1_1_8.up = 1;
Z_DISJ_1_1_8.lo = 1;
equation d_DISJ_1_1_8;
equation c_DISJ_1_1_8;
DISJ_1_1_8.. Y_DISJ_1_1_8 =G= Z_DISJ_1_1_8*exp(X_DISJ_1_1_8/Z_DISJ_1_1_8);
c_DISJ_1_1_8.. X_DISJ_1_1_8 =E= (X('23') - BIGM('1','1','8')*(1-Z('8')) )/(1*1);
d_DISJ_1_1_8.. Y_DISJ_1_1_8 =E= 1+X('14');
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

*DISJ_1_1_11.. X('26') =L= 1.1*LOG(1+X('20')) + BIGM('1','1','11')*(1-Z('11')) ;
variables X_DISJ_1_1_11, Y_DISJ_1_1_11, Z_DISJ_1_1_11;
Y_DISJ_1_1_11.lo = 1;
Z_DISJ_1_1_11.up = 1;
Z_DISJ_1_1_11.lo = 1;
equation d_DISJ_1_1_11;
equation c_DISJ_1_1_11;
DISJ_1_1_11.. Y_DISJ_1_1_11 =G= Z_DISJ_1_1_11*exp(X_DISJ_1_1_11/Z_DISJ_1_1_11);
c_DISJ_1_1_11.. X_DISJ_1_1_11 =E= (X('26') - BIGM('1','1','11')*(1-Z('11')) )/(1.1*1);
d_DISJ_1_1_11.. Y_DISJ_1_1_11 =E= 1+X('20');
DISJ_1_2_11.. X('20') =L= BIGM('1','2','11')*Z('11');
X.up('20') = BIGM('1','2','11');
DISJ_2_2_11.. X('26') =L= BIGM('2','2','11')*Z('11');
X.up('26') = BIGM('2','2','11');

DISJ_1_1_12.. X('37') =L= 0.9*X('21') + BIGM('1','1','12')*(1-Z('12'));
DISJ_2_1_12.. X('37') =G= 0.9*X('21') - BIGM('2','1','12')*(1-Z('12'));
DISJ_3_1_12.. X('37') =L= X('29') + BIGM('3','1','12')*(1-Z('12'));
DISJ_4_1_12.. X('37') =G= X('29') - BIGM('4','1','12')*(1-Z('12'));
DISJ_1_2_12.. X('21') =L= BIGM('1','2','12')*Z('12');
X.up('21') = BIGM('1','2','12');
DISJ_2_2_12.. X('29') =L= BIGM('2','2','12')*Z('12');
X.up('29') = BIGM('2','2','12');
DISJ_3_2_12.. X('37') =L= BIGM('3','2','12')*Z('12');
X.up('37') = BIGM('3','2','12');

*DISJ_1_1_13.. X('38') =L= LOG(1+X('22')) + BIGM('1','1','13')*(1-Z('13')) ;
variables X_DISJ_1_1_13, Y_DISJ_1_1_13, Z_DISJ_1_1_13;
Y_DISJ_1_1_13.lo = 1;
Z_DISJ_1_1_13.up = 1;
Z_DISJ_1_1_13.lo = 1;
equation d_DISJ_1_1_13;
equation c_DISJ_1_1_13;
DISJ_1_1_13.. Y_DISJ_1_1_13 =G= Z_DISJ_1_1_13*exp(X_DISJ_1_1_13/Z_DISJ_1_1_13);
c_DISJ_1_1_13.. X_DISJ_1_1_13 =E= (X('38') - BIGM('1','1','13')*(1-Z('13')) )/(1*1);
d_DISJ_1_1_13.. Y_DISJ_1_1_13 =E= 1+X('22');
DISJ_1_2_13.. X('22') =L= BIGM('1','2','13')*Z('13');
X.up('22') = BIGM('1','2','13');
DISJ_2_2_13.. X('38') =L= BIGM('2','2','13')*Z('13');
X.up('38') = BIGM('2','2','13');

*DISJ_1_1_14.. X('39') =L= 0.7*LOG(1+X('27')) + BIGM('1','1','14')*(1-Z('14')) ;
variables X_DISJ_1_1_14, Y_DISJ_1_1_14, Z_DISJ_1_1_14;
Y_DISJ_1_1_14.lo = 1;
Z_DISJ_1_1_14.up = 1;
Z_DISJ_1_1_14.lo = 1;
equation d_DISJ_1_1_14;
equation c_DISJ_1_1_14;
DISJ_1_1_14.. Y_DISJ_1_1_14 =G= Z_DISJ_1_1_14*exp(X_DISJ_1_1_14/Z_DISJ_1_1_14);
c_DISJ_1_1_14.. X_DISJ_1_1_14 =E= (X('39') - BIGM('1','1','14')*(1-Z('14')) )/(0.7*1);
d_DISJ_1_1_14.. Y_DISJ_1_1_14 =E= 1+X('27');
DISJ_1_2_14.. X('27') =L= BIGM('1','2','14')*Z('14');
X.up('27') = BIGM('1','2','14');
DISJ_2_2_14.. X('39') =L= BIGM('2','2','14')*Z('14');
X.up('39') = BIGM('2','2','14');

*DISJ_1_1_15.. X('40') =L= 0.65*LOG(1+X('28')) + BIGM('1','1','15')*(1-Z('15')) ;
variables X_DISJ_1_1_15, Y_DISJ_1_1_15, Z_DISJ_1_1_15;
Y_DISJ_1_1_15.lo = 1;
Z_DISJ_1_1_15.up = 1;
Z_DISJ_1_1_15.lo = 1;
equation d_DISJ_1_1_15;
equation c_DISJ_1_1_15;
DISJ_1_1_15.. Y_DISJ_1_1_15 =G= Z_DISJ_1_1_15*exp(X_DISJ_1_1_15/Z_DISJ_1_1_15);
c_DISJ_1_1_15.. X_DISJ_1_1_15 =E= (X('40') - BIGM('1','1','15')*(1-Z('15')) )/(0.65*1);
d_DISJ_1_1_15.. Y_DISJ_1_1_15 =E= 1+X('28');
*DISJ_2_1_15.. X('40') =L= 0.65*LOG(1+X('31')) + BIGM('2','1','15')*(1-Z('15')) ;
variables X_DISJ_2_1_15, Y_DISJ_2_1_15, Z_DISJ_2_1_15;
Y_DISJ_2_1_15.lo = 1;
Z_DISJ_2_1_15.up = 1;
Z_DISJ_2_1_15.lo = 1;
equation d_DISJ_2_1_15;
equation c_DISJ_2_1_15;
DISJ_2_1_15.. Y_DISJ_2_1_15 =G= Z_DISJ_2_1_15*exp(X_DISJ_2_1_15/Z_DISJ_2_1_15);
c_DISJ_2_1_15.. X_DISJ_2_1_15 =E= (X('40') - BIGM('2','1','15')*(1-Z('15')) )/(0.65*1);
d_DISJ_2_1_15.. Y_DISJ_2_1_15 =E= 1+X('31');
DISJ_1_2_15.. X('28') =L= BIGM('1','2','15')*Z('15');
X.up('28') = BIGM('1','2','15');
DISJ_2_2_15.. X('31') =L= BIGM('2','2','15')*Z('15');
X.up('31') = BIGM('2','2','15');
DISJ_3_2_15.. X('40') =L= BIGM('3','2','15')*Z('15');
X.up('40') = BIGM('3','2','15');

DISJ_1_1_16.. X('41') =L= X('32') + BIGM('1','1','16')*(1-Z('16'));
DISJ_2_1_16.. X('41') =G= X('32') - BIGM('2','1','16')*(1-Z('16'));
DISJ_1_2_16.. X('32') =L= BIGM('1','2','16')*Z('16');
X.up('32') = BIGM('1','2','16');
DISJ_2_2_16.. X('41') =L= BIGM('2','2','16')*Z('16');
X.up('41') = BIGM('2','2','16');

DISJ_1_1_17.. X('42') =L= X('33') + BIGM('1','1','17')*(1-Z('17'));
DISJ_2_1_17.. X('42') =G= X('33') - BIGM('2','1','17')*(1-Z('17'));
DISJ_1_2_17.. X('33') =L= BIGM('1','2','17')*Z('17');
X.up('33') = BIGM('1','2','17');
DISJ_2_2_17.. X('42') =L= BIGM('2','2','17')*Z('17');
X.up('42') = BIGM('2','2','17');

*DISJ_1_1_18.. X('43') =L= 0.75*LOG(1+X('34')) + BIGM('1','1','18')*(1-Z('18')) ;
variables X_DISJ_1_1_18, Y_DISJ_1_1_18, Z_DISJ_1_1_18;
Y_DISJ_1_1_18.lo = 1;
Z_DISJ_1_1_18.up = 1;
Z_DISJ_1_1_18.lo = 1;
equation d_DISJ_1_1_18;
equation c_DISJ_1_1_18;
DISJ_1_1_18.. Y_DISJ_1_1_18 =G= Z_DISJ_1_1_18*exp(X_DISJ_1_1_18/Z_DISJ_1_1_18);
c_DISJ_1_1_18.. X_DISJ_1_1_18 =E= (X('43') - BIGM('1','1','18')*(1-Z('18')) )/(0.75*1);
d_DISJ_1_1_18.. Y_DISJ_1_1_18 =E= 1+X('34');
DISJ_1_2_18.. X('34') =L= BIGM('1','2','18')*Z('18');
X.up('34') = BIGM('1','2','18');
DISJ_2_2_18.. X('43') =L= BIGM('2','2','18')*Z('18');
X.up('43') = BIGM('2','2','18');

*DISJ_1_1_19.. X('44') =L= 0.8*LOG(1+X('35')) + BIGM('1','1','19')*(1-Z('19')) ;
variables X_DISJ_1_1_19, Y_DISJ_1_1_19, Z_DISJ_1_1_19;
Y_DISJ_1_1_19.lo = 1;
Z_DISJ_1_1_19.up = 1;
Z_DISJ_1_1_19.lo = 1;
equation d_DISJ_1_1_19;
equation c_DISJ_1_1_19;
DISJ_1_1_19.. Y_DISJ_1_1_19 =G= Z_DISJ_1_1_19*exp(X_DISJ_1_1_19/Z_DISJ_1_1_19);
c_DISJ_1_1_19.. X_DISJ_1_1_19 =E= (X('44') - BIGM('1','1','19')*(1-Z('19')) )/(0.8*1);
d_DISJ_1_1_19.. Y_DISJ_1_1_19 =E= 1+X('35');
DISJ_1_2_19.. X('35') =L= BIGM('1','2','19')*Z('19');
X.up('35') = BIGM('1','2','19');
DISJ_2_2_19.. X('44') =L= BIGM('2','2','19')*Z('19');
X.up('44') = BIGM('2','2','19');

*DISJ_1_1_20.. X('45') =L= 0.85*LOG(1+X('36')) + BIGM('1','1','20')*(1-Z('20')) ;
variables X_DISJ_1_1_20, Y_DISJ_1_1_20, Z_DISJ_1_1_20;
Y_DISJ_1_1_20.lo = 1;
Z_DISJ_1_1_20.up = 1;
Z_DISJ_1_1_20.lo = 1;
equation d_DISJ_1_1_20;
equation c_DISJ_1_1_20;
DISJ_1_1_20.. Y_DISJ_1_1_20 =G= Z_DISJ_1_1_20*exp(X_DISJ_1_1_20/Z_DISJ_1_1_20);
c_DISJ_1_1_20.. X_DISJ_1_1_20 =E= (X('45') - BIGM('1','1','20')*(1-Z('20')) )/(0.85*1);
d_DISJ_1_1_20.. Y_DISJ_1_1_20 =E= 1+X('36');
DISJ_1_2_20.. X('36') =L= BIGM('1','2','20')*Z('20');
X.up('36') = BIGM('1','2','20');
DISJ_2_2_20.. X('45') =L= BIGM('2','2','20')*Z('20');
X.up('45') = BIGM('2','2','20');

*DISJ_1_1_21.. X('49') =L= LOG(1+X('47')) + BIGM('1','1','21')*(1-Z('21'));
variables X_DISJ_1_1_21, Y_DISJ_1_1_21, Z_DISJ_1_1_21;
Y_DISJ_1_1_21.lo = 1;
Z_DISJ_1_1_21.up = 1;
Z_DISJ_1_1_21.lo = 1;
equation d_DISJ_1_1_21;
equation c_DISJ_1_1_21;
DISJ_1_1_21.. Y_DISJ_1_1_21 =G= Z_DISJ_1_1_21*exp(X_DISJ_1_1_21/Z_DISJ_1_1_21);
c_DISJ_1_1_21.. X_DISJ_1_1_21 =E= (X('49') - BIGM('1','1','21')*(1-Z('21')))/(1*1);
d_DISJ_1_1_21.. Y_DISJ_1_1_21 =E= 1+X('47');
DISJ_1_2_21.. X('47') =L= BIGM('1','2','21')*Z('21');
X.up('47') = BIGM('1','2','21');
DISJ_2_2_21.. X('49') =L= BIGM('2','2','21')*Z('21');
X.up('49') = BIGM('2','2','21');

*DISJ_1_1_22.. X('50') =L= 1.2*LOG(1+X('48')) + BIGM('1','1','22')*(1-Z('22')) ;
variables X_DISJ_1_1_22, Y_DISJ_1_1_22, Z_DISJ_1_1_22;
Y_DISJ_1_1_22.lo = 1;
Z_DISJ_1_1_22.up = 1;
Z_DISJ_1_1_22.lo = 1;
equation d_DISJ_1_1_22;
equation c_DISJ_1_1_22;
DISJ_1_1_22.. Y_DISJ_1_1_22 =G= Z_DISJ_1_1_22*exp(X_DISJ_1_1_22/Z_DISJ_1_1_22);
c_DISJ_1_1_22.. X_DISJ_1_1_22 =E= (X('50') - BIGM('1','1','22')*(1-Z('22')) )/(1.2*1);
d_DISJ_1_1_22.. Y_DISJ_1_1_22 =E= 1+X('48');
DISJ_1_2_22.. X('48') =L= BIGM('1','2','22')*Z('22');
X.up('48') = BIGM('1','2','22');
DISJ_2_2_22.. X('50') =L= BIGM('2','2','22')*Z('22');
X.up('50') = BIGM('2','2','22');

DISJ_1_1_23.. X('58') =L= 0.75*X('54') + BIGM('1','1','23')*(1-Z('23'));
DISJ_2_1_23.. X('58') =G= 0.75*X('54') - BIGM('2','1','23')*(1-Z('23'));
DISJ_1_2_23.. X('54') =L= BIGM('1','2','23')*Z('23');
X.up('54') = BIGM('1','2','23');
DISJ_2_2_23.. X('58') =L= BIGM('2','2','23')*Z('23');
X.up('58') = BIGM('2','2','23');

*DISJ_1_1_24.. X('59') =L= 1.5*LOG(1+X('55')) + BIGM('1','1','24')*(1-Z('24')) ;
variables X_DISJ_1_1_24, Y_DISJ_1_1_24, Z_DISJ_1_1_24;
Y_DISJ_1_1_24.lo = 1;
Z_DISJ_1_1_24.up = 1;
Z_DISJ_1_1_24.lo = 1;
equation d_DISJ_1_1_24;
equation c_DISJ_1_1_24;
DISJ_1_1_24.. Y_DISJ_1_1_24 =G= Z_DISJ_1_1_24*exp(X_DISJ_1_1_24/Z_DISJ_1_1_24);
c_DISJ_1_1_24.. X_DISJ_1_1_24 =E= (X('59') - BIGM('1','1','24')*(1-Z('24')) )/(1.5*1);
d_DISJ_1_1_24.. Y_DISJ_1_1_24 =E= 1+X('55');
DISJ_1_2_24.. X('55') =L= BIGM('1','2','24')*Z('24');
X.up('55') = BIGM('1','2','24');
DISJ_2_2_24.. X('59') =L= BIGM('2','2','24')*Z('24');
X.up('59') = BIGM('2','2','24');

DISJ_1_1_25.. X('60') =L= X('56') + BIGM('1','1','25')*(1-Z('25'));
DISJ_2_1_25.. X('60') =G= X('56') - BIGM('2','1','25')*(1-Z('25'));
DISJ_3_1_25.. X('60') =L= 0.5*X('57') + BIGM('3','1','25')*(1-Z('25'));
DISJ_4_1_25.. X('60') =G= 0.5*X('57') - BIGM('4','1','25')*(1-Z('25'));
DISJ_1_2_25.. X('56') =L= BIGM('1','2','25')*Z('25');
X.up('56') = BIGM('1','2','25');
DISJ_2_2_25.. X('57') =L= BIGM('2','2','25')*Z('25');
X.up('57') = BIGM('2','2','25');
DISJ_3_2_25.. X('60') =L= BIGM('3','2','25')*Z('25');
X.up('60') = BIGM('3','2','25');

*DISJ_1_1_26.. X('66') =L= 1.25*LOG(1+X('61')) + BIGM('1','1','26')*(1-Z('26')) ;
variables X_DISJ_1_1_26, Y_DISJ_1_1_26, Z_DISJ_1_1_26;
Y_DISJ_1_1_26.lo = 1;
Z_DISJ_1_1_26.up = 1;
Z_DISJ_1_1_26.lo = 1;
equation d_DISJ_1_1_26;
equation c_DISJ_1_1_26;
DISJ_1_1_26.. Y_DISJ_1_1_26 =G= Z_DISJ_1_1_26*exp(X_DISJ_1_1_26/Z_DISJ_1_1_26);
c_DISJ_1_1_26.. X_DISJ_1_1_26 =E= (X('66') - BIGM('1','1','26')*(1-Z('26')) )/(1.25*1);
d_DISJ_1_1_26.. Y_DISJ_1_1_26 =E= 1+X('61');
DISJ_1_2_26.. X('61') =L= BIGM('1','2','26')*Z('26');
X.up('61') = BIGM('1','2','26');
DISJ_2_2_26.. X('66') =L= BIGM('2','2','26')*Z('26');
X.up('66') = BIGM('2','2','26');

*DISJ_1_1_27.. X('67') =L= 0.9*LOG(1+X('62')) + BIGM('1','1','27')*(1-Z('27')) ;
variables X_DISJ_1_1_27, Y_DISJ_1_1_27, Z_DISJ_1_1_27;
Y_DISJ_1_1_27.lo = 1;
Z_DISJ_1_1_27.up = 1;
Z_DISJ_1_1_27.lo = 1;
equation d_DISJ_1_1_27;
equation c_DISJ_1_1_27;
DISJ_1_1_27.. Y_DISJ_1_1_27 =G= Z_DISJ_1_1_27*exp(X_DISJ_1_1_27/Z_DISJ_1_1_27);
c_DISJ_1_1_27.. X_DISJ_1_1_27 =E= (X('67') - BIGM('1','1','27')*(1-Z('27')) )/(0.9*1);
d_DISJ_1_1_27.. Y_DISJ_1_1_27 =E= 1+X('62');
DISJ_1_2_27.. X('62') =L= BIGM('1','2','27')*Z('27');
X.up('62') = BIGM('1','2','27');
DISJ_2_2_27.. X('67') =L= BIGM('2','2','27')*Z('27');
X.up('67') = BIGM('2','2','27');

*DISJ_1_1_28.. X('68') =L= LOG(1+X('59')) + BIGM('1','1','28')*(1-Z('28')) ;
variables X_DISJ_1_1_28, Y_DISJ_1_1_28, Z_DISJ_1_1_28;
Y_DISJ_1_1_28.lo = 1;
Z_DISJ_1_1_28.up = 1;
Z_DISJ_1_1_28.lo = 1;
equation d_DISJ_1_1_28;
equation c_DISJ_1_1_28;
DISJ_1_1_28.. Y_DISJ_1_1_28 =G= Z_DISJ_1_1_28*exp(X_DISJ_1_1_28/Z_DISJ_1_1_28);
c_DISJ_1_1_28.. X_DISJ_1_1_28 =E= (X('68') - BIGM('1','1','28')*(1-Z('28')) )/(1*1);
d_DISJ_1_1_28.. Y_DISJ_1_1_28 =E= 1+X('59');
DISJ_1_2_28.. X('59') =L= BIGM('1','2','28')*Z('28');
X.up('59') = BIGM('1','2','28');
DISJ_2_2_28.. X('68') =L= BIGM('2','2','28')*Z('28');
X.up('68') = BIGM('2','2','28');

DISJ_1_1_29.. X('69') =L= 0.9*X('63') + BIGM('1','1','29')*(1-Z('29'));
DISJ_2_1_29.. X('69') =G= 0.9*X('63') - BIGM('2','1','29')*(1-Z('29'));
DISJ_1_2_29.. X('63') =L= BIGM('1','2','29')*Z('29');
X.up('63') = BIGM('1','2','29');
DISJ_2_2_29.. X('69') =L= BIGM('2','2','29')*Z('29');
X.up('69') = BIGM('2','2','29');

DISJ_1_1_30.. X('70') =L= 0.6*X('64') + BIGM('1','1','30')*(1-Z('30'));
DISJ_2_1_30.. X('70') =G= 0.6*X('64') - BIGM('2','1','30')*(1-Z('30'));
DISJ_1_2_30.. X('64') =L= BIGM('1','2','30')*Z('30');
X.up('64') = BIGM('1','2','30');
DISJ_2_2_30.. X('70') =L= BIGM('2','2','30')*Z('30');
X.up('70') = BIGM('2','2','30');

*DISJ_1_1_31.. X('71') =L= 1.1*LOG(1+X('65')) + BIGM('1','1','31')*(1-Z('31')) ;
variables X_DISJ_1_1_31, Y_DISJ_1_1_31, Z_DISJ_1_1_31;
Y_DISJ_1_1_31.lo = 1;
Z_DISJ_1_1_31.up = 1;
Z_DISJ_1_1_31.lo = 1;
equation d_DISJ_1_1_31;
equation c_DISJ_1_1_31;
DISJ_1_1_31.. Y_DISJ_1_1_31 =G= Z_DISJ_1_1_31*exp(X_DISJ_1_1_31/Z_DISJ_1_1_31);
c_DISJ_1_1_31.. X_DISJ_1_1_31 =E= (X('71') - BIGM('1','1','31')*(1-Z('31')) )/(1.1*1);
d_DISJ_1_1_31.. Y_DISJ_1_1_31 =E= 1+X('65');
DISJ_1_2_31.. X('65') =L= BIGM('1','2','31')*Z('31');
X.up('65') = BIGM('1','2','31');
DISJ_2_2_31.. X('71') =L= BIGM('2','2','31')*Z('31');
X.up('71') = BIGM('2','2','31');

DISJ_1_1_32.. X('82') =L= 0.9*X('66') + BIGM('1','1','32')*(1-Z('32'));
DISJ_2_1_32.. X('82') =G= 0.9*X('66') - BIGM('2','1','32')*(1-Z('32'));
DISJ_3_1_32.. X('82') =L= X('74') + BIGM('3','1','32')*(1-Z('32'));
DISJ_4_1_32.. X('82') =G= X('74') - BIGM('4','1','32')*(1-Z('32'));
DISJ_1_2_32.. X('66') =L= BIGM('1','2','32')*Z('32');
X.up('66') = BIGM('1','2','32');
DISJ_2_2_32.. X('74') =L= BIGM('2','2','32')*Z('32');
X.up('74') = BIGM('2','2','32');
DISJ_3_2_32.. X('82') =L= BIGM('3','2','32')*Z('32');
X.up('82') = BIGM('3','2','32');

*DISJ_1_1_33.. X('83') =L= LOG(1+X('67')) + BIGM('1','1','33')*(1-Z('33')) ;
variables X_DISJ_1_1_33, Y_DISJ_1_1_33, Z_DISJ_1_1_33;
Y_DISJ_1_1_33.lo = 1;
Z_DISJ_1_1_33.up = 1;
Z_DISJ_1_1_33.lo = 1;
equation d_DISJ_1_1_33;
equation c_DISJ_1_1_33;
DISJ_1_1_33.. Y_DISJ_1_1_33 =G= Z_DISJ_1_1_33*exp(X_DISJ_1_1_33/Z_DISJ_1_1_33);
c_DISJ_1_1_33.. X_DISJ_1_1_33 =E= (X('83') - BIGM('1','1','33')*(1-Z('33')) )/(1*1);
d_DISJ_1_1_33.. Y_DISJ_1_1_33 =E= 1+X('67');
DISJ_1_2_33.. X('67') =L= BIGM('1','2','33')*Z('33');
X.up('67') = BIGM('1','2','33');
DISJ_2_2_33.. X('83') =L= BIGM('2','2','33')*Z('33');
X.up('83') = BIGM('2','2','33');

*DISJ_1_1_34.. X('84') =L= 0.7*LOG(1+X('72')) + BIGM('1','1','34')*(1-Z('34')) ;
variables X_DISJ_1_1_34, Y_DISJ_1_1_34, Z_DISJ_1_1_34;
Y_DISJ_1_1_34.lo = 1;
Z_DISJ_1_1_34.up = 1;
Z_DISJ_1_1_34.lo = 1;
equation d_DISJ_1_1_34;
equation c_DISJ_1_1_34;
DISJ_1_1_34.. Y_DISJ_1_1_34 =G= Z_DISJ_1_1_34*exp(X_DISJ_1_1_34/Z_DISJ_1_1_34);
c_DISJ_1_1_34.. X_DISJ_1_1_34 =E= (X('84') - BIGM('1','1','34')*(1-Z('34')) )/(0.7*1);
d_DISJ_1_1_34.. Y_DISJ_1_1_34 =E= 1+X('72');
DISJ_1_2_34.. X('72') =L= BIGM('1','2','34')*Z('34');
X.up('72') = BIGM('1','2','34');
DISJ_2_2_34.. X('84') =L= BIGM('2','2','34')*Z('34');
X.up('84') = BIGM('2','2','34');

*DISJ_1_1_35.. X('85') =L= 0.65*LOG(1+X('73')) + BIGM('1','1','35')*(1-Z('35')) ;
variables X_DISJ_1_1_35, Y_DISJ_1_1_35, Z_DISJ_1_1_35;
Y_DISJ_1_1_35.lo = 1;
Z_DISJ_1_1_35.up = 1;
Z_DISJ_1_1_35.lo = 1;
equation d_DISJ_1_1_35;
equation c_DISJ_1_1_35;
DISJ_1_1_35.. Y_DISJ_1_1_35 =G= Z_DISJ_1_1_35*exp(X_DISJ_1_1_35/Z_DISJ_1_1_35);
c_DISJ_1_1_35.. X_DISJ_1_1_35 =E= (X('85') - BIGM('1','1','35')*(1-Z('35')) )/(0.65*1);
d_DISJ_1_1_35.. Y_DISJ_1_1_35 =E= 1+X('73');
*DISJ_2_1_35.. X('85') =L= 0.65*LOG(1+X('76')) + BIGM('2','1','35')*(1-Z('35')) ;
variables X_DISJ_2_1_35, Y_DISJ_2_1_35, Z_DISJ_2_1_35;
Y_DISJ_2_1_35.lo = 1;
Z_DISJ_2_1_35.up = 1;
Z_DISJ_2_1_35.lo = 1;
equation d_DISJ_2_1_35;
equation c_DISJ_2_1_35;
DISJ_2_1_35.. Y_DISJ_2_1_35 =G= Z_DISJ_2_1_35*exp(X_DISJ_2_1_35/Z_DISJ_2_1_35);
c_DISJ_2_1_35.. X_DISJ_2_1_35 =E= (X('85') - BIGM('2','1','35')*(1-Z('35')) )/(0.65*1);
d_DISJ_2_1_35.. Y_DISJ_2_1_35 =E= 1+X('76');
DISJ_1_2_35.. X('73') =L= BIGM('1','2','35')*Z('35');
X.up('73') = BIGM('1','2','35');
DISJ_2_2_35.. X('76') =L= BIGM('2','2','35')*Z('35');
X.up('76') = BIGM('2','2','35');
DISJ_3_2_35.. X('85') =L= BIGM('3','2','35')*Z('35');
X.up('85') = BIGM('3','2','35');

DISJ_1_1_36.. X('86') =L= X('77') + BIGM('1','1','36')*(1-Z('36'));
DISJ_2_1_36.. X('86') =G= X('77') - BIGM('2','1','36')*(1-Z('36'));
DISJ_1_2_36.. X('77') =L= BIGM('1','2','36')*Z('36');
X.up('77') = BIGM('1','2','36');
DISJ_2_2_36.. X('86') =L= BIGM('2','2','36')*Z('36');
X.up('86') = BIGM('2','2','36');

DISJ_1_1_37.. X('87') =L= X('78') + BIGM('1','1','37')*(1-Z('37'));
DISJ_2_1_37.. X('87') =G= X('78') - BIGM('2','1','37')*(1-Z('37'));
DISJ_1_2_37.. X('78') =L= BIGM('1','2','37')*Z('37');
X.up('78') = BIGM('1','2','37');
DISJ_2_2_37.. X('87') =L= BIGM('2','2','37')*Z('37');
X.up('87') = BIGM('2','2','37');

*DISJ_1_1_38.. X('88') =L= 0.75*LOG(1+X('79')) + BIGM('1','1','38')*(1-Z('38')) ;
variables X_DISJ_1_1_38, Y_DISJ_1_1_38, Z_DISJ_1_1_38;
Y_DISJ_1_1_38.lo = 1;
Z_DISJ_1_1_38.up = 1;
Z_DISJ_1_1_38.lo = 1;
equation d_DISJ_1_1_38;
equation c_DISJ_1_1_38;
DISJ_1_1_38.. Y_DISJ_1_1_38 =G= Z_DISJ_1_1_38*exp(X_DISJ_1_1_38/Z_DISJ_1_1_38);
c_DISJ_1_1_38.. X_DISJ_1_1_38 =E= (X('88') - BIGM('1','1','38')*(1-Z('38')) )/(0.75*1);
d_DISJ_1_1_38.. Y_DISJ_1_1_38 =E= 1+X('79');
DISJ_1_2_38.. X('79') =L= BIGM('1','2','38')*Z('38');
X.up('79') = BIGM('1','2','38');
DISJ_2_2_38.. X('88') =L= BIGM('2','2','38')*Z('38');
X.up('88') = BIGM('2','2','38');

*DISJ_1_1_39.. X('89') =L= 0.8*LOG(1+X('80')) + BIGM('1','1','39')*(1-Z('39')) ;
variables X_DISJ_1_1_39, Y_DISJ_1_1_39, Z_DISJ_1_1_39;
Y_DISJ_1_1_39.lo = 1;
Z_DISJ_1_1_39.up = 1;
Z_DISJ_1_1_39.lo = 1;
equation d_DISJ_1_1_39;
equation c_DISJ_1_1_39;
DISJ_1_1_39.. Y_DISJ_1_1_39 =G= Z_DISJ_1_1_39*exp(X_DISJ_1_1_39/Z_DISJ_1_1_39);
c_DISJ_1_1_39.. X_DISJ_1_1_39 =E= (X('89') - BIGM('1','1','39')*(1-Z('39')) )/(0.8*1);
d_DISJ_1_1_39.. Y_DISJ_1_1_39 =E= 1+X('80');
DISJ_1_2_39.. X('80') =L= BIGM('1','2','39')*Z('39');
X.up('80') = BIGM('1','2','39');
DISJ_2_2_39.. X('89') =L= BIGM('2','2','39')*Z('39');
X.up('89') = BIGM('2','2','39');

*DISJ_1_1_40.. X('90') =L= 0.85*LOG(1+X('81')) + BIGM('1','1','40')*(1-Z('40')) ;
variables X_DISJ_1_1_40, Y_DISJ_1_1_40, Z_DISJ_1_1_40;
Y_DISJ_1_1_40.lo = 1;
Z_DISJ_1_1_40.up = 1;
Z_DISJ_1_1_40.lo = 1;
equation d_DISJ_1_1_40;
equation c_DISJ_1_1_40;
DISJ_1_1_40.. Y_DISJ_1_1_40 =G= Z_DISJ_1_1_40*exp(X_DISJ_1_1_40/Z_DISJ_1_1_40);
c_DISJ_1_1_40.. X_DISJ_1_1_40 =E= (X('90') - BIGM('1','1','40')*(1-Z('40')) )/(0.85*1);
d_DISJ_1_1_40.. Y_DISJ_1_1_40 =E= 1+X('81');
DISJ_1_2_40.. X('81') =L= BIGM('1','2','40')*Z('40');
X.up('81') = BIGM('1','2','40');
DISJ_2_2_40.. X('90') =L= BIGM('2','2','40')*Z('40');
X.up('90') = BIGM('2','2','40');

*Design Specifications
D1..  Z('1') + Z('2')                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1..  -Z('3') + Z('6') + Z('7')                  =G= 0;
L2..  -Z('6') + Z('12')                          =G= 0;
L3..  -Z('7') + Z('13')                          =G= 0;
L4..  -Z('4') + Z('8')                           =G= 0;
L5..  -Z('8') + Z('14') + Z('15')                =G= 0;
L6..  -Z('5') + Z('9') + Z('10') + Z('11')       =G= 0;
L7..  -Z('9') + Z('15')                          =G= 0;
L8..  -Z('10') + Z('16') + Z('17')               =G= 0;
L9..  -Z('11') + Z('18') + Z('19') + Z('20')     =G= 0;
L10.. -Z('6') + Z('3')                           =G= 0;
L11.. -Z('7') + Z('3')                           =G= 0;
L12.. -Z('8') + Z('4')                           =G= 0;
L13.. -Z('9') + Z('5')                           =G= 0;
L14.. -Z('10') + Z('5')                          =G= 0;
L15.. -Z('11') + Z('5')                          =G= 0;
L16.. -Z('12') + Z('6')                          =G= 0;
L17.. -Z('13') + Z('7')                          =G= 0;
L18.. -Z('14') + Z('8')                          =G= 0;
L19.. -Z('15') + Z('8')                          =G= 0;
L20.. -Z('16') + Z('10')                         =G= 0;
L21.. -Z('17') + Z('10')                         =G= 0;
L22.. -Z('18') + Z('11')                         =G= 0;
L23.. -Z('19') + Z('11')                         =G= 0;
L24.. -Z('20') + Z('11')                         =G= 0;

L25.. -Z('20') + Z('21') + Z('22')               =G= 0;
L26.. -Z('23') + Z('26') + Z('27')               =G= 0;
L27.. -Z('26') + Z('32')                         =G= 0;
L28.. -Z('27') + Z('33')                         =G= 0;
L29.. -Z('24') + Z('28')                         =G= 0;
L30.. -Z('28') + Z('34') + Z('35')               =G= 0;
L31.. -Z('25') + Z('29') + Z('30') + Z('31')     =G= 0;
L32.. -Z('29') + Z('35')                         =G= 0;
L33.. -Z('30') + Z('36') + Z('37')               =G= 0;
L34.. -Z('31') + Z('38') + Z('39') + Z('40')     =G= 0;
L35.. -Z('26') + Z('23')                         =G= 0;
L36.. -Z('27') + Z('23')                         =G= 0;
L37.. -Z('32') + Z('26')                         =G= 0;
L38.. -Z('33') + Z('27')                         =G= 0;
L39.. -Z('28') + Z('24')                         =G= 0;
L40.. -Z('34') + Z('28')                         =G= 0;
L41.. -Z('35') + Z('28')                         =G= 0;
L42.. -Z('29') + Z('25')                         =G= 0;
L43.. -Z('30') + Z('25')                         =G= 0;
L44.. -Z('31') + Z('25')                         =G= 0;
L45.. -Z('36') + Z('30')                         =G= 0;
L46.. -Z('37') + Z('30')                         =G= 0;
L47.. -Z('38') + Z('31')                         =G= 0;
L48.. -Z('39') + Z('31')                         =G= 0;
L49.. -Z('40') + Z('31')                         =G= 0;
L50.. -Z('3') + Z('1') + Z('2')                  =G= 0;
L51.. -Z('4') + Z('1') + Z('2')                  =G= 0;
L52.. -Z('5') + Z('1') + Z('2')                  =G= 0;
L53.. -Z('21') + Z('20')                         =G= 0;
L54.. -Z('22') + Z('20')                         =G= 0;

* Bounds
X.UP('1') = 40;
X.UP('12') = 30;
X.UP('29') = 20;
X.UP('30') = 20;
X.UP('57') = 30;
X.UP('74') = 25;
X.UP('75') = 25;

MODEL SYNTH_40_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_40_BIGM USING %TYPE% MAXIMIZING OBJ;