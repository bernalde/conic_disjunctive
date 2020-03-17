*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= z*exp(x/z) <=> x <= z*log(y/z) ; x >= v1/c ; y = z + v2
*Synthesis Problem with 30 processes
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

I       /1*30/                            /* Number of process units */
K       /1*70/                            /* Number of streams */
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
                29      -10     -5
                30      -5      -5
                31      0       0
                32      0       0
                33      0       0
                34      0       0
                35      0       0
                36      0       0
                37      40      30
                38      15      20
                39      10      30
                40      30      20
                41      35      50
                42      20      30
                43      25      50
                44      15      20
                45      0       0
                46      0       0
                47      0       0
                48      0       0
                49      0       0
                50      0       0
                51      0       0
                52      30      40
                53      0       0
                54      0       0
                55      0       0
                56      0       0
                57      -1      -1
                58      0       0
                59      0       0
                60      0       0
                61      0       0
                62      0       0
                63      0       0
                64      0       0
                65      80      90
                66      285     390
                67      290     405
                68      280     400
                69      290     300
                70      350     250

TABLE FC(I,T)             /* Fixed costs in objective */
                         1       2
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
;

PARAMETER UB(K,D,I,T) /1*70 .1*2 .1*30 .1*2= 0/;

*Note: The bounds available on X('1'), X('12'), X('29'), X('30'), X('57'), X('74') and X('75') were written as X1_UP, X12_UP, X29_UP, X30_UP, X57_UP, X74_UP and X75_UP below in order to generate the optimal upper bounds on the disaggregated variables.


PARAMETERS
X1_UP(T)
/1 = 40
 2 = 40/

X12_UP(T)
/1 = 30
 2 = 30/

X29_UP(T)
/1 = 20
 2 = 20/

X30_UP(T)
/1 = 20
 2 = 20/

X57_UP(T)
/1 = 30
 2 = 30/;

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

****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1(T),MB2(T),MB3(T),MB4(T),MB5(T),MB6(T),MB7(T),MB8(T),MB9(T),MB10(T),
MB11(T),MB12(T),MB13(T),MB14(T),MB15(T),MB16(T),MB17(T)

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

DISJ2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T),L4(T),L5(T),L6(T),L7(T),L8(T),L9(T),L10(T),L11(T),L12(T),L13(T),L14(T),L15(T),L16(T),L17(T),L18(T),L19(T),L20(T)
L21(T),L22(T),L23(T),L24(T),L25(T),L26(T),L27(T),L28(T),L29(T),L30(T),L31(T),L32(T),L33(T),L34(T),L35(T),L36(T),L37(T)

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

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in Sawaya & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

*DISJ_1_1_1(T).. (Z('1',T)+ES)*(V('4','1','1',T)/(Z('1',T)+ES) - LOG(1+V('2','1','1',T)/(Z('1',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_1(T), Y_DISJ_1_1_1(T);
X_DISJ_1_1_1.up(T) = UB('4','1','1',T)/(1*1);
Y_DISJ_1_1_1.up(T) = UB('2','1','1',T) + 1;
equation d_DISJ_1_1_1(T);
equation c_DISJ_1_1_1(T);
Z.l('1',T) = 1;
DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =G= Z('1',T)*exp(X_DISJ_1_1_1(T)/Z('1',T));
c_DISJ_1_1_1(T).. X_DISJ_1_1_1(T) =G= V('4','1','1',T)/(1*1);
d_DISJ_1_1_1(T).. Y_DISJ_1_1_1(T) =E= Z('1',T)+V('2','1','1',T);
DISJ_1_2_1(T).. V('2','2','1',T) =E= 0;
DISJ_2_2_1(T).. V('4','2','1',T) =E= 0;
DISJ_1_3_1(T).. X('2',T) =E= SUM(D,V('2',D,'1',T));
DISJ_2_3_1(T).. X('4',T) =E= SUM(D,V('4',D,'1',T));
DISJ_1_4_1(T).. V('2','1','1',T) =L= UB('2','1','1',T)*Z('1',T);
DISJ_2_4_1(T).. V('2','2','1',T) =L= UB('2','2','1',T)*(1-Z('1',T));
DISJ_3_4_1(T).. V('4','1','1',T) =L= UB('4','1','1',T)*Z('1',T);
DISJ_4_4_1(T).. V('4','2','1',T) =L= UB('4','2','1',T)*(1-Z('1',T));

*DISJ_1_1_2(T).. (Z('2',T)+ES)*(V('5','1','2',T)/(Z('2',T)+ES) - 1.2*LOG(1+V('3','1','2',T)/(Z('2',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_2(T), Y_DISJ_1_1_2(T);
X_DISJ_1_1_2.up(T) = UB('5','1','2',T)/(1.2*1);
Y_DISJ_1_1_2.up(T) = UB('3','1','2',T) + 1;
equation d_DISJ_1_1_2(T);
equation c_DISJ_1_1_2(T);
Z.l('2',T) = 1;
DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =G= Z('2',T)*exp(X_DISJ_1_1_2(T)/Z('2',T));
c_DISJ_1_1_2(T).. X_DISJ_1_1_2(T) =G= V('5','1','2',T)/(1.2*1);
d_DISJ_1_1_2(T).. Y_DISJ_1_1_2(T) =E= Z('2',T)+V('3','1','2',T);
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
positive variable X_DISJ_1_1_4(T), Y_DISJ_1_1_4(T);
X_DISJ_1_1_4.up(T) = UB('14','1','4',T)/(1.5*1);
Y_DISJ_1_1_4.up(T) = UB('10','1','4',T) + 1;
equation d_DISJ_1_1_4(T);
equation c_DISJ_1_1_4(T);
Z.l('4',T) = 1;
DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =G= Z('4',T)*exp(X_DISJ_1_1_4(T)/Z('4',T));
c_DISJ_1_1_4(T).. X_DISJ_1_1_4(T) =G= V('14','1','4',T)/(1.5*1);
d_DISJ_1_1_4(T).. Y_DISJ_1_1_4(T) =E= Z('4',T)+V('10','1','4',T);
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
positive variable X_DISJ_1_1_6(T), Y_DISJ_1_1_6(T);
X_DISJ_1_1_6.up(T) = UB('21','1','6',T)/(1.25*1);
Y_DISJ_1_1_6.up(T) = UB('16','1','6',T) + 1;
equation d_DISJ_1_1_6(T);
equation c_DISJ_1_1_6(T);
Z.l('6',T) = 1;
DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =G= Z('6',T)*exp(X_DISJ_1_1_6(T)/Z('6',T));
c_DISJ_1_1_6(T).. X_DISJ_1_1_6(T) =G= V('21','1','6',T)/(1.25*1);
d_DISJ_1_1_6(T).. Y_DISJ_1_1_6(T) =E= Z('6',T)+V('16','1','6',T);
DISJ_1_2_6(T).. V('16','2','6',T) =E= 0;
DISJ_2_2_6(T).. V('21','2','6',T) =E= 0;
DISJ_1_3_6(T).. X('16',T) =E= SUM(D,V('16',D,'6',T));
DISJ_2_3_6(T).. X('21',T) =E= SUM(D,V('21',D,'6',T));
DISJ_1_4_6(T).. V('16','1','6',T) =L= UB('16','1','6',T)*Z('6',T);
DISJ_2_4_6(T).. V('16','2','6',T) =L= UB('16','2','6',T)*(1-Z('6',T));
DISJ_3_4_6(T).. V('21','1','6',T) =L= UB('21','1','6',T)*Z('6',T);
DISJ_4_4_6(T).. V('21','2','6',T) =L= UB('21','2','6',T)*(1-Z('6',T));

*DISJ_1_1_7(T).. (Z('7',T)+ES)*(V('22','1','7',T)/(Z('7',T)+ES) - 0.9*LOG(1+V('17','1','7',T)/(Z('7',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_7(T), Y_DISJ_1_1_7(T);
X_DISJ_1_1_7.up(T) = UB('22','1','7',T)/(0.9*1);
Y_DISJ_1_1_7.up(T) = UB('17','1','7',T) + 1;
equation d_DISJ_1_1_7(T);
equation c_DISJ_1_1_7(T);
Z.l('7',T) = 1;
DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =G= Z('7',T)*exp(X_DISJ_1_1_7(T)/Z('7',T));
c_DISJ_1_1_7(T).. X_DISJ_1_1_7(T) =G= V('22','1','7',T)/(0.9*1);
d_DISJ_1_1_7(T).. Y_DISJ_1_1_7(T) =E= Z('7',T)+V('17','1','7',T);
DISJ_1_2_7(T).. V('17','2','7',T) =E= 0;
DISJ_2_2_7(T).. V('22','2','7',T) =E= 0;
DISJ_1_3_7(T).. X('17',T) =E= SUM(D,V('17',D,'7',T));
DISJ_2_3_7(T).. X('22',T) =E= SUM(D,V('22',D,'7',T));
DISJ_1_4_7(T).. V('17','1','7',T) =L= UB('17','1','7',T)*Z('7',T);
DISJ_2_4_7(T).. V('17','2','7',T) =L= UB('17','2','7',T)*(1-Z('7',T));
DISJ_3_4_7(T).. V('22','1','7',T) =L= UB('22','1','7',T)*Z('7',T);
DISJ_4_4_7(T).. V('22','2','7',T) =L= UB('22','2','7',T)*(1-Z('7',T));

*DISJ_1_1_8(T).. (Z('8',T)+ES)*(V('23','1','8',T)/(Z('8',T)+ES) - LOG(1+V('14','1','8',T)/(Z('8',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_8(T), Y_DISJ_1_1_8(T);
X_DISJ_1_1_8.up(T) = UB('23','1','8',T)/(1*1);
Y_DISJ_1_1_8.up(T) = UB('14','1','8',T) + 1;
equation d_DISJ_1_1_8(T);
equation c_DISJ_1_1_8(T);
Z.l('8',T) = 1;
DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =G= Z('8',T)*exp(X_DISJ_1_1_8(T)/Z('8',T));
c_DISJ_1_1_8(T).. X_DISJ_1_1_8(T) =G= V('23','1','8',T)/(1*1);
d_DISJ_1_1_8(T).. Y_DISJ_1_1_8(T) =E= Z('8',T)+V('14','1','8',T);
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
positive variable X_DISJ_1_1_11(T), Y_DISJ_1_1_11(T);
X_DISJ_1_1_11.up(T) = UB('26','1','11',T)/(1.1*1);
Y_DISJ_1_1_11.up(T) = UB('20','1','11',T) + 1;
equation d_DISJ_1_1_11(T);
equation c_DISJ_1_1_11(T);
Z.l('11',T) = 1;
DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =G= Z('11',T)*exp(X_DISJ_1_1_11(T)/Z('11',T));
c_DISJ_1_1_11(T).. X_DISJ_1_1_11(T) =G= V('26','1','11',T)/(1.1*1);
d_DISJ_1_1_11(T).. Y_DISJ_1_1_11(T) =E= Z('11',T)+V('20','1','11',T);
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
positive variable X_DISJ_1_1_13(T), Y_DISJ_1_1_13(T);
X_DISJ_1_1_13.up(T) = UB('38','1','13',T)/(1*1);
Y_DISJ_1_1_13.up(T) = UB('22','1','13',T) + 1;
equation d_DISJ_1_1_13(T);
equation c_DISJ_1_1_13(T);
Z.l('13',T) = 1;
DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =G= Z('13',T)*exp(X_DISJ_1_1_13(T)/Z('13',T));
c_DISJ_1_1_13(T).. X_DISJ_1_1_13(T) =G= V('38','1','13',T)/(1*1);
d_DISJ_1_1_13(T).. Y_DISJ_1_1_13(T) =E= Z('13',T)+V('22','1','13',T);
DISJ_1_2_13(T).. V('22','2','13',T) =E= 0;
DISJ_2_2_13(T).. V('38','2','13',T) =E= 0;
DISJ_1_3_13(T).. X('22',T) =E= SUM(D,V('22',D,'13',T));
DISJ_2_3_13(T).. X('38',T) =E= SUM(D,V('38',D,'13',T));
DISJ_1_4_13(T).. V('22','1','13',T) =L= UB('22','1','13',T)*Z('13',T);
DISJ_2_4_13(T).. V('22','2','13',T) =L= UB('22','2','13',T)*(1-Z('13',T));
DISJ_3_4_13(T).. V('38','1','13',T) =L= UB('38','1','13',T)*Z('13',T);
DISJ_4_4_13(T).. V('38','2','13',T) =L= UB('38','2','13',T)*(1-Z('13',T));

*DISJ_1_1_14(T).. (Z('14',T)+ES)*(V('39','1','14',T)/(Z('14',T)+ES) - 0.7*LOG(1+V('27','1','14',T)/(Z('14',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_14(T), Y_DISJ_1_1_14(T);
X_DISJ_1_1_14.up(T) = UB('39','1','14',T)/(0.7*1);
Y_DISJ_1_1_14.up(T) = UB('27','1','14',T) + 1;
equation d_DISJ_1_1_14(T);
equation c_DISJ_1_1_14(T);
Z.l('14',T) = 1;
DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =G= Z('14',T)*exp(X_DISJ_1_1_14(T)/Z('14',T));
c_DISJ_1_1_14(T).. X_DISJ_1_1_14(T) =G= V('39','1','14',T)/(0.7*1);
d_DISJ_1_1_14(T).. Y_DISJ_1_1_14(T) =E= Z('14',T)+V('27','1','14',T);
DISJ_1_2_14(T).. V('27','2','14',T) =E= 0;
DISJ_2_2_14(T).. V('39','2','14',T) =E= 0;
DISJ_1_3_14(T).. X('27',T) =E= SUM(D,V('27',D,'14',T));
DISJ_2_3_14(T).. X('39',T) =E= SUM(D,V('39',D,'14',T));
DISJ_1_4_14(T).. V('27','1','14',T) =L= UB('27','1','14',T)*Z('14',T);
DISJ_2_4_14(T).. V('27','2','14',T) =L= UB('27','2','14',T)*(1-Z('14',T));
DISJ_3_4_14(T).. V('39','1','14',T) =L= UB('39','1','14',T)*Z('14',T);
DISJ_4_4_14(T).. V('39','2','14',T) =L= UB('39','2','14',T)*(1-Z('14',T));

*DISJ_1_1_15(T).. (Z('15',T)+ES)*(V('40','1','15',T)/(Z('15',T)+ES) - 0.65*LOG(1+(V('28','1','15',T))/(Z('15',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_15(T), Y_DISJ_1_1_15(T);
X_DISJ_1_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
Y_DISJ_1_1_15.up(T) = UB('28','1','15',T) + 1;
equation d_DISJ_1_1_15(T);
equation c_DISJ_1_1_15(T);
Z.l('15',T) = 1;
DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =G= Z('15',T)*exp(X_DISJ_1_1_15(T)/Z('15',T));
c_DISJ_1_1_15(T).. X_DISJ_1_1_15(T) =G= V('40','1','15',T)/(0.65*1);
d_DISJ_1_1_15(T).. Y_DISJ_1_1_15(T) =E= Z('15',T)+V('28','1','15',T);
*DISJ_2_1_15(T).. (Z('15',T)+ES)*(V('40','1','15',T)/(Z('15',T)+ES) - 0.65*LOG(1+(V('31','1','15',T))/(Z('15',T)+ES))) =L= 0;
positive variable X_DISJ_2_1_15(T), Y_DISJ_2_1_15(T);
X_DISJ_2_1_15.up(T) = UB('40','1','15',T)/(0.65*1);
Y_DISJ_2_1_15.up(T) = UB('31','1','15',T) + 1;
equation d_DISJ_2_1_15(T);
equation c_DISJ_2_1_15(T);
binary variable Z15(T);
equation Z15_eq(T);
Z15.l(T) = 1;
Z15_eq(T).. Z15(T) =E= Z('15',T);
DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =G= Z15(T)*exp(X_DISJ_2_1_15(T)/Z15(T));
c_DISJ_2_1_15(T).. X_DISJ_2_1_15(T) =G= V('40','1','15',T)/(0.65*1);
d_DISJ_2_1_15(T).. Y_DISJ_2_1_15(T) =E= Z15(T)+V('31','1','15',T);
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
positive variable X_DISJ_1_1_18(T), Y_DISJ_1_1_18(T);
X_DISJ_1_1_18.up(T) = UB('43','1','18',T)/(0.75*1);
Y_DISJ_1_1_18.up(T) = UB('34','1','18',T) + 1;
equation d_DISJ_1_1_18(T);
equation c_DISJ_1_1_18(T);
Z.l('18',T) = 1;
DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =G= Z('18',T)*exp(X_DISJ_1_1_18(T)/Z('18',T));
c_DISJ_1_1_18(T).. X_DISJ_1_1_18(T) =G= V('43','1','18',T)/(0.75*1);
d_DISJ_1_1_18(T).. Y_DISJ_1_1_18(T) =E= Z('18',T)+V('34','1','18',T);
DISJ_1_2_18(T).. V('34','2','18',T) =E= 0;
DISJ_2_2_18(T).. V('43','2','18',T) =E= 0;
DISJ_1_3_18(T).. X('34',T) =E= SUM(D,V('34',D,'18',T));
DISJ_2_3_18(T).. X('43',T) =E= SUM(D,V('43',D,'18',T));
DISJ_1_4_18(T).. V('34','1','18',T) =L= UB('34','1','18',T)*Z('18',T);
DISJ_2_4_18(T).. V('34','2','18',T) =L= UB('34','2','18',T)*(1-Z('18',T));
DISJ_3_4_18(T).. V('43','1','18',T) =L= UB('43','1','18',T)*Z('18',T);
DISJ_4_4_18(T).. V('43','2','18',T) =L= UB('43','2','18',T)*(1-Z('18',T));

*DISJ_1_1_19(T).. (Z('19',T)+ES)*(V('44','1','19',T)/(Z('19',T)+ES) - 0.8*LOG(1+V('35','1','19',T)/(Z('19',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_19(T), Y_DISJ_1_1_19(T);
X_DISJ_1_1_19.up(T) = UB('44','1','19',T)/(0.8*1);
Y_DISJ_1_1_19.up(T) = UB('35','1','19',T) + 1;
equation d_DISJ_1_1_19(T);
equation c_DISJ_1_1_19(T);
Z.l('19',T) = 1;
DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =G= Z('19',T)*exp(X_DISJ_1_1_19(T)/Z('19',T));
c_DISJ_1_1_19(T).. X_DISJ_1_1_19(T) =G= V('44','1','19',T)/(0.8*1);
d_DISJ_1_1_19(T).. Y_DISJ_1_1_19(T) =E= Z('19',T)+V('35','1','19',T);
DISJ_1_2_19(T).. V('35','2','19',T) =E= 0;
DISJ_2_2_19(T).. V('44','2','19',T) =E= 0;
DISJ_1_3_19(T).. X('35',T) =E= SUM(D,V('35',D,'19',T));
DISJ_2_3_19(T).. X('44',T) =E= SUM(D,V('44',D,'19',T));
DISJ_1_4_19(T).. V('35','1','19',T) =L= UB('35','1','19',T)*Z('19',T);
DISJ_2_4_19(T).. V('35','2','19',T) =L= UB('35','2','19',T)*(1-Z('19',T));
DISJ_3_4_19(T).. V('44','1','19',T) =L= UB('44','1','19',T)*Z('19',T);
DISJ_4_4_19(T).. V('44','2','19',T) =L= UB('44','2','19',T)*(1-Z('19',T));

*DISJ_1_1_20(T).. (Z('20',T)+ES)*(V('45','1','20',T)/(Z('20',T)+ES) - 0.85*LOG(1+V('36','1','20',T)/(Z('20',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_20(T), Y_DISJ_1_1_20(T);
X_DISJ_1_1_20.up(T) = UB('45','1','20',T)/(0.85*1);
Y_DISJ_1_1_20.up(T) = UB('36','1','20',T) + 1;
equation d_DISJ_1_1_20(T);
equation c_DISJ_1_1_20(T);
Z.l('20',T) = 1;
DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =G= Z('20',T)*exp(X_DISJ_1_1_20(T)/Z('20',T));
c_DISJ_1_1_20(T).. X_DISJ_1_1_20(T) =G= V('45','1','20',T)/(0.85*1);
d_DISJ_1_1_20(T).. Y_DISJ_1_1_20(T) =E= Z('20',T)+V('36','1','20',T);
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
positive variable X_DISJ_1_1_21(T), Y_DISJ_1_1_21(T);
X_DISJ_1_1_21.up(T) = UB('49','1','21',T)/(1*1);
Y_DISJ_1_1_21.up(T) = UB('47','1','21',T) + 1;
equation d_DISJ_1_1_21(T);
equation c_DISJ_1_1_21(T);
Z.l('21',T) = 1;
DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =G= Z('21',T)*exp(X_DISJ_1_1_21(T)/Z('21',T));
c_DISJ_1_1_21(T).. X_DISJ_1_1_21(T) =G= V('49','1','21',T)/(1*1);
d_DISJ_1_1_21(T).. Y_DISJ_1_1_21(T) =E= Z('21',T)+V('47','1','21',T);
DISJ_1_2_21(T).. V('47','2','21',T) =E= 0;
DISJ_2_2_21(T).. V('49','2','21',T) =E= 0;
DISJ_1_3_21(T).. X('47',T) =E= SUM(D,V('47',D,'21',T));
DISJ_2_3_21(T).. X('49',T) =E= SUM(D,V('49',D,'21',T));
DISJ_1_4_21(T).. V('47','1','21',T) =L= UB('47','1','21',T)*Z('21',T);
DISJ_2_4_21(T).. V('47','2','21',T) =L= UB('47','2','21',T)*(1-Z('21',T));
DISJ_3_4_21(T).. V('49','1','21',T) =L= UB('49','1','21',T)*Z('21',T);
DISJ_4_4_21(T).. V('49','2','21',T) =L= UB('49','2','21',T)*(1-Z('21',T));

*DISJ_1_1_22(T).. (Z('22',T)+ES)*(V('50','1','22',T)/(Z('22',T)+ES) - 1.2*LOG(1+V('48','1','22',T)/(Z('22',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_22(T), Y_DISJ_1_1_22(T);
X_DISJ_1_1_22.up(T) = UB('50','1','22',T)/(1.2*1);
Y_DISJ_1_1_22.up(T) = UB('48','1','22',T) + 1;
equation d_DISJ_1_1_22(T);
equation c_DISJ_1_1_22(T);
Z.l('22',T) = 1;
DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =G= Z('22',T)*exp(X_DISJ_1_1_22(T)/Z('22',T));
c_DISJ_1_1_22(T).. X_DISJ_1_1_22(T) =G= V('50','1','22',T)/(1.2*1);
d_DISJ_1_1_22(T).. Y_DISJ_1_1_22(T) =E= Z('22',T)+V('48','1','22',T);
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
positive variable X_DISJ_1_1_24(T), Y_DISJ_1_1_24(T);
X_DISJ_1_1_24.up(T) = UB('59','1','24',T)/(1.5*1);
Y_DISJ_1_1_24.up(T) = UB('55','1','24',T) + 1;
equation d_DISJ_1_1_24(T);
equation c_DISJ_1_1_24(T);
Z.l('24',T) = 1;
DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =G= Z('24',T)*exp(X_DISJ_1_1_24(T)/Z('24',T));
c_DISJ_1_1_24(T).. X_DISJ_1_1_24(T) =G= V('59','1','24',T)/(1.5*1);
d_DISJ_1_1_24(T).. Y_DISJ_1_1_24(T) =E= Z('24',T)+V('55','1','24',T);
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
positive variable X_DISJ_1_1_26(T), Y_DISJ_1_1_26(T);
X_DISJ_1_1_26.up(T) = UB('66','1','26',T)/(1.25*1);
Y_DISJ_1_1_26.up(T) = UB('61','1','26',T) + 1;
equation d_DISJ_1_1_26(T);
equation c_DISJ_1_1_26(T);
Z.l('26',T) = 1;
DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =G= Z('26',T)*exp(X_DISJ_1_1_26(T)/Z('26',T));
c_DISJ_1_1_26(T).. X_DISJ_1_1_26(T) =G= V('66','1','26',T)/(1.25*1);
d_DISJ_1_1_26(T).. Y_DISJ_1_1_26(T) =E= Z('26',T)+V('61','1','26',T);
DISJ_1_2_26(T).. V('61','2','26',T) =E= 0;
DISJ_2_2_26(T).. V('66','2','26',T) =E= 0;
DISJ_1_3_26(T).. X('61',T) =E= SUM(D,V('61',D,'26',T));
DISJ_2_3_26(T).. X('66',T) =E= SUM(D,V('66',D,'26',T));
DISJ_1_4_26(T).. V('61','1','26',T) =L= UB('61','1','26',T)*Z('26',T);
DISJ_2_4_26(T).. V('61','2','26',T) =L= UB('61','2','26',T)*(1-Z('26',T));
DISJ_3_4_26(T).. V('66','1','26',T) =L= UB('66','1','26',T)*Z('26',T);
DISJ_4_4_26(T).. V('66','2','26',T) =L= UB('66','2','26',T)*(1-Z('26',T));

*DISJ_1_1_27(T).. (Z('27',T)+ES)*(V('67','1','27',T)/(Z('27',T)+ES) - 0.9*LOG(1+V('62','1','27',T)/(Z('27',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_27(T), Y_DISJ_1_1_27(T);
X_DISJ_1_1_27.up(T) = UB('67','1','27',T)/(0.9*1);
Y_DISJ_1_1_27.up(T) = UB('62','1','27',T) + 1;
equation d_DISJ_1_1_27(T);
equation c_DISJ_1_1_27(T);
Z.l('27',T) = 1;
DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =G= Z('27',T)*exp(X_DISJ_1_1_27(T)/Z('27',T));
c_DISJ_1_1_27(T).. X_DISJ_1_1_27(T) =G= V('67','1','27',T)/(0.9*1);
d_DISJ_1_1_27(T).. Y_DISJ_1_1_27(T) =E= Z('27',T)+V('62','1','27',T);
DISJ_1_2_27(T).. V('62','2','27',T) =E= 0;
DISJ_2_2_27(T).. V('67','2','27',T) =E= 0;
DISJ_1_3_27(T).. X('62',T) =E= SUM(D,V('62',D,'27',T));
DISJ_2_3_27(T).. X('67',T) =E= SUM(D,V('67',D,'27',T));
DISJ_1_4_27(T).. V('62','1','27',T) =L= UB('62','1','27',T)*Z('27',T);
DISJ_2_4_27(T).. V('62','2','27',T) =L= UB('62','2','27',T)*(1-Z('27',T));
DISJ_3_4_27(T).. V('67','1','27',T) =L= UB('67','1','27',T)*Z('27',T);
DISJ_4_4_27(T).. V('67','2','27',T) =L= UB('67','2','27',T)*(1-Z('27',T));

*DISJ_1_1_28(T).. (Z('28',T)+ES)*(V('68','1','28',T)/(Z('28',T)+ES) - LOG(1+V('59','1','28',T)/(Z('28',T)+ES))) =L= 0;
positive variable X_DISJ_1_1_28(T), Y_DISJ_1_1_28(T);
X_DISJ_1_1_28.up(T) = UB('68','1','28',T)/(1*1);
Y_DISJ_1_1_28.up(T) = UB('59','1','28',T) + 1;
equation d_DISJ_1_1_28(T);
equation c_DISJ_1_1_28(T);
Z.l('28',T) = 1;
DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =G= Z('28',T)*exp(X_DISJ_1_1_28(T)/Z('28',T));
c_DISJ_1_1_28(T).. X_DISJ_1_1_28(T) =G= V('68','1','28',T)/(1*1);
d_DISJ_1_1_28(T).. Y_DISJ_1_1_28(T) =E= Z('28',T)+V('59','1','28',T);
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
L10(T).. -Z('3',T) + Z('1',T) + Z('2',T)                  =G= 0;
L11(T).. -Z('4',T) + Z('1',T) + Z('2',T)                  =G= 0;
L12(T).. -Z('5',T) + Z('1',T) + Z('2',T)                  =G= 0;
L13(T).. -Z('6',T) + Z('3',T)                             =G= 0;
L14(T).. -Z('7',T) + Z('3',T)                             =G= 0;
L15(T).. -Z('8',T) + Z('4',T)                             =G= 0;
L16(T).. -Z('9',T) + Z('5',T)                             =G= 0;
L17(T).. -Z('10',T) + Z('5',T)                            =G= 0;
L18(T).. -Z('11',T) + Z('5',T)                            =G= 0;
L19(T).. -Z('12',T) + Z('6',T)                            =G= 0;
L20(T).. -Z('13',T) + Z('7',T)                            =G= 0;
L21(T).. -Z('14',T) + Z('8',T)                            =G= 0;
L22(T).. -Z('15',T) + Z('8',T)                            =G= 0;
L23(T).. -Z('16',T) + Z('10',T)                           =G= 0;
L24(T).. -Z('17',T) + Z('10',T)                           =G= 0;
L25(T).. -Z('18',T) + Z('11',T)                           =G= 0;
L26(T).. -Z('19',T) + Z('11',T)                           =G= 0;
L27(T).. -Z('20',T) + Z('11',T)                           =G= 0;

L28(T).. -Z('20',T) + Z('21',T) + Z('22',T)               =G= 0;
L29(T).. -Z('23',T) + Z('26',T) + Z('27',T)               =G= 0;
L30(T).. -Z('24',T) + Z('28',T)                           =G= 0;
L31(T).. -Z('21',T) + Z('20',T)                           =G= 0;
L32(T).. -Z('22',T) + Z('20',T)                           =G= 0;
L33(T).. -Z('26',T) + Z('23',T)                           =G= 0;
L34(T).. -Z('27',T) + Z('23',T)                           =G= 0;
L35(T).. -Z('28',T) + Z('24',T)                           =G= 0;
L36(T).. -Z('29',T) + Z('25',T)                           =G= 0;
L37(T).. -Z('30',T) + Z('25',T)                           =G= 0;

* Bounds
X.UP('1',T) = 40;
X.UP('12',T) = 30;
X.UP('29',T) = 20;
X.UP('30',T) = 20;
X.UP('57',T) = 30;

V.up(K,D,I,T) = UB(K,D,I,T);
MODEL SYNTH_30_MULTI_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_30_MULTI_CH USING %TYPE% MAXIMIZING OBJ;
