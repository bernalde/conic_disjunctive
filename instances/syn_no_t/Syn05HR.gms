*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Convexification by sum disaggregation and binary continuous product linearization (done twice)
*disj.. z + v2 >= z*exp(x) <=> x <= log((z+v2)/z) ; c*z*x = c*w >= v1;
*y = z*exp(x): y >= z; y <= exp(v1_ub/c)*z;    y >= exp(x) - (1-z)*exp(v1_ub/c);   y <= exp(x) - (1-z) (removed because nonconvex and inactive)
*w = z*x: w >= 0; c*w <= v1_up*z; c*w >= c*x - (1-z)*v1_ub; w <= x;
*Synthesis Problem with 5 processes
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

K            /1*15/                       /* Number of Synthesis Streams */
I            /1*5/                       /* Number of Synthesis Processes */
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

PARAMETER UB(K,D,I) /1*15 .1*2 .1*5 = 0/;

*Note: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal upper bounds on the disaggregated variables.

SCALARS
X1_UP /0/
X12_UP /0/;

X1_UP = 10;
X12_UP = 7;

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


****************************************************** EQUATIONS ******************************************************

EQUATIONS

Objective

MB1,MB2,MB3,MB4

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

D1
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

*Design Specifications
D1..  Z('1') + Z('2')                           =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1..  -Z('3') + Z('1') + Z('2')                    =G= 0;
L2..  -Z('4') + Z('1') + Z('2')                    =G= 0;
L3..  -Z('5') + Z('1') + Z('2')                    =G= 0;

* Bounds
X.UP('1') = 10;
X.UP('12') = 7;

V.up(K,D,I) = UB(K,D,I);
MODEL SYNTH_5_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE SYNTH_5_CH USING %TYPE% MAXIMIZING OBJ;