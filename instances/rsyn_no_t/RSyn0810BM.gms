*Retrofit-Synthesis Problem with 8 retrofit processes and 10 synthesis processes
*One Periods (t=1)
*Big-M Version

$TITLE       Retrofit_Synthesis
$OFFSYMXREF
$OFFSYMLIST
$ONINLINE

*See process flowsheet for stream labeling

************************************************************************************************************************
*************************************************** DECLARATIONS *******************************************************
************************************************************************************************************************


******************************************************* SETS ***********************************************************

SETS

S            /1*35/                       /*Streams*/
P            /1*8/                        /*Processes*/
M            /1*4/                        /*Conversion &OR capacity scenarios*/

I       /1*10/                            /* Number of process units */
K       /1*25/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */
E       /1*4/                             /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */

S_RAW(S)    /1,6,10,22,29/                /*Raw feed streams for Retrofit portion*/
S_PROD(S)   /26,28,32,33,34,35/           /*Product streams for Retrofit portion (some will be used as feed streams into Synthesis portion*/


S_P1_IN(S)  /2/                           /*Streams into process Pi for Retrofit portion*/
S_P1_OUT(S) /4/                           /*Reacted streams out of process Pi for Retrofit portion*/
S_P2_IN(S)  /3,7/
S_P2_OUT(S) /8/
S_P3_IN(S)  /11/
S_P3_OUT(S) /12,13/
S_P4_IN(S)  /14/
S_P4_OUT(S) /15/
S_P5_IN(S)  /17/
S_P5_OUT(S) /18,19/
S_P6_IN(S)  /16,23/
S_P6_OUT(S) /25/
S_P7_IN(S)  /24,31/
S_P7_OUT(S) /27/
S_P8_IN(S)  /30/
S_P8_OUT(S) /31/

S_N1_IN(S)  /1/                           /*Streams into node Ni*/
S_N1_OUT(S) /2,3/                         /*Streams out of node Ni*/
S_N2_IN(S)  /4/
S_N2_OUT(S) /5/
S_N3_IN(S)  /6,12/
S_N3_OUT(S) /7/
S_N4_IN(S)  /8,13/
S_N4_OUT(S) /9/
S_N5_IN(S)  /10/
S_N5_OUT(S) /11,14/
S_N6_IN(S)  /15/
S_N6_OUT(S) /16,17/
S_N7_IN(S)  /18/
S_N7_OUT(S) /20/
S_N8_IN(S)  /19/
S_N8_OUT(S) /21/
S_N9_IN(S)  /22/
S_N9_OUT(S) /23,24/
S_N10_IN(S)  /25/
S_N10_OUT(S) /26/
S_N11_IN(S)  /27/
S_N11_OUT(S) /28/
S_N12_IN(S)  /29/
S_N12_OUT(S) /30/
;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

mf(S)                                  /*Mass flowrate (in 1E6 lbs per time period)*/
f(S)                                   /*Molar flowrate (in 1E3 lbmol per time period)*/
mf_p1_unreacted                       /*Mass flowrate of unreacted streams for process Pi (in 1E6 lbs per time period)*/
mf_p2_unreacted
mf_p3_unreacted
mf_p4_unreacted
mf_p5_unreacted
mf_p6_unreacted
mf_p7_unreacted
mf_p8_unreacted

convcapcost(P)                         /*Retrofit conversion &OR capacity fixed cost (in 1E3 $)*/


y(P,M)                                        /*Retrofit variable for conversion &OR capacity*/
w(P,M)                                        /*Retrofit variable for conversion &OR capacity fixed cost enforcement*/

X(K)
Z(I)
R(I)
COST(I)
;

POSITIVE VARIABLES

mf(S)
f(S)
mf_p1_unreacted
mf_p2_unreacted
mf_p3_unreacted
mf_p4_unreacted
mf_p5_unreacted
mf_p6_unreacted
mf_p7_unreacted
mf_p8_unreacted

convcapcost(P)

X(K)
V(K,D,I)
;

BINARY VARIABLES

y(P,M)
w(P,M)
Z(I)
R(I)
;

****************************************************** DATA ENTRY *****************************************************

******************************************* Prices, Costs and Dollar Limits

PARAMETER Price_Prod(S_PROD)                /*Price of Product Streams (in 1E3 $ per 1E6 lbs)*/

/26 =   23
 28 =   19
 32 =   2
 33 =   3
 34 =   25
 35 =   24/
;

PARAMETER Price_Raw(S_RAW)                  /*Price of Raw Streams (in 1E3 of $ per 1E6 lbs)*/

/1 =    4
 6  =   8
 10 =   5
 22 =   8
 29 =   10/
;

PARAMETER FixedCost_ConvCap(P,M)            /*Fixed Cost for Retrofit Conversion &OR Capacity (in 1E3 $)*/

/1.1   =  0
 2.1   =  0
 3.1   =  0
 4.1   =  0
 5.1   =  0
 6.1   =  0
 7.1   =  0
 8.1   =  0
 1.2   =  6
 2.2   =  7
 3.2   =  7
 4.2   =  11
 5.2   =  10
 6.2   =  9
 7.2   =  8
 8.2   =  8
 1.3   =  40
 2.3   =  30
 3.3   =  15
 4.3   =  13
 5.3   =  13
 6.3   =  30
 7.3   =  20
 8.3   =  15
 1.4   =  46
 2.4   =  37
 3.4   =  22
 4.4   =  24
 5.4   =  23
 6.4   =  39
 7.4   =  28
 8.4   =  23/
;

SCALAR InvestmentLimit /0/;
InvestmentLimit = 4000;

******************************************* Physical Properties

PARAMETER MolWeight(S)                    /*Molecular Weight of Stream (in 1E6 lb per 1E3 lbmol)*/
/ 1 = 0.2
  2 = 0.2
  3 = 0.2
  4 = 0.2
  5 = 0.2
  6 = 0.5
  7 = 0.5
  8 = 0.7
  9 = 0.7
  10 = 1.2
  11 = 1.2
  12 = 0.5
  13 = 0.7
  14 = 1.2
  15 = 1.2
  16 = 1.2
  17 = 1.2
  18 = 0.3
  19 = 0.9
  20 = 0.3
  21 = 0.9
  22 = 0.4
  23 = 0.4
  24 = 0.4
  25 = 1.6
  26 = 1.6
  27 = 1.1
  28 = 1.1
  29 = 0.7
  30 = 0.7
  31 = 0.7
  32 = 0.2
  33 = 0.7
  34 = 0.3
  35 = 0.9/
;

PARAMETER Gamma(S)                               /*Stoichiometric Coefficients. Note: In this instance of the problem, we assume all relevant stoic coefficients to be 1*/

/ 1 = 0
  2 = 1
  3 = 1
  4 = 1
  5 = 0
  6 = 0
  7 = 1
  8 = 1
  9 = 0
 10 = 0
 11 = 1
 12 = 1
 13 = 1
 14 = 1
 15 = 1
 16 = 1
 17 = 1
 18 = 1
 19 = 1
 20 = 0
 21 = 0
 22 = 0
 23 = 1
 24 = 1
 25 = 1
 26 = 0
 27 = 1
 28 = 0
 29 = 0
 30 = 1
 31 = 1
 32 = 0
 33 = 0
 34 = 0
 35 = 0/
;
******************************************* Design Specs

PARAMETER Dem(S_PROD)                       /*Demand for Product (in 1E6 lbs per time period)*/

/26  =    0.4
 28  =    0.3
 32  =    0.2
 33  =    0.5
 34  =    0.2
 35  =    0.3/
;

PARAMETER Sup(S_RAW)                        /*Supply of raw feed (in 1E6 lbs per time period)*/

/1   =    35
 6    =   36
 10   =   25
 22   =   24
 29   =   30/
;

PARAMETER Eta(P,M)                          /*Conversion Rate*/

/1.1  =   0.8
 2.1   =  0.9
 3.1   =  0.85
 4.1   =  0.85
 5.1   =  0.75
 6.1   =  0.8
 7.1   =  0.85
 8.1   =  0.8
 1.2   =  0.85
 2.2   =  0.95
 3.2   =  0.98
 4.2   =  0.9
 5.2   =  0.95
 6.2   =  0.85
 7.2   =  0.95
 8.2   =  0.92
 1.3   =  0.8
 2.3   =  0.9
 3.3   =  0.85
 4.3   =  0.85
 5.3   =  0.9
 6.3   =  0.8
 7.3   =  0.85
 8.3   =  0.8
 1.4   =  0.85
 2.4   =  0.95
 3.4   =  0.98
 4.4   =  0.9
 5.4   =  0.95
 6.4   =  0.85
 7.4   =  0.95
 8.4   =  0.92/
;

PARAMETER Cap(P,M)                         /*Capacity limit on every process (in 1E6 lbs per time period)*/

/1.1  =   10
 2.1   =  40
 3.1   =  15
 4.1   =  15
 5.1   =  10
 6.1   =  20
 7.1   =  25
 8.1   =  15
 1.2   =  10
 2.2   =  40
 3.2   =  15
 4.2   =  15
 5.2   =  10
 6.2   =  20
 7.2   =  25
 8.2   =  15
 1.3   =  50
 2.3   =  60
 3.3   =  25
 4.3   =  20
 5.3   =  20
 6.3   =  55
 7.3   =  50
 8.3   =  35
 1.4   =  50
 2.4   =  60
 3.4   =  25
 4.4   =  20
 5.4   =  20
 6.4   =  55
 7.4   =  50
 8.4   =  35/
;

******************************************* Optimal bounds on disaggregated variables

PARAMETER BigM_Conv_lt(S,M)              /*BigM for Disjunction 1, Conversion*/
/1*35 .1*4 = 0/
;

PARAMETER BigM_Conv_gt(S,M)
/1*35 .1*4 = 0/
;

LOOP((S_P1_OUT,M),
        BigM_Conv_lt(S_P1_OUT,M) = (Sup('1')/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2');
);

LOOP((S_P1_OUT,M),
        BigM_Conv_gt(S_P1_OUT,M) = (Sup('1')/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2');
);

LOOP((S_P2_OUT,M),
        BigM_Conv_lt(S_P2_OUT,M) = (Sup('1')/MolWeight('1')+Sup('6')/MolWeight('6')+(Sup('10')/MolWeight('10'))*(Gamma('12')/Gamma('11'))*Eta('3','2'))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2');
);

LOOP((S_P2_OUT,M),
        BigM_Conv_gt(S_P2_OUT,M) = (Sup('1')/MolWeight('1'))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2');
);

LOOP((S_P3_OUT,M),
        BigM_Conv_lt(S_P3_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2');
);

LOOP((S_P3_OUT,M),
        BigM_Conv_gt(S_P3_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2');
);

LOOP((S_P4_OUT,M),
        BigM_Conv_lt(S_P4_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2');
);

LOOP((S_P4_OUT,M),
        BigM_Conv_gt(S_P4_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2');
);

LOOP((S_P5_OUT,M),
        BigM_Conv_lt(S_P5_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2');
);

LOOP((S_P5_OUT,M),
        BigM_Conv_gt(S_P5_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2');
);

LOOP((S_P6_OUT,M),
        BigM_Conv_lt(S_P6_OUT,M) = ((Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')+Sup('22')/MolWeight('22'))*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2');
);

LOOP((S_P6_OUT,M),
        BigM_Conv_gt(S_P6_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2');
);

LOOP((S_P7_OUT,M),
        BigM_Conv_lt(S_P7_OUT,M) = ((Sup('29')/MolWeight('29'))*(Gamma('31')/Gamma('30'))*Eta('8','2')+Sup('22')/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2');
);

LOOP((S_P7_OUT,M),
        BigM_Conv_gt(S_P7_OUT,M) = (Sup('22')/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2');
);

LOOP((S_P8_OUT,M),
        BigM_Conv_lt(S_P8_OUT,M) = (Sup('29')/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2');
);

LOOP((S_P8_OUT,M),
        BigM_Conv_gt(S_P8_OUT,M) = (Sup('29')/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2');
);


PARAMETER BigM_Cap(P,M)                   /*BigM for Disjunction 1, Capacity*/
/1*8 .1*4 = 0/
;

LOOP((M),
        BigM_Cap('1',M) = Sup('1') - Cap('1',M);
);

LOOP((M),
        BigM_Cap('2',M) = Sup('1') + Sup('6') + Sup('10') - Cap('2',M);
);

LOOP((M),
        BigM_Cap('3',M) = Sup('10') - Cap('3',M);
);

LOOP((M),
        BigM_Cap('4',M) = Sup('10') - Cap('4',M);
);

LOOP((M),
        BigM_Cap('5',M) = Sup('10') - Cap('5',M);
);

LOOP((M),
        BigM_Cap('6',M) = Sup('10') + Sup('22') - Cap('6',M);
);

LOOP((M),
        BigM_Cap('7',M) = Sup('22') + Sup('29') - Cap('7',M);
);

LOOP((M),
        BigM_Cap('8',M) = Sup('29') - Cap('8',M);
);


PARAMETER BigM_ConvCapCost_lt(P,M)        /*BigM for Disjunction 2*/
/1*8 .1*4  = 0/
;

PARAMETER BigM_ConvCapCost_gt(P,M)
/1*8 .1*4  = 0/
;

LOOP((P,M),
        BigM_ConvCapCost_lt(P,M) = FixedCost_ConvCap(P,'4') - FixedCost_ConvCap(P,M);
);

LOOP((P,M),
        BigM_ConvCapCost_gt(P,M) = FixedCost_ConvCap(P,M);
);


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

Equivalence_Mass(S)

Demand(S_PROD)
Supply(S_RAW)

MassBalance_Node1
MassBalance_Node2
MassBalance_Node3
MassBalance_Node4
MassBalance_Node5
MassBalance_Node6
MassBalance_Node7
MassBalance_Node8
MassBalance_Node9
MassBalance_Node10
MassBalance_Node11
MassBalance_Node12

MassBalance_Process1
MassBalance_Process2
MassBalance_Process3
MassBalance_Process4
MassBalance_Process5
MassBalance_Process6
MassBalance_Process7
MassBalance_Process8

Limiting_Process2
Limiting_Process6
Limiting_Process7

Disj1_Conv_Process1_lt(S_P1_OUT,M)
Disj1_Conv_Process1_gt(S_P1_OUT,M)
Disj1_Conv_Process2_lt(S_P2_OUT,M)
Disj1_Conv_Process2_gt(S_P2_OUT,M)
Disj1_Conv_Process3_lt(S_P3_OUT,M)
Disj1_Conv_Process3_gt(S_P3_OUT,M)
Disj1_Conv_Process4_lt(S_P4_OUT,M)
Disj1_Conv_Process4_gt(S_P4_OUT,M)
Disj1_Conv_Process5_lt(S_P5_OUT,M)
Disj1_Conv_Process5_gt(S_P5_OUT,M)
Disj1_Conv_Process6_lt(S_P6_OUT,M)
Disj1_Conv_Process6_gt(S_P6_OUT,M)
Disj1_Conv_Process7_lt(S_P7_OUT,M)
Disj1_Conv_Process7_gt(S_P7_OUT,M)
Disj1_Conv_Process8_lt(S_P8_OUT,M)
Disj1_Conv_Process8_gt(S_P8_OUT,M)

Disj1_Cap_Process1(M)
Disj1_Cap_Process2(M)
Disj1_Cap_Process3(M)
Disj1_Cap_Process4(M)
Disj1_Cap_Process5(M)
Disj1_Cap_Process6(M)
Disj1_Cap_Process7(M)
Disj1_Cap_Process8(M)

Disj2_lt(P,M)
Disj2_gt(P,M)

LimitingCost

Sum_y(P)

*Interconnecting Equations

Inter1
Inter2
Inter3
Inter4

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

Objective.. obj =E= SUM(S_PROD,Price_Prod(S_PROD)*mf(S_PROD)) - SUM(S_RAW,Price_Raw(S_RAW)*mf(S_RAW))
                  - SUM(M,SUM(P,FixedCost_ConvCap(P,M)*y(P,M))) + SUM(I,FC(I)*Z(I)) + SUM(K,PC(K)*X(K));

Equivalence_Mass(S).. mf(S) =E= f(S)*MolWeight(S);

Demand(S_PROD).. mf(S_PROD) =G= Dem(S_PROD);
Supply(S_RAW)..  mf(S_RAW) =L= Sup(S_RAW);

MassBalance_Node1..  SUM(S_N1_IN,mf(S_N1_IN)) =E= SUM(S_N1_OUT,mf(S_N1_OUT));
MassBalance_Node2..  SUM(S_N2_IN,mf(S_N2_IN)) =E= SUM(S_N2_OUT,mf(S_N2_OUT));
MassBalance_Node3..  SUM(S_N3_IN,mf(S_N3_IN)) =E= SUM(S_N3_OUT,mf(S_N3_OUT));
MassBalance_Node4..  SUM(S_N4_IN,mf(S_N4_IN)) =E= SUM(S_N4_OUT,mf(S_N4_OUT));
MassBalance_Node5..  SUM(S_N5_IN,mf(S_N5_IN)) =E= SUM(S_N5_OUT,mf(S_N5_OUT));
MassBalance_Node6..  SUM(S_N6_IN,mf(S_N6_IN)) =E= SUM(S_N6_OUT,mf(S_N6_OUT));
MassBalance_Node7..  SUM(S_N7_IN,mf(S_N7_IN)) =E= SUM(S_N7_OUT,mf(S_N7_OUT));
MassBalance_Node8..  SUM(S_N8_IN,mf(S_N8_IN)) =E= SUM(S_N8_OUT,mf(S_N8_OUT));
MassBalance_Node9..  SUM(S_N9_IN,mf(S_N9_IN)) =E= SUM(S_N9_OUT,mf(S_N9_OUT));
MassBalance_Node10.. SUM(S_N10_IN,mf(S_N10_IN)) =E= SUM(S_N10_OUT,mf(S_N10_OUT));
MassBalance_Node11.. SUM(S_N11_IN,mf(S_N11_IN)) =E= SUM(S_N11_OUT,mf(S_N11_OUT));
MassBalance_Node12.. SUM(S_N12_IN,mf(S_N12_IN)) =E= SUM(S_N12_OUT,mf(S_N12_OUT));

MassBalance_Process1.. SUM(S_P1_IN,mf(S_P1_IN)) =E= SUM(S_P1_OUT,mf(S_P1_OUT)) + mf_p1_unreacted;
MassBalance_Process2.. SUM(S_P2_IN,mf(S_P2_IN)) =E= SUM(S_P2_OUT,mf(S_P2_OUT)) + mf_p2_unreacted;
MassBalance_Process3.. SUM(S_P3_IN,mf(S_P3_IN)) =E= SUM(S_P3_OUT,mf(S_P3_OUT)) + mf_p3_unreacted;
MassBalance_Process4.. SUM(S_P4_IN,mf(S_P4_IN)) =E= SUM(S_P4_OUT,mf(S_P4_OUT)) + mf_p4_unreacted;
MassBalance_Process5.. SUM(S_P5_IN,mf(S_P5_IN)) =E= SUM(S_P5_OUT,mf(S_P5_OUT)) + mf_p5_unreacted;
MassBalance_Process6.. SUM(S_P6_IN,mf(S_P6_IN)) =E= SUM(S_P6_OUT,mf(S_P6_OUT)) + mf_p6_unreacted;
MassBalance_Process7.. SUM(S_P7_IN,mf(S_P7_IN)) =E= SUM(S_P7_OUT,mf(S_P7_OUT)) + mf_p7_unreacted;
MassBalance_Process8.. SUM(S_P8_IN,mf(S_P8_IN)) =E= SUM(S_P8_OUT,mf(S_P8_OUT)) + mf_p8_unreacted;

*Note: We add an additional constraint to ensure that conversion in every process is being done relative to limiting reactant (We assume limiting reactant is known apriori for every process).

Limiting_Process2.. f('3')*Gamma('3') =L= f('7')*Gamma('7');
Limiting_Process6.. f('16')*Gamma('16') =L= f('23')*Gamma('23');
Limiting_Process7.. f('24')*Gamma('24') =L= f('31')*Gamma('31');

*****************
*Disjunction 1 constraints

*Disjunction 1 constraints

Disj1_Conv_Process1_lt(S_P1_OUT,M).. f(S_P1_OUT) =L= f('2')*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M) + BigM_Conv_lt(S_P1_OUT,M)*(1-y('1',M));
Disj1_Conv_Process1_gt(S_P1_OUT,M).. f(S_P1_OUT) =G= f('2')*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M) - BigM_Conv_gt(S_P1_OUT,M)*(1-y('1',M));
Disj1_Conv_Process2_lt(S_P2_OUT,M).. f(S_P2_OUT) =L= f('3')*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M) + BigM_Conv_lt(S_P2_OUT,M)*(1-y('2',M));
Disj1_Conv_Process2_gt(S_P2_OUT,M).. f(S_P2_OUT) =G= f('3')*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M) - BigM_Conv_gt(S_P2_OUT,M)*(1-y('2',M));
Disj1_Conv_Process3_lt(S_P3_OUT,M).. f(S_P3_OUT) =L= f('11')*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M) + BigM_Conv_lt(S_P3_OUT,M)*(1-y('3',M));
Disj1_Conv_Process3_gt(S_P3_OUT,M).. f(S_P3_OUT) =G= f('11')*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M) - BigM_Conv_gt(S_P3_OUT,M)*(1-y('3',M));
Disj1_Conv_Process4_lt(S_P4_OUT,M).. f(S_P4_OUT) =L= f('14')*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M) + BigM_Conv_lt(S_P4_OUT,M)*(1-y('4',M));
Disj1_Conv_Process4_gt(S_P4_OUT,M).. f(S_P4_OUT) =G= f('14')*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M) - BigM_Conv_gt(S_P4_OUT,M)*(1-y('4',M));
Disj1_Conv_Process5_lt(S_P5_OUT,M).. f(S_P5_OUT) =L= f('17')*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M) + BigM_Conv_lt(S_P5_OUT,M)*(1-y('5',M));
Disj1_Conv_Process5_gt(S_P5_OUT,M).. f(S_P5_OUT) =G= f('17')*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M) - BigM_Conv_gt(S_P5_OUT,M)*(1-y('5',M));
Disj1_Conv_Process6_lt(S_P6_OUT,M).. f(S_P6_OUT) =L= f('16')*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M) + BigM_Conv_lt(S_P6_OUT,M)*(1-y('6',M));
Disj1_Conv_Process6_gt(S_P6_OUT,M).. f(S_P6_OUT) =G= f('16')*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M) - BigM_Conv_gt(S_P6_OUT,M)*(1-y('6',M));
Disj1_Conv_Process7_lt(S_P7_OUT,M).. f(S_P7_OUT) =L= f('24')*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M) + BigM_Conv_lt(S_P7_OUT,M)*(1-y('7',M));
Disj1_Conv_Process7_gt(S_P7_OUT,M).. f(S_P7_OUT) =G= f('24')*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M) - BigM_Conv_gt(S_P7_OUT,M)*(1-y('7',M));
Disj1_Conv_Process8_lt(S_P8_OUT,M).. f(S_P8_OUT) =L= f('30')*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M) + BigM_Conv_lt(S_P8_OUT,M)*(1-y('8',M));
Disj1_Conv_Process8_gt(S_P8_OUT,M).. f(S_P8_OUT) =G= f('30')*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M) - BigM_Conv_gt(S_P8_OUT,M)*(1-y('8',M));

Disj1_Cap_Process1(M).. SUM(S_P1_IN,mf(S_P1_IN)) =L= Cap('1',M) + BigM_Cap('1',M)*(1-y('1',M));
Disj1_Cap_Process2(M).. SUM(S_P2_IN,mf(S_P2_IN)) =L= Cap('2',M) + BigM_Cap('2',M)*(1-y('2',M));
Disj1_Cap_Process3(M).. SUM(S_P3_IN,mf(S_P3_IN)) =L= Cap('3',M) + BigM_Cap('3',M)*(1-y('3',M));
Disj1_Cap_Process4(M).. SUM(S_P4_IN,mf(S_P4_IN)) =L= Cap('4',M) + BigM_Cap('4',M)*(1-y('4',M));
Disj1_Cap_Process5(M).. SUM(S_P5_IN,mf(S_P5_IN)) =L= Cap('5',M) + BigM_Cap('5',M)*(1-y('5',M));
Disj1_Cap_Process6(M).. SUM(S_P6_IN,mf(S_P6_IN)) =L= Cap('6',M) + BigM_Cap('6',M)*(1-y('6',M));
Disj1_Cap_Process7(M).. SUM(S_P7_IN,mf(S_P7_IN)) =L= Cap('7',M) + BigM_Cap('7',M)*(1-y('7',M));
Disj1_Cap_Process8(M).. SUM(S_P8_IN,mf(S_P8_IN)) =L= Cap('8',M) + BigM_Cap('8',M)*(1-y('8',M));
*****************

*****************
*Disjunction 2 constraints

Disj2_lt(P,M).. convcapcost(P) =L= FixedCost_ConvCap(P,M) + BigM_ConvCapCost_lt(P,M)*(1-w(P,M));
Disj2_gt(P,M).. convcapcost(P) =G= FixedCost_ConvCap(P,M) - BigM_ConvCapCost_gt(P,M)*(1-w(P,M));
*****************

LimitingCost..   SUM(P,convcapcost(P)) + SUM(S_RAW,Price_Raw(S_RAW)*mf(S_RAW)) =L= InvestmentLimit;

*Logic Constraints

Sum_y(P).. SUM(M,y(P,M)) =E= 1;

*Interconnecting Streams
Inter1.. mf('5') =E= mf('32') + X('1');
Inter2.. mf('9') =E= mf('33') + X('12');
Inter3.. mf('20') =E= mf('34');
Inter4.. mf('21') =E= mf('35');

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
