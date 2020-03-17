*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Convexification by sum disaggregation and binary continuous product linearization (done twice)
*disj.. z + v2 >= z*exp(x) <=> x <= log((z+v2)/z) ; c*z*x = c*w >= v1;
*y = z*exp(x): y >= z; y <= exp(v1_ub/c)*z;    y >= exp(x) - (1-z)*exp(v1_ub/c);   y <= exp(x) - (1-z) (removed because nonconvex and inactive)
*w = z*x: w >= 0; c*w <= v1_up*z; c*w >= c*x - (1-z)*v1_ub; w <= x;
*Synthesis Problem with 15 processes
*One Period (t=1)
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

K            /1*40/                       /* Number of Synthesis Streams */
I            /1*15/                       /* Number of Synthesis Processes */
D            /1*2/                        /* Number of disjuncts per disjunction for Synthesis portion */
E            /1*4/                        /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */


;

*Epsilon used in the reformulation of non-linear constraints in disjunctions.
SCALAR  ES      /1E-6/;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

;

POSITIVE VARIABLES

X(K),V(K,D,I)
;

BINARY VARIABLES

Z(I)
;

****************************************************** DATA FOR RETROFIT PORTION *****************************************************

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
                12      0
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
                25      500
                26      350
                27      0
                28      0
                29      0
                30      0
                31      0
                32      0
                33      0
                34      0
                35      0
                36      0
                37      200
                38      250
                39      200
                40      200 /

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
                15      -4/
;

PARAMETER UB(K,D,I) /1*40 .1*2 .1*15 = 0/;

*Note: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal upper bounds on the disaggregated variables.

SCALARS
X1_UP /0/
X12_UP /0/
X29_UP /0/
X30_UP /0/;

X1_UP = 10;
X12_UP = 7;
X29_UP = 5;
X30_UP = 5;

UB('2','1','1') = X1_UP;
UB('2','2','1') = X1_UP;
UB('4','1','1') = LOG(1+X1_UP);
UB('4','2','1') = LOG(1+X1_UP);

UB('3','1','2') = X1_UP;
UB('3','2','2') = X1_UP;
UB('5','1','2') = 1.2*LOG(1+X1_UP);
UB('5','2','2') = 1.2*LOG(1+X1_UP);

UB('9','1','3') = 1.2*LOG(1+X1_UP);
UB('9','2','3') = 1.2*LOG(1+X1_UP);
UB('13','1','3') = 0.75*1.2*LOG(1+X1_UP);
UB('13','2','3') = 0.75*1.2*LOG(1+X1_UP);

UB('10','1','4') = 1.2*LOG(1+X1_UP);
UB('10','2','4') = 1.2*LOG(1+X1_UP);
UB('14','1','4') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));
UB('14','2','4') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));

UB('11','1','5') = 1.2*LOG(1+X1_UP);
UB('11','2','5') = 1.2*LOG(1+X1_UP);
UB('12','1','5') = X12_UP;
UB('12','2','5') = X12_UP;
UB('15','1','5') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('15','2','5') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);

UB('16','1','6') = 0.75*1.2*LOG(1+X1_UP);
UB('16','2','6') = 0.75*1.2*LOG(1+X1_UP);
UB('21','1','6') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('21','2','6') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));

UB('17','1','7') = 0.75*1.2*LOG(1+X1_UP);
UB('17','2','7') = 0.75*1.2*LOG(1+X1_UP);
UB('22','1','7') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('22','2','7') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));

UB('14','1','8') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));
UB('14','2','8') = 1.5*LOG(1+(1.2*LOG(1+X1_UP)));
UB('23','1','8') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
UB('23','2','8') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));

UB('18','1','9') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('18','2','9') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('24','1','9') = 0.9*(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP));
UB('24','2','9') = 0.9*(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP));

UB('19','1','10') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('19','2','10') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('25','1','10') = 0.6*(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP));
UB('25','2','10') = 0.6*(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP));

UB('20','1','11') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('20','2','11') = MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP);
UB('26','1','11') = 1.1*LOG(1+(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP)));
UB('26','2','11') = 1.1*LOG(1+(MAX(1.2*LOG(1+X1_UP), 0.5*X12_UP)));

UB('21','1','12') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('21','2','12') = 1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('29','1','12') = X29_UP;
UB('29','2','12') = X29_UP;
UB('37','1','12') = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)))), X29_UP);
UB('37','2','12') = MAX(0.9*(1.25*LOG(1+(0.75*1.2*LOG(1+X1_UP)))), X29_UP);

UB('22','1','13') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('22','2','13') = 0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)));
UB('38','1','13') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)))));
UB('38','2','13') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+X1_UP)))));

UB('27','1','14') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
UB('27','2','14') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
UB('39','1','14') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))));
UB('39','2','14') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))));

UB('28','1','15') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
UB('28','2','15') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))));
UB('31','1','15') = X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('31','2','15') = X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('40','1','15') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))), 0.65*LOG(1+ (X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('40','2','15') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+X1_UP)))))), 0.65*LOG(1+ (X30_UP + 0.9*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1,MB2,MB3,MB4,MB5,MB6,MB7,MB8,MB9,MB10,

DISJ_1_1_1
DISJ_1_2_1
DISJ_2_2_1
DISJ_1_3_1
DISJ_2_3_1
DISJ_1_4_1
DISJ_2_4_1
DISJ_3_4_1
DISJ_4_4_1

DISJ_1_1_2
DISJ_1_2_2
DISJ_2_2_2
DISJ_1_3_2
DISJ_2_3_2
DISJ_1_4_2
DISJ_2_4_2
DISJ_3_4_2
DISJ_4_4_2

DISJ_1_1_3
DISJ_1_2_3
DISJ_2_2_3
DISJ_1_3_3
DISJ_2_3_3
DISJ_1_4_3
DISJ_2_4_3
DISJ_3_4_3
DISJ_4_4_3

DISJ_1_1_4
DISJ_1_2_4
DISJ_2_2_4
DISJ_1_3_4
DISJ_2_3_4
DISJ_1_4_4
DISJ_2_4_4
DISJ_3_4_4
DISJ_4_4_4

DISJ_1_1_5
DISJ_2_1_5
DISJ_1_2_5
DISJ_2_2_5
DISJ_3_2_5
DISJ_1_3_5
DISJ_2_3_5
DISJ_3_3_5
DISJ_1_4_5
DISJ_2_4_5
DISJ_3_4_5
DISJ_4_4_5
DISJ_5_4_5
DISJ_6_4_5

DISJ_1_1_6
DISJ_1_2_6
DISJ_2_2_6
DISJ_1_3_6
DISJ_2_3_6
DISJ_1_4_6
DISJ_2_4_6
DISJ_3_4_6
DISJ_4_4_6

DISJ_1_1_7
DISJ_1_2_7
DISJ_2_2_7
DISJ_1_3_7
DISJ_2_3_7
DISJ_1_4_7
DISJ_2_4_7
DISJ_3_4_7
DISJ_4_4_7

DISJ_1_1_8
DISJ_1_2_8
DISJ_2_2_8
DISJ_1_3_8
DISJ_2_3_8
DISJ_1_4_8
DISJ_2_4_8
DISJ_3_4_8
DISJ_4_4_8

DISJ_1_1_9
DISJ_1_2_9
DISJ_2_2_9
DISJ_1_3_9
DISJ_2_3_9
DISJ_1_4_9
DISJ_2_4_9
DISJ_3_4_9
DISJ_4_4_9

DISJ_1_1_10
DISJ_1_2_10
DISJ_2_2_10
DISJ_1_3_10
DISJ_2_3_10
DISJ_1_4_10
DISJ_2_4_10
DISJ_3_4_10
DISJ_4_4_10

DISJ_1_1_11
DISJ_1_2_11
DISJ_2_2_11
DISJ_1_3_11
DISJ_2_3_11
DISJ_1_4_11
DISJ_2_4_11
DISJ_3_4_11
DISJ_4_4_11

DISJ_1_1_12
DISJ_2_1_12
DISJ_1_2_12
DISJ_2_2_12
DISJ_3_2_12
DISJ_1_3_12
DISJ_2_3_12
DISJ_3_3_12
DISJ_1_4_12
DISJ_2_4_12
DISJ_3_4_12
DISJ_4_4_12
DISJ_5_4_12
DISJ_6_4_12

DISJ_1_1_13
DISJ_1_2_13
DISJ_2_2_13
DISJ_1_3_13
DISJ_2_3_13
DISJ_1_4_13
DISJ_2_4_13
DISJ_3_4_13
DISJ_4_4_13

DISJ_1_1_14
DISJ_1_2_14
DISJ_2_2_14
DISJ_1_3_14
DISJ_2_3_14
DISJ_1_4_14
DISJ_2_4_14
DISJ_3_4_14
DISJ_4_4_14

DISJ_1_1_15
DISJ_2_1_15
DISJ_1_2_15
DISJ_2_2_15
DISJ_3_2_15
DISJ_1_3_15
DISJ_2_3_15
DISJ_3_3_15
DISJ_1_4_15
DISJ_2_4_15
DISJ_3_4_15
DISJ_4_4_15
DISJ_5_4_15
DISJ_6_4_15


D1
L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20
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

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technicallZ equations, but relax as less than or equal to inequalities (from phZsical considerations, the greater than or equal to inequalities are nonsense), which is whZ this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solelZ as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in SawaZa & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

*DISJ_1_1_1.. (Z('1')+ES)*(V('4','1','1')/(Z('1')+ES) - LOG(1+V('2','1','1')/(Z('1')+ES))) =L= 0;
positive variable X_DISJ_1_1_1, Y_DISJ_1_1_1, W_DISJ_1_1_1;
X_DISJ_1_1_1.up = UB('4','1','1')/(1*1);
W_DISJ_1_1_1.up = UB('4','1','1')/(1*1);
Y_DISJ_1_1_1.up = exp(UB('4','1','1')/(1*1));
equation d_DISJ_1_1_1;
equation a_DISJ_1_1_1, b_DISJ_1_1_1, c_DISJ_1_1_1;
equation e_DISJ_1_1_1, f_DISJ_1_1_1, g_DISJ_1_1_1;
DISJ_1_1_1.. Z('1')+V('2','1','1') =G= Y_DISJ_1_1_1;
d_DISJ_1_1_1.. 1*W_DISJ_1_1_1 =G= V('4','1','1');
a_DISJ_1_1_1.. Y_DISJ_1_1_1 =G= Z('1');
b_DISJ_1_1_1.. Y_DISJ_1_1_1 =L= Z('1')*exp(UB('4','1','1')/(1*1));
c_DISJ_1_1_1.. Y_DISJ_1_1_1 =G= exp(X_DISJ_1_1_1) - (1-Z('1'));
e_DISJ_1_1_1.. 1*W_DISJ_1_1_1 =L= Z('1')*UB('4','1','1');
f_DISJ_1_1_1.. 1*W_DISJ_1_1_1 =G= 1*X_DISJ_1_1_1 - (1-Z('1'))*UB('4','1','1');
g_DISJ_1_1_1.. W_DISJ_1_1_1 =L= X_DISJ_1_1_1;
DISJ_1_2_1.. V('2','2','1') =E= 0;
DISJ_2_2_1.. V('4','2','1') =E= 0;
DISJ_1_3_1.. X('2') =E= SUM(D,V('2',D,'1'));
DISJ_2_3_1.. X('4') =E= SUM(D,V('4',D,'1'));
DISJ_1_4_1.. V('2','1','1') =L= UB('2','1','1')*Z('1');
DISJ_2_4_1.. V('2','2','1') =L= UB('2','2','1')*(1-Z('1'));
DISJ_3_4_1.. V('4','1','1') =L= UB('4','1','1')*Z('1');
DISJ_4_4_1.. V('4','2','1') =L= UB('4','2','1')*(1-Z('1'));

*DISJ_1_1_2.. (Z('2')+ES)*(V('5','1','2')/(Z('2')+ES) - 1.2*LOG(1+V('3','1','2')/(Z('2')+ES))) =L= 0;
positive variable X_DISJ_1_1_2, Y_DISJ_1_1_2, W_DISJ_1_1_2;
X_DISJ_1_1_2.up = UB('5','1','2')/(1.2*1);
W_DISJ_1_1_2.up = UB('5','1','2')/(1.2*1);
Y_DISJ_1_1_2.up = exp(UB('5','1','2')/(1.2*1));
equation d_DISJ_1_1_2;
equation a_DISJ_1_1_2, b_DISJ_1_1_2, c_DISJ_1_1_2;
equation e_DISJ_1_1_2, f_DISJ_1_1_2, g_DISJ_1_1_2;
DISJ_1_1_2.. Z('2')+V('3','1','2') =G= Y_DISJ_1_1_2;
d_DISJ_1_1_2.. 1.2*W_DISJ_1_1_2 =G= V('5','1','2');
a_DISJ_1_1_2.. Y_DISJ_1_1_2 =G= Z('2');
b_DISJ_1_1_2.. Y_DISJ_1_1_2 =L= Z('2')*exp(UB('5','1','2')/(1.2*1));
c_DISJ_1_1_2.. Y_DISJ_1_1_2 =G= exp(X_DISJ_1_1_2) - (1-Z('2'));
e_DISJ_1_1_2.. 1.2*W_DISJ_1_1_2 =L= Z('2')*UB('5','1','2');
f_DISJ_1_1_2.. 1.2*W_DISJ_1_1_2 =G= 1.2*X_DISJ_1_1_2 - (1-Z('2'))*UB('5','1','2');
g_DISJ_1_1_2.. W_DISJ_1_1_2 =L= X_DISJ_1_1_2;
DISJ_1_2_2.. V('3','2','2') =E= 0;
DISJ_2_2_2.. V('5','2','2') =E= 0;
DISJ_1_3_2.. X('3') =E= SUM(D,V('3',D,'2'));
DISJ_2_3_2.. X('5') =E= SUM(D,V('5',D,'2'));
DISJ_1_4_2.. V('3','1','2') =L= UB('3','1','2')*Z('2');
DISJ_2_4_2.. V('3','2','2') =L= UB('3','2','2')*(1-Z('2'));
DISJ_3_4_2.. V('5','1','2') =L= UB('5','1','2')*Z('2');
DISJ_4_4_2.. V('5','2','2') =L= UB('5','2','2')*(1-Z('2'));

DISJ_1_1_3.. V('13','1','3') - 0.75*V('9','1','3') =E= 0;
DISJ_1_2_3.. V('9','2','3') =E= 0;
DISJ_2_2_3.. V('13','2','3') =E= 0;
DISJ_1_3_3.. X('9') =E= SUM(D,V('9',D,'3'));
DISJ_2_3_3.. X('13') =E= SUM(D,V('13',D,'3'));
DISJ_1_4_3.. V('9','1','3') =L= UB('9','1','3')*Z('3');
DISJ_2_4_3.. V('9','2','3') =L= UB('9','2','3')*(1-Z('3'));
DISJ_3_4_3.. V('13','1','3') =L= UB('13','1','3')*Z('3');
DISJ_4_4_3.. V('13','2','3') =L= UB('13','2','3')*(1-Z('3'));

*DISJ_1_1_4.. (Z('4')+ES)*(V('14','1','4')/(Z('4')+ES) - 1.5*LOG(1+V('10','1','4')/(Z('4')+ES))) =L= 0;
positive variable X_DISJ_1_1_4, Y_DISJ_1_1_4, W_DISJ_1_1_4;
X_DISJ_1_1_4.up = UB('14','1','4')/(1.5*1);
W_DISJ_1_1_4.up = UB('14','1','4')/(1.5*1);
Y_DISJ_1_1_4.up = exp(UB('14','1','4')/(1.5*1));
equation d_DISJ_1_1_4;
equation a_DISJ_1_1_4, b_DISJ_1_1_4, c_DISJ_1_1_4;
equation e_DISJ_1_1_4, f_DISJ_1_1_4, g_DISJ_1_1_4;
DISJ_1_1_4.. Z('4')+V('10','1','4') =G= Y_DISJ_1_1_4;
d_DISJ_1_1_4.. 1.5*W_DISJ_1_1_4 =G= V('14','1','4');
a_DISJ_1_1_4.. Y_DISJ_1_1_4 =G= Z('4');
b_DISJ_1_1_4.. Y_DISJ_1_1_4 =L= Z('4')*exp(UB('14','1','4')/(1.5*1));
c_DISJ_1_1_4.. Y_DISJ_1_1_4 =G= exp(X_DISJ_1_1_4) - (1-Z('4'));
e_DISJ_1_1_4.. 1.5*W_DISJ_1_1_4 =L= Z('4')*UB('14','1','4');
f_DISJ_1_1_4.. 1.5*W_DISJ_1_1_4 =G= 1.5*X_DISJ_1_1_4 - (1-Z('4'))*UB('14','1','4');
g_DISJ_1_1_4.. W_DISJ_1_1_4 =L= X_DISJ_1_1_4;
DISJ_1_2_4.. V('10','2','4') =E= 0;
DISJ_2_2_4.. V('14','2','4') =E= 0;
DISJ_1_3_4.. X('10') =E= SUM(D,V('10',D,'4'));
DISJ_2_3_4.. X('14') =E= SUM(D,V('14',D,'4'));
DISJ_1_4_4.. V('10','1','4') =L= UB('10','1','4')*Z('4');
DISJ_2_4_4.. V('10','2','4') =L= UB('10','2','4')*(1-Z('4'));
DISJ_3_4_4.. V('14','1','4') =L= UB('14','1','4')*Z('4');
DISJ_4_4_4.. V('14','2','4') =L= UB('14','2','4')*(1-Z('4'));

DISJ_1_1_5.. V('15','1','5') - V('11','1','5')  =E= 0;
DISJ_2_1_5.. V('15','1','5') - 0.5*V('12','1','5') =E= 0;
DISJ_1_2_5.. V('11','2','5') =E= 0;
DISJ_2_2_5.. V('12','2','5') =E= 0;
DISJ_3_2_5.. V('15','2','5') =E= 0;
DISJ_1_3_5.. X('11') =E= SUM(D,V('11',D,'5'));
DISJ_2_3_5.. X('12') =E= SUM(D,V('12',D,'5'));
DISJ_3_3_5.. X('15') =E= SUM(D,V('15',D,'5'));
DISJ_1_4_5.. V('11','1','5') =L= UB('11','1','5')*Z('5');
DISJ_2_4_5.. V('11','2','5') =L= UB('11','2','5')*(1-Z('5'));
DISJ_3_4_5.. V('12','1','5') =L= UB('12','1','5')*Z('5');
DISJ_4_4_5.. V('12','2','5') =L= UB('12','2','5')*(1-Z('5'));
DISJ_5_4_5.. V('15','1','5') =L= UB('15','1','5')*Z('5');
DISJ_6_4_5.. V('15','2','5') =L= UB('15','2','5')*(1-Z('5'));

*DISJ_1_1_6.. (Z('6')+ES)*(V('21','1','6')/(Z('6')+ES) - 1.25*LOG(1+V('16','1','6')/(Z('6')+ES))) =L= 0;
positive variable X_DISJ_1_1_6, Y_DISJ_1_1_6, W_DISJ_1_1_6;
X_DISJ_1_1_6.up = UB('21','1','6')/(1.25*1);
W_DISJ_1_1_6.up = UB('21','1','6')/(1.25*1);
Y_DISJ_1_1_6.up = exp(UB('21','1','6')/(1.25*1));
equation d_DISJ_1_1_6;
equation a_DISJ_1_1_6, b_DISJ_1_1_6, c_DISJ_1_1_6;
equation e_DISJ_1_1_6, f_DISJ_1_1_6, g_DISJ_1_1_6;
DISJ_1_1_6.. Z('6')+V('16','1','6') =G= Y_DISJ_1_1_6;
d_DISJ_1_1_6.. 1.25*W_DISJ_1_1_6 =G= V('21','1','6');
a_DISJ_1_1_6.. Y_DISJ_1_1_6 =G= Z('6');
b_DISJ_1_1_6.. Y_DISJ_1_1_6 =L= Z('6')*exp(UB('21','1','6')/(1.25*1));
c_DISJ_1_1_6.. Y_DISJ_1_1_6 =G= exp(X_DISJ_1_1_6) - (1-Z('6'));
e_DISJ_1_1_6.. 1.25*W_DISJ_1_1_6 =L= Z('6')*UB('21','1','6');
f_DISJ_1_1_6.. 1.25*W_DISJ_1_1_6 =G= 1.25*X_DISJ_1_1_6 - (1-Z('6'))*UB('21','1','6');
g_DISJ_1_1_6.. W_DISJ_1_1_6 =L= X_DISJ_1_1_6;
DISJ_1_2_6.. V('16','2','6') =E= 0;
DISJ_2_2_6.. V('21','2','6') =E= 0;
DISJ_1_3_6.. X('16') =E= SUM(D,V('16',D,'6'));
DISJ_2_3_6.. X('21') =E= SUM(D,V('21',D,'6'));
DISJ_1_4_6.. V('16','1','6') =L= UB('16','1','6')*Z('6');
DISJ_2_4_6.. V('16','2','6') =L= UB('16','2','6')*(1-Z('6'));
DISJ_3_4_6.. V('21','1','6') =L= UB('21','1','6')*Z('6');
DISJ_4_4_6.. V('21','2','6') =L= UB('21','2','6')*(1-Z('6'));

*DISJ_1_1_7.. (Z('7')+ES)*(V('22','1','7')/(Z('7')+ES) - 0.9*LOG(1+V('17','1','7')/(Z('7')+ES))) =L= 0;
positive variable X_DISJ_1_1_7, Y_DISJ_1_1_7, W_DISJ_1_1_7;
X_DISJ_1_1_7.up = UB('22','1','7')/(0.9*1);
W_DISJ_1_1_7.up = UB('22','1','7')/(0.9*1);
Y_DISJ_1_1_7.up = exp(UB('22','1','7')/(0.9*1));
equation d_DISJ_1_1_7;
equation a_DISJ_1_1_7, b_DISJ_1_1_7, c_DISJ_1_1_7;
equation e_DISJ_1_1_7, f_DISJ_1_1_7, g_DISJ_1_1_7;
DISJ_1_1_7.. Z('7')+V('17','1','7') =G= Y_DISJ_1_1_7;
d_DISJ_1_1_7.. 0.9*W_DISJ_1_1_7 =G= V('22','1','7');
a_DISJ_1_1_7.. Y_DISJ_1_1_7 =G= Z('7');
b_DISJ_1_1_7.. Y_DISJ_1_1_7 =L= Z('7')*exp(UB('22','1','7')/(0.9*1));
c_DISJ_1_1_7.. Y_DISJ_1_1_7 =G= exp(X_DISJ_1_1_7) - (1-Z('7'));
e_DISJ_1_1_7.. 0.9*W_DISJ_1_1_7 =L= Z('7')*UB('22','1','7');
f_DISJ_1_1_7.. 0.9*W_DISJ_1_1_7 =G= 0.9*X_DISJ_1_1_7 - (1-Z('7'))*UB('22','1','7');
g_DISJ_1_1_7.. W_DISJ_1_1_7 =L= X_DISJ_1_1_7;
DISJ_1_2_7.. V('17','2','7') =E= 0;
DISJ_2_2_7.. V('22','2','7') =E= 0;
DISJ_1_3_7.. X('17') =E= SUM(D,V('17',D,'7'));
DISJ_2_3_7.. X('22') =E= SUM(D,V('22',D,'7'));
DISJ_1_4_7.. V('17','1','7') =L= UB('17','1','7')*Z('7');
DISJ_2_4_7.. V('17','2','7') =L= UB('17','2','7')*(1-Z('7'));
DISJ_3_4_7.. V('22','1','7') =L= UB('22','1','7')*Z('7');
DISJ_4_4_7.. V('22','2','7') =L= UB('22','2','7')*(1-Z('7'));

*DISJ_1_1_8.. (Z('8')+ES)*(V('23','1','8')/(Z('8')+ES) - LOG(1+V('14','1','8')/(Z('8')+ES))) =L= 0;
positive variable X_DISJ_1_1_8, Y_DISJ_1_1_8, W_DISJ_1_1_8;
X_DISJ_1_1_8.up = UB('23','1','8')/(1*1);
W_DISJ_1_1_8.up = UB('23','1','8')/(1*1);
Y_DISJ_1_1_8.up = exp(UB('23','1','8')/(1*1));
equation d_DISJ_1_1_8;
equation a_DISJ_1_1_8, b_DISJ_1_1_8, c_DISJ_1_1_8;
equation e_DISJ_1_1_8, f_DISJ_1_1_8, g_DISJ_1_1_8;
DISJ_1_1_8.. Z('8')+V('14','1','8') =G= Y_DISJ_1_1_8;
d_DISJ_1_1_8.. 1*W_DISJ_1_1_8 =G= V('23','1','8');
a_DISJ_1_1_8.. Y_DISJ_1_1_8 =G= Z('8');
b_DISJ_1_1_8.. Y_DISJ_1_1_8 =L= Z('8')*exp(UB('23','1','8')/(1*1));
c_DISJ_1_1_8.. Y_DISJ_1_1_8 =G= exp(X_DISJ_1_1_8) - (1-Z('8'));
e_DISJ_1_1_8.. 1*W_DISJ_1_1_8 =L= Z('8')*UB('23','1','8');
f_DISJ_1_1_8.. 1*W_DISJ_1_1_8 =G= 1*X_DISJ_1_1_8 - (1-Z('8'))*UB('23','1','8');
g_DISJ_1_1_8.. W_DISJ_1_1_8 =L= X_DISJ_1_1_8;
DISJ_1_2_8.. V('14','2','8') =E= 0;
DISJ_2_2_8.. V('23','2','8') =E= 0;
DISJ_1_3_8.. X('14') =E= SUM(D,V('14',D,'8'));
DISJ_2_3_8.. X('23') =E= SUM(D,V('23',D,'8'));
DISJ_1_4_8.. V('14','1','8') =L= UB('14','1','8')*Z('8');
DISJ_2_4_8.. V('14','2','8') =L= UB('14','2','8')*(1-Z('8'));
DISJ_3_4_8.. V('23','1','8') =L= UB('23','1','8')*Z('8');
DISJ_4_4_8.. V('23','2','8') =L= UB('23','2','8')*(1-Z('8'));

DISJ_1_1_9.. V('24','1','9') - 0.9*V('18','1','9') =E= 0;
DISJ_1_2_9.. V('18','2','9') =E= 0;
DISJ_2_2_9.. V('24','2','9') =E= 0;
DISJ_1_3_9.. X('18') =E= SUM(D,V('18',D,'9'));
DISJ_2_3_9.. X('24') =E= SUM(D,V('24',D,'9'));
DISJ_1_4_9.. V('18','1','9') =L= UB('18','1','9')*Z('9');
DISJ_2_4_9.. V('18','2','9') =L= UB('18','2','9')*(1-Z('9'));
DISJ_3_4_9.. V('24','1','9') =L= UB('24','1','9')*Z('9');
DISJ_4_4_9.. V('24','2','9') =L= UB('24','2','9')*(1-Z('9'));

DISJ_1_1_10.. V('25','1','10') - 0.6*V('19','1','10') =E= 0;
DISJ_1_2_10.. V('19','2','10') =E= 0;
DISJ_2_2_10.. V('25','2','10') =E= 0;
DISJ_1_3_10.. X('19') =E= SUM(D,V('19',D,'10'));
DISJ_2_3_10.. X('25') =E= SUM(D,V('25',D,'10'));
DISJ_1_4_10.. V('19','1','10') =L= UB('19','1','10')*Z('10');
DISJ_2_4_10.. V('19','2','10') =L= UB('19','2','10')*(1-Z('10'));
DISJ_3_4_10.. V('25','1','10') =L= UB('25','1','10')*Z('10');
DISJ_4_4_10.. V('25','2','10') =L= UB('25','2','10')*(1-Z('10'));

*DISJ_1_1_11.. (Z('11')+ES)*(V('26','1','11')/(Z('11')+ES) - 1.1*LOG(1+V('20','1','11')/(Z('11')+ES))) =L= 0;
positive variable X_DISJ_1_1_11, Y_DISJ_1_1_11, W_DISJ_1_1_11;
X_DISJ_1_1_11.up = UB('26','1','11')/(1.1*1);
W_DISJ_1_1_11.up = UB('26','1','11')/(1.1*1);
Y_DISJ_1_1_11.up = exp(UB('26','1','11')/(1.1*1));
equation d_DISJ_1_1_11;
equation a_DISJ_1_1_11, b_DISJ_1_1_11, c_DISJ_1_1_11;
equation e_DISJ_1_1_11, f_DISJ_1_1_11, g_DISJ_1_1_11;
DISJ_1_1_11.. Z('11')+V('20','1','11') =G= Y_DISJ_1_1_11;
d_DISJ_1_1_11.. 1.1*W_DISJ_1_1_11 =G= V('26','1','11');
a_DISJ_1_1_11.. Y_DISJ_1_1_11 =G= Z('11');
b_DISJ_1_1_11.. Y_DISJ_1_1_11 =L= Z('11')*exp(UB('26','1','11')/(1.1*1));
c_DISJ_1_1_11.. Y_DISJ_1_1_11 =G= exp(X_DISJ_1_1_11) - (1-Z('11'));
e_DISJ_1_1_11.. 1.1*W_DISJ_1_1_11 =L= Z('11')*UB('26','1','11');
f_DISJ_1_1_11.. 1.1*W_DISJ_1_1_11 =G= 1.1*X_DISJ_1_1_11 - (1-Z('11'))*UB('26','1','11');
g_DISJ_1_1_11.. W_DISJ_1_1_11 =L= X_DISJ_1_1_11;
DISJ_1_2_11.. V('20','2','11') =E= 0;
DISJ_2_2_11.. V('26','2','11') =E= 0;
DISJ_1_3_11.. X('20') =E= SUM(D,V('20',D,'11'));
DISJ_2_3_11.. X('26') =E= SUM(D,V('26',D,'11'));
DISJ_1_4_11.. V('20','1','11') =L= UB('20','1','11')*Z('11');
DISJ_2_4_11.. V('20','2','11') =L= UB('20','2','11')*(1-Z('11'));
DISJ_3_4_11.. V('26','1','11') =L= UB('26','1','11')*Z('11');
DISJ_4_4_11.. V('26','2','11') =L= UB('26','2','11')*(1-Z('11'));

DISJ_1_1_12.. V('37','1','12') - 0.9*V('21','1','12') =E= 0;
DISJ_2_1_12.. V('37','1','12') - V('29','1','12') =E= 0;
DISJ_1_2_12.. V('21','2','12') =E= 0;
DISJ_2_2_12.. V('29','2','12') =E= 0;
DISJ_3_2_12.. V('37','2','12') =E= 0;
DISJ_1_3_12.. X('21') =E= SUM(D,V('21',D,'12'));
DISJ_2_3_12.. X('29') =E= SUM(D,V('29',D,'12'));
DISJ_3_3_12.. X('37') =E= SUM(D,V('37',D,'12'));
DISJ_1_4_12.. V('21','1','12') =L= UB('21','1','12')*Z('12');
DISJ_2_4_12.. V('21','2','12') =L= UB('21','2','12')*(1-Z('12'));
DISJ_3_4_12.. V('29','1','12') =L= UB('29','1','12')*Z('12');
DISJ_4_4_12.. V('29','2','12') =L= UB('29','2','12')*(1-Z('12'));
DISJ_5_4_12.. V('37','1','12') =L= UB('37','1','12')*Z('12');
DISJ_6_4_12.. V('37','2','12') =L= UB('37','2','12')*(1-Z('12'));

*DISJ_1_1_13.. (Z('13')+ES)*(V('38','1','13')/(Z('13')+ES) - LOG(1+V('22','1','13')/(Z('13')+ES))) =L= 0;
positive variable X_DISJ_1_1_13, Y_DISJ_1_1_13, W_DISJ_1_1_13;
X_DISJ_1_1_13.up = UB('38','1','13')/(1*1);
W_DISJ_1_1_13.up = UB('38','1','13')/(1*1);
Y_DISJ_1_1_13.up = exp(UB('38','1','13')/(1*1));
equation d_DISJ_1_1_13;
equation a_DISJ_1_1_13, b_DISJ_1_1_13, c_DISJ_1_1_13;
equation e_DISJ_1_1_13, f_DISJ_1_1_13, g_DISJ_1_1_13;
DISJ_1_1_13.. Z('13')+V('22','1','13') =G= Y_DISJ_1_1_13;
d_DISJ_1_1_13.. 1*W_DISJ_1_1_13 =G= V('38','1','13');
a_DISJ_1_1_13.. Y_DISJ_1_1_13 =G= Z('13');
b_DISJ_1_1_13.. Y_DISJ_1_1_13 =L= Z('13')*exp(UB('38','1','13')/(1*1));
c_DISJ_1_1_13.. Y_DISJ_1_1_13 =G= exp(X_DISJ_1_1_13) - (1-Z('13'));
e_DISJ_1_1_13.. 1*W_DISJ_1_1_13 =L= Z('13')*UB('38','1','13');
f_DISJ_1_1_13.. 1*W_DISJ_1_1_13 =G= 1*X_DISJ_1_1_13 - (1-Z('13'))*UB('38','1','13');
g_DISJ_1_1_13.. W_DISJ_1_1_13 =L= X_DISJ_1_1_13;
DISJ_1_2_13.. V('22','2','13') =E= 0;
DISJ_2_2_13.. V('38','2','13') =E= 0;
DISJ_1_3_13.. X('22') =E= SUM(D,V('22',D,'13'));
DISJ_2_3_13.. X('38') =E= SUM(D,V('38',D,'13'));
DISJ_1_4_13.. V('22','1','13') =L= UB('22','1','13')*Z('13');
DISJ_2_4_13.. V('22','2','13') =L= UB('22','2','13')*(1-Z('13'));
DISJ_3_4_13.. V('38','1','13') =L= UB('38','1','13')*Z('13');
DISJ_4_4_13.. V('38','2','13') =L= UB('38','2','13')*(1-Z('13'));

*DISJ_1_1_14.. (Z('14')+ES)*(V('39','1','14')/(Z('14')+ES) - 0.7*LOG(1+V('27','1','14')/(Z('14')+ES))) =L= 0;
positive variable X_DISJ_1_1_14, Y_DISJ_1_1_14, W_DISJ_1_1_14;
X_DISJ_1_1_14.up = UB('39','1','14')/(0.7*1);
W_DISJ_1_1_14.up = UB('39','1','14')/(0.7*1);
Y_DISJ_1_1_14.up = exp(UB('39','1','14')/(0.7*1));
equation d_DISJ_1_1_14;
equation a_DISJ_1_1_14, b_DISJ_1_1_14, c_DISJ_1_1_14;
equation e_DISJ_1_1_14, f_DISJ_1_1_14, g_DISJ_1_1_14;
DISJ_1_1_14.. Z('14')+V('27','1','14') =G= Y_DISJ_1_1_14;
d_DISJ_1_1_14.. 0.7*W_DISJ_1_1_14 =G= V('39','1','14');
a_DISJ_1_1_14.. Y_DISJ_1_1_14 =G= Z('14');
b_DISJ_1_1_14.. Y_DISJ_1_1_14 =L= Z('14')*exp(UB('39','1','14')/(0.7*1));
c_DISJ_1_1_14.. Y_DISJ_1_1_14 =G= exp(X_DISJ_1_1_14) - (1-Z('14'));
e_DISJ_1_1_14.. 0.7*W_DISJ_1_1_14 =L= Z('14')*UB('39','1','14');
f_DISJ_1_1_14.. 0.7*W_DISJ_1_1_14 =G= 0.7*X_DISJ_1_1_14 - (1-Z('14'))*UB('39','1','14');
g_DISJ_1_1_14.. W_DISJ_1_1_14 =L= X_DISJ_1_1_14;
DISJ_1_2_14.. V('27','2','14') =E= 0;
DISJ_2_2_14.. V('39','2','14') =E= 0;
DISJ_1_3_14.. X('27') =E= SUM(D,V('27',D,'14'));
DISJ_2_3_14.. X('39') =E= SUM(D,V('39',D,'14'));
DISJ_1_4_14.. V('27','1','14') =L= UB('27','1','14')*Z('14');
DISJ_2_4_14.. V('27','2','14') =L= UB('27','2','14')*(1-Z('14'));
DISJ_3_4_14.. V('39','1','14') =L= UB('39','1','14')*Z('14');
DISJ_4_4_14.. V('39','2','14') =L= UB('39','2','14')*(1-Z('14'));

*DISJ_1_1_15.. (Z('15')+ES)*(V('40','1','15')/(Z('15')+ES) - 0.65*LOG(1+(V('28','1','15'))/(Z('15')+ES))) =L= 0;
positive variable X_DISJ_1_1_15, Y_DISJ_1_1_15, W_DISJ_1_1_15;
X_DISJ_1_1_15.up = UB('40','1','15')/(0.65*1);
W_DISJ_1_1_15.up = UB('40','1','15')/(0.65*1);
Y_DISJ_1_1_15.up = exp(UB('40','1','15')/(0.65*1));
equation d_DISJ_1_1_15;
equation a_DISJ_1_1_15, b_DISJ_1_1_15, c_DISJ_1_1_15;
equation e_DISJ_1_1_15, f_DISJ_1_1_15, g_DISJ_1_1_15;
DISJ_1_1_15.. Z('15')+V('28','1','15') =G= Y_DISJ_1_1_15;
d_DISJ_1_1_15.. 0.65*W_DISJ_1_1_15 =G= V('40','1','15');
a_DISJ_1_1_15.. Y_DISJ_1_1_15 =G= Z('15');
b_DISJ_1_1_15.. Y_DISJ_1_1_15 =L= Z('15')*exp(UB('40','1','15')/(0.65*1));
c_DISJ_1_1_15.. Y_DISJ_1_1_15 =G= exp(X_DISJ_1_1_15) - (1-Z('15'));
e_DISJ_1_1_15.. 0.65*W_DISJ_1_1_15 =L= Z('15')*UB('40','1','15');
f_DISJ_1_1_15.. 0.65*W_DISJ_1_1_15 =G= 0.65*X_DISJ_1_1_15 - (1-Z('15'))*UB('40','1','15');
g_DISJ_1_1_15.. W_DISJ_1_1_15 =L= X_DISJ_1_1_15;
*DISJ_2_1_15.. (Z('15')+ES)*(V('40','1','15')/(Z('15')+ES) - 0.65*LOG(1+(V('31','1','15'))/(Z('15')+ES))) =L= 0;
positive variable X_DISJ_2_1_15, Y_DISJ_2_1_15, W_DISJ_2_1_15;
X_DISJ_2_1_15.up = UB('40','1','15')/(0.65*1);
W_DISJ_2_1_15.up = UB('40','1','15')/(0.65*1);
Y_DISJ_2_1_15.up = exp(UB('40','1','15')/(0.65*1));
equation d_DISJ_2_1_15;
equation a_DISJ_2_1_15, b_DISJ_2_1_15, c_DISJ_2_1_15;
equation e_DISJ_2_1_15, f_DISJ_2_1_15, g_DISJ_2_1_15;
DISJ_2_1_15.. Z('15')+V('31','1','15') =G= Y_DISJ_2_1_15;
d_DISJ_2_1_15.. 0.65*W_DISJ_2_1_15 =G= V('40','1','15');
a_DISJ_2_1_15.. Y_DISJ_2_1_15 =G= Z('15');
b_DISJ_2_1_15.. Y_DISJ_2_1_15 =L= Z('15')*exp(UB('40','1','15')/(0.65*1));
c_DISJ_2_1_15.. Y_DISJ_2_1_15 =G= exp(X_DISJ_2_1_15) - (1-Z('15'));
e_DISJ_2_1_15.. 0.65*W_DISJ_2_1_15 =L= Z('15')*UB('40','1','15');
f_DISJ_2_1_15.. 0.65*W_DISJ_2_1_15 =G= 0.65*X_DISJ_2_1_15 - (1-Z('15'))*UB('40','1','15');
g_DISJ_2_1_15.. W_DISJ_2_1_15 =L= X_DISJ_2_1_15;
DISJ_1_2_15.. V('28','2','15') =E= 0;
DISJ_2_2_15.. V('31','2','15') =E= 0;
DISJ_3_2_15.. V('40','2','15') =E= 0;
DISJ_1_3_15.. X('28') =E= SUM(D,V('28',D,'15'));
DISJ_2_3_15.. X('31') =E= SUM(D,V('31',D,'15'));
DISJ_3_3_15.. X('40') =E= SUM(D,V('40',D,'15'));
DISJ_1_4_15.. V('28','1','15') =L= UB('28','1','15')*Z('15');
DISJ_2_4_15.. V('28','2','15') =L= UB('28','2','15')*(1-Z('15'));
DISJ_3_4_15.. V('31','1','15') =L= UB('31','1','15')*Z('15');
DISJ_4_4_15.. V('31','2','15') =L= UB('31','2','15')*(1-Z('15'));
DISJ_5_4_15.. V('40','1','15') =L= UB('40','1','15')*Z('15');
DISJ_6_4_15.. V('40','2','15') =L= UB('40','2','15')*(1-Z('15'));

*Design Specifications
D1..  Z('1') + Z('2')                           =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1..  -Z('3') + Z('6') +Z('7')                  =G= 0;
L2..  -Z('6') + Z('12')                         =G= 0;
L3..  -Z('7') + Z('13')                         =G= 0;
L4..  -Z('4') + Z('8')                          =G= 0;
L5..  -Z('8') + Z('14') + Z('15')               =G= 0;
L6..  -Z('5') + Z('9') + Z('10') + Z('11')      =G= 0;
L7..  -Z('9') + Z('15')                         =G= 0;
L8..  -Z('3') + Z('1') + Z('2')                 =G= 0;
L9..  -Z('4') + Z('1') + Z('2')                 =G= 0;
L10.. -Z('5') + Z('1') + Z('2')                 =G= 0;
L11.. -Z('6') + Z('3')                          =G= 0;
L12.. -Z('7') + Z('3')                          =G= 0;
L13.. -Z('8') + Z('4')                          =G= 0;
L14.. -Z('9') + Z('5')                          =G= 0;
L15.. -Z('10') + Z('5')                         =G= 0;
L16.. -Z('11') + Z('5')                         =G= 0;
L17.. -Z('12') + Z('6')                         =G= 0;
L18.. -Z('13') + Z('7')                         =G= 0;
L19.. -Z('14') + Z('8')                         =G= 0;
L20.. -Z('15') + Z('8')                         =G= 0;

* Bounds
X.UP('1') = 10;
X.UP('12') = 7;
X.UP('29') = 5;
X.UP('30') = 5;

V.up(K,D,I) = UB(K,D,I);
MODEL SYNTH_15_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_15_CH USING %TYPE% MAXIMIZING OBJ;
