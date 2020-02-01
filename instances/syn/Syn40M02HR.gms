*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Convexification by sum disaggregation and binary continuous product linearization (done twice)
*disj.. z + v2 >= z*exp(x) <=> x <= log((z+v2)/z) ; c*z*x = c*w >= v1;
*y = z*exp(x): y >= z; y <= exp(v1_ub/c)*z;    y >= exp(x) - (1-z)*exp(v1_ub/c);   y <= exp(x) - (1-z) (removed because nonconvex and inactive)
*w = z*x: w >= 0; c*w <= v1_up*z; c*w >= c*x - (1-z)*v1_ub; w <= x;
*Synthesis Problem with 40 processes
*Two Periods (t=2)
*Convex Hull Version

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

I       /1*40/                            /* Number of process units */
K       /1*90/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */
;

ALIAS

(T,TAU)
;

*Epsilon used for RHS of non-linear constraints in disjunctions.
SCALAR  ES      /1E-6/;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

X(K,T)
V(K,D,I,T)
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
                1       -1     -1
                2       0       0
                3       0       0
                4       0       0
                5       0       0
                6       0       0
                7       5      10
                8       0       0
                9       0       0
                10      0       0
                11      0       0
                12      -1     -1
                13      0       0
                14      0       0
                15      0       0
                16      0       0
                17      0       0
                18      0       0
                19      0       0
                20      0       0
                21      0       0
                22      0       0
                23      0       0
                24      0       0
                25      0       0
                26      0       0
                27      0       0
                28      0       0
                29      -10    -5
                30      -5     -5
                31      0       0
                32      0       0
                33      0       0
                34      0       0
                35      0       0
                36      0       0
                37      40     30
                38      15     20
                39      10     30
                40      30     20
                41      35     50
                42      20     30
                43      25     50
                44      15     20
                45      0       0
                46      0       0
                47      0       0
                48      0       0
                49      0       0
                50      0       0
                51      0       0
                52      30     40
                53      0       0
                54      0       0
                55      0       0
                56      0       0
                57      -1     -1
                58      0       0
                59      0       0
                60      0       0
                61      0       0
                62      0       0
                63      0       0
                64      0       0
                65      0       0
                66      0       0
                67      0       0
                68      0       0
                69      0       0
                70      0       0
                71      0       0
                72      0       0
                73      0       0
                74      -5     -3
                75      -1     -1
                76      0       0
                77      0       0
                78      0       0
                79      0       0
                80      0       0
                81      0       0
                82      220    210
                83      240    220
                84      190    160
                85      190    190
                86      385    490
                87      390    505
                88      480    600
                89      490    600
                90      550    550

TABLE FC(I,T)             /* Fixed costs in objective */
                         1        2
                1       -5       -4
                2       -8       -7
                3       -6       -9
                4       -10      -9
                5       -6       -10
                6       -7       -7
                7       -4       -3
                8       -5       -6
                9       -2       -5
                10      -4       -7
                11      -3       -9
                12      -7       -2
                13      -3       -1
                14      -2       -6
                15      -4       -8
                16      -2       -5
                17      -3       -4
                18      -5       -7
                19      -2       -8
                20      -1       -4
                21      -2       -5
                22      -9       -2
                23      -5       -8
                24      -2       -3
                25      -10      -6
                26      -4       -8
                27      -7       -3
                28      -4       -8
                29      -2       -1
                30      -8       -3
                31      -9       -5
                32      -3       -9
                33      -5       -3
                34      -5       -3
                35      -6       -4
                36      -2       -6
                37      -6       -4
                38      -3       -2
                39      -5       -8
                40      -9       -5
;

PARAMETER UB(K,D,I,T) /1*90 .1*2 .1*40 .1*2= 0/;

*Note: The bounds available on X('1'), X('12'), X('29'), X('30'), X('57'), X('74') and X('75') were written as X1_UP, X12_UP, X29_UP, X30_UP, X57_UP, X74_UP and X75_UP below in order to generate the optimal upper bounds on the disaggregated variables.


PARAMETERS
X1_UP(T)
/1 = 10
 2 = 10/

X12_UP(T)
/1 = 7
 2 = 7/

X29_UP(T)
/1 = 7
 2 = 7/

X30_UP(T)
/1 = 5
 2 = 5/

X57_UP(T)
/1 = 7
 2 = 7/

X74_UP(T)
/1 = 7
 2 = 7/

X75_UP(T)
/1 = 5
 2 = 5/;


UB('2','1','1',T) = X1_UP(T);
UB('2','2','1',T) = X1_UP(T);
UB('4','1','1',T) = LOG(1+X1_UP(T));
UB('4','2','1',T) = LOG(1+X1_UP(T));

UB('3','1','2',T) = X1_UP(T);
UB('3','2','2',T) = X1_UP(T);
UB('5','1','2',T) = 1.2*LOG(1+X1_UP(T));
UB('5','2','2',T) = 1.2*LOG(1+X1_UP(T));

UB('9','1','3',T) = 1.2*LOG(1+X1_UP(T));
UB('9','2','3',T) = 1.2*LOG(1+X1_UP(T));
UB('13','1','3',T) = 0.75*1.2*LOG(1+X1_UP(T));
UB('13','2','3',T) = 0.75*1.2*LOG(1+X1_UP(T));

UB('10','1','4',T) = 1.2*LOG(1+X1_UP(T));
UB('10','2','4',T) = 1.2*LOG(1+X1_UP(T));
UB('14','1','4',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));
UB('14','2','4',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));

UB('11','1','5',T) = 1.2*LOG(1+X1_UP(T));
UB('11','2','5',T) = 1.2*LOG(1+X1_UP(T));
UB('12','1','5',T) = X12_UP(T);
UB('12','2','5',T) = X12_UP(T);
UB('15','1','5',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('15','2','5',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));

UB('16','1','6',T) = 0.75*1.2*LOG(1+X1_UP(T));
UB('16','2','6',T) = 0.75*1.2*LOG(1+X1_UP(T));
UB('21','1','6',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('21','2','6',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));

UB('17','1','7',T) = 0.75*1.2*LOG(1+X1_UP(T));
UB('17','2','7',T) = 0.75*1.2*LOG(1+X1_UP(T));
UB('22','1','7',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('22','2','7',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));

UB('14','1','8',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));
UB('14','2','8',T) = 1.5*LOG(1+(1.2*LOG(1+X1_UP(T))));
UB('23','1','8',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
UB('23','2','8',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));

UB('18','1','9',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('18','2','9',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('24','1','9',T) = 0.9*(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T)));
UB('24','2','9',T) = 0.9*(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T)));

UB('19','1','10',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('19','2','10',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('25','1','10',T) = 0.6*(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T)));
UB('25','2','10',T) = 0.6*(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T)));

UB('20','1','11',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('20','2','11',T) = MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T));
UB('26','1','11',T) = 1.1*LOG(1+(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T))));
UB('26','2','11',T) = 1.1*LOG(1+(MAX(1.2*LOG(1+X1_UP(T)), 0.5*X12_UP(T))));

UB('21','1','12',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('21','2','12',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('29','1','12',T) = X29_UP(T);
UB('29','2','12',T) = X29_UP(T);
UB('37','1','12',T) = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))), X29_UP(T));
UB('37','2','12',T) = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))), X29_UP(T));

UB('22','1','13',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('22','2','13',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))));
UB('38','1','13',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))));
UB('38','2','13',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP(T))))));

UB('27','1','14',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
UB('27','2','14',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
UB('39','1','14',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))));
UB('39','2','14',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))));

UB('28','1','15',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
UB('28','2','15',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))));
UB('31','1','15',T) = X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('31','2','15',T) = X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('40','1','15',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))), 0.65*LOG(1+ (X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('40','2','15',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP(T))))))), 0.65*LOG(1+ (X30_UP(T) + 0.9*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

UB('32','1','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('32','2','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('41','1','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('41','2','16',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

UB('33','1','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('33','2','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('42','1','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));
UB('42','2','17',T) = 0.6*MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T));

UB('34','1','18',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('34','2','18',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('43','1','18',T) = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('43','2','18',T) = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

UB('35','1','19',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('35','2','19',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('44','1','19',T) = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('44','2','19',T) = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

UB('36','1','20',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('36','2','20',T) = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)));
UB('45','1','20',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('45','2','20',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));

*For values of UB in the range of 21-40, simply replace the upper bound of X('1') wherever it's present in 1-20 with the upper bound of X('45') (i.e. replace X1_UB with 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))
UB('47','1','21',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('47','2','21',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('49','1','21',T) = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('49','2','21',T) = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

UB('48','1','22',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('48','2','22',T) = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))));
UB('50','1','22',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('50','2','22',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

UB('54','1','23',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('54','2','23',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('58','1','23',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('58','2','23',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));

UB('55','1','24',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('55','2','24',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('59','1','24',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('59','2','24',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

UB('56','1','25',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('56','2','25',T) = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('57','1','25',T) = X57_UP(T);
UB('57','2','25',T) = X57_UP(T);
UB('60','1','25',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('60','2','25',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

UB('61','1','26',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('61','2','26',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('66','1','26',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('66','2','26',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

UB('62','1','27',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('62','2','27',T) = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))));
UB('67','1','27',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('67','2','27',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));

UB('59','1','28',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('59','2','28',T) = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('68','1','28',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('68','2','28',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));

UB('63','1','29',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('63','2','29',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('69','1','29',T) = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('69','2','29',T) = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

UB('64','1','30',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('64','2','30',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('70','1','30',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('70','2','30',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

UB('65','1','31',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('65','2','31',T) = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('71','1','31',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('71','2','31',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));

UB('66','1','32',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('66','2','32',T) = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('74','1','32',T) = X74_UP(T);
UB('74','2','32',T) = X74_UP(T);
UB('82','1','32',T) = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))))), X74_UP(T));
UB('82','2','32',T) = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))))), X74_UP(T));

UB('67','1','33',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('67','2','33',T) = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))));
UB('83','1','33',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('83','2','33',T) = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));

UB('72','1','34',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('72','2','34',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('84','1','34',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))));
UB('84','2','34',T) = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))));

UB('73','1','35',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('73','2','35',T) = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))));
UB('76','1','35',T) = X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('76','2','35',T) = X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('85','1','35',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))), 0.65*LOG(1+X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));
UB('85','2','35',T) = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T))))))))))), 0.65*LOG(1+X75_UP(T) + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

UB('77','1','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('77','2','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('86','1','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('86','2','36',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

UB('78','1','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('78','2','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('87','1','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));
UB('87','2','37',T) = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T));

UB('79','1','38',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('79','2','38',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('88','1','38',T) = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));
UB('88','2','38',T) = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

UB('80','1','39',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('80','2','39',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('89','1','39',T) = 0.8*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));
UB('89','2','39',T) = 0.8*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));

UB('81','1','40',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('81','2','40',T) = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T)));
UB('90','1','40',T) = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));
UB('90','2','40',T) = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP(T)),0.5*X12_UP(T)))))), 0.5*X57_UP(T))));


****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1(T),MB2(T),MB3(T),MB4(T),MB5(T),MB6(T),MB7(T),MB8(T),MB9(T),MB10(T),
MB11(T),MB12(T),MB13(T),MB14(T),MB15(T),MB16(T),MB17(T),MB18(T),MB19(T),MB20(T),MB21(T)

DISJ_1_1_1(T)
DISJ_1_2_1(T)
DISJ_2_2_1(T)
DISJ_1_3_1(T)
DISJ_2_3_1(T)
DISJ_1_4_1(T)
DISJ_2_4_1(T)
DISJ_3_4_1(T)
DISJ_4_4_1(T)

DISJ_1_1_2(T)
DISJ_1_2_2(T)
DISJ_2_2_2(T)
DISJ_1_3_2(T)
DISJ_2_3_2(T)
DISJ_1_4_2(T)
DISJ_2_4_2(T)
DISJ_3_4_2(T)
DISJ_4_4_2(T)

DISJ_1_1_3(T)
DISJ_1_2_3(T)
DISJ_2_2_3(T)
DISJ_1_3_3(T)
DISJ_2_3_3(T)
DISJ_1_4_3(T)
DISJ_2_4_3(T)
DISJ_3_4_3(T)
DISJ_4_4_3(T)

DISJ_1_1_4(T)
DISJ_1_2_4(T)
DISJ_2_2_4(T)
DISJ_1_3_4(T)
DISJ_2_3_4(T)
DISJ_1_4_4(T)
DISJ_2_4_4(T)
DISJ_3_4_4(T)
DISJ_4_4_4(T)

DISJ_1_1_5(T)
DISJ_2_1_5(T)
DISJ_1_2_5(T)
DISJ_2_2_5(T)
DISJ_3_2_5(T)
DISJ_1_3_5(T)
DISJ_2_3_5(T)
DISJ_3_3_5(T)
DISJ_1_4_5(T)
DISJ_2_4_5(T)
DISJ_3_4_5(T)
DISJ_4_4_5(T)
DISJ_5_4_5(T)
DISJ_6_4_5(T)

DISJ_1_1_6(T)
DISJ_1_2_6(T)
DISJ_2_2_6(T)
DISJ_1_3_6(T)
DISJ_2_3_6(T)
DISJ_1_4_6(T)
DISJ_2_4_6(T)
DISJ_3_4_6(T)
DISJ_4_4_6(T)

DISJ_1_1_7(T)
DISJ_1_2_7(T)
DISJ_2_2_7(T)
DISJ_1_3_7(T)
DISJ_2_3_7(T)
DISJ_1_4_7(T)
DISJ_2_4_7(T)
DISJ_3_4_7(T)
DISJ_4_4_7(T)

DISJ_1_1_8(T)
DISJ_1_2_8(T)
DISJ_2_2_8(T)
DISJ_1_3_8(T)
DISJ_2_3_8(T)
DISJ_1_4_8(T)
DISJ_2_4_8(T)
DISJ_3_4_8(T)
DISJ_4_4_8(T)

DISJ_1_1_9(T)
DISJ_1_2_9(T)
DISJ_2_2_9(T)
DISJ_1_3_9(T)
DISJ_2_3_9(T)
DISJ_1_4_9(T)
DISJ_2_4_9(T)
DISJ_3_4_9(T)
DISJ_4_4_9(T)

DISJ_1_1_10(T)
DISJ_1_2_10(T)
DISJ_2_2_10(T)
DISJ_1_3_10(T)
DISJ_2_3_10(T)
DISJ_1_4_10(T)
DISJ_2_4_10(T)
DISJ_3_4_10(T)
DISJ_4_4_10(T)

DISJ_1_1_11(T)
DISJ_1_2_11(T)
DISJ_2_2_11(T)
DISJ_1_3_11(T)
DISJ_2_3_11(T)
DISJ_1_4_11(T)
DISJ_2_4_11(T)
DISJ_3_4_11(T)
DISJ_4_4_11(T)

DISJ_1_1_12(T)
DISJ_2_1_12(T)
DISJ_1_2_12(T)
DISJ_2_2_12(T)
DISJ_3_2_12(T)
DISJ_1_3_12(T)
DISJ_2_3_12(T)
DISJ_3_3_12(T)
DISJ_1_4_12(T)
DISJ_2_4_12(T)
DISJ_3_4_12(T)
DISJ_4_4_12(T)
DISJ_5_4_12(T)
DISJ_6_4_12(T)

DISJ_1_1_13(T)
DISJ_1_2_13(T)
DISJ_2_2_13(T)
DISJ_1_3_13(T)
DISJ_2_3_13(T)
DISJ_1_4_13(T)
DISJ_2_4_13(T)
DISJ_3_4_13(T)
DISJ_4_4_13(T)

DISJ_1_1_14(T)
DISJ_1_2_14(T)
DISJ_2_2_14(T)
DISJ_1_3_14(T)
DISJ_2_3_14(T)
DISJ_1_4_14(T)
DISJ_2_4_14(T)
DISJ_3_4_14(T)
DISJ_4_4_14(T)

DISJ_1_1_15(T)
DISJ_2_1_15(T)
DISJ_1_2_15(T)
DISJ_2_2_15(T)
DISJ_3_2_15(T)
DISJ_1_3_15(T)
DISJ_2_3_15(T)
DISJ_3_3_15(T)
DISJ_1_4_15(T)
DISJ_2_4_15(T)
DISJ_3_4_15(T)
DISJ_4_4_15(T)
DISJ_5_4_15(T)
DISJ_6_4_15(T)

DISJ_1_1_16(T)
DISJ_1_2_16(T)
DISJ_2_2_16(T)
DISJ_1_3_16(T)
DISJ_2_3_16(T)
DISJ_1_4_16(T)
DISJ_2_4_16(T)
DISJ_3_4_16(T)
DISJ_4_4_16(T)

DISJ_1_1_17(T)
DISJ_1_2_17(T)
DISJ_2_2_17(T)
DISJ_1_3_17(T)
DISJ_2_3_17(T)
DISJ_1_4_17(T)
DISJ_2_4_17(T)
DISJ_3_4_17(T)
DISJ_4_4_17(T)

DISJ_1_1_18(T)
DISJ_1_2_18(T)
DISJ_2_2_18(T)
DISJ_1_3_18(T)
DISJ_2_3_18(T)
DISJ_1_4_18(T)
DISJ_2_4_18(T)
DISJ_3_4_18(T)
DISJ_4_4_18(T)

DISJ_1_1_19(T)
DISJ_1_2_19(T)
DISJ_2_2_19(T)
DISJ_1_3_19(T)
DISJ_2_3_19(T)
DISJ_1_4_19(T)
DISJ_2_4_19(T)
DISJ_3_4_19(T)
DISJ_4_4_19(T)

DISJ_1_1_20(T)
DISJ_1_2_20(T)
DISJ_2_2_20(T)
DISJ_1_3_20(T)
DISJ_2_3_20(T)
DISJ_1_4_20(T)
DISJ_2_4_20(T)
DISJ_3_4_20(T)
DISJ_4_4_20(T)

DISJ_1_1_21(T)
DISJ_1_2_21(T)
DISJ_2_2_21(T)
DISJ_1_3_21(T)
DISJ_2_3_21(T)
DISJ_1_4_21(T)
DISJ_2_4_21(T)
DISJ_3_4_21(T)
DISJ_4_4_21(T)

DISJ_1_1_22(T)
DISJ_1_2_22(T)
DISJ_2_2_22(T)
DISJ_1_3_22(T)
DISJ_2_3_22(T)
DISJ_1_4_22(T)
DISJ_2_4_22(T)
DISJ_3_4_22(T)
DISJ_4_4_22(T)

DISJ_1_1_23(T)
DISJ_1_2_23(T)
DISJ_2_2_23(T)
DISJ_1_3_23(T)
DISJ_2_3_23(T)
DISJ_1_4_23(T)
DISJ_2_4_23(T)
DISJ_3_4_23(T)
DISJ_4_4_23(T)

DISJ_1_1_24(T)
DISJ_1_2_24(T)
DISJ_2_2_24(T)
DISJ_1_3_24(T)
DISJ_2_3_24(T)
DISJ_1_4_24(T)
DISJ_2_4_24(T)
DISJ_3_4_24(T)
DISJ_4_4_24(T)

DISJ_1_1_25(T)
DISJ_2_1_25(T)
DISJ_1_2_25(T)
DISJ_2_2_25(T)
DISJ_3_2_25(T)
DISJ_1_3_25(T)
DISJ_2_3_25(T)
DISJ_3_3_25(T)
DISJ_1_4_25(T)
DISJ_2_4_25(T)
DISJ_3_4_25(T)
DISJ_4_4_25(T)
DISJ_5_4_25(T)
DISJ_6_4_25(T)

DISJ_1_1_26(T)
DISJ_1_2_26(T)
DISJ_2_2_26(T)
DISJ_1_3_26(T)
DISJ_2_3_26(T)
DISJ_1_4_26(T)
DISJ_2_4_26(T)
DISJ_3_4_26(T)
DISJ_4_4_26(T)

DISJ_1_1_27(T)
DISJ_1_2_27(T)
DISJ_2_2_27(T)
DISJ_1_3_27(T)
DISJ_2_3_27(T)
DISJ_1_4_27(T)
DISJ_2_4_27(T)
DISJ_3_4_27(T)
DISJ_4_4_27(T)

DISJ_1_1_28(T)
DISJ_1_2_28(T)
DISJ_2_2_28(T)
DISJ_1_3_28(T)
DISJ_2_3_28(T)
DISJ_1_4_28(T)
DISJ_2_4_28(T)
DISJ_3_4_28(T)
DISJ_4_4_28(T)

DISJ_1_1_29(T)
DISJ_1_2_29(T)
DISJ_2_2_29(T)
DISJ_1_3_29(T)
DISJ_2_3_29(T)
DISJ_1_4_29(T)
DISJ_2_4_29(T)
DISJ_3_4_29(T)
DISJ_4_4_29(T)

DISJ_1_1_30(T)
DISJ_1_2_30(T)
DISJ_2_2_30(T)
DISJ_1_3_30(T)
DISJ_2_3_30(T)
DISJ_1_4_30(T)
DISJ_2_4_30(T)
DISJ_3_4_30(T)
DISJ_4_4_30(T)

DISJ_1_1_31(T)
DISJ_1_2_31(T)
DISJ_2_2_31(T)
DISJ_1_3_31(T)
DISJ_2_3_31(T)
DISJ_1_4_31(T)
DISJ_2_4_31(T)
DISJ_3_4_31(T)
DISJ_4_4_31(T)

DISJ_1_1_32(T)
DISJ_2_1_32(T)
DISJ_1_2_32(T)
DISJ_2_2_32(T)
DISJ_3_2_32(T)
DISJ_1_3_32(T)
DISJ_2_3_32(T)
DISJ_3_3_32(T)
DISJ_1_4_32(T)
DISJ_2_4_32(T)
DISJ_3_4_32(T)
DISJ_4_4_32(T)
DISJ_5_4_32(T)
DISJ_6_4_32(T)

DISJ_1_1_33(T)
DISJ_1_2_33(T)
DISJ_2_2_33(T)
DISJ_1_3_33(T)
DISJ_2_3_33(T)
DISJ_1_4_33(T)
DISJ_2_4_33(T)
DISJ_3_4_33(T)
DISJ_4_4_33(T)

DISJ_1_1_34(T)
DISJ_1_2_34(T)
DISJ_2_2_34(T)
DISJ_1_3_34(T)
DISJ_2_3_34(T)
DISJ_1_4_34(T)
DISJ_2_4_34(T)
DISJ_3_4_34(T)
DISJ_4_4_34(T)

DISJ_1_1_35(T)
DISJ_2_1_35(T)
DISJ_1_2_35(T)
DISJ_2_2_35(T)
DISJ_3_2_35(T)
DISJ_1_3_35(T)
DISJ_2_3_35(T)
DISJ_3_3_35(T)
DISJ_1_4_35(T)
DISJ_2_4_35(T)
DISJ_3_4_35(T)
DISJ_4_4_35(T)
DISJ_5_4_35(T)
DISJ_6_4_35(T)

DISJ_1_1_36(T)
DISJ_1_2_36(T)
DISJ_2_2_36(T)
DISJ_1_3_36(T)
DISJ_2_3_36(T)
DISJ_1_4_36(T)
DISJ_2_4_36(T)
DISJ_3_4_36(T)
DISJ_4_4_36(T)

DISJ_1_1_37(T)
DISJ_1_2_37(T)
DISJ_2_2_37(T)
DISJ_1_3_37(T)
DISJ_2_3_37(T)
DISJ_1_4_37(T)
DISJ_2_4_37(T)
DISJ_3_4_37(T)
DISJ_4_4_37(T)

DISJ_1_1_38(T)
DISJ_1_2_38(T)
DISJ_2_2_38(T)
DISJ_1_3_38(T)
DISJ_2_3_38(T)
DISJ_1_4_38(T)
DISJ_2_4_38(T)
DISJ_3_4_38(T)
DISJ_4_4_38(T)

DISJ_1_1_39(T)
DISJ_1_2_39(T)
DISJ_2_2_39(T)
DISJ_1_3_39(T)
DISJ_2_3_39(T)
DISJ_1_4_39(T)
DISJ_2_4_39(T)
DISJ_3_4_39(T)
DISJ_4_4_39(T)

DISJ_1_1_40(T)
DISJ_1_2_40(T)
DISJ_2_2_40(T)
DISJ_1_3_40(T)
DISJ_2_3_40(T)
DISJ_1_4_40(T)
DISJ_2_4_40(T)
DISJ_3_4_40(T)
DISJ_4_4_40(T)

DISJ2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T),L4(T),L5(T),L6(T),L7(T),L8(T),L9(T),L10(T),L11(T),L12(T),L13(T),L14(T),L15(T),L16(T),L17(T),L18(T),L19(T),L20(T)
L21(T),L22(T),L23(T),L24(T),L25(T),L26(T),L27(T),L28(T),L29(T),L30(T),L31(T),L32(T),L33(T),L34(T),L35(T),L36(T),L37(T),L38(T),L39(T),L40(T),L41(T),L42(T),L43(T),L44(T),L45(T),L46(T),L47(T),L48(T),L49(T),L50(T),L51(T),L52(T),L53(T),L54(T)
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
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in Sawaya & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

*DISJ_1_1_1(T).. (Z('1',T)+ES)*(V('4','1','1',T)/(Z('1',T)+ES) - LOG(1+V('2','1','1',T)/(Z('1',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_1(T), Y_DISJ_1_1_1(T), W_DISJ_1_1_1(T);
X_DISJ_1_1_1.up(T) = UB('4','1','1',T)/(1*1);
W_DISJ_1_1_1.up(T) = UB('4','1','1',T)/(1*1);
Y_DISJ_1_1_1.up(T) = exp(UB('4','1','1',T)/(1*1));
equation d_DISJ_1_1_1(T);
equation a_DISJ_1_1_1(T), b_DISJ_1_1_1(T), c_DISJ_1_1_1(T);
equation e_DISJ_1_1_1(T), f_DISJ_1_1_1(T), g_DISJ_1_1_1(T);
DISJ_1_1_1(T).. Z('1',T)+V('2','1','1',T) =G= Y_DISJ_1_1_1(T);
d_DISJ_1_1_1(T).. 1*W_DISJ_1_1_1(T) =G= V('4','1','1',T);
a_DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =G= Z('1',T);
b_DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =L= Z('1',T)*exp(UB('4','1','1',T)/(1*1));
c_DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =G= exp(X_DISJ_1_1_1(T)) - (1-Z('1',T));
e_DISJ_1_1_1(T).. 1*W_DISJ_1_1_1(T) =L= Z('1',T)*UB('4','1','1',T);
f_DISJ_1_1_1(T).. 1*W_DISJ_1_1_1(T) =G= 1*X_DISJ_1_1_1(T) - (1-Z('1',T))*UB('4','1','1',T);
g_DISJ_1_1_1(T).. W_DISJ_1_1_1(T) =L= X_DISJ_1_1_1(T);
DISJ_1_2_1(T).. V('2','2','1',T) =E= 0;
DISJ_2_2_1(T).. V('4','2','1',T) =E= 0;
DISJ_1_3_1(T).. X('2',T) =E= SUM(D,V('2',D,'1',T));
DISJ_2_3_1(T).. X('4',T) =E= SUM(D,V('4',D,'1',T));
DISJ_1_4_1(T).. V('2','1','1',T) =L= UB('2','1','1',T)*Z('1',T);
DISJ_2_4_1(T).. V('2','2','1',T) =L= UB('2','2','1',T)*(1-Z('1',T));
DISJ_3_4_1(T).. V('4','1','1',T) =L= UB('4','1','1',T)*Z('1',T);
DISJ_4_4_1(T).. V('4','2','1',T) =L= UB('4','2','1',T)*(1-Z('1',T));

*DISJ_1_1_2(T).. (Z('2',T)+ES)*(V('5','1','2',T)/(Z('2',T)+ES) - 1.2*LOG(1+V('3','1','2',T)/(Z('2',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_2(T), Y_DISJ_1_1_2(T), W_DISJ_1_1_2(T);
X_DISJ_1_1_2.up(T) = UB('5','1','2',T)/(1.2*1);
W_DISJ_1_1_2.up(T) = UB('5','1','2',T)/(1.2*1);
Y_DISJ_1_1_2.up(T) = exp(UB('5','1','2',T)/(1.2*1));
equation d_DISJ_1_1_2(T);
equation a_DISJ_1_1_2(T), b_DISJ_1_1_2(T), c_DISJ_1_1_2(T);
equation e_DISJ_1_1_2(T), f_DISJ_1_1_2(T), g_DISJ_1_1_2(T);
DISJ_1_1_2(T).. Z('2',T)+V('3','1','2',T) =G= Y_DISJ_1_1_2(T);
d_DISJ_1_1_2(T).. 1.2*W_DISJ_1_1_2(T) =G= V('5','1','2',T);
a_DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =G= Z('2',T);
b_DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =L= Z('2',T)*exp(UB('5','1','2',T)/(1.2*1));
c_DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =G= exp(X_DISJ_1_1_2(T)) - (1-Z('2',T));
e_DISJ_1_1_2(T).. 1.2*W_DISJ_1_1_2(T) =L= Z('2',T)*UB('5','1','2',T);
f_DISJ_1_1_2(T).. 1.2*W_DISJ_1_1_2(T) =G= 1.2*X_DISJ_1_1_2(T) - (1-Z('2',T))*UB('5','1','2',T);
g_DISJ_1_1_2(T).. W_DISJ_1_1_2(T) =L= X_DISJ_1_1_2(T);
DISJ_1_2_2(T).. V('3','2','2',T) =E= 0;
DISJ_2_2_2(T).. V('5','2','2',T) =E= 0;
DISJ_1_3_2(T).. X('3',T) =E= SUM(D,V('3',D,'2',T));
DISJ_2_3_2(T).. X('5',T) =E= SUM(D,V('5',D,'2',T));
DISJ_1_4_2(T).. V('3','1','2',T) =L= UB('3','1','2',T)*Z('2',T);
DISJ_2_4_2(T).. V('3','2','2',T) =L= UB('3','2','2',T)*(1-Z('2',T));
DISJ_3_4_2(T).. V('5','1','2',T) =L= UB('5','1','2',T)*Z('2',T);
DISJ_4_4_2(T).. V('5','2','2',T) =L= UB('5','2','2',T)*(1-Z('2',T));

DISJ_1_1_3(T).. V('13','1','3',T) - 0.75*V('9','1','3',T) =E= 0;
DISJ_1_2_3(T).. V('9','2','3',T) =E= 0;
DISJ_2_2_3(T).. V('13','2','3',T) =E= 0;
DISJ_1_3_3(T).. X('9',T) =E= SUM(D,V('9',D,'3',T));
DISJ_2_3_3(T).. X('13',T) =E= SUM(D,V('13',D,'3',T));
DISJ_1_4_3(T).. V('9','1','3',T) =L= UB('9','1','3',T)*Z('3',T);
DISJ_2_4_3(T).. V('9','2','3',T) =L= UB('9','2','3',T)*(1-Z('3',T));
DISJ_3_4_3(T).. V('13','1','3',T) =L= UB('13','1','3',T)*Z('3',T);
DISJ_4_4_3(T).. V('13','2','3',T) =L= UB('13','2','3',T)*(1-Z('3',T));

*DISJ_1_1_4(T).. (Z('4',T)+ES)*(V('14','1','4',T)/(Z('4',T)+ES) - 1.5*LOG(1+V('10','1','4',T)/(Z('4',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_4(T), Y_DISJ_1_1_4(T), W_DISJ_1_1_4(T);
X_DISJ_1_1_4.up(T) = UB('14','1','4',T)/(1.5*1);
W_DISJ_1_1_4.up(T) = UB('14','1','4',T)/(1.5*1);
Y_DISJ_1_1_4.up(T) = exp(UB('14','1','4',T)/(1.5*1));
equation d_DISJ_1_1_4(T);
equation a_DISJ_1_1_4(T), b_DISJ_1_1_4(T), c_DISJ_1_1_4(T);
equation e_DISJ_1_1_4(T), f_DISJ_1_1_4(T), g_DISJ_1_1_4(T);
DISJ_1_1_4(T).. Z('4',T)+V('10','1','4',T) =G= Y_DISJ_1_1_4(T);
d_DISJ_1_1_4(T).. 1.5*W_DISJ_1_1_4(T) =G= V('14','1','4',T);
a_DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =G= Z('4',T);
b_DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =L= Z('4',T)*exp(UB('14','1','4',T)/(1.5*1));
c_DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =G= exp(X_DISJ_1_1_4(T)) - (1-Z('4',T));
e_DISJ_1_1_4(T).. 1.5*W_DISJ_1_1_4(T) =L= Z('4',T)*UB('14','1','4',T);
f_DISJ_1_1_4(T).. 1.5*W_DISJ_1_1_4(T) =G= 1.5*X_DISJ_1_1_4(T) - (1-Z('4',T))*UB('14','1','4',T);
g_DISJ_1_1_4(T).. W_DISJ_1_1_4(T) =L= X_DISJ_1_1_4(T);
DISJ_1_2_4(T).. V('10','2','4',T) =E= 0;
DISJ_2_2_4(T).. V('14','2','4',T) =E= 0;
DISJ_1_3_4(T).. X('10',T) =E= SUM(D,V('10',D,'4',T));
DISJ_2_3_4(T).. X('14',T) =E= SUM(D,V('14',D,'4',T));
DISJ_1_4_4(T).. V('10','1','4',T) =L= UB('10','1','4',T)*Z('4',T);
DISJ_2_4_4(T).. V('10','2','4',T) =L= UB('10','2','4',T)*(1-Z('4',T));
DISJ_3_4_4(T).. V('14','1','4',T) =L= UB('14','1','4',T)*Z('4',T);
DISJ_4_4_4(T).. V('14','2','4',T) =L= UB('14','2','4',T)*(1-Z('4',T));

DISJ_1_1_5(T).. V('15','1','5',T) - V('11','1','5',T)  =E= 0;
DISJ_2_1_5(T).. V('15','1','5',T) - 0.5*V('12','1','5',T) =E= 0;
DISJ_1_2_5(T).. V('11','2','5',T) =E= 0;
DISJ_2_2_5(T).. V('12','2','5',T) =E= 0;
DISJ_3_2_5(T).. V('15','2','5',T) =E= 0;
DISJ_1_3_5(T).. X('11',T) =E= SUM(D,V('11',D,'5',T));
DISJ_2_3_5(T).. X('12',T) =E= SUM(D,V('12',D,'5',T));
DISJ_3_3_5(T).. X('15',T) =E= SUM(D,V('15',D,'5',T));
DISJ_1_4_5(T).. V('11','1','5',T) =L= UB('11','1','5',T)*Z('5',T);
DISJ_2_4_5(T).. V('11','2','5',T) =L= UB('11','2','5',T)*(1-Z('5',T));
DISJ_3_4_5(T).. V('12','1','5',T) =L= UB('12','1','5',T)*Z('5',T);
DISJ_4_4_5(T).. V('12','2','5',T) =L= UB('12','2','5',T)*(1-Z('5',T));
DISJ_5_4_5(T).. V('15','1','5',T) =L= UB('15','1','5',T)*Z('5',T);
DISJ_6_4_5(T).. V('15','2','5',T) =L= UB('15','2','5',T)*(1-Z('5',T));

*DISJ_1_1_6(T).. (Z('6',T)+ES)*(V('21','1','6',T)/(Z('6',T)+ES) - 1.25*LOG(1+V('16','1','6',T)/(Z('6',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_6(T), Y_DISJ_1_1_6(T), W_DISJ_1_1_6(T);
X_DISJ_1_1_6.up(T) = UB('21','1','6',T)/(1.25*1);
W_DISJ_1_1_6.up(T) = UB('21','1','6',T)/(1.25*1);
Y_DISJ_1_1_6.up(T) = exp(UB('21','1','6',T)/(1.25*1));
equation d_DISJ_1_1_6(T);
equation a_DISJ_1_1_6(T), b_DISJ_1_1_6(T), c_DISJ_1_1_6(T);
equation e_DISJ_1_1_6(T), f_DISJ_1_1_6(T), g_DISJ_1_1_6(T);
DISJ_1_1_6(T).. Z('6',T)+V('16','1','6',T) =G= Y_DISJ_1_1_6(T);
d_DISJ_1_1_6(T).. 1.25*W_DISJ_1_1_6(T) =G= V('21','1','6',T);
a_DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =G= Z('6',T);
b_DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =L= Z('6',T)*exp(UB('21','1','6',T)/(1.25*1));
c_DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =G= exp(X_DISJ_1_1_6(T)) - (1-Z('6',T));
e_DISJ_1_1_6(T).. 1.25*W_DISJ_1_1_6(T) =L= Z('6',T)*UB('21','1','6',T);
f_DISJ_1_1_6(T).. 1.25*W_DISJ_1_1_6(T) =G= 1.25*X_DISJ_1_1_6(T) - (1-Z('6',T))*UB('21','1','6',T);
g_DISJ_1_1_6(T).. W_DISJ_1_1_6(T) =L= X_DISJ_1_1_6(T);
DISJ_1_2_6(T).. V('16','2','6',T) =E= 0;
DISJ_2_2_6(T).. V('21','2','6',T) =E= 0;
DISJ_1_3_6(T).. X('16',T) =E= SUM(D,V('16',D,'6',T));
DISJ_2_3_6(T).. X('21',T) =E= SUM(D,V('21',D,'6',T));
DISJ_1_4_6(T).. V('16','1','6',T) =L= UB('16','1','6',T)*Z('6',T);
DISJ_2_4_6(T).. V('16','2','6',T) =L= UB('16','2','6',T)*(1-Z('6',T));
DISJ_3_4_6(T).. V('21','1','6',T) =L= UB('21','1','6',T)*Z('6',T);
DISJ_4_4_6(T).. V('21','2','6',T) =L= UB('21','2','6',T)*(1-Z('6',T));

*DISJ_1_1_7(T).. (Z('7',T)+ES)*(V('22','1','7',T)/(Z('7',T)+ES) - 0.9*LOG(1+V('17','1','7',T)/(Z('7',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_7(T), Y_DISJ_1_1_7(T), W_DISJ_1_1_7(T);
X_DISJ_1_1_7.up(T) = UB('22','1','7',T)/(0.9*1);
W_DISJ_1_1_7.up(T) = UB('22','1','7',T)/(0.9*1);
Y_DISJ_1_1_7.up(T) = exp(UB('22','1','7',T)/(0.9*1));
equation d_DISJ_1_1_7(T);
equation a_DISJ_1_1_7(T), b_DISJ_1_1_7(T), c_DISJ_1_1_7(T);
equation e_DISJ_1_1_7(T), f_DISJ_1_1_7(T), g_DISJ_1_1_7(T);
DISJ_1_1_7(T).. Z('7',T)+V('17','1','7',T) =G= Y_DISJ_1_1_7(T);
d_DISJ_1_1_7(T).. 0.9*W_DISJ_1_1_7(T) =G= V('22','1','7',T);
a_DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =G= Z('7',T);
b_DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =L= Z('7',T)*exp(UB('22','1','7',T)/(0.9*1));
c_DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =G= exp(X_DISJ_1_1_7(T)) - (1-Z('7',T));
e_DISJ_1_1_7(T).. 0.9*W_DISJ_1_1_7(T) =L= Z('7',T)*UB('22','1','7',T);
f_DISJ_1_1_7(T).. 0.9*W_DISJ_1_1_7(T) =G= 0.9*X_DISJ_1_1_7(T) - (1-Z('7',T))*UB('22','1','7',T);
g_DISJ_1_1_7(T).. W_DISJ_1_1_7(T) =L= X_DISJ_1_1_7(T);
DISJ_1_2_7(T).. V('17','2','7',T) =E= 0;
DISJ_2_2_7(T).. V('22','2','7',T) =E= 0;
DISJ_1_3_7(T).. X('17',T) =E= SUM(D,V('17',D,'7',T));
DISJ_2_3_7(T).. X('22',T) =E= SUM(D,V('22',D,'7',T));
DISJ_1_4_7(T).. V('17','1','7',T) =L= UB('17','1','7',T)*Z('7',T);
DISJ_2_4_7(T).. V('17','2','7',T) =L= UB('17','2','7',T)*(1-Z('7',T));
DISJ_3_4_7(T).. V('22','1','7',T) =L= UB('22','1','7',T)*Z('7',T);
DISJ_4_4_7(T).. V('22','2','7',T) =L= UB('22','2','7',T)*(1-Z('7',T));

*DISJ_1_1_8(T).. (Z('8',T)+ES)*(V('23','1','8',T)/(Z('8',T)+ES) - LOG(1+V('14','1','8',T)/(Z('8',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_8(T), Y_DISJ_1_1_8(T), W_DISJ_1_1_8(T);
X_DISJ_1_1_8.up(T) = UB('23','1','8',T)/(1*1);
W_DISJ_1_1_8.up(T) = UB('23','1','8',T)/(1*1);
Y_DISJ_1_1_8.up(T) = exp(UB('23','1','8',T)/(1*1));
equation d_DISJ_1_1_8(T);
equation a_DISJ_1_1_8(T), b_DISJ_1_1_8(T), c_DISJ_1_1_8(T);
equation e_DISJ_1_1_8(T), f_DISJ_1_1_8(T), g_DISJ_1_1_8(T);
DISJ_1_1_8(T).. Z('8',T)+V('14','1','8',T) =G= Y_DISJ_1_1_8(T);
d_DISJ_1_1_8(T).. 1*W_DISJ_1_1_8(T) =G= V('23','1','8',T);
a_DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =G= Z('8',T);
b_DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =L= Z('8',T)*exp(UB('23','1','8',T)/(1*1));
c_DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =G= exp(X_DISJ_1_1_8(T)) - (1-Z('8',T));
e_DISJ_1_1_8(T).. 1*W_DISJ_1_1_8(T) =L= Z('8',T)*UB('23','1','8',T);
f_DISJ_1_1_8(T).. 1*W_DISJ_1_1_8(T) =G= 1*X_DISJ_1_1_8(T) - (1-Z('8',T))*UB('23','1','8',T);
g_DISJ_1_1_8(T).. W_DISJ_1_1_8(T) =L= X_DISJ_1_1_8(T);
DISJ_1_2_8(T).. V('14','2','8',T) =E= 0;
DISJ_2_2_8(T).. V('23','2','8',T) =E= 0;
DISJ_1_3_8(T).. X('14',T) =E= SUM(D,V('14',D,'8',T));
DISJ_2_3_8(T).. X('23',T) =E= SUM(D,V('23',D,'8',T));
DISJ_1_4_8(T).. V('14','1','8',T) =L= UB('14','1','8',T)*Z('8',T);
DISJ_2_4_8(T).. V('14','2','8',T) =L= UB('14','2','8',T)*(1-Z('8',T));
DISJ_3_4_8(T).. V('23','1','8',T) =L= UB('23','1','8',T)*Z('8',T);
DISJ_4_4_8(T).. V('23','2','8',T) =L= UB('23','2','8',T)*(1-Z('8',T));

DISJ_1_1_9(T).. V('24','1','9',T) - 0.9*V('18','1','9',T) =E= 0;
DISJ_1_2_9(T).. V('18','2','9',T) =E= 0;
DISJ_2_2_9(T).. V('24','2','9',T) =E= 0;
DISJ_1_3_9(T).. X('18',T) =E= SUM(D,V('18',D,'9',T));
DISJ_2_3_9(T).. X('24',T) =E= SUM(D,V('24',D,'9',T));
DISJ_1_4_9(T).. V('18','1','9',T) =L= UB('18','1','9',T)*Z('9',T);
DISJ_2_4_9(T).. V('18','2','9',T) =L= UB('18','2','9',T)*(1-Z('9',T));
DISJ_3_4_9(T).. V('24','1','9',T) =L= UB('24','1','9',T)*Z('9',T);
DISJ_4_4_9(T).. V('24','2','9',T) =L= UB('24','2','9',T)*(1-Z('9',T));

DISJ_1_1_10(T).. V('25','1','10',T) - 0.6*V('19','1','10',T) =E= 0;
DISJ_1_2_10(T).. V('19','2','10',T) =E= 0;
DISJ_2_2_10(T).. V('25','2','10',T) =E= 0;
DISJ_1_3_10(T).. X('19',T) =E= SUM(D,V('19',D,'10',T));
DISJ_2_3_10(T).. X('25',T) =E= SUM(D,V('25',D,'10',T));
DISJ_1_4_10(T).. V('19','1','10',T) =L= UB('19','1','10',T)*Z('10',T);
DISJ_2_4_10(T).. V('19','2','10',T) =L= UB('19','2','10',T)*(1-Z('10',T));
DISJ_3_4_10(T).. V('25','1','10',T) =L= UB('25','1','10',T)*Z('10',T);
DISJ_4_4_10(T).. V('25','2','10',T) =L= UB('25','2','10',T)*(1-Z('10',T));

*DISJ_1_1_11(T).. (Z('11',T)+ES)*(V('26','1','11',T)/(Z('11',T)+ES) - 1.1*LOG(1+V('20','1','11',T)/(Z('11',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_11(T), Y_DISJ_1_1_11(T), W_DISJ_1_1_11(T);
X_DISJ_1_1_11.up(T) = UB('26','1','11',T)/(1.1*1);
W_DISJ_1_1_11.up(T) = UB('26','1','11',T)/(1.1*1);
Y_DISJ_1_1_11.up(T) = exp(UB('26','1','11',T)/(1.1*1));
equation d_DISJ_1_1_11(T);
equation a_DISJ_1_1_11(T), b_DISJ_1_1_11(T), c_DISJ_1_1_11(T);
equation e_DISJ_1_1_11(T), f_DISJ_1_1_11(T), g_DISJ_1_1_11(T);
DISJ_1_1_11(T).. Z('11',T)+V('20','1','11',T) =G= Y_DISJ_1_1_11(T);
d_DISJ_1_1_11(T).. 1.1*W_DISJ_1_1_11(T) =G= V('26','1','11',T);
a_DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =G= Z('11',T);
b_DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =L= Z('11',T)*exp(UB('26','1','11',T)/(1.1*1));
c_DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =G= exp(X_DISJ_1_1_11(T)) - (1-Z('11',T));
e_DISJ_1_1_11(T).. 1.1*W_DISJ_1_1_11(T) =L= Z('11',T)*UB('26','1','11',T);
f_DISJ_1_1_11(T).. 1.1*W_DISJ_1_1_11(T) =G= 1.1*X_DISJ_1_1_11(T) - (1-Z('11',T))*UB('26','1','11',T);
g_DISJ_1_1_11(T).. W_DISJ_1_1_11(T) =L= X_DISJ_1_1_11(T);
DISJ_1_2_11(T).. V('20','2','11',T) =E= 0;
DISJ_2_2_11(T).. V('26','2','11',T) =E= 0;
DISJ_1_3_11(T).. X('20',T) =E= SUM(D,V('20',D,'11',T));
DISJ_2_3_11(T).. X('26',T) =E= SUM(D,V('26',D,'11',T));
DISJ_1_4_11(T).. V('20','1','11',T) =L= UB('20','1','11',T)*Z('11',T);
DISJ_2_4_11(T).. V('20','2','11',T) =L= UB('20','2','11',T)*(1-Z('11',T));
DISJ_3_4_11(T).. V('26','1','11',T) =L= UB('26','1','11',T)*Z('11',T);
DISJ_4_4_11(T).. V('26','2','11',T) =L= UB('26','2','11',T)*(1-Z('11',T));

DISJ_1_1_12(T).. V('37','1','12',T) - 0.9*V('21','1','12',T) =E= 0;
DISJ_2_1_12(T).. V('37','1','12',T) - V('29','1','12',T) =E= 0;
DISJ_1_2_12(T).. V('21','2','12',T) =E= 0;
DISJ_2_2_12(T).. V('29','2','12',T) =E= 0;
DISJ_3_2_12(T).. V('37','2','12',T) =E= 0;
DISJ_1_3_12(T).. X('21',T) =E= SUM(D,V('21',D,'12',T));
DISJ_2_3_12(T).. X('29',T) =E= SUM(D,V('29',D,'12',T));
DISJ_3_3_12(T).. X('37',T) =E= SUM(D,V('37',D,'12',T));
DISJ_1_4_12(T).. V('21','1','12',T) =L= UB('21','1','12',T)*Z('12',T);
DISJ_2_4_12(T).. V('21','2','12',T) =L= UB('21','2','12',T)*(1-Z('12',T));
DISJ_3_4_12(T).. V('29','1','12',T) =L= UB('29','1','12',T)*Z('12',T);
DISJ_4_4_12(T).. V('29','2','12',T) =L= UB('29','2','12',T)*(1-Z('12',T));
DISJ_5_4_12(T).. V('37','1','12',T) =L= UB('37','1','12',T)*Z('12',T);
DISJ_6_4_12(T).. V('37','2','12',T) =L= UB('37','2','12',T)*(1-Z('12',T));

*DISJ_1_1_13(T).. (Z('13',T)+ES)*(V('38','1','13',T)/(Z('13',T)+ES) - LOG(1+V('22','1','13',T)/(Z('13',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_13(T), Y_DISJ_1_1_13(T), W_DISJ_1_1_13(T);
X_DISJ_1_1_13.up(T) = UB('38','1','13',T)/(1*1);
W_DISJ_1_1_13.up(T) = UB('38','1','13',T)/(1*1);
Y_DISJ_1_1_13.up(T) = exp(UB('38','1','13',T)/(1*1));
equation d_DISJ_1_1_13(T);
equation a_DISJ_1_1_13(T), b_DISJ_1_1_13(T), c_DISJ_1_1_13(T);
equation e_DISJ_1_1_13(T), f_DISJ_1_1_13(T), g_DISJ_1_1_13(T);
DISJ_1_1_13(T).. Z('13',T)+V('22','1','13',T) =G= Y_DISJ_1_1_13(T);
d_DISJ_1_1_13(T).. 1*W_DISJ_1_1_13(T) =G= V('38','1','13',T);
a_DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =G= Z('13',T);
b_DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =L= Z('13',T)*exp(UB('38','1','13',T)/(1*1));
c_DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =G= exp(X_DISJ_1_1_13(T)) - (1-Z('13',T));
e_DISJ_1_1_13(T).. 1*W_DISJ_1_1_13(T) =L= Z('13',T)*UB('38','1','13',T);
f_DISJ_1_1_13(T).. 1*W_DISJ_1_1_13(T) =G= 1*X_DISJ_1_1_13(T) - (1-Z('13',T))*UB('38','1','13',T);
g_DISJ_1_1_13(T).. W_DISJ_1_1_13(T) =L= X_DISJ_1_1_13(T);
DISJ_1_2_13(T).. V('22','2','13',T) =E= 0;
DISJ_2_2_13(T).. V('38','2','13',T) =E= 0;
DISJ_1_3_13(T).. X('22',T) =E= SUM(D,V('22',D,'13',T));
DISJ_2_3_13(T).. X('38',T) =E= SUM(D,V('38',D,'13',T));
DISJ_1_4_13(T).. V('22','1','13',T) =L= UB('22','1','13',T)*Z('13',T);
DISJ_2_4_13(T).. V('22','2','13',T) =L= UB('22','2','13',T)*(1-Z('13',T));
DISJ_3_4_13(T).. V('38','1','13',T) =L= UB('38','1','13',T)*Z('13',T);
DISJ_4_4_13(T).. V('38','2','13',T) =L= UB('38','2','13',T)*(1-Z('13',T));

*DISJ_1_1_14(T).. (Z('14',T)+ES)*(V('39','1','14',T)/(Z('14',T)+ES) - 0.7*LOG(1+V('27','1','14',T)/(Z('14',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_14(T), Y_DISJ_1_1_14(T), W_DISJ_1_1_14(T);
X_DISJ_1_1_14.up(T) = UB('39','1','14',T)/(0.7*1);
W_DISJ_1_1_14.up(T) = UB('39','1','14',T)/(0.7*1);
Y_DISJ_1_1_14.up(T) = exp(UB('39','1','14',T)/(0.7*1));
equation d_DISJ_1_1_14(T);
equation a_DISJ_1_1_14(T), b_DISJ_1_1_14(T), c_DISJ_1_1_14(T);
equation e_DISJ_1_1_14(T), f_DISJ_1_1_14(T), g_DISJ_1_1_14(T);
DISJ_1_1_14(T).. Z('14',T)+V('27','1','14',T) =G= Y_DISJ_1_1_14(T);
d_DISJ_1_1_14(T).. 0.7*W_DISJ_1_1_14(T) =G= V('39','1','14',T);
a_DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =G= Z('14',T);
b_DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =L= Z('14',T)*exp(UB('39','1','14',T)/(0.7*1));
c_DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =G= exp(X_DISJ_1_1_14(T)) - (1-Z('14',T));
e_DISJ_1_1_14(T).. 0.7*W_DISJ_1_1_14(T) =L= Z('14',T)*UB('39','1','14',T);
f_DISJ_1_1_14(T).. 0.7*W_DISJ_1_1_14(T) =G= 0.7*X_DISJ_1_1_14(T) - (1-Z('14',T))*UB('39','1','14',T);
g_DISJ_1_1_14(T).. W_DISJ_1_1_14(T) =L= X_DISJ_1_1_14(T);
DISJ_1_2_14(T).. V('27','2','14',T) =E= 0;
DISJ_2_2_14(T).. V('39','2','14',T) =E= 0;
DISJ_1_3_14(T).. X('27',T) =E= SUM(D,V('27',D,'14',T));
DISJ_2_3_14(T).. X('39',T) =E= SUM(D,V('39',D,'14',T));
DISJ_1_4_14(T).. V('27','1','14',T) =L= UB('27','1','14',T)*Z('14',T);
DISJ_2_4_14(T).. V('27','2','14',T) =L= UB('27','2','14',T)*(1-Z('14',T));
DISJ_3_4_14(T).. V('39','1','14',T) =L= UB('39','1','14',T)*Z('14',T);
DISJ_4_4_14(T).. V('39','2','14',T) =L= UB('39','2','14',T)*(1-Z('14',T));

*DISJ_1_1_15(T).. (Z('15',T)+ES)*(V('40','1','15',T)/(Z('15',T)+ES) - 0.65*LOG(1+(V('28','1','15',T))/(Z('15',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_15(T), Y_DISJ_1_1_15(T), W_DISJ_1_1_15(T);
X_DISJ_1_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
W_DISJ_1_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
Y_DISJ_1_1_15.up(T) = exp(UB('40','1','15',T)/(0.65*1));
equation d_DISJ_1_1_15(T);
equation a_DISJ_1_1_15(T), b_DISJ_1_1_15(T), c_DISJ_1_1_15(T);
equation e_DISJ_1_1_15(T), f_DISJ_1_1_15(T), g_DISJ_1_1_15(T);
DISJ_1_1_15(T).. Z('15',T)+V('28','1','15',T) =G= Y_DISJ_1_1_15(T);
d_DISJ_1_1_15(T).. 0.65*W_DISJ_1_1_15(T) =G= V('40','1','15',T);
a_DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =G= Z('15',T);
b_DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =L= Z('15',T)*exp(UB('40','1','15',T)/(0.65*1));
c_DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =G= exp(X_DISJ_1_1_15(T)) - (1-Z('15',T));
e_DISJ_1_1_15(T).. 0.65*W_DISJ_1_1_15(T) =L= Z('15',T)*UB('40','1','15',T);
f_DISJ_1_1_15(T).. 0.65*W_DISJ_1_1_15(T) =G= 0.65*X_DISJ_1_1_15(T) - (1-Z('15',T))*UB('40','1','15',T);
g_DISJ_1_1_15(T).. W_DISJ_1_1_15(T) =L= X_DISJ_1_1_15(T);
*DISJ_2_1_15(T).. (Z('15',T)+ES)*(V('40','1','15',T)/(Z('15',T)+ES) - 0.65*LOG(1+(V('31','1','15',T))/(Z('15',T)+ES))) =L= 0;
positive variable X_DISJ_2_1_15(T), Y_DISJ_2_1_15(T), W_DISJ_2_1_15(T);
X_DISJ_2_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
W_DISJ_2_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
Y_DISJ_2_1_15.up(T) = exp(UB('40','1','15',T)/(0.65*1));
equation d_DISJ_2_1_15(T);
equation a_DISJ_2_1_15(T), b_DISJ_2_1_15(T), c_DISJ_2_1_15(T);
equation e_DISJ_2_1_15(T), f_DISJ_2_1_15(T), g_DISJ_2_1_15(T);
DISJ_2_1_15(T).. Z('15',T)+V('31','1','15',T) =G= Y_DISJ_2_1_15(T);
d_DISJ_2_1_15(T).. 0.65*W_DISJ_2_1_15(T) =G= V('40','1','15',T);
a_DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =G= Z('15',T);
b_DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =L= Z('15',T)*exp(UB('40','1','15',T)/(0.65*1));
c_DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =G= exp(X_DISJ_2_1_15(T)) - (1-Z('15',T));
e_DISJ_2_1_15(T).. 0.65*W_DISJ_2_1_15(T) =L= Z('15',T)*UB('40','1','15',T);
f_DISJ_2_1_15(T).. 0.65*W_DISJ_2_1_15(T) =G= 0.65*X_DISJ_2_1_15(T) - (1-Z('15',T))*UB('40','1','15',T);
g_DISJ_2_1_15(T).. W_DISJ_2_1_15(T) =L= X_DISJ_2_1_15(T);
DISJ_1_2_15(T).. V('28','2','15',T) =E= 0;
DISJ_2_2_15(T).. V('31','2','15',T) =E= 0;
DISJ_3_2_15(T).. V('40','2','15',T) =E= 0;
DISJ_1_3_15(T).. X('28',T) =E= SUM(D,V('28',D,'15',T));
DISJ_2_3_15(T).. X('31',T) =E= SUM(D,V('31',D,'15',T));
DISJ_3_3_15(T).. X('40',T) =E= SUM(D,V('40',D,'15',T));
DISJ_1_4_15(T).. V('28','1','15',T) =L= UB('28','1','15',T)*Z('15',T);
DISJ_2_4_15(T).. V('28','2','15',T) =L= UB('28','2','15',T)*(1-Z('15',T));
DISJ_3_4_15(T).. V('31','1','15',T) =L= UB('31','1','15',T)*Z('15',T);
DISJ_4_4_15(T).. V('31','2','15',T) =L= UB('31','2','15',T)*(1-Z('15',T));
DISJ_5_4_15(T).. V('40','1','15',T) =L= UB('40','1','15',T)*Z('15',T);
DISJ_6_4_15(T).. V('40','2','15',T) =L= UB('40','2','15',T)*(1-Z('15',T));

DISJ_1_1_16(T).. V('41','1','16',T) - V('32','1','16',T) =E= 0;
DISJ_1_2_16(T).. V('32','2','16',T) =E= 0;
DISJ_2_2_16(T).. V('41','2','16',T) =E= 0;
DISJ_1_3_16(T).. X('32',T) =E= SUM(D,V('32',D,'16',T));
DISJ_2_3_16(T).. X('41',T) =E= SUM(D,V('41',D,'16',T));
DISJ_1_4_16(T).. V('32','1','16',T) =L= UB('32','1','16',T)*Z('16',T);
DISJ_2_4_16(T).. V('32','2','16',T) =L= UB('32','2','16',T)*(1-Z('16',T));
DISJ_3_4_16(T).. V('41','1','16',T) =L= UB('41','1','16',T)*Z('16',T);
DISJ_4_4_16(T).. V('41','2','16',T) =L= UB('41','2','16',T)*(1-Z('16',T));

DISJ_1_1_17(T).. V('42','1','17',T) - V('33','1','17',T) =E= 0;
DISJ_1_2_17(T).. V('33','2','17',T) =E= 0;
DISJ_2_2_17(T).. V('42','2','17',T) =E= 0;
DISJ_1_3_17(T).. X('33',T) =E= SUM(D,V('33',D,'17',T));
DISJ_2_3_17(T).. X('42',T) =E= SUM(D,V('42',D,'17',T));
DISJ_1_4_17(T).. V('33','1','17',T) =L= UB('33','1','17',T)*Z('17',T);
DISJ_2_4_17(T).. V('33','2','17',T) =L= UB('33','2','17',T)*(1-Z('17',T));
DISJ_3_4_17(T).. V('42','1','17',T) =L= UB('42','1','17',T)*Z('17',T);
DISJ_4_4_17(T).. V('42','2','17',T) =L= UB('42','2','17',T)*(1-Z('17',T));

*DISJ_1_1_18(T).. (Z('18',T)+ES)*(V('43','1','18',T)/(Z('18',T)+ES) - 0.75*LOG(1+V('34','1','18',T)/(Z('18',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_18(T), Y_DISJ_1_1_18(T), W_DISJ_1_1_18(T);
X_DISJ_1_1_18.up(T) = UB('43','1','18',T)/(0.75*1);
W_DISJ_1_1_18.up(T) = UB('43','1','18',T)/(0.75*1);
Y_DISJ_1_1_18.up(T) = exp(UB('43','1','18',T)/(0.75*1));
equation d_DISJ_1_1_18(T);
equation a_DISJ_1_1_18(T), b_DISJ_1_1_18(T), c_DISJ_1_1_18(T);
equation e_DISJ_1_1_18(T), f_DISJ_1_1_18(T), g_DISJ_1_1_18(T);
DISJ_1_1_18(T).. Z('18',T)+V('34','1','18',T) =G= Y_DISJ_1_1_18(T);
d_DISJ_1_1_18(T).. 0.75*W_DISJ_1_1_18(T) =G= V('43','1','18',T);
a_DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =G= Z('18',T);
b_DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =L= Z('18',T)*exp(UB('43','1','18',T)/(0.75*1));
c_DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =G= exp(X_DISJ_1_1_18(T)) - (1-Z('18',T));
e_DISJ_1_1_18(T).. 0.75*W_DISJ_1_1_18(T) =L= Z('18',T)*UB('43','1','18',T);
f_DISJ_1_1_18(T).. 0.75*W_DISJ_1_1_18(T) =G= 0.75*X_DISJ_1_1_18(T) - (1-Z('18',T))*UB('43','1','18',T);
g_DISJ_1_1_18(T).. W_DISJ_1_1_18(T) =L= X_DISJ_1_1_18(T);
DISJ_1_2_18(T).. V('34','2','18',T) =E= 0;
DISJ_2_2_18(T).. V('43','2','18',T) =E= 0;
DISJ_1_3_18(T).. X('34',T) =E= SUM(D,V('34',D,'18',T));
DISJ_2_3_18(T).. X('43',T) =E= SUM(D,V('43',D,'18',T));
DISJ_1_4_18(T).. V('34','1','18',T) =L= UB('34','1','18',T)*Z('18',T);
DISJ_2_4_18(T).. V('34','2','18',T) =L= UB('34','2','18',T)*(1-Z('18',T));
DISJ_3_4_18(T).. V('43','1','18',T) =L= UB('43','1','18',T)*Z('18',T);
DISJ_4_4_18(T).. V('43','2','18',T) =L= UB('43','2','18',T)*(1-Z('18',T));

*DISJ_1_1_19(T).. (Z('19',T)+ES)*(V('44','1','19',T)/(Z('19',T)+ES) - 0.8*LOG(1+V('35','1','19',T)/(Z('19',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_19(T), Y_DISJ_1_1_19(T), W_DISJ_1_1_19(T);
X_DISJ_1_1_19.up(T) = UB('44','1','19',T)/(0.8*1);
W_DISJ_1_1_19.up(T) = UB('44','1','19',T)/(0.8*1);
Y_DISJ_1_1_19.up(T) = exp(UB('44','1','19',T)/(0.8*1));
equation d_DISJ_1_1_19(T);
equation a_DISJ_1_1_19(T), b_DISJ_1_1_19(T), c_DISJ_1_1_19(T);
equation e_DISJ_1_1_19(T), f_DISJ_1_1_19(T), g_DISJ_1_1_19(T);
DISJ_1_1_19(T).. Z('19',T)+V('35','1','19',T) =G= Y_DISJ_1_1_19(T);
d_DISJ_1_1_19(T).. 0.8*W_DISJ_1_1_19(T) =G= V('44','1','19',T);
a_DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =G= Z('19',T);
b_DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =L= Z('19',T)*exp(UB('44','1','19',T)/(0.8*1));
c_DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =G= exp(X_DISJ_1_1_19(T)) - (1-Z('19',T));
e_DISJ_1_1_19(T).. 0.8*W_DISJ_1_1_19(T) =L= Z('19',T)*UB('44','1','19',T);
f_DISJ_1_1_19(T).. 0.8*W_DISJ_1_1_19(T) =G= 0.8*X_DISJ_1_1_19(T) - (1-Z('19',T))*UB('44','1','19',T);
g_DISJ_1_1_19(T).. W_DISJ_1_1_19(T) =L= X_DISJ_1_1_19(T);
DISJ_1_2_19(T).. V('35','2','19',T) =E= 0;
DISJ_2_2_19(T).. V('44','2','19',T) =E= 0;
DISJ_1_3_19(T).. X('35',T) =E= SUM(D,V('35',D,'19',T));
DISJ_2_3_19(T).. X('44',T) =E= SUM(D,V('44',D,'19',T));
DISJ_1_4_19(T).. V('35','1','19',T) =L= UB('35','1','19',T)*Z('19',T);
DISJ_2_4_19(T).. V('35','2','19',T) =L= UB('35','2','19',T)*(1-Z('19',T));
DISJ_3_4_19(T).. V('44','1','19',T) =L= UB('44','1','19',T)*Z('19',T);
DISJ_4_4_19(T).. V('44','2','19',T) =L= UB('44','2','19',T)*(1-Z('19',T));

*DISJ_1_1_20(T).. (Z('20',T)+ES)*(V('45','1','20',T)/(Z('20',T)+ES) - 0.85*LOG(1+V('36','1','20',T)/(Z('20',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_20(T), Y_DISJ_1_1_20(T), W_DISJ_1_1_20(T);
X_DISJ_1_1_20.up(T) = UB('45','1','20',T)/(0.85*1);
W_DISJ_1_1_20.up(T) = UB('45','1','20',T)/(0.85*1);
Y_DISJ_1_1_20.up(T) = exp(UB('45','1','20',T)/(0.85*1));
equation d_DISJ_1_1_20(T);
equation a_DISJ_1_1_20(T), b_DISJ_1_1_20(T), c_DISJ_1_1_20(T);
equation e_DISJ_1_1_20(T), f_DISJ_1_1_20(T), g_DISJ_1_1_20(T);
DISJ_1_1_20(T).. Z('20',T)+V('36','1','20',T) =G= Y_DISJ_1_1_20(T);
d_DISJ_1_1_20(T).. 0.85*W_DISJ_1_1_20(T) =G= V('45','1','20',T);
a_DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =G= Z('20',T);
b_DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =L= Z('20',T)*exp(UB('45','1','20',T)/(0.85*1));
c_DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =G= exp(X_DISJ_1_1_20(T)) - (1-Z('20',T));
e_DISJ_1_1_20(T).. 0.85*W_DISJ_1_1_20(T) =L= Z('20',T)*UB('45','1','20',T);
f_DISJ_1_1_20(T).. 0.85*W_DISJ_1_1_20(T) =G= 0.85*X_DISJ_1_1_20(T) - (1-Z('20',T))*UB('45','1','20',T);
g_DISJ_1_1_20(T).. W_DISJ_1_1_20(T) =L= X_DISJ_1_1_20(T);
DISJ_1_2_20(T).. V('36','2','20',T) =E= 0;
DISJ_2_2_20(T).. V('45','2','20',T) =E= 0;
DISJ_1_3_20(T).. X('36',T) =E= SUM(D,V('36',D,'20',T));
DISJ_2_3_20(T).. X('45',T) =E= SUM(D,V('45',D,'20',T));
DISJ_1_4_20(T).. V('36','1','20',T) =L= UB('36','1','20',T)*Z('20',T);
DISJ_2_4_20(T).. V('36','2','20',T) =L= UB('36','2','20',T)*(1-Z('20',T));
DISJ_3_4_20(T).. V('45','1','20',T) =L= UB('45','1','20',T)*Z('20',T);
DISJ_4_4_20(T).. V('45','2','20',T) =L= UB('45','2','20',T)*(1-Z('20',T));

*Form of disjunctions 21-30 is the same as that of first 20 disjunctions
*DISJ_1_1_21(T).. (Z('21',T)+ES)*(V('49','1','21',T)/(Z('21',T)+ES) - LOG(1+V('47','1','21',T)/(Z('21',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_21(T), Y_DISJ_1_1_21(T), W_DISJ_1_1_21(T);
X_DISJ_1_1_21.up(T) = UB('49','1','21',T)/(1*1);
W_DISJ_1_1_21.up(T) = UB('49','1','21',T)/(1*1);
Y_DISJ_1_1_21.up(T) = exp(UB('49','1','21',T)/(1*1));
equation d_DISJ_1_1_21(T);
equation a_DISJ_1_1_21(T), b_DISJ_1_1_21(T), c_DISJ_1_1_21(T);
equation e_DISJ_1_1_21(T), f_DISJ_1_1_21(T), g_DISJ_1_1_21(T);
DISJ_1_1_21(T).. Z('21',T)+V('47','1','21',T) =G= Y_DISJ_1_1_21(T);
d_DISJ_1_1_21(T).. 1*W_DISJ_1_1_21(T) =G= V('49','1','21',T);
a_DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =G= Z('21',T);
b_DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =L= Z('21',T)*exp(UB('49','1','21',T)/(1*1));
c_DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =G= exp(X_DISJ_1_1_21(T)) - (1-Z('21',T));
e_DISJ_1_1_21(T).. 1*W_DISJ_1_1_21(T) =L= Z('21',T)*UB('49','1','21',T);
f_DISJ_1_1_21(T).. 1*W_DISJ_1_1_21(T) =G= 1*X_DISJ_1_1_21(T) - (1-Z('21',T))*UB('49','1','21',T);
g_DISJ_1_1_21(T).. W_DISJ_1_1_21(T) =L= X_DISJ_1_1_21(T);
DISJ_1_2_21(T).. V('47','2','21',T) =E= 0;
DISJ_2_2_21(T).. V('49','2','21',T) =E= 0;
DISJ_1_3_21(T).. X('47',T) =E= SUM(D,V('47',D,'21',T));
DISJ_2_3_21(T).. X('49',T) =E= SUM(D,V('49',D,'21',T));
DISJ_1_4_21(T).. V('47','1','21',T) =L= UB('47','1','21',T)*Z('21',T);
DISJ_2_4_21(T).. V('47','2','21',T) =L= UB('47','2','21',T)*(1-Z('21',T));
DISJ_3_4_21(T).. V('49','1','21',T) =L= UB('49','1','21',T)*Z('21',T);
DISJ_4_4_21(T).. V('49','2','21',T) =L= UB('49','2','21',T)*(1-Z('21',T));

*DISJ_1_1_22(T).. (Z('22',T)+ES)*(V('50','1','22',T)/(Z('22',T)+ES) - 1.2*LOG(1+V('48','1','22',T)/(Z('22',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_22(T), Y_DISJ_1_1_22(T), W_DISJ_1_1_22(T);
X_DISJ_1_1_22.up(T) = UB('50','1','22',T)/(1.2*1);
W_DISJ_1_1_22.up(T) = UB('50','1','22',T)/(1.2*1);
Y_DISJ_1_1_22.up(T) = exp(UB('50','1','22',T)/(1.2*1));
equation d_DISJ_1_1_22(T);
equation a_DISJ_1_1_22(T), b_DISJ_1_1_22(T), c_DISJ_1_1_22(T);
equation e_DISJ_1_1_22(T), f_DISJ_1_1_22(T), g_DISJ_1_1_22(T);
DISJ_1_1_22(T).. Z('22',T)+V('48','1','22',T) =G= Y_DISJ_1_1_22(T);
d_DISJ_1_1_22(T).. 1.2*W_DISJ_1_1_22(T) =G= V('50','1','22',T);
a_DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =G= Z('22',T);
b_DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =L= Z('22',T)*exp(UB('50','1','22',T)/(1.2*1));
c_DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =G= exp(X_DISJ_1_1_22(T)) - (1-Z('22',T));
e_DISJ_1_1_22(T).. 1.2*W_DISJ_1_1_22(T) =L= Z('22',T)*UB('50','1','22',T);
f_DISJ_1_1_22(T).. 1.2*W_DISJ_1_1_22(T) =G= 1.2*X_DISJ_1_1_22(T) - (1-Z('22',T))*UB('50','1','22',T);
g_DISJ_1_1_22(T).. W_DISJ_1_1_22(T) =L= X_DISJ_1_1_22(T);
DISJ_1_2_22(T).. V('48','2','22',T) =E= 0;
DISJ_2_2_22(T).. V('50','2','22',T) =E= 0;
DISJ_1_3_22(T).. X('48',T) =E= SUM(D,V('48',D,'22',T));
DISJ_2_3_22(T).. X('50',T) =E= SUM(D,V('50',D,'22',T));
DISJ_1_4_22(T).. V('48','1','22',T) =L= UB('48','1','22',T)*Z('22',T);
DISJ_2_4_22(T).. V('48','2','22',T) =L= UB('48','2','22',T)*(1-Z('22',T));
DISJ_3_4_22(T).. V('50','1','22',T) =L= UB('50','1','22',T)*Z('22',T);
DISJ_4_4_22(T).. V('50','2','22',T) =L= UB('50','2','22',T)*(1-Z('22',T));

DISJ_1_1_23(T).. V('58','1','23',T) - 0.75*V('54','1','23',T) =E= 0;
DISJ_1_2_23(T).. V('54','2','23',T) =E= 0;
DISJ_2_2_23(T).. V('58','2','23',T) =E= 0;
DISJ_1_3_23(T).. X('54',T) =E= SUM(D,V('54',D,'23',T));
DISJ_2_3_23(T).. X('58',T) =E= SUM(D,V('58',D,'23',T));
DISJ_1_4_23(T).. V('54','1','23',T) =L= UB('54','1','23',T)*Z('23',T);
DISJ_2_4_23(T).. V('54','2','23',T) =L= UB('54','2','23',T)*(1-Z('23',T));
DISJ_3_4_23(T).. V('58','1','23',T) =L= UB('58','1','23',T)*Z('23',T);
DISJ_4_4_23(T).. V('58','2','23',T) =L= UB('58','2','23',T)*(1-Z('23',T));

*DISJ_1_1_24(T).. (Z('24',T)+ES)*(V('59','1','24',T)/(Z('24',T)+ES) - 1.5*LOG(1+V('55','1','24',T)/(Z('24',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_24(T), Y_DISJ_1_1_24(T), W_DISJ_1_1_24(T);
X_DISJ_1_1_24.up(T) = UB('59','1','24',T)/(1.5*1);
W_DISJ_1_1_24.up(T) = UB('59','1','24',T)/(1.5*1);
Y_DISJ_1_1_24.up(T) = exp(UB('59','1','24',T)/(1.5*1));
equation d_DISJ_1_1_24(T);
equation a_DISJ_1_1_24(T), b_DISJ_1_1_24(T), c_DISJ_1_1_24(T);
equation e_DISJ_1_1_24(T), f_DISJ_1_1_24(T), g_DISJ_1_1_24(T);
DISJ_1_1_24(T).. Z('24',T)+V('55','1','24',T) =G= Y_DISJ_1_1_24(T);
d_DISJ_1_1_24(T).. 1.5*W_DISJ_1_1_24(T) =G= V('59','1','24',T);
a_DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =G= Z('24',T);
b_DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =L= Z('24',T)*exp(UB('59','1','24',T)/(1.5*1));
c_DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =G= exp(X_DISJ_1_1_24(T)) - (1-Z('24',T));
e_DISJ_1_1_24(T).. 1.5*W_DISJ_1_1_24(T) =L= Z('24',T)*UB('59','1','24',T);
f_DISJ_1_1_24(T).. 1.5*W_DISJ_1_1_24(T) =G= 1.5*X_DISJ_1_1_24(T) - (1-Z('24',T))*UB('59','1','24',T);
g_DISJ_1_1_24(T).. W_DISJ_1_1_24(T) =L= X_DISJ_1_1_24(T);
DISJ_1_2_24(T).. V('55','2','24',T) =E= 0;
DISJ_2_2_24(T).. V('59','2','24',T) =E= 0;
DISJ_1_3_24(T).. X('55',T) =E= SUM(D,V('55',D,'24',T));
DISJ_2_3_24(T).. X('59',T) =E= SUM(D,V('59',D,'24',T));
DISJ_1_4_24(T).. V('55','1','24',T) =L= UB('55','1','24',T)*Z('24',T);
DISJ_2_4_24(T).. V('55','2','24',T) =L= UB('55','2','24',T)*(1-Z('24',T));
DISJ_3_4_24(T).. V('59','1','24',T) =L= UB('59','1','24',T)*Z('24',T);
DISJ_4_4_24(T).. V('59','2','24',T) =L= UB('59','2','24',T)*(1-Z('24',T));

DISJ_1_1_25(T).. V('60','1','25',T) - V('56','1','25',T) =E= 0;
DISJ_2_1_25(T).. V('60','1','25',T) - 0.5*V('57','1','25',T) =E= 0;
DISJ_1_2_25(T).. V('56','2','25',T) =E= 0;
DISJ_2_2_25(T).. V('57','2','25',T) =E= 0;
DISJ_3_2_25(T).. V('60','2','25',T) =E= 0;
DISJ_1_3_25(T).. X('56',T) =E= SUM(D,V('56',D,'25',T));
DISJ_2_3_25(T).. X('57',T) =E= SUM(D,V('57',D,'25',T));
DISJ_3_3_25(T).. X('60',T) =E= SUM(D,V('60',D,'25',T));
DISJ_1_4_25(T).. V('56','1','25',T) =L= UB('56','1','25',T)*Z('25',T);
DISJ_2_4_25(T).. V('56','2','25',T) =L= UB('56','2','25',T)*(1-Z('25',T));
DISJ_3_4_25(T).. V('57','1','25',T) =L= UB('57','1','25',T)*Z('25',T);
DISJ_4_4_25(T).. V('57','2','25',T) =L= UB('57','2','25',T)*(1-Z('25',T));
DISJ_5_4_25(T).. V('60','1','25',T) =L= UB('60','1','25',T)*Z('25',T);
DISJ_6_4_25(T).. V('60','2','25',T) =L= UB('60','2','25',T)*(1-Z('25',T));

*DISJ_1_1_26(T).. (Z('26',T)+ES)*(V('66','1','26',T)/(Z('26',T)+ES) - 1.25*LOG(1+V('61','1','26',T)/(Z('26',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_26(T), Y_DISJ_1_1_26(T), W_DISJ_1_1_26(T);
X_DISJ_1_1_26.up(T) = UB('66','1','26',T)/(1.25*1);
W_DISJ_1_1_26.up(T) = UB('66','1','26',T)/(1.25*1);
Y_DISJ_1_1_26.up(T) = exp(UB('66','1','26',T)/(1.25*1));
equation d_DISJ_1_1_26(T);
equation a_DISJ_1_1_26(T), b_DISJ_1_1_26(T), c_DISJ_1_1_26(T);
equation e_DISJ_1_1_26(T), f_DISJ_1_1_26(T), g_DISJ_1_1_26(T);
DISJ_1_1_26(T).. Z('26',T)+V('61','1','26',T) =G= Y_DISJ_1_1_26(T);
d_DISJ_1_1_26(T).. 1.25*W_DISJ_1_1_26(T) =G= V('66','1','26',T);
a_DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =G= Z('26',T);
b_DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =L= Z('26',T)*exp(UB('66','1','26',T)/(1.25*1));
c_DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =G= exp(X_DISJ_1_1_26(T)) - (1-Z('26',T));
e_DISJ_1_1_26(T).. 1.25*W_DISJ_1_1_26(T) =L= Z('26',T)*UB('66','1','26',T);
f_DISJ_1_1_26(T).. 1.25*W_DISJ_1_1_26(T) =G= 1.25*X_DISJ_1_1_26(T) - (1-Z('26',T))*UB('66','1','26',T);
g_DISJ_1_1_26(T).. W_DISJ_1_1_26(T) =L= X_DISJ_1_1_26(T);
DISJ_1_2_26(T).. V('61','2','26',T) =E= 0;
DISJ_2_2_26(T).. V('66','2','26',T) =E= 0;
DISJ_1_3_26(T).. X('61',T) =E= SUM(D,V('61',D,'26',T));
DISJ_2_3_26(T).. X('66',T) =E= SUM(D,V('66',D,'26',T));
DISJ_1_4_26(T).. V('61','1','26',T) =L= UB('61','1','26',T)*Z('26',T);
DISJ_2_4_26(T).. V('61','2','26',T) =L= UB('61','2','26',T)*(1-Z('26',T));
DISJ_3_4_26(T).. V('66','1','26',T) =L= UB('66','1','26',T)*Z('26',T);
DISJ_4_4_26(T).. V('66','2','26',T) =L= UB('66','2','26',T)*(1-Z('26',T));

*DISJ_1_1_27(T).. (Z('27',T)+ES)*(V('67','1','27',T)/(Z('27',T)+ES) - 0.9*LOG(1+V('62','1','27',T)/(Z('27',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_27(T), Y_DISJ_1_1_27(T), W_DISJ_1_1_27(T);
X_DISJ_1_1_27.up(T) = UB('67','1','27',T)/(0.9*1);
W_DISJ_1_1_27.up(T) = UB('67','1','27',T)/(0.9*1);
Y_DISJ_1_1_27.up(T) = exp(UB('67','1','27',T)/(0.9*1));
equation d_DISJ_1_1_27(T);
equation a_DISJ_1_1_27(T), b_DISJ_1_1_27(T), c_DISJ_1_1_27(T);
equation e_DISJ_1_1_27(T), f_DISJ_1_1_27(T), g_DISJ_1_1_27(T);
DISJ_1_1_27(T).. Z('27',T)+V('62','1','27',T) =G= Y_DISJ_1_1_27(T);
d_DISJ_1_1_27(T).. 0.9*W_DISJ_1_1_27(T) =G= V('67','1','27',T);
a_DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =G= Z('27',T);
b_DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =L= Z('27',T)*exp(UB('67','1','27',T)/(0.9*1));
c_DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =G= exp(X_DISJ_1_1_27(T)) - (1-Z('27',T));
e_DISJ_1_1_27(T).. 0.9*W_DISJ_1_1_27(T) =L= Z('27',T)*UB('67','1','27',T);
f_DISJ_1_1_27(T).. 0.9*W_DISJ_1_1_27(T) =G= 0.9*X_DISJ_1_1_27(T) - (1-Z('27',T))*UB('67','1','27',T);
g_DISJ_1_1_27(T).. W_DISJ_1_1_27(T) =L= X_DISJ_1_1_27(T);
DISJ_1_2_27(T).. V('62','2','27',T) =E= 0;
DISJ_2_2_27(T).. V('67','2','27',T) =E= 0;
DISJ_1_3_27(T).. X('62',T) =E= SUM(D,V('62',D,'27',T));
DISJ_2_3_27(T).. X('67',T) =E= SUM(D,V('67',D,'27',T));
DISJ_1_4_27(T).. V('62','1','27',T) =L= UB('62','1','27',T)*Z('27',T);
DISJ_2_4_27(T).. V('62','2','27',T) =L= UB('62','2','27',T)*(1-Z('27',T));
DISJ_3_4_27(T).. V('67','1','27',T) =L= UB('67','1','27',T)*Z('27',T);
DISJ_4_4_27(T).. V('67','2','27',T) =L= UB('67','2','27',T)*(1-Z('27',T));

*DISJ_1_1_28(T).. (Z('28',T)+ES)*(V('68','1','28',T)/(Z('28',T)+ES) - LOG(1+V('59','1','28',T)/(Z('28',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_28(T), Y_DISJ_1_1_28(T), W_DISJ_1_1_28(T);
X_DISJ_1_1_28.up(T) = UB('68','1','28',T)/(1*1);
W_DISJ_1_1_28.up(T) = UB('68','1','28',T)/(1*1);
Y_DISJ_1_1_28.up(T) = exp(UB('68','1','28',T)/(1*1));
equation d_DISJ_1_1_28(T);
equation a_DISJ_1_1_28(T), b_DISJ_1_1_28(T), c_DISJ_1_1_28(T);
equation e_DISJ_1_1_28(T), f_DISJ_1_1_28(T), g_DISJ_1_1_28(T);
DISJ_1_1_28(T).. Z('28',T)+V('59','1','28',T) =G= Y_DISJ_1_1_28(T);
d_DISJ_1_1_28(T).. 1*W_DISJ_1_1_28(T) =G= V('68','1','28',T);
a_DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =G= Z('28',T);
b_DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =L= Z('28',T)*exp(UB('68','1','28',T)/(1*1));
c_DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =G= exp(X_DISJ_1_1_28(T)) - (1-Z('28',T));
e_DISJ_1_1_28(T).. 1*W_DISJ_1_1_28(T) =L= Z('28',T)*UB('68','1','28',T);
f_DISJ_1_1_28(T).. 1*W_DISJ_1_1_28(T) =G= 1*X_DISJ_1_1_28(T) - (1-Z('28',T))*UB('68','1','28',T);
g_DISJ_1_1_28(T).. W_DISJ_1_1_28(T) =L= X_DISJ_1_1_28(T);
DISJ_1_2_28(T).. V('59','2','28',T) =E= 0;
DISJ_2_2_28(T).. V('68','2','28',T) =E= 0;
DISJ_1_3_28(T).. X('59',T) =E= SUM(D,V('59',D,'28',T));
DISJ_2_3_28(T).. X('68',T) =E= SUM(D,V('68',D,'28',T));
DISJ_1_4_28(T).. V('59','1','28',T) =L= UB('59','1','28',T)*Z('28',T);
DISJ_2_4_28(T).. V('59','2','28',T) =L= UB('59','2','28',T)*(1-Z('28',T));
DISJ_3_4_28(T).. V('68','1','28',T) =L= UB('68','1','28',T)*Z('28',T);
DISJ_4_4_28(T).. V('68','2','28',T) =L= UB('68','2','28',T)*(1-Z('28',T));

DISJ_1_1_29(T).. V('69','1','29',T) - 0.9*V('63','1','29',T) =E= 0;
DISJ_1_2_29(T).. V('63','2','29',T) =E= 0;
DISJ_2_2_29(T).. V('69','2','29',T) =E= 0;
DISJ_1_3_29(T).. X('63',T) =E= SUM(D,V('63',D,'29',T));
DISJ_2_3_29(T).. X('69',T) =E= SUM(D,V('69',D,'29',T));
DISJ_1_4_29(T).. V('63','1','29',T) =L= UB('63','1','29',T)*Z('29',T);
DISJ_2_4_29(T).. V('63','2','29',T) =L= UB('63','2','29',T)*(1-Z('29',T));
DISJ_3_4_29(T).. V('69','1','29',T) =L= UB('69','1','29',T)*Z('29',T);
DISJ_4_4_29(T).. V('69','2','29',T) =L= UB('69','2','29',T)*(1-Z('29',T));

DISJ_1_1_30(T).. V('70','1','30',T) - 0.6*V('64','1','30',T) =E= 0;
DISJ_1_2_30(T).. V('64','2','30',T) =E= 0;
DISJ_2_2_30(T).. V('70','2','30',T) =E= 0;
DISJ_1_3_30(T).. X('64',T) =E= SUM(D,V('64',D,'30',T));
DISJ_2_3_30(T).. X('70',T) =E= SUM(D,V('70',D,'30',T));
DISJ_1_4_30(T).. V('64','1','30',T) =L= UB('64','1','30',T)*Z('30',T);
DISJ_2_4_30(T).. V('64','2','30',T) =L= UB('64','2','30',T)*(1-Z('30',T));
DISJ_3_4_30(T).. V('70','1','30',T) =L= UB('70','1','30',T)*Z('30',T);
DISJ_4_4_30(T).. V('70','2','30',T) =L= UB('70','2','30',T)*(1-Z('30',T));

*DISJ_1_1_31(T).. (Z('31',T)+ES)*(V('71','1','31',T)/(Z('31',T)+ES) - 1.1*LOG(1+V('65','1','31',T)/(Z('31',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_31(T), Y_DISJ_1_1_31(T), W_DISJ_1_1_31(T);
X_DISJ_1_1_31.up(T) = UB('71','1','31',T)/(1.1*1);
W_DISJ_1_1_31.up(T) = UB('71','1','31',T)/(1.1*1);
Y_DISJ_1_1_31.up(T) = exp(UB('71','1','31',T)/(1.1*1));
equation d_DISJ_1_1_31(T);
equation a_DISJ_1_1_31(T), b_DISJ_1_1_31(T), c_DISJ_1_1_31(T);
equation e_DISJ_1_1_31(T), f_DISJ_1_1_31(T), g_DISJ_1_1_31(T);
DISJ_1_1_31(T).. Z('31',T)+V('65','1','31',T) =G= Y_DISJ_1_1_31(T);
d_DISJ_1_1_31(T).. 1.1*W_DISJ_1_1_31(T) =G= V('71','1','31',T);
a_DISJ_1_1_31(T).. Y_DISJ_1_1_31(T) =G= Z('31',T);
b_DISJ_1_1_31(T).. Y_DISJ_1_1_31(T) =L= Z('31',T)*exp(UB('71','1','31',T)/(1.1*1));
c_DISJ_1_1_31(T).. Y_DISJ_1_1_31(T) =G= exp(X_DISJ_1_1_31(T)) - (1-Z('31',T));
e_DISJ_1_1_31(T).. 1.1*W_DISJ_1_1_31(T) =L= Z('31',T)*UB('71','1','31',T);
f_DISJ_1_1_31(T).. 1.1*W_DISJ_1_1_31(T) =G= 1.1*X_DISJ_1_1_31(T) - (1-Z('31',T))*UB('71','1','31',T);
g_DISJ_1_1_31(T).. W_DISJ_1_1_31(T) =L= X_DISJ_1_1_31(T);
DISJ_1_2_31(T).. V('65','2','31',T) =E= 0;
DISJ_2_2_31(T).. V('71','2','31',T) =E= 0;
DISJ_1_3_31(T).. X('65',T) =E= SUM(D,V('65',D,'31',T));
DISJ_2_3_31(T).. X('71',T) =E= SUM(D,V('71',D,'31',T));
DISJ_1_4_31(T).. V('65','1','31',T) =L= UB('65','1','31',T)*Z('31',T);
DISJ_2_4_31(T).. V('65','2','31',T) =L= UB('65','2','31',T)*(1-Z('31',T));
DISJ_3_4_31(T).. V('71','1','31',T) =L= UB('71','1','31',T)*Z('31',T);
DISJ_4_4_31(T).. V('71','2','31',T) =L= UB('71','2','31',T)*(1-Z('31',T));

DISJ_1_1_32(T).. V('82','1','32',T) - 0.9*V('66','1','32',T) =E= 0;
DISJ_2_1_32(T).. V('82','1','32',T) - V('74','1','32',T) =E= 0;
DISJ_1_2_32(T).. V('66','2','32',T) =E= 0;
DISJ_2_2_32(T).. V('74','2','32',T) =E= 0;
DISJ_3_2_32(T).. V('82','2','32',T) =E= 0;
DISJ_1_3_32(T).. X('66',T) =E= SUM(D,V('66',D,'32',T));
DISJ_2_3_32(T).. X('74',T) =E= SUM(D,V('74',D,'32',T));
DISJ_3_3_32(T).. X('82',T) =E= SUM(D,V('82',D,'32',T));
DISJ_1_4_32(T).. V('66','1','32',T) =L= UB('66','1','32',T)*Z('32',T);
DISJ_2_4_32(T).. V('66','2','32',T) =L= UB('66','2','32',T)*(1-Z('32',T));
DISJ_3_4_32(T).. V('74','1','32',T) =L= UB('74','1','32',T)*Z('32',T);
DISJ_4_4_32(T).. V('74','2','32',T) =L= UB('74','2','32',T)*(1-Z('32',T));
DISJ_5_4_32(T).. V('82','1','32',T) =L= UB('82','1','32',T)*Z('32',T);
DISJ_6_4_32(T).. V('82','2','32',T) =L= UB('82','2','32',T)*(1-Z('32',T));

*DISJ_1_1_33(T).. (Z('33',T)+ES)*(V('83','1','33',T)/(Z('33',T)+ES) - LOG(1+V('67','1','33',T)/(Z('33',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_33(T), Y_DISJ_1_1_33(T), W_DISJ_1_1_33(T);
X_DISJ_1_1_33.up(T) = UB('83','1','33',T)/(1*1);
W_DISJ_1_1_33.up(T) = UB('83','1','33',T)/(1*1);
Y_DISJ_1_1_33.up(T) = exp(UB('83','1','33',T)/(1*1));
equation d_DISJ_1_1_33(T);
equation a_DISJ_1_1_33(T), b_DISJ_1_1_33(T), c_DISJ_1_1_33(T);
equation e_DISJ_1_1_33(T), f_DISJ_1_1_33(T), g_DISJ_1_1_33(T);
DISJ_1_1_33(T).. Z('33',T)+V('67','1','33',T) =G= Y_DISJ_1_1_33(T);
d_DISJ_1_1_33(T).. 1*W_DISJ_1_1_33(T) =G= V('83','1','33',T);
a_DISJ_1_1_33(T).. Y_DISJ_1_1_33(T) =G= Z('33',T);
b_DISJ_1_1_33(T).. Y_DISJ_1_1_33(T) =L= Z('33',T)*exp(UB('83','1','33',T)/(1*1));
c_DISJ_1_1_33(T).. Y_DISJ_1_1_33(T) =G= exp(X_DISJ_1_1_33(T)) - (1-Z('33',T));
e_DISJ_1_1_33(T).. 1*W_DISJ_1_1_33(T) =L= Z('33',T)*UB('83','1','33',T);
f_DISJ_1_1_33(T).. 1*W_DISJ_1_1_33(T) =G= 1*X_DISJ_1_1_33(T) - (1-Z('33',T))*UB('83','1','33',T);
g_DISJ_1_1_33(T).. W_DISJ_1_1_33(T) =L= X_DISJ_1_1_33(T);
DISJ_1_2_33(T).. V('67','2','33',T) =E= 0;
DISJ_2_2_33(T).. V('83','2','33',T) =E= 0;
DISJ_1_3_33(T).. X('67',T) =E= SUM(D,V('67',D,'33',T));
DISJ_2_3_33(T).. X('83',T) =E= SUM(D,V('83',D,'33',T));
DISJ_1_4_33(T).. V('67','1','33',T) =L= UB('67','1','33',T)*Z('33',T);
DISJ_2_4_33(T).. V('67','2','33',T) =L= UB('67','2','33',T)*(1-Z('33',T));
DISJ_3_4_33(T).. V('83','1','33',T) =L= UB('83','1','33',T)*Z('33',T);
DISJ_4_4_33(T).. V('83','2','33',T) =L= UB('83','2','33',T)*(1-Z('33',T));

*DISJ_1_1_34(T).. (Z('34',T)+ES)*(V('84','1','34',T)/(Z('34',T)+ES) - 0.7*LOG(1+V('72','1','34',T)/(Z('34',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_34(T), Y_DISJ_1_1_34(T), W_DISJ_1_1_34(T);
X_DISJ_1_1_34.up(T) = UB('84','1','34',T)/(0.7*1);
W_DISJ_1_1_34.up(T) = UB('84','1','34',T)/(0.7*1);
Y_DISJ_1_1_34.up(T) = exp(UB('84','1','34',T)/(0.7*1));
equation d_DISJ_1_1_34(T);
equation a_DISJ_1_1_34(T), b_DISJ_1_1_34(T), c_DISJ_1_1_34(T);
equation e_DISJ_1_1_34(T), f_DISJ_1_1_34(T), g_DISJ_1_1_34(T);
DISJ_1_1_34(T).. Z('34',T)+V('72','1','34',T) =G= Y_DISJ_1_1_34(T);
d_DISJ_1_1_34(T).. 0.7*W_DISJ_1_1_34(T) =G= V('84','1','34',T);
a_DISJ_1_1_34(T).. Y_DISJ_1_1_34(T) =G= Z('34',T);
b_DISJ_1_1_34(T).. Y_DISJ_1_1_34(T) =L= Z('34',T)*exp(UB('84','1','34',T)/(0.7*1));
c_DISJ_1_1_34(T).. Y_DISJ_1_1_34(T) =G= exp(X_DISJ_1_1_34(T)) - (1-Z('34',T));
e_DISJ_1_1_34(T).. 0.7*W_DISJ_1_1_34(T) =L= Z('34',T)*UB('84','1','34',T);
f_DISJ_1_1_34(T).. 0.7*W_DISJ_1_1_34(T) =G= 0.7*X_DISJ_1_1_34(T) - (1-Z('34',T))*UB('84','1','34',T);
g_DISJ_1_1_34(T).. W_DISJ_1_1_34(T) =L= X_DISJ_1_1_34(T);
DISJ_1_2_34(T).. V('72','2','34',T) =E= 0;
DISJ_2_2_34(T).. V('84','2','34',T) =E= 0;
DISJ_1_3_34(T).. X('72',T) =E= SUM(D,V('72',D,'34',T));
DISJ_2_3_34(T).. X('84',T) =E= SUM(D,V('84',D,'34',T));
DISJ_1_4_34(T).. V('72','1','34',T) =L= UB('72','1','34',T)*Z('34',T);
DISJ_2_4_34(T).. V('72','2','34',T) =L= UB('72','2','34',T)*(1-Z('34',T));
DISJ_3_4_34(T).. V('84','1','34',T) =L= UB('84','1','34',T)*Z('34',T);
DISJ_4_4_34(T).. V('84','2','34',T) =L= UB('84','2','34',T)*(1-Z('34',T));

*DISJ_1_1_35(T).. (Z('35',T)+ES)*(V('85','1','35',T)/(Z('35',T)+ES) - 0.65*LOG(1+(V('73','1','35',T))/(Z('35',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_35(T), Y_DISJ_1_1_35(T), W_DISJ_1_1_35(T);
X_DISJ_1_1_35.up(T) = UB('85','1','35',T)/(0.65*1);
W_DISJ_1_1_35.up(T) = UB('85','1','35',T)/(0.65*1);
Y_DISJ_1_1_35.up(T) = exp(UB('85','1','35',T)/(0.65*1));
equation d_DISJ_1_1_35(T);
equation a_DISJ_1_1_35(T), b_DISJ_1_1_35(T), c_DISJ_1_1_35(T);
equation e_DISJ_1_1_35(T), f_DISJ_1_1_35(T), g_DISJ_1_1_35(T);
DISJ_1_1_35(T).. Z('35',T)+V('73','1','35',T) =G= Y_DISJ_1_1_35(T);
d_DISJ_1_1_35(T).. 0.65*W_DISJ_1_1_35(T) =G= V('85','1','35',T);
a_DISJ_1_1_35(T).. Y_DISJ_1_1_35(T) =G= Z('35',T);
b_DISJ_1_1_35(T).. Y_DISJ_1_1_35(T) =L= Z('35',T)*exp(UB('85','1','35',T)/(0.65*1));
c_DISJ_1_1_35(T).. Y_DISJ_1_1_35(T) =G= exp(X_DISJ_1_1_35(T)) - (1-Z('35',T));
e_DISJ_1_1_35(T).. 0.65*W_DISJ_1_1_35(T) =L= Z('35',T)*UB('85','1','35',T);
f_DISJ_1_1_35(T).. 0.65*W_DISJ_1_1_35(T) =G= 0.65*X_DISJ_1_1_35(T) - (1-Z('35',T))*UB('85','1','35',T);
g_DISJ_1_1_35(T).. W_DISJ_1_1_35(T) =L= X_DISJ_1_1_35(T);
*DISJ_2_1_35(T).. (Z('35',T)+ES)*(V('85','1','35',T)/(Z('35',T)+ES) - 0.65*LOG(1+(V('76','1','35',T))/(Z('35',T)+ES))) =L= 0;
positive variable X_DISJ_2_1_35(T), Y_DISJ_2_1_35(T), W_DISJ_2_1_35(T);
X_DISJ_2_1_35.up(T) = UB('85','1','35',T)/(0.65*1);
W_DISJ_2_1_35.up(T) = UB('85','1','35',T)/(0.65*1);
Y_DISJ_2_1_35.up(T) = exp(UB('85','1','35',T)/(0.65*1));
equation d_DISJ_2_1_35(T);
equation a_DISJ_2_1_35(T), b_DISJ_2_1_35(T), c_DISJ_2_1_35(T);
equation e_DISJ_2_1_35(T), f_DISJ_2_1_35(T), g_DISJ_2_1_35(T);
DISJ_2_1_35(T).. Z('35',T)+V('76','1','35',T) =G= Y_DISJ_2_1_35(T);
d_DISJ_2_1_35(T).. 0.65*W_DISJ_2_1_35(T) =G= V('85','1','35',T);
a_DISJ_2_1_35(T).. Y_DISJ_2_1_35(T) =G= Z('35',T);
b_DISJ_2_1_35(T).. Y_DISJ_2_1_35(T) =L= Z('35',T)*exp(UB('85','1','35',T)/(0.65*1));
c_DISJ_2_1_35(T).. Y_DISJ_2_1_35(T) =G= exp(X_DISJ_2_1_35(T)) - (1-Z('35',T));
e_DISJ_2_1_35(T).. 0.65*W_DISJ_2_1_35(T) =L= Z('35',T)*UB('85','1','35',T);
f_DISJ_2_1_35(T).. 0.65*W_DISJ_2_1_35(T) =G= 0.65*X_DISJ_2_1_35(T) - (1-Z('35',T))*UB('85','1','35',T);
g_DISJ_2_1_35(T).. W_DISJ_2_1_35(T) =L= X_DISJ_2_1_35(T);
DISJ_1_2_35(T).. V('73','2','35',T) =E= 0;
DISJ_2_2_35(T).. V('76','2','35',T) =E= 0;
DISJ_3_2_35(T).. V('85','2','35',T) =E= 0;
DISJ_1_3_35(T).. X('73',T) =E= SUM(D,V('73',D,'35',T));
DISJ_2_3_35(T).. X('76',T) =E= SUM(D,V('76',D,'35',T));
DISJ_3_3_35(T).. X('85',T) =E= SUM(D,V('85',D,'35',T));
DISJ_1_4_35(T).. V('73','1','35',T) =L= UB('73','1','35',T)*Z('35',T);
DISJ_2_4_35(T).. V('73','2','35',T) =L= UB('73','2','35',T)*(1-Z('35',T));
DISJ_3_4_35(T).. V('76','1','35',T) =L= UB('76','1','35',T)*Z('35',T);
DISJ_4_4_35(T).. V('76','2','35',T) =L= UB('76','2','35',T)*(1-Z('35',T));
DISJ_5_4_35(T).. V('85','1','35',T) =L= UB('85','1','35',T)*Z('35',T);
DISJ_6_4_35(T).. V('85','2','35',T) =L= UB('85','2','35',T)*(1-Z('35',T));

DISJ_1_1_36(T).. V('86','1','36',T) - V('77','1','36',T) =E= 0;
DISJ_1_2_36(T).. V('77','2','36',T) =E= 0;
DISJ_2_2_36(T).. V('86','2','36',T) =E= 0;
DISJ_1_3_36(T).. X('77',T) =E= SUM(D,V('77',D,'36',T));
DISJ_2_3_36(T).. X('86',T) =E= SUM(D,V('86',D,'36',T));
DISJ_1_4_36(T).. V('77','1','36',T) =L= UB('77','1','36',T)*Z('36',T);
DISJ_2_4_36(T).. V('77','2','36',T) =L= UB('77','2','36',T)*(1-Z('36',T));
DISJ_3_4_36(T).. V('86','1','36',T) =L= UB('86','1','36',T)*Z('36',T);
DISJ_4_4_36(T).. V('86','2','36',T) =L= UB('86','2','36',T)*(1-Z('36',T));

DISJ_1_1_37(T).. V('87','1','37',T) - V('78','1','37',T) =E= 0;
DISJ_1_2_37(T).. V('78','2','37',T) =E= 0;
DISJ_2_2_37(T).. V('87','2','37',T) =E= 0;
DISJ_1_3_37(T).. X('78',T) =E= SUM(D,V('78',D,'37',T));
DISJ_2_3_37(T).. X('87',T) =E= SUM(D,V('87',D,'37',T));
DISJ_1_4_37(T).. V('78','1','37',T) =L= UB('78','1','37',T)*Z('37',T);
DISJ_2_4_37(T).. V('78','2','37',T) =L= UB('78','2','37',T)*(1-Z('37',T));
DISJ_3_4_37(T).. V('87','1','37',T) =L= UB('87','1','37',T)*Z('37',T);
DISJ_4_4_37(T).. V('87','2','37',T) =L= UB('87','2','37',T)*(1-Z('37',T));

*DISJ_1_1_38(T).. (Z('38',T)+ES)*(V('88','1','38',T)/(Z('38',T)+ES) - 0.75*LOG(1+V('79','1','38',T)/(Z('38',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_38(T), Y_DISJ_1_1_38(T), W_DISJ_1_1_38(T);
X_DISJ_1_1_38.up(T) = UB('88','1','38',T)/(0.75*1);
W_DISJ_1_1_38.up(T) = UB('88','1','38',T)/(0.75*1);
Y_DISJ_1_1_38.up(T) = exp(UB('88','1','38',T)/(0.75*1));
equation d_DISJ_1_1_38(T);
equation a_DISJ_1_1_38(T), b_DISJ_1_1_38(T), c_DISJ_1_1_38(T);
equation e_DISJ_1_1_38(T), f_DISJ_1_1_38(T), g_DISJ_1_1_38(T);
DISJ_1_1_38(T).. Z('38',T)+V('79','1','38',T) =G= Y_DISJ_1_1_38(T);
d_DISJ_1_1_38(T).. 0.75*W_DISJ_1_1_38(T) =G= V('88','1','38',T);
a_DISJ_1_1_38(T).. Y_DISJ_1_1_38(T) =G= Z('38',T);
b_DISJ_1_1_38(T).. Y_DISJ_1_1_38(T) =L= Z('38',T)*exp(UB('88','1','38',T)/(0.75*1));
c_DISJ_1_1_38(T).. Y_DISJ_1_1_38(T) =G= exp(X_DISJ_1_1_38(T)) - (1-Z('38',T));
e_DISJ_1_1_38(T).. 0.75*W_DISJ_1_1_38(T) =L= Z('38',T)*UB('88','1','38',T);
f_DISJ_1_1_38(T).. 0.75*W_DISJ_1_1_38(T) =G= 0.75*X_DISJ_1_1_38(T) - (1-Z('38',T))*UB('88','1','38',T);
g_DISJ_1_1_38(T).. W_DISJ_1_1_38(T) =L= X_DISJ_1_1_38(T);
DISJ_1_2_38(T).. V('79','2','38',T) =E= 0;
DISJ_2_2_38(T).. V('88','2','38',T) =E= 0;
DISJ_1_3_38(T).. X('79',T) =E= SUM(D,V('79',D,'38',T));
DISJ_2_3_38(T).. X('88',T) =E= SUM(D,V('88',D,'38',T));
DISJ_1_4_38(T).. V('79','1','38',T) =L= UB('79','1','38',T)*Z('38',T);
DISJ_2_4_38(T).. V('79','2','38',T) =L= UB('79','2','38',T)*(1-Z('38',T));
DISJ_3_4_38(T).. V('88','1','38',T) =L= UB('88','1','38',T)*Z('38',T);
DISJ_4_4_38(T).. V('88','2','38',T) =L= UB('88','2','38',T)*(1-Z('38',T));

*DISJ_1_1_39(T).. (Z('39',T)+ES)*(V('89','1','39',T)/(Z('39',T)+ES) - 0.8*LOG(1+V('80','1','39',T)/(Z('39',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_39(T), Y_DISJ_1_1_39(T), W_DISJ_1_1_39(T);
X_DISJ_1_1_39.up(T) = UB('89','1','39',T)/(0.8*1);
W_DISJ_1_1_39.up(T) = UB('89','1','39',T)/(0.8*1);
Y_DISJ_1_1_39.up(T) = exp(UB('89','1','39',T)/(0.8*1));
equation d_DISJ_1_1_39(T);
equation a_DISJ_1_1_39(T), b_DISJ_1_1_39(T), c_DISJ_1_1_39(T);
equation e_DISJ_1_1_39(T), f_DISJ_1_1_39(T), g_DISJ_1_1_39(T);
DISJ_1_1_39(T).. Z('39',T)+V('80','1','39',T) =G= Y_DISJ_1_1_39(T);
d_DISJ_1_1_39(T).. 0.8*W_DISJ_1_1_39(T) =G= V('89','1','39',T);
a_DISJ_1_1_39(T).. Y_DISJ_1_1_39(T) =G= Z('39',T);
b_DISJ_1_1_39(T).. Y_DISJ_1_1_39(T) =L= Z('39',T)*exp(UB('89','1','39',T)/(0.8*1));
c_DISJ_1_1_39(T).. Y_DISJ_1_1_39(T) =G= exp(X_DISJ_1_1_39(T)) - (1-Z('39',T));
e_DISJ_1_1_39(T).. 0.8*W_DISJ_1_1_39(T) =L= Z('39',T)*UB('89','1','39',T);
f_DISJ_1_1_39(T).. 0.8*W_DISJ_1_1_39(T) =G= 0.8*X_DISJ_1_1_39(T) - (1-Z('39',T))*UB('89','1','39',T);
g_DISJ_1_1_39(T).. W_DISJ_1_1_39(T) =L= X_DISJ_1_1_39(T);
DISJ_1_2_39(T).. V('80','2','39',T) =E= 0;
DISJ_2_2_39(T).. V('89','2','39',T) =E= 0;
DISJ_1_3_39(T).. X('80',T) =E= SUM(D,V('80',D,'39',T));
DISJ_2_3_39(T).. X('89',T) =E= SUM(D,V('89',D,'39',T));
DISJ_1_4_39(T).. V('80','1','39',T) =L= UB('80','1','39',T)*Z('39',T);
DISJ_2_4_39(T).. V('80','2','39',T) =L= UB('80','2','39',T)*(1-Z('39',T));
DISJ_3_4_39(T).. V('89','1','39',T) =L= UB('89','1','39',T)*Z('39',T);
DISJ_4_4_39(T).. V('89','2','39',T) =L= UB('89','2','39',T)*(1-Z('39',T));

*DISJ_1_1_40(T).. (Z('40',T)+ES)*(V('90','1','40',T)/(Z('40',T)+ES) - 0.85*LOG(1+V('81','1','40',T)/(Z('40',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_40(T), Y_DISJ_1_1_40(T), W_DISJ_1_1_40(T);
X_DISJ_1_1_40.up(T) = UB('90','1','40',T)/(0.85*1);
W_DISJ_1_1_40.up(T) = UB('90','1','40',T)/(0.85*1);
Y_DISJ_1_1_40.up(T) = exp(UB('90','1','40',T)/(0.85*1));
equation d_DISJ_1_1_40(T);
equation a_DISJ_1_1_40(T), b_DISJ_1_1_40(T), c_DISJ_1_1_40(T);
equation e_DISJ_1_1_40(T), f_DISJ_1_1_40(T), g_DISJ_1_1_40(T);
DISJ_1_1_40(T).. Z('40',T)+V('81','1','40',T) =G= Y_DISJ_1_1_40(T);
d_DISJ_1_1_40(T).. 0.85*W_DISJ_1_1_40(T) =G= V('90','1','40',T);
a_DISJ_1_1_40(T).. Y_DISJ_1_1_40(T) =G= Z('40',T);
b_DISJ_1_1_40(T).. Y_DISJ_1_1_40(T) =L= Z('40',T)*exp(UB('90','1','40',T)/(0.85*1));
c_DISJ_1_1_40(T).. Y_DISJ_1_1_40(T) =G= exp(X_DISJ_1_1_40(T)) - (1-Z('40',T));
e_DISJ_1_1_40(T).. 0.85*W_DISJ_1_1_40(T) =L= Z('40',T)*UB('90','1','40',T);
f_DISJ_1_1_40(T).. 0.85*W_DISJ_1_1_40(T) =G= 0.85*X_DISJ_1_1_40(T) - (1-Z('40',T))*UB('90','1','40',T);
g_DISJ_1_1_40(T).. W_DISJ_1_1_40(T) =L= X_DISJ_1_1_40(T);
DISJ_1_2_40(T).. V('81','2','40',T) =E= 0;
DISJ_2_2_40(T).. V('90','2','40',T) =E= 0;
DISJ_1_3_40(T).. X('81',T) =E= SUM(D,V('81',D,'40',T));
DISJ_2_3_40(T).. X('90',T) =E= SUM(D,V('90',D,'40',T));
DISJ_1_4_40(T).. V('81','1','40',T) =L= UB('81','1','40',T)*Z('40',T);
DISJ_2_4_40(T).. V('81','2','40',T) =L= UB('81','2','40',T)*(1-Z('40',T));
DISJ_3_4_40(T).. V('90','1','40',T) =L= UB('90','1','40',T)*Z('40',T);
DISJ_4_4_40(T).. V('90','2','40',T) =L= UB('90','2','40',T)*(1-Z('40',T));

*Constraints in disjunct 2
DISJ2_Synthesis(I,T).. COST(I,T) =E= FC(I,T)*R(I,T);
*****************

Logic_Z(I,T,TAU)$(ORD(T) LT ORD(TAU))..                   Z(I,T) =L= Z(I,TAU);
Logic_R(I,T,TAU)$(ORD(TAU) NE ORD(T))..                   R(I,T) + R(I,TAU) =L= 1;
Logic_ZR(I,T)..                                           Z(I,T) =L= R(I,T) + Z(I,T-1);


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

*Binary Equivalence relations
*BINARY_EQUIV_1(I,T).. Z(I,T) =E= Z_BINARY(I,T);
*BINARY_EQUIV_2(I,T).. R(I,T) =E= R_BINARY(I,T);

* Bounds
X.UP('1',T) = 10;
X.UP('12',T) = 7;
X.UP('29',T) = 7;
X.UP('30',T) = 5;
X.UP('57',T) = 7;
X.UP('74',T) = 7;
X.UP('75',T) = 5;

V.up(K,D,I,T) = UB(K,D,I,T);
MODEL SYNTH_40_MULTI_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_40_MULTI_CH USING %TYPE% MAXIMIZING OBJ;
