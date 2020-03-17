*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= Z*exp(x/Z) <=> x <= z*log(y/z) ; x >= (x1 - M(1-z))/c ; y = 1 + x2; Z = 1
*Synthesis Problem with 40 processes
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

I       /1*40/                            /* Number of process units */
K       /1*90/                            /* Number of streams */
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
                1       -1     -1      -1       -1
                2       0       0       0        0
                3       0       0       0        0
                4       0       0       0        0
                5       0       0       0        0
                6       0       0       0        0
                7       5      10       5       10
                8       0       0       0        0
                9       0       0       0        0
                10      0       0       0        0
                11      0       0       0        0
                12      -1     -1       -1      -1
                13      0       0       0        0
                14      0       0       0        0
                15      0       0       0        0
                16      0       0       0        0
                17      0       0       0        0
                18      0       0       0        0
                19      0       0       0        0
                20      0       0       0        0
                21      0       0       0        0
                22      0       0       0        0
                23      0       0       0        0
                24      0       0       0        0
                25      0       0       0        0
                26      0       0       0        0
                27      0       0       0        0
                28      0       0       0        0
                29      -10    -5      -5      -10
                30      -5     -5      -5      -10
                31      0       0       0        0
                32      0       0       0        0
                33      0       0       0        0
                34      0       0       0        0
                35      0       0       0        0
                36      0       0       0        0
                37      40     30       15      10
                38      15     20       25      20
                39      10     30       40      30
                40      30     20       20      25
                41      35     50       20      50
                42      20     30       35      10
                43      25     50       10      35
                44      15     20       20      30
                45      0       0       0        0
                46      0       0       0        0
                47      0       0       0        0
                48      0       0       0        0
                49      0       0       0        0
                50      0       0       0        0
                51      0       0       0        0
                52      30     40       40      35
                53      0       0       0        0
                54      0       0       0        0
                55      0       0       0        0
                56      0       0       0        0
                57      -1     -1       -1      -1
                58      0       0       0        0
                59      0       0       0        0
                60      0       0       0        0
                61      0       0       0        0
                62      0       0       0        0
                63      0       0       0        0
                64      0       0       0        0
                65      0       0       0        0
                66      0       0       0        0
                67      0       0       0        0
                68      0       0       0        0
                69      0       0       0        0
                70      0       0       0        0
                71      0       0       0        0
                72      0       0       0        0
                73      0       0       0        0
                74      -5     -3       -4      -3
                75      -1     -1       -1      -1
                76      0       0       0        0
                77      0       0       0        0
                78      0       0       0        0
                79      0       0       0        0
                80      0       0       0        0
                81      0       0       0        0
                82      220    210      150     125
                83      240    220      100     130
                84      190    160      150     110
                85      190    190      120     100
                86      385    490      550     500
                87      390    505      490     640
                88      480    600      530     560
                89      490    600      440     510
                90      550    550      600     500

TABLE FC(I,T)             /* Fixed costs in objective */
                         1        2      3         4
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
                11      -3       -9      -3       -6
                12      -7       -2      -9       -6
                13      -3       -1      -9       -10
                14      -2       -6      -3       -7
                15      -4       -8      -1       -4
                16      -2       -5      -2       -5
                17      -3       -4      -3       -7
                18      -5       -7      -6       -2
                19      -2       -8      -4       -2
                20      -1       -4      -1       -1
                21      -2       -5      -2       -7
                22      -9       -2      -9       -6
                23      -5       -8      -4       -3
                24      -2       -3      -8       -9
                25      -10      -6      -3       -6
                26      -4       -8      -7       -7
                27      -7       -3      -9       -3
                28      -4       -8      -6       -8
                29      -2       -1      -3       -9
                30      -8       -3      -4       -3
                31      -9       -5      -1       -2
                32      -3       -9      -5       -3
                33      -5       -3      -3       -4
                34      -5       -3      -2       -7
                35      -6       -4      -6       -7
                36      -2       -6      -6       -7
                37      -6       -4      -3       -5
                38      -3       -2      -1       -3
                39      -5       -8      -6       -5
                40      -9       -5      -2       -1
;

PARAMETERS BIGM(E,D,I,T) /1*4 .1*2 .1*40 .1*4 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

PARAMETERS
X1_UP(T)
/1 = 10
 2 = 10
 3 = 10
 4 = 10/

X12_UP(T)
/1 = 7
 2 = 7
 3 = 7
 4 = 7/

X29_UP(T)
/1 = 7
 2 = 7
 3 = 7
 4 = 7/

X30_UP(T)
/1 = 5
 2 = 5
 3 = 5
 4 = 5/

X57_UP(T)
/1 = 7
 2 = 7
 3 = 7
 4 = 7/

X74_UP(T)
/1 = 7
 2 = 7
 3 = 7
 4 = 7/

X75_UP(T)
/1 = 5
 2 = 5
 3 = 5
 4 = 5/;

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

BIGM('1','1','11',T) = 1;
BIGM('1','2','11',T) = MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('2','2','11',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));

BIGM('1','1','12',T) = 1;
BIGM('2','1','12',T) = 1;
BIGM('3','1','12',T) = 1;
BIGM('4','1','12',T) = 1;
BIGM('1','2','12',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
BIGM('2','2','12',T) = X29_UP(T);
BIGM('3','2','12',T) = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))), X29_UP(T));

BIGM('1','1','13',T) = 1;
BIGM('1','2','13',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
BIGM('2','2','13',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))));

BIGM('1','1','14',T) = 1;
BIGM('1','2','14',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
BIGM('2','2','14',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))));

BIGM('1','1','15',T) = 1;
BIGM('2','1','15',T) = 1;
BIGM('1','2','15',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
BIGM('2','2','15',T) = X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('3','2','15',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))), 0.65*LOG(1+ (X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

BIGM('1','1','16',T) = 1;
BIGM('2','1','16',T) = 1;
BIGM('1','2','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('2','2','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

BIGM('1','1','17',T) = 1;
BIGM('2','1','17',T) = 1;
BIGM('1','2','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
BIGM('2','2','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

BIGM('1','1','18',T) = 1;
BIGM('1','2','18',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
BIGM('2','2','18',T) = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

BIGM('1','1','19',T) = 1;
BIGM('1','2','19',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
BIGM('2','2','19',T) = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

BIGM('1','1','20',T) = 1;
BIGM('1','2','20',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
BIGM('2','2','20',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

BIGM('1','1','21',T) = 1;
BIGM('1','2','21',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
BIGM('2','2','21',T) = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

BIGM('1','1','22',T) = 1;
BIGM('1','2','22',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
BIGM('2','2','22',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

BIGM('1','1','23',T) = 1;
BIGM('2','1','23',T) = 1;
BIGM('1','2','23',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
BIGM('2','2','23',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

BIGM('1','1','24',T) = 1;
BIGM('1','2','24',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
BIGM('2','2','24',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

BIGM('1','1','25',T) = 1;
BIGM('2','1','25',T) = 1;
BIGM('3','1','25',T) = 1;
BIGM('4','1','25',T) = 1;
BIGM('1','2','25',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
BIGM('2','2','25',T) = X57_UP(T);
BIGM('3','2','25',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

BIGM('1','1','26',T) = 1;
BIGM('1','2','26',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
BIGM('2','2','26',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

BIGM('1','1','27',T) = 1;
BIGM('1','2','27',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
BIGM('2','2','27',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

BIGM('1','1','28',T) = 1;
BIGM('1','2','28',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
BIGM('2','2','28',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));

BIGM('1','1','29',T) = 1;
BIGM('2','1','29',T) = 1;
BIGM('1','2','29',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('2','2','29',T) = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

BIGM('1','1','30',T) = 1;
BIGM('2','1','30',T) = 1;
BIGM('1','2','30',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('2','2','30',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

BIGM('1','1','31',T) = 1;
BIGM('1','2','31',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('2','2','31',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));

BIGM('1','1','32',T) = 1;
BIGM('2','1','32',T) = 1;
BIGM('3','1','32',T) = 1;
BIGM('4','1','32',T) = 1;
BIGM('1','2','32',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
BIGM('2','2','32',T) = X74_UP(T);
BIGM('3','2','32',T) = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))))), X74_UP(T));

BIGM('1','1','33',T) = 1;
BIGM('1','2','33',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
BIGM('2','2','33',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));

BIGM('1','1','34',T) = 1;
BIGM('1','2','34',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
BIGM('2','2','34',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))));

BIGM('1','1','35',T) = 1;
BIGM('2','1','35',T) = 1;
BIGM('1','2','35',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
BIGM('2','2','35',T) = X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('3','2','35',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))), 0.65*LOG(1+X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

BIGM('1','1','36',T) = 1;
BIGM('2','1','36',T) = 1;
BIGM('1','2','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('2','2','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

BIGM('1','1','37',T) = 1;
BIGM('2','1','37',T) = 1;
BIGM('1','2','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
BIGM('2','2','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

BIGM('1','1','38',T) = 1;
BIGM('1','2','38',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
BIGM('2','2','38',T) = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

BIGM('1','1','39',T) = 1;
BIGM('1','2','39',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
BIGM('2','2','39',T) = 0.80*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

BIGM('1','1','40',T) = 1;
BIGM('1','2','40',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
BIGM('2','2','40',T) = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

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
                11      3       9      3       6
                12      7       2      9       6
                13      3       1      9       10
                14      2       6      3       7
                15      4       8      1       4
                16      2       5      2       5
                17      3       4      3       7
                18      5       7      6       2
                19      2       8      4       2
                20      1       4      1       1
                21      2       5      2       7
                22      9       2      9       6
                23      5       8      4       3
                24      2       3      8       9
                25      10      6      3       6
                26      4       8      7       7
                27      7       3      9       3
                28      4       8      6       8
                29      2       1      3       9
                30      8       3      4       3
                31      9       5      1       2
                32      3       9      5       3
                33      5       3      3       4
                34      5       3      2       7
                35      6       4      6       7
                36      2       6      6       7
                37      6       4      3       5
                38      3       2      1       3
                39      5       8      6       5
                40      9       5      2       1
;

TABLE BIGM2_2(I,T)
                         1        2      3         4
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
                11      -3       -9      -3       -6
                12      -7       -2      -9       -6
                13      -3       -1      -9       -10
                14      -2       -6      -3       -7
                15      -4       -8      -1       -4
                16      -2       -5      -2       -5
                17      -3       -4      -3       -7
                18      -5       -7      -6       -2
                19      -2       -8      -4       -2
                20      -1       -4      -1       -1
                21      -2       -5      -2       -7
                22      -9       -2      -9       -6
                23      -5       -8      -4       -3
                24      -2       -3      -8       -9
                25      -10      -6      -3       -6
                26      -4       -8      -7       -7
                27      -7       -3      -9       -3
                28      -4       -8      -6       -8
                29      -2       -1      -3       -9
                30      -8       -3      -4       -3
                31      -9       -5      -1       -2
                32      -3       -9      -5       -3
                33      -5       -3      -3       -4
                34      -5       -3      -2       -7
                35      -6       -4      -6       -7
                36      -2       -6      -6       -7
                37      -6       -4      -3       -5
                38      -3       -2      -1       -3
                39      -5       -8      -6       -5
                40      -9       -5      -2       -1
;


****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1(T),MB2(T),MB3(T),MB4(T),MB5(T),MB6(T),MB7(T),MB8(T),MB9(T),MB10(T),
MB11(T),MB12(T),MB13(T),MB14(T),MB15(T),MB16(T),MB17(T),MB18(T),MB19(T),MB20(T),MB21(T)

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

DISJ_1_1_11(T)
DISJ_1_2_11(T)
DISJ_2_2_11(T)

DISJ_1_1_12(T)
DISJ_2_1_12(T)
DISJ_3_1_12(T)
DISJ_4_1_12(T)
DISJ_1_2_12(T)
DISJ_2_2_12(T)
DISJ_3_2_12(T)

DISJ_1_1_13(T)
DISJ_1_2_13(T)
DISJ_2_2_13(T)

DISJ_1_1_14(T)
DISJ_1_2_14(T)
DISJ_2_2_14(T)

DISJ_1_1_15(T)
DISJ_2_1_15(T)
DISJ_1_2_15(T)
DISJ_2_2_15(T)
DISJ_3_2_15(T)

DISJ_1_1_16(T)
DISJ_2_1_16(T)
DISJ_1_2_16(T)
DISJ_2_2_16(T)

DISJ_1_1_17(T)
DISJ_2_1_17(T)
DISJ_1_2_17(T)
DISJ_2_2_17(T)

DISJ_1_1_18(T)
DISJ_1_2_18(T)
DISJ_2_2_18(T)

DISJ_1_1_19(T)
DISJ_1_2_19(T)
DISJ_2_2_19(T)

DISJ_1_1_20(T)
DISJ_1_2_20(T)
DISJ_2_2_20(T)

DISJ_1_1_21(T)
DISJ_1_2_21(T)
DISJ_2_2_21(T)

DISJ_1_1_22(T)
DISJ_1_2_22(T)
DISJ_2_2_22(T)

DISJ_1_1_23(T)
DISJ_2_1_23(T)
DISJ_1_2_23(T)
DISJ_2_2_23(T)

DISJ_1_1_24(T)
DISJ_1_2_24(T)
DISJ_2_2_24(T)

DISJ_1_1_25(T)
DISJ_2_1_25(T)
DISJ_3_1_25(T)
DISJ_4_1_25(T)
DISJ_1_2_25(T)
DISJ_2_2_25(T)
DISJ_3_2_25(T)

DISJ_1_1_26(T)
DISJ_1_2_26(T)
DISJ_2_2_26(T)

DISJ_1_1_27(T)
DISJ_1_2_27(T)
DISJ_2_2_27(T)

DISJ_1_1_28(T)
DISJ_1_2_28(T)
DISJ_2_2_28(T)

DISJ_1_1_29(T)
DISJ_2_1_29(T)
DISJ_1_2_29(T)
DISJ_2_2_29(T)

DISJ_1_1_30(T)
DISJ_2_1_30(T)
DISJ_1_2_30(T)
DISJ_2_2_30(T)

DISJ_1_1_31(T)
DISJ_1_2_31(T)
DISJ_2_2_31(T)

DISJ_1_1_32(T)
DISJ_2_1_32(T)
DISJ_3_1_32(T)
DISJ_4_1_32(T)
DISJ_1_2_32(T)
DISJ_2_2_32(T)
DISJ_3_2_32(T)

DISJ_1_1_33(T)
DISJ_1_2_33(T)
DISJ_2_2_33(T)

DISJ_1_1_34(T)
DISJ_1_2_34(T)
DISJ_2_2_34(T)

DISJ_1_1_35(T)
DISJ_2_1_35(T)
DISJ_1_2_35(T)
DISJ_2_2_35(T)
DISJ_3_2_35(T)

DISJ_1_1_36(T)
DISJ_2_1_36(T)
DISJ_1_2_36(T)
DISJ_2_2_36(T)

DISJ_1_1_37(T)
DISJ_2_1_37(T)
DISJ_1_2_37(T)
DISJ_2_2_37(T)

DISJ_1_1_38(T)
DISJ_1_2_38(T)
DISJ_2_2_38(T)

DISJ_1_1_39(T)
DISJ_1_2_39(T)
DISJ_2_2_39(T)

DISJ_1_1_40(T)
DISJ_1_2_40(T)
DISJ_2_2_40(T)

DISJ2_1_Synthesis(I,T)
DISJ2_2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T),L4(T),L5(T),L6(T),L7(T),L8(T),L9(T),L10(T),L11(T),L12(T),L13(T),L14(T),L15(T),L16(T),L17(T),L18(T),L19(T),L20(T)
L21(T),L22(T),L23(T),L24(T),L25(T),L26(T),L27(T),L28(T),L29(T),L30(T),L31(T),L32(T),L33(T),L34(T),L35(T),L36(T),L37(T),L38(T),L39(T)
L40(T),L41(T),L42(T),L43(T),L44(T),L45(T),L46(T),L47(T),L48(T),L49(T),L50(T),L51(T),L52(T),L53(T),L54(T)
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
MB7(T)..    X('23',T)    -    X('27',T) -    X('28',T)                   =E= 0;
MB8(T)..    X('31',T)    -    X('24',T) -    X('30',T)                   =E= 0;
MB9(T)..    X('25',T)    -    X('32',T) -    X('33',T)                   =E= 0;
MB10(T)..   X('26',T)    -    X('34',T) -    X('35',T) -   X('36',T)     =E= 0;

*Connecting Stream between flowsheets
MB11(T)..   X('45',T)    -    X('46',T)                                  =E= 0;

MB12(T)..    X('46',T)     -    X('47',T)  -    X('48',T)                =E= 0;
MB13(T)..    X('51',T)     -    X('49',T)  -    X('50',T)                =E= 0;
MB14(T)..    X('51',T)     -    X('52',T)  -    X('53',T)                =E= 0;
MB15(T)..    X('53',T)     -    X('54',T)  -    X('55',T) -   X('56',T)  =E= 0;
MB16(T)..    X('58',T)     -    X('61',T)  -    X('62',T)                =E= 0;
MB17(T)..    X('60',T)     -    X('63',T)  -    X('64',T) -   X('65',T)  =E= 0;
MB18(T)..    X('68',T)     -    X('72',T)  -    X('73',T)                =E= 0;
MB19(T)..    X('76',T)     -    X('69',T)  -    X('75',T)                =E= 0;
MB20(T)..    X('70',T)     -    X('77',T)  -    X('78',T)                =E= 0;
MB21(T)..    X('71',T)     -    X('79',T)  -    X('80',T) -   X('81',T)  =E= 0;

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

*DISJ_1_1_6(T).. X('21',T) =L= 1.25*LOG(1+X('16',T)) + BIGM('1','1','6',T)*(1-Z('6',T)) ;
variables X_DISJ_1_1_6(T), Y_DISJ_1_1_6(T), Z_DISJ_1_1_6(T);
Y_DISJ_1_1_6.lo(T) = 1;
Z_DISJ_1_1_6.up(T) = 1;
Z_DISJ_1_1_6.lo(T) = 1;
equation d_DISJ_1_1_6(T);
equation c_DISJ_1_1_6(T);
DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =G= Z_DISJ_1_1_6(T)*exp(X_DISJ_1_1_6(T)/Z_DISJ_1_1_6(T));
c_DISJ_1_1_6(T).. X_DISJ_1_1_6(T) =E= (X('21',T) - BIGM('1','1','6',T)*(1-Z('6',T)) )/(1.25*1);
d_DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =E= 1+X('16',T);
DISJ_1_2_6(T).. X('16',T) =L= BIGM('1','2','6',T)*Z('6',T);
X.up('16',T) = BIGM('1','2','6',T);
DISJ_2_2_6(T).. X('21',T) =L= BIGM('2','2','6',T)*Z('6',T);
X.up('21',T) = BIGM('2','2','6',T);

*DISJ_1_1_7(T).. X('22',T) =L= 0.9*LOG(1+X('17',T)) + BIGM('1','1','7',T)*(1-Z('7',T)) ;
variables X_DISJ_1_1_7(T), Y_DISJ_1_1_7(T), Z_DISJ_1_1_7(T);
Y_DISJ_1_1_7.lo(T) = 1;
Z_DISJ_1_1_7.up(T) = 1;
Z_DISJ_1_1_7.lo(T) = 1;
equation d_DISJ_1_1_7(T);
equation c_DISJ_1_1_7(T);
DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =G= Z_DISJ_1_1_7(T)*exp(X_DISJ_1_1_7(T)/Z_DISJ_1_1_7(T));
c_DISJ_1_1_7(T).. X_DISJ_1_1_7(T) =E= (X('22',T) - BIGM('1','1','7',T)*(1-Z('7',T)) )/(0.9*1);
d_DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =E= 1+X('17',T);
DISJ_1_2_7(T).. X('17',T) =L= BIGM('1','2','7',T)*Z('7',T);
X.up('17',T) = BIGM('1','2','7',T);
DISJ_2_2_7(T).. X('22',T) =L= BIGM('2','2','7',T)*Z('7',T);
X.up('22',T) = BIGM('2','2','7',T);

*DISJ_1_1_8(T).. X('23',T) =L= LOG(1+X('14',T)) + BIGM('1','1','8',T)*(1-Z('8',T)) ;
variables X_DISJ_1_1_8(T), Y_DISJ_1_1_8(T), Z_DISJ_1_1_8(T);
Y_DISJ_1_1_8.lo(T) = 1;
Z_DISJ_1_1_8.up(T) = 1;
Z_DISJ_1_1_8.lo(T) = 1;
equation d_DISJ_1_1_8(T);
equation c_DISJ_1_1_8(T);
DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =G= Z_DISJ_1_1_8(T)*exp(X_DISJ_1_1_8(T)/Z_DISJ_1_1_8(T));
c_DISJ_1_1_8(T).. X_DISJ_1_1_8(T) =E= (X('23',T) - BIGM('1','1','8',T)*(1-Z('8',T)) )/(1*1);
d_DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =E= 1+X('14',T);
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

*DISJ_1_1_11(T).. X('26',T) =L= 1.1*LOG(1+X('20',T)) + BIGM('1','1','11',T)*(1-Z('11',T)) ;
variables X_DISJ_1_1_11(T), Y_DISJ_1_1_11(T), Z_DISJ_1_1_11(T);
Y_DISJ_1_1_11.lo(T) = 1;
Z_DISJ_1_1_11.up(T) = 1;
Z_DISJ_1_1_11.lo(T) = 1;
equation d_DISJ_1_1_11(T);
equation c_DISJ_1_1_11(T);
DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =G= Z_DISJ_1_1_11(T)*exp(X_DISJ_1_1_11(T)/Z_DISJ_1_1_11(T));
c_DISJ_1_1_11(T).. X_DISJ_1_1_11(T) =E= (X('26',T) - BIGM('1','1','11',T)*(1-Z('11',T)) )/(1.1*1);
d_DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =E= 1+X('20',T);
DISJ_1_2_11(T).. X('20',T) =L= BIGM('1','2','11',T)*Z('11',T);
X.up('20',T) = BIGM('1','2','11',T);
DISJ_2_2_11(T).. X('26',T) =L= BIGM('2','2','11',T)*Z('11',T);
X.up('26',T) = BIGM('2','2','11',T);

DISJ_1_1_12(T).. X('37',T) =L= 0.9*X('21',T) + BIGM('1','1','12',T)*(1-Z('12',T));
DISJ_2_1_12(T).. X('37',T) =G= 0.9*X('21',T) - BIGM('2','1','12',T)*(1-Z('12',T));
DISJ_3_1_12(T).. X('37',T) =L= X('29',T) + BIGM('3','1','12',T)*(1-Z('12',T));
DISJ_4_1_12(T).. X('37',T) =G= X('29',T) - BIGM('4','1','12',T)*(1-Z('12',T));
DISJ_1_2_12(T).. X('21',T) =L= BIGM('1','2','12',T)*Z('12',T);
X.up('21',T) = BIGM('1','2','12',T);
DISJ_2_2_12(T).. X('29',T) =L= BIGM('2','2','12',T)*Z('12',T);
X.up('29',T) = BIGM('2','2','12',T);
DISJ_3_2_12(T).. X('37',T) =L= BIGM('3','2','12',T)*Z('12',T);
X.up('37',T) = BIGM('3','2','12',T);

*DISJ_1_1_13(T).. X('38',T) =L= LOG(1+X('22',T)) + BIGM('1','1','13',T)*(1-Z('13',T)) ;
variables X_DISJ_1_1_13(T), Y_DISJ_1_1_13(T), Z_DISJ_1_1_13(T);
Y_DISJ_1_1_13.lo(T) = 1;
Z_DISJ_1_1_13.up(T) = 1;
Z_DISJ_1_1_13.lo(T) = 1;
equation d_DISJ_1_1_13(T);
equation c_DISJ_1_1_13(T);
DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =G= Z_DISJ_1_1_13(T)*exp(X_DISJ_1_1_13(T)/Z_DISJ_1_1_13(T));
c_DISJ_1_1_13(T).. X_DISJ_1_1_13(T) =E= (X('38',T) - BIGM('1','1','13',T)*(1-Z('13',T)) )/(1*1);
d_DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =E= 1+X('22',T);
DISJ_1_2_13(T).. X('22',T) =L= BIGM('1','2','13',T)*Z('13',T);
X.up('22',T) = BIGM('1','2','13',T);
DISJ_2_2_13(T).. X('38',T) =L= BIGM('2','2','13',T)*Z('13',T);
X.up('38',T) = BIGM('2','2','13',T);

*DISJ_1_1_14(T).. X('39',T) =L= 0.7*LOG(1+X('27',T)) + BIGM('1','1','14',T)*(1-Z('14',T)) ;
variables X_DISJ_1_1_14(T), Y_DISJ_1_1_14(T), Z_DISJ_1_1_14(T);
Y_DISJ_1_1_14.lo(T) = 1;
Z_DISJ_1_1_14.up(T) = 1;
Z_DISJ_1_1_14.lo(T) = 1;
equation d_DISJ_1_1_14(T);
equation c_DISJ_1_1_14(T);
DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =G= Z_DISJ_1_1_14(T)*exp(X_DISJ_1_1_14(T)/Z_DISJ_1_1_14(T));
c_DISJ_1_1_14(T).. X_DISJ_1_1_14(T) =E= (X('39',T) - BIGM('1','1','14',T)*(1-Z('14',T)) )/(0.7*1);
d_DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =E= 1+X('27',T);
DISJ_1_2_14(T).. X('27',T) =L= BIGM('1','2','14',T)*Z('14',T);
X.up('27',T) = BIGM('1','2','14',T);
DISJ_2_2_14(T).. X('39',T) =L= BIGM('2','2','14',T)*Z('14',T);
X.up('39',T) = BIGM('2','2','14',T);

*DISJ_1_1_15(T).. X('40',T) =L= 0.65*LOG(1+X('28',T)) + BIGM('1','1','15',T)*(1-Z('15',T)) ;
variables X_DISJ_1_1_15(T), Y_DISJ_1_1_15(T), Z_DISJ_1_1_15(T);
Y_DISJ_1_1_15.lo(T) = 1;
Z_DISJ_1_1_15.up(T) = 1;
Z_DISJ_1_1_15.lo(T) = 1;
equation d_DISJ_1_1_15(T);
equation c_DISJ_1_1_15(T);
DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =G= Z_DISJ_1_1_15(T)*exp(X_DISJ_1_1_15(T)/Z_DISJ_1_1_15(T));
c_DISJ_1_1_15(T).. X_DISJ_1_1_15(T) =E= (X('40',T) - BIGM('1','1','15',T)*(1-Z('15',T)) )/(0.65*1);
d_DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =E= 1+X('28',T);
*DISJ_2_1_15(T).. X('40',T) =L= 0.65*LOG(1+X('31',T)) + BIGM('2','1','15',T)*(1-Z('15',T)) ;
variables X_DISJ_2_1_15(T), Y_DISJ_2_1_15(T), Z_DISJ_2_1_15(T);
Y_DISJ_2_1_15.lo(T) = 1;
Z_DISJ_2_1_15.up(T) = 1;
Z_DISJ_2_1_15.lo(T) = 1;
equation d_DISJ_2_1_15(T);
equation c_DISJ_2_1_15(T);
DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =G= Z_DISJ_2_1_15(T)*exp(X_DISJ_2_1_15(T)/Z_DISJ_2_1_15(T));
c_DISJ_2_1_15(T).. X_DISJ_2_1_15(T) =E= (X('40',T) - BIGM('2','1','15',T)*(1-Z('15',T)) )/(0.65*1);
d_DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =E= 1+X('31',T);
DISJ_1_2_15(T).. X('28',T) =L= BIGM('1','2','15',T)*Z('15',T);
X.up('28',T) = BIGM('1','2','15',T);
DISJ_2_2_15(T).. X('31',T) =L= BIGM('2','2','15',T)*Z('15',T);
X.up('31',T) = BIGM('2','2','15',T);
DISJ_3_2_15(T).. X('40',T) =L= BIGM('3','2','15',T)*Z('15',T);
X.up('40',T) = BIGM('3','2','15',T);

DISJ_1_1_16(T).. X('41',T) =L= X('32',T) + BIGM('1','1','16',T)*(1-Z('16',T));
DISJ_2_1_16(T).. X('41',T) =G= X('32',T) - BIGM('2','1','16',T)*(1-Z('16',T));
DISJ_1_2_16(T).. X('32',T) =L= BIGM('1','2','16',T)*Z('16',T);
X.up('32',T) = BIGM('1','2','16',T);
DISJ_2_2_16(T).. X('41',T) =L= BIGM('2','2','16',T)*Z('16',T);
X.up('41',T) = BIGM('2','2','16',T);

DISJ_1_1_17(T).. X('42',T) =L= X('33',T) + BIGM('1','1','17',T)*(1-Z('17',T));
DISJ_2_1_17(T).. X('42',T) =G= X('33',T) - BIGM('2','1','17',T)*(1-Z('17',T));
DISJ_1_2_17(T).. X('33',T) =L= BIGM('1','2','17',T)*Z('17',T);
X.up('33',T) = BIGM('1','2','17',T);
DISJ_2_2_17(T).. X('42',T) =L= BIGM('2','2','17',T)*Z('17',T);
X.up('42',T) = BIGM('2','2','17',T);

*DISJ_1_1_18(T).. X('43',T) =L= 0.75*LOG(1+X('34',T)) + BIGM('1','1','18',T)*(1-Z('18',T)) ;
variables X_DISJ_1_1_18(T), Y_DISJ_1_1_18(T), Z_DISJ_1_1_18(T);
Y_DISJ_1_1_18.lo(T) = 1;
Z_DISJ_1_1_18.up(T) = 1;
Z_DISJ_1_1_18.lo(T) = 1;
equation d_DISJ_1_1_18(T);
equation c_DISJ_1_1_18(T);
DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =G= Z_DISJ_1_1_18(T)*exp(X_DISJ_1_1_18(T)/Z_DISJ_1_1_18(T));
c_DISJ_1_1_18(T).. X_DISJ_1_1_18(T) =E= (X('43',T) - BIGM('1','1','18',T)*(1-Z('18',T)) )/(0.75*1);
d_DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =E= 1+X('34',T);
DISJ_1_2_18(T).. X('34',T) =L= BIGM('1','2','18',T)*Z('18',T);
X.up('34',T) = BIGM('1','2','18',T);
DISJ_2_2_18(T).. X('43',T) =L= BIGM('2','2','18',T)*Z('18',T);
X.up('43',T) = BIGM('2','2','18',T);

*DISJ_1_1_19(T).. X('44',T) =L= 0.8*LOG(1+X('35',T)) + BIGM('1','1','19',T)*(1-Z('19',T)) ;
variables X_DISJ_1_1_19(T), Y_DISJ_1_1_19(T), Z_DISJ_1_1_19(T);
Y_DISJ_1_1_19.lo(T) = 1;
Z_DISJ_1_1_19.up(T) = 1;
Z_DISJ_1_1_19.lo(T) = 1;
equation d_DISJ_1_1_19(T);
equation c_DISJ_1_1_19(T);
DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =G= Z_DISJ_1_1_19(T)*exp(X_DISJ_1_1_19(T)/Z_DISJ_1_1_19(T));
c_DISJ_1_1_19(T).. X_DISJ_1_1_19(T) =E= (X('44',T) - BIGM('1','1','19',T)*(1-Z('19',T)) )/(0.8*1);
d_DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =E= 1+X('35',T);
DISJ_1_2_19(T).. X('35',T) =L= BIGM('1','2','19',T)*Z('19',T);
X.up('35',T) = BIGM('1','2','19',T);
DISJ_2_2_19(T).. X('44',T) =L= BIGM('2','2','19',T)*Z('19',T);
X.up('44',T) = BIGM('2','2','19',T);

*DISJ_1_1_20(T).. X('45',T) =L= 0.85*LOG(1+X('36',T)) + BIGM('1','1','20',T)*(1-Z('20',T)) ;
variables X_DISJ_1_1_20(T), Y_DISJ_1_1_20(T), Z_DISJ_1_1_20(T);
Y_DISJ_1_1_20.lo(T) = 1;
Z_DISJ_1_1_20.up(T) = 1;
Z_DISJ_1_1_20.lo(T) = 1;
equation d_DISJ_1_1_20(T);
equation c_DISJ_1_1_20(T);
DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =G= Z_DISJ_1_1_20(T)*exp(X_DISJ_1_1_20(T)/Z_DISJ_1_1_20(T));
c_DISJ_1_1_20(T).. X_DISJ_1_1_20(T) =E= (X('45',T) - BIGM('1','1','20',T)*(1-Z('20',T)) )/(0.85*1);
d_DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =E= 1+X('36',T);
DISJ_1_2_20(T).. X('36',T) =L= BIGM('1','2','20',T)*Z('20',T);
X.up('36',T) = BIGM('1','2','20',T);
DISJ_2_2_20(T).. X('45',T) =L= BIGM('2','2','20',T)*Z('20',T);
X.up('45',T) = BIGM('2','2','20',T);

*DISJ_1_1_21(T).. X('49',T) =L= LOG(1+X('47',T)) + BIGM('1','1','21',T)*(1-Z('21',T));
variables X_DISJ_1_1_21(T), Y_DISJ_1_1_21(T), Z_DISJ_1_1_21(T);
Y_DISJ_1_1_21.lo(T) = 1;
Z_DISJ_1_1_21.up(T) = 1;
Z_DISJ_1_1_21.lo(T) = 1;
equation d_DISJ_1_1_21(T);
equation c_DISJ_1_1_21(T);
DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =G= Z_DISJ_1_1_21(T)*exp(X_DISJ_1_1_21(T)/Z_DISJ_1_1_21(T));
c_DISJ_1_1_21(T).. X_DISJ_1_1_21(T) =E= (X('49',T) - BIGM('1','1','21',T)*(1-Z('21',T)))/(1*1);
d_DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =E= 1+X('47',T);
DISJ_1_2_21(T).. X('47',T) =L= BIGM('1','2','21',T)*Z('21',T);
X.up('47',T) = BIGM('1','2','21',T);
DISJ_2_2_21(T).. X('49',T) =L= BIGM('2','2','21',T)*Z('21',T);
X.up('49',T) = BIGM('2','2','21',T);

*DISJ_1_1_22(T).. X('50',T) =L= 1.2*LOG(1+X('48',T)) + BIGM('1','1','22',T)*(1-Z('22',T)) ;
variables X_DISJ_1_1_22(T), Y_DISJ_1_1_22(T), Z_DISJ_1_1_22(T);
Y_DISJ_1_1_22.lo(T) = 1;
Z_DISJ_1_1_22.up(T) = 1;
Z_DISJ_1_1_22.lo(T) = 1;
equation d_DISJ_1_1_22(T);
equation c_DISJ_1_1_22(T);
DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =G= Z_DISJ_1_1_22(T)*exp(X_DISJ_1_1_22(T)/Z_DISJ_1_1_22(T));
c_DISJ_1_1_22(T).. X_DISJ_1_1_22(T) =E= (X('50',T) - BIGM('1','1','22',T)*(1-Z('22',T)) )/(1.2*1);
d_DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =E= 1+X('48',T);
DISJ_1_2_22(T).. X('48',T) =L= BIGM('1','2','22',T)*Z('22',T);
X.up('48',T) = BIGM('1','2','22',T);
DISJ_2_2_22(T).. X('50',T) =L= BIGM('2','2','22',T)*Z('22',T);
X.up('50',T) = BIGM('2','2','22',T);

DISJ_1_1_23(T).. X('58',T) =L= 0.75*X('54',T) + BIGM('1','1','23',T)*(1-Z('23',T));
DISJ_2_1_23(T).. X('58',T) =G= 0.75*X('54',T) - BIGM('2','1','23',T)*(1-Z('23',T));
DISJ_1_2_23(T).. X('54',T) =L= BIGM('1','2','23',T)*Z('23',T);
X.up('54',T) = BIGM('1','2','23',T);
DISJ_2_2_23(T).. X('58',T) =L= BIGM('2','2','23',T)*Z('23',T);
X.up('58',T) = BIGM('2','2','23',T);

*DISJ_1_1_24(T).. X('59',T) =L= 1.5*LOG(1+X('55',T)) + BIGM('1','1','24',T)*(1-Z('24',T)) ;
variables X_DISJ_1_1_24(T), Y_DISJ_1_1_24(T), Z_DISJ_1_1_24(T);
Y_DISJ_1_1_24.lo(T) = 1;
Z_DISJ_1_1_24.up(T) = 1;
Z_DISJ_1_1_24.lo(T) = 1;
equation d_DISJ_1_1_24(T);
equation c_DISJ_1_1_24(T);
DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =G= Z_DISJ_1_1_24(T)*exp(X_DISJ_1_1_24(T)/Z_DISJ_1_1_24(T));
c_DISJ_1_1_24(T).. X_DISJ_1_1_24(T) =E= (X('59',T) - BIGM('1','1','24',T)*(1-Z('24',T)) )/(1.5*1);
d_DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =E= 1+X('55',T);
DISJ_1_2_24(T).. X('55',T) =L= BIGM('1','2','24',T)*Z('24',T);
X.up('55',T) = BIGM('1','2','24',T);
DISJ_2_2_24(T).. X('59',T) =L= BIGM('2','2','24',T)*Z('24',T);
X.up('59',T) = BIGM('2','2','24',T);

DISJ_1_1_25(T).. X('60',T) =L= X('56',T) + BIGM('1','1','25',T)*(1-Z('25',T));
DISJ_2_1_25(T).. X('60',T) =G= X('56',T) - BIGM('2','1','25',T)*(1-Z('25',T));
DISJ_3_1_25(T).. X('60',T) =L= 0.5*X('57',T) + BIGM('3','1','25',T)*(1-Z('25',T));
DISJ_4_1_25(T).. X('60',T) =G= 0.5*X('57',T) - BIGM('4','1','25',T)*(1-Z('25',T));
DISJ_1_2_25(T).. X('56',T) =L= BIGM('1','2','25',T)*Z('25',T);
X.up('56',T) = BIGM('1','2','25',T);
DISJ_2_2_25(T).. X('57',T) =L= BIGM('2','2','25',T)*Z('25',T);
X.up('57',T) = BIGM('2','2','25',T);
DISJ_3_2_25(T).. X('60',T) =L= BIGM('3','2','25',T)*Z('25',T);
X.up('60',T) = BIGM('3','2','25',T);

*DISJ_1_1_26(T).. X('66',T) =L= 1.25*LOG(1+X('61',T)) + BIGM('1','1','26',T)*(1-Z('26',T)) ;
variables X_DISJ_1_1_26(T), Y_DISJ_1_1_26(T), Z_DISJ_1_1_26(T);
Y_DISJ_1_1_26.lo(T) = 1;
Z_DISJ_1_1_26.up(T) = 1;
Z_DISJ_1_1_26.lo(T) = 1;
equation d_DISJ_1_1_26(T);
equation c_DISJ_1_1_26(T);
DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =G= Z_DISJ_1_1_26(T)*exp(X_DISJ_1_1_26(T)/Z_DISJ_1_1_26(T));
c_DISJ_1_1_26(T).. X_DISJ_1_1_26(T) =E= (X('66',T) - BIGM('1','1','26',T)*(1-Z('26',T)) )/(1.25*1);
d_DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =E= 1+X('61',T);
DISJ_1_2_26(T).. X('61',T) =L= BIGM('1','2','26',T)*Z('26',T);
X.up('61',T) = BIGM('1','2','26',T);
DISJ_2_2_26(T).. X('66',T) =L= BIGM('2','2','26',T)*Z('26',T);
X.up('66',T) = BIGM('2','2','26',T);

*DISJ_1_1_27(T).. X('67',T) =L= 0.9*LOG(1+X('62',T)) + BIGM('1','1','27',T)*(1-Z('27',T)) ;
variables X_DISJ_1_1_27(T), Y_DISJ_1_1_27(T), Z_DISJ_1_1_27(T);
Y_DISJ_1_1_27.lo(T) = 1;
Z_DISJ_1_1_27.up(T) = 1;
Z_DISJ_1_1_27.lo(T) = 1;
equation d_DISJ_1_1_27(T);
equation c_DISJ_1_1_27(T);
DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =G= Z_DISJ_1_1_27(T)*exp(X_DISJ_1_1_27(T)/Z_DISJ_1_1_27(T));
c_DISJ_1_1_27(T).. X_DISJ_1_1_27(T) =E= (X('67',T) - BIGM('1','1','27',T)*(1-Z('27',T)) )/(0.9*1);
d_DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =E= 1+X('62',T);
DISJ_1_2_27(T).. X('62',T) =L= BIGM('1','2','27',T)*Z('27',T);
X.up('62',T) = BIGM('1','2','27',T);
DISJ_2_2_27(T).. X('67',T) =L= BIGM('2','2','27',T)*Z('27',T);
X.up('67',T) = BIGM('2','2','27',T);

*DISJ_1_1_28(T).. X('68',T) =L= LOG(1+X('59',T)) + BIGM('1','1','28',T)*(1-Z('28',T)) ;
variables X_DISJ_1_1_28(T), Y_DISJ_1_1_28(T), Z_DISJ_1_1_28(T);
Y_DISJ_1_1_28.lo(T) = 1;
Z_DISJ_1_1_28.up(T) = 1;
Z_DISJ_1_1_28.lo(T) = 1;
equation d_DISJ_1_1_28(T);
equation c_DISJ_1_1_28(T);
DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =G= Z_DISJ_1_1_28(T)*exp(X_DISJ_1_1_28(T)/Z_DISJ_1_1_28(T));
c_DISJ_1_1_28(T).. X_DISJ_1_1_28(T) =E= (X('68',T) - BIGM('1','1','28',T)*(1-Z('28',T)) )/(1*1);
d_DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =E= 1+X('59',T);
DISJ_1_2_28(T).. X('59',T) =L= BIGM('1','2','28',T)*Z('28',T);
X.up('59',T) = BIGM('1','2','28',T);
DISJ_2_2_28(T).. X('68',T) =L= BIGM('2','2','28',T)*Z('28',T);
X.up('68',T) = BIGM('2','2','28',T);

DISJ_1_1_29(T).. X('69',T) =L= 0.9*X('63',T) + BIGM('1','1','29',T)*(1-Z('29',T));
DISJ_2_1_29(T).. X('69',T) =G= 0.9*X('63',T) - BIGM('2','1','29',T)*(1-Z('29',T));
DISJ_1_2_29(T).. X('63',T) =L= BIGM('1','2','29',T)*Z('29',T);
X.up('63',T) = BIGM('1','2','29',T);
DISJ_2_2_29(T).. X('69',T) =L= BIGM('2','2','29',T)*Z('29',T);
X.up('69',T) = BIGM('2','2','29',T);

DISJ_1_1_30(T).. X('70',T) =L= 0.6*X('64',T) + BIGM('1','1','30',T)*(1-Z('30',T));
DISJ_2_1_30(T).. X('70',T) =G= 0.6*X('64',T) - BIGM('2','1','30',T)*(1-Z('30',T));
DISJ_1_2_30(T).. X('64',T) =L= BIGM('1','2','30',T)*Z('30',T);
X.up('64',T) = BIGM('1','2','30',T);
DISJ_2_2_30(T).. X('70',T) =L= BIGM('2','2','30',T)*Z('30',T);
X.up('70',T) = BIGM('2','2','30',T);

*DISJ_1_1_31(T).. X('71',T) =L= 1.1*LOG(1+X('65',T)) + BIGM('1','1','31',T)*(1-Z('31',T)) ;
variables X_DISJ_1_1_31(T), Y_DISJ_1_1_31(T), Z_DISJ_1_1_31(T);
Y_DISJ_1_1_31.lo(T) = 1;
Z_DISJ_1_1_31.up(T) = 1;
Z_DISJ_1_1_31.lo(T) = 1;
equation d_DISJ_1_1_31(T);
equation c_DISJ_1_1_31(T);
DISJ_1_1_31(T).. Y_DISJ_1_1_31(T) =G= Z_DISJ_1_1_31(T)*exp(X_DISJ_1_1_31(T)/Z_DISJ_1_1_31(T));
c_DISJ_1_1_31(T).. X_DISJ_1_1_31(T) =E= (X('71',T) - BIGM('1','1','31',T)*(1-Z('31',T)) )/(1.1*1);
d_DISJ_1_1_31(T).. Y_DISJ_1_1_31(T) =E= 1+X('65',T);
DISJ_1_2_31(T).. X('65',T) =L= BIGM('1','2','31',T)*Z('31',T);
X.up('65',T) = BIGM('1','2','31',T);
DISJ_2_2_31(T).. X('71',T) =L= BIGM('2','2','31',T)*Z('31',T);
X.up('71',T) = BIGM('2','2','31',T);

DISJ_1_1_32(T).. X('82',T) =L= 0.9*X('66',T) + BIGM('1','1','32',T)*(1-Z('32',T));
DISJ_2_1_32(T).. X('82',T) =G= 0.9*X('66',T) - BIGM('2','1','32',T)*(1-Z('32',T));
DISJ_3_1_32(T).. X('82',T) =L= X('74',T) + BIGM('3','1','32',T)*(1-Z('32',T));
DISJ_4_1_32(T).. X('82',T) =G= X('74',T) - BIGM('4','1','32',T)*(1-Z('32',T));
DISJ_1_2_32(T).. X('66',T) =L= BIGM('1','2','32',T)*Z('32',T);
X.up('66',T) = BIGM('1','2','32',T);
DISJ_2_2_32(T).. X('74',T) =L= BIGM('2','2','32',T)*Z('32',T);
X.up('74',T) = BIGM('2','2','32',T);
DISJ_3_2_32(T).. X('82',T) =L= BIGM('3','2','32',T)*Z('32',T);
X.up('82',T) = BIGM('3','2','32',T);

*DISJ_1_1_33(T).. X('83',T) =L= LOG(1+X('67',T)) + BIGM('1','1','33',T)*(1-Z('33',T)) ;
variables X_DISJ_1_1_33(T), Y_DISJ_1_1_33(T), Z_DISJ_1_1_33(T);
Y_DISJ_1_1_33.lo(T) = 1;
Z_DISJ_1_1_33.up(T) = 1;
Z_DISJ_1_1_33.lo(T) = 1;
equation d_DISJ_1_1_33(T);
equation c_DISJ_1_1_33(T);
DISJ_1_1_33(T).. Y_DISJ_1_1_33(T) =G= Z_DISJ_1_1_33(T)*exp(X_DISJ_1_1_33(T)/Z_DISJ_1_1_33(T));
c_DISJ_1_1_33(T).. X_DISJ_1_1_33(T) =E= (X('83',T) - BIGM('1','1','33',T)*(1-Z('33',T)) )/(1*1);
d_DISJ_1_1_33(T).. Y_DISJ_1_1_33(T) =E= 1+X('67',T);
DISJ_1_2_33(T).. X('67',T) =L= BIGM('1','2','33',T)*Z('33',T);
X.up('67',T) = BIGM('1','2','33',T);
DISJ_2_2_33(T).. X('83',T) =L= BIGM('2','2','33',T)*Z('33',T);
X.up('83',T) = BIGM('2','2','33',T);

*DISJ_1_1_34(T).. X('84',T) =L= 0.7*LOG(1+X('72',T)) + BIGM('1','1','34',T)*(1-Z('34',T)) ;
variables X_DISJ_1_1_34(T), Y_DISJ_1_1_34(T), Z_DISJ_1_1_34(T);
Y_DISJ_1_1_34.lo(T) = 1;
Z_DISJ_1_1_34.up(T) = 1;
Z_DISJ_1_1_34.lo(T) = 1;
equation d_DISJ_1_1_34(T);
equation c_DISJ_1_1_34(T);
DISJ_1_1_34(T).. Y_DISJ_1_1_34(T) =G= Z_DISJ_1_1_34(T)*exp(X_DISJ_1_1_34(T)/Z_DISJ_1_1_34(T));
c_DISJ_1_1_34(T).. X_DISJ_1_1_34(T) =E= (X('84',T) - BIGM('1','1','34',T)*(1-Z('34',T)) )/(0.7*1);
d_DISJ_1_1_34(T).. Y_DISJ_1_1_34(T) =E= 1+X('72',T);
DISJ_1_2_34(T).. X('72',T) =L= BIGM('1','2','34',T)*Z('34',T);
X.up('72',T) = BIGM('1','2','34',T);
DISJ_2_2_34(T).. X('84',T) =L= BIGM('2','2','34',T)*Z('34',T);
X.up('84',T) = BIGM('2','2','34',T);

*DISJ_1_1_35(T).. X('85',T) =L= 0.65*LOG(1+X('73',T)) + BIGM('1','1','35',T)*(1-Z('35',T)) ;
variables X_DISJ_1_1_35(T), Y_DISJ_1_1_35(T), Z_DISJ_1_1_35(T);
Y_DISJ_1_1_35.lo(T) = 1;
Z_DISJ_1_1_35.up(T) = 1;
Z_DISJ_1_1_35.lo(T) = 1;
equation d_DISJ_1_1_35(T);
equation c_DISJ_1_1_35(T);
DISJ_1_1_35(T).. Y_DISJ_1_1_35(T) =G= Z_DISJ_1_1_35(T)*exp(X_DISJ_1_1_35(T)/Z_DISJ_1_1_35(T));
c_DISJ_1_1_35(T).. X_DISJ_1_1_35(T) =E= (X('85',T) - BIGM('1','1','35',T)*(1-Z('35',T)) )/(0.65*1);
d_DISJ_1_1_35(T).. Y_DISJ_1_1_35(T) =E= 1+X('73',T);
*DISJ_2_1_35(T).. X('85',T) =L= 0.65*LOG(1+X('76',T)) + BIGM('2','1','35',T)*(1-Z('35',T)) ;
variables X_DISJ_2_1_35(T), Y_DISJ_2_1_35(T), Z_DISJ_2_1_35(T);
Y_DISJ_2_1_35.lo(T) = 1;
Z_DISJ_2_1_35.up(T) = 1;
Z_DISJ_2_1_35.lo(T) = 1;
equation d_DISJ_2_1_35(T);
equation c_DISJ_2_1_35(T);
DISJ_2_1_35(T).. Y_DISJ_2_1_35(T) =G= Z_DISJ_2_1_35(T)*exp(X_DISJ_2_1_35(T)/Z_DISJ_2_1_35(T));
c_DISJ_2_1_35(T).. X_DISJ_2_1_35(T) =E= (X('85',T) - BIGM('2','1','35',T)*(1-Z('35',T)) )/(0.65*1);
d_DISJ_2_1_35(T).. Y_DISJ_2_1_35(T) =E= 1+X('76',T);
DISJ_1_2_35(T).. X('73',T) =L= BIGM('1','2','35',T)*Z('35',T);
X.up('73',T) = BIGM('1','2','35',T);
DISJ_2_2_35(T).. X('76',T) =L= BIGM('2','2','35',T)*Z('35',T);
X.up('76',T) = BIGM('2','2','35',T);
DISJ_3_2_35(T).. X('85',T) =L= BIGM('3','2','35',T)*Z('35',T);
X.up('85',T) = BIGM('3','2','35',T);

DISJ_1_1_36(T).. X('86',T) =L= X('77',T) + BIGM('1','1','36',T)*(1-Z('36',T));
DISJ_2_1_36(T).. X('86',T) =G= X('77',T) - BIGM('2','1','36',T)*(1-Z('36',T));
DISJ_1_2_36(T).. X('77',T) =L= BIGM('1','2','36',T)*Z('36',T);
X.up('77',T) = BIGM('1','2','36',T);
DISJ_2_2_36(T).. X('86',T) =L= BIGM('2','2','36',T)*Z('36',T);
X.up('86',T) = BIGM('2','2','36',T);

DISJ_1_1_37(T).. X('87',T) =L= X('78',T) + BIGM('1','1','37',T)*(1-Z('37',T));
DISJ_2_1_37(T).. X('87',T) =G= X('78',T) - BIGM('2','1','37',T)*(1-Z('37',T));
DISJ_1_2_37(T).. X('78',T) =L= BIGM('1','2','37',T)*Z('37',T);
X.up('78',T) = BIGM('1','2','37',T);
DISJ_2_2_37(T).. X('87',T) =L= BIGM('2','2','37',T)*Z('37',T);
X.up('87',T) = BIGM('2','2','37',T);

*DISJ_1_1_38(T).. X('88',T) =L= 0.75*LOG(1+X('79',T)) + BIGM('1','1','38',T)*(1-Z('38',T)) ;
variables X_DISJ_1_1_38(T), Y_DISJ_1_1_38(T), Z_DISJ_1_1_38(T);
Y_DISJ_1_1_38.lo(T) = 1;
Z_DISJ_1_1_38.up(T) = 1;
Z_DISJ_1_1_38.lo(T) = 1;
equation d_DISJ_1_1_38(T);
equation c_DISJ_1_1_38(T);
DISJ_1_1_38(T).. Y_DISJ_1_1_38(T) =G= Z_DISJ_1_1_38(T)*exp(X_DISJ_1_1_38(T)/Z_DISJ_1_1_38(T));
c_DISJ_1_1_38(T).. X_DISJ_1_1_38(T) =E= (X('88',T) - BIGM('1','1','38',T)*(1-Z('38',T)) )/(0.75*1);
d_DISJ_1_1_38(T).. Y_DISJ_1_1_38(T) =E= 1+X('79',T);
DISJ_1_2_38(T).. X('79',T) =L= BIGM('1','2','38',T)*Z('38',T);
X.up('79',T) = BIGM('1','2','38',T);
DISJ_2_2_38(T).. X('88',T) =L= BIGM('2','2','38',T)*Z('38',T);
X.up('88',T) = BIGM('2','2','38',T);

*DISJ_1_1_39(T).. X('89',T) =L= 0.8*LOG(1+X('80',T)) + BIGM('1','1','39',T)*(1-Z('39',T)) ;
variables X_DISJ_1_1_39(T), Y_DISJ_1_1_39(T), Z_DISJ_1_1_39(T);
Y_DISJ_1_1_39.lo(T) = 1;
Z_DISJ_1_1_39.up(T) = 1;
Z_DISJ_1_1_39.lo(T) = 1;
equation d_DISJ_1_1_39(T);
equation c_DISJ_1_1_39(T);
DISJ_1_1_39(T).. Y_DISJ_1_1_39(T) =G= Z_DISJ_1_1_39(T)*exp(X_DISJ_1_1_39(T)/Z_DISJ_1_1_39(T));
c_DISJ_1_1_39(T).. X_DISJ_1_1_39(T) =E= (X('89',T) - BIGM('1','1','39',T)*(1-Z('39',T)) )/(0.8*1);
d_DISJ_1_1_39(T).. Y_DISJ_1_1_39(T) =E= 1+X('80',T);
DISJ_1_2_39(T).. X('80',T) =L= BIGM('1','2','39',T)*Z('39',T);
X.up('80',T) = BIGM('1','2','39',T);
DISJ_2_2_39(T).. X('89',T) =L= BIGM('2','2','39',T)*Z('39',T);
X.up('89',T) = BIGM('2','2','39',T);

*DISJ_1_1_40(T).. X('90',T) =L= 0.85*LOG(1+X('81',T)) + BIGM('1','1','40',T)*(1-Z('40',T)) ;
variables X_DISJ_1_1_40(T), Y_DISJ_1_1_40(T), Z_DISJ_1_1_40(T);
Y_DISJ_1_1_40.lo(T) = 1;
Z_DISJ_1_1_40.up(T) = 1;
Z_DISJ_1_1_40.lo(T) = 1;
equation d_DISJ_1_1_40(T);
equation c_DISJ_1_1_40(T);
DISJ_1_1_40(T).. Y_DISJ_1_1_40(T) =G= Z_DISJ_1_1_40(T)*exp(X_DISJ_1_1_40(T)/Z_DISJ_1_1_40(T));
c_DISJ_1_1_40(T).. X_DISJ_1_1_40(T) =E= (X('90',T) - BIGM('1','1','40',T)*(1-Z('40',T)) )/(0.85*1);
d_DISJ_1_1_40(T).. Y_DISJ_1_1_40(T) =E= 1+X('81',T);
DISJ_1_2_40(T).. X('81',T) =L= BIGM('1','2','40',T)*Z('40',T);
X.up('81',T) = BIGM('1','2','40',T);
DISJ_2_2_40(T).. X('90',T) =L= BIGM('2','2','40',T)*Z('40',T);
X.up('90',T) = BIGM('2','2','40',T);

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
L2(T)..  -Z('6',T) + Z('12',T)                            =G= 0;
L3(T)..  -Z('7',T) + Z('13',T)                            =G= 0;
L4(T)..  -Z('4',T) + Z('8',T)                             =G= 0;
L5(T)..  -Z('8',T) + Z('14',T) + Z('15',T)                =G= 0;
L6(T)..  -Z('5',T) + Z('9',T) + Z('10',T) + Z('11',T)     =G= 0;
L7(T)..  -Z('9',T) + Z('15',T)                            =G= 0;
L8(T)..  -Z('10',T) + Z('16',T) + Z('17',T)               =G= 0;
L9(T)..  -Z('11',T) + Z('18',T) + Z('19',T) + Z('20',T)   =G= 0;
L10(T).. -Z('6',T) + Z('3',T)                             =G= 0;
L11(T).. -Z('7',T) + Z('3',T)                             =G= 0;
L12(T).. -Z('8',T) + Z('4',T)                             =G= 0;
L13(T).. -Z('9',T) + Z('5',T)                             =G= 0;
L14(T).. -Z('10',T) + Z('5',T)                            =G= 0;
L15(T).. -Z('11',T) + Z('5',T)                            =G= 0;
L16(T).. -Z('12',T) + Z('6',T)                            =G= 0;
L17(T).. -Z('13',T) + Z('7',T)                            =G= 0;
L18(T).. -Z('14',T) + Z('8',T)                            =G= 0;
L19(T).. -Z('15',T) + Z('8',T)                            =G= 0;
L20(T).. -Z('16',T) + Z('10',T)                           =G= 0;
L21(T).. -Z('17',T) + Z('10',T)                           =G= 0;
L22(T).. -Z('18',T) + Z('11',T)                           =G= 0;
L23(T).. -Z('19',T) + Z('11',T)                           =G= 0;
L24(T).. -Z('20',T) + Z('11',T)                           =G= 0;

L25(T).. -Z('20',T) + Z('21',T) + Z('22',T)               =G= 0;
L26(T).. -Z('23',T) + Z('26',T) + Z('27',T)               =G= 0;
L27(T).. -Z('26',T) + Z('32',T)                           =G= 0;
L28(T).. -Z('27',T) + Z('33',T)                           =G= 0;
L29(T).. -Z('24',T) + Z('28',T)                           =G= 0;
L30(T).. -Z('28',T) + Z('34',T) + Z('35',T)               =G= 0;
L31(T).. -Z('25',T) + Z('29',T) + Z('30',T) + Z('31',T)   =G= 0;
L32(T).. -Z('29',T) + Z('35',T)                           =G= 0;
L33(T).. -Z('30',T) + Z('36',T) + Z('37',T)               =G= 0;
L34(T).. -Z('31',T) + Z('38',T) + Z('39',T) + Z('40',T)   =G= 0;
L35(T).. -Z('26',T) + Z('23',T)                           =G= 0;
L36(T).. -Z('27',T) + Z('23',T)                           =G= 0;
L37(T).. -Z('32',T) + Z('26',T)                           =G= 0;
L38(T).. -Z('33',T) + Z('27',T)                           =G= 0;
L39(T).. -Z('28',T) + Z('24',T)                           =G= 0;
L40(T).. -Z('34',T) + Z('28',T)                           =G= 0;
L41(T).. -Z('35',T) + Z('28',T)                           =G= 0;
L42(T).. -Z('29',T) + Z('25',T)                           =G= 0;
L43(T).. -Z('30',T) + Z('25',T)                           =G= 0;
L44(T).. -Z('31',T) + Z('25',T)                           =G= 0;
L45(T).. -Z('36',T) + Z('30',T)                           =G= 0;
L46(T).. -Z('37',T) + Z('30',T)                           =G= 0;
L47(T).. -Z('38',T) + Z('31',T)                           =G= 0;
L48(T).. -Z('39',T) + Z('31',T)                           =G= 0;
L49(T).. -Z('40',T) + Z('31',T)                           =G= 0;
L50(T).. -Z('3',T) + Z('1',T) + Z('2',T)                  =G= 0;
L51(T).. -Z('4',T) + Z('1',T) + Z('2',T)                  =G= 0;
L52(T).. -Z('5',T) + Z('1',T) + Z('2',T)                  =G= 0;
L53(T).. -Z('21',T) + Z('20',T)                           =G= 0;
L54(T).. -Z('22',T) + Z('20',T)                           =G= 0;

* Bounds
X.UP('1',T) = 10;
X.UP('12',T) = 7;
X.UP('29',T) = 7;
X.UP('30',T) = 5;
X.UP('57',T) = 7;
X.UP('74',T) = 7;
X.UP('75',T) = 5;

MODEL SYNTH_40_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_40_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
