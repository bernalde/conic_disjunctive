*Retrofit-Synthesis Problem with 8 retrofit processes and 5 synthesis processes
*Two Periods (t=2)
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
T            /1*2/                        /*Time periods*/
M            /1*4/                        /*Conversion &OR capacity scenarios*/

I       /1*5/                            /* Number of process units */
K       /1*15/                            /* Number of streams */
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

ALIAS

(T,TAU)
;

***************************************************** VARIABLES *******************************************************

VARIABLES

obj                                      /*Objective function variable (in $)*/

mf(S,T)                                  /*Mass flowrate (in 1E6 lbs per time period)*/
f(S,T)                                   /*Molar flowrate (in 1E3 lbmol per time period)*/
mf_p1_unreacted(T)                       /*Mass flowrate of unreacted streams for process Pi (in 1E6 lbs per time period)*/
mf_p2_unreacted(T)
mf_p3_unreacted(T)
mf_p4_unreacted(T)
mf_p5_unreacted(T)
mf_p6_unreacted(T)
mf_p7_unreacted(T)
mf_p8_unreacted(T)

convcapcost(P,T)                         /*Retrofit conversion &OR capacity fixed cost (in 1E3 $)*/


y(P,M,T)                                        /*Retrofit variable for conversion &OR capacity*/
w(P,M,T)                                        /*Retrofit variable for conversion &OR capacity fixed cost enforcement*/

X(K,T)
Z(I,T)
R(I,T)
COST(I,T)
;

POSITIVE VARIABLES

mf(S,T)
f(S,T)
mf_p1_unreacted(T)
mf_p2_unreacted(T)
mf_p3_unreacted(T)
mf_p4_unreacted(T)
mf_p5_unreacted(T)
mf_p6_unreacted(T)
mf_p7_unreacted(T)
mf_p8_unreacted(T)

convcapcost(P,T)

X(K,T)
V(K,D,I,T)
;

BINARY VARIABLES

y(P,M,T)
w(P,M,T)
Z(I,T)
R(I,T)
;

****************************************************** DATA ENTRY *****************************************************

******************************************* Prices, Costs and Dollar Limits

TABLE Price_Prod(S_PROD,T)                /*Price of Product Streams (in 1E3 $ per 1E6 lbs)*/
      1     2
26    26    31
28    30    29
32    2      2
33    3      2
34    30     31
35    24     22
;

TABLE Price_Raw(S_RAW,T)                  /*Price of Raw Streams (in 1E3 of $ per 1E6 lbs)*/
      1      2
1     20     17
6     20     21
10    18     20
22    16     19
29    20     18
;

TABLE FixedCost_ConvCap(P,M,T)            /*Fixed Cost for Retrofit Conversion &OR Capacity (in 1E3 $)*/
        1       2
1.1     0       0
2.1     0       0
3.1     0       0
4.1     0       0
5.1     0       0
6.1     0       0
7.1     0       0
8.1     0       0
1.2     6       4
2.2     7       4
3.2     7       5
4.2     11      8
5.2     10      7
6.2     9       9
7.2     8       7
8.2     8       6
1.3     40      35
2.3     30      25
3.3     15      5
4.3     13      8
5.3     13      8
6.3     30      30
7.3     20      15
8.3     15      10
1.4     46      39
2.4     37      29
3.4     22      10
4.4     24      16
5.4     23      15
6.4     39      39
7.4     28      22
8.4     23      16
;
PARAMETER InvestmentLimit(T)              /*Limit on Total Investment (in 1E3 $ per period)*/
/ 1 = 4000
  2 = 3800/
;
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

TABLE Dem(S_PROD,T)                       /*Demand for Product (in 1E6 lbs per time period)*/
        1        2
26      1.2     1.15
28      1.2     1.15
32      1.1     1.1
33      1.1     1.1
34      1.4     1.3
35      1.3     1.2
;

TABLE Sup(S_RAW,T)                        /*Supply of raw feed (in 1E6 lbs per time period)*/
        1       2
1       55     40
6       46     41
10      45     62
22      54     51
29      40     45
;

TABLE Eta(P,M,T)                          /*Conversion Rate*/
        1       2
1.1     0.8     0.8
2.1     0.9     0.9
3.1     0.85    0.85
4.1     0.85    0.85
5.1     0.75    0.75
6.1     0.8     0.8
7.1     0.85    0.85
8.1     0.8     0.8
1.2     0.85    0.85
2.2     0.95    0.95
3.2     0.98    0.98
4.2     0.9     0.9
5.2     0.95    0.95
6.2     0.85    0.85
7.2     0.95    0.95
8.2     0.92    0.92
1.3     0.8     0.8
2.3     0.9     0.9
3.3     0.85    0.85
4.3     0.85    0.85
5.3     0.9     0.9
6.3     0.8     0.8
7.3     0.85    0.85
8.3     0.8     0.8
1.4     0.85    0.85
2.4     0.95    0.95
3.4     0.98    0.98
4.4     0.9     0.9
5.4     0.95    0.95
6.4     0.85    0.85
7.4     0.95    0.95
8.4     0.92    0.92
;

TABLE Cap(P,M,T)                         /*Capacity limit on every process (in 1E6 lbs per time period)*/
        1       2
1.1     10      10
2.1     40      40
3.1     15      15
4.1     15      15
5.1     10      10
6.1     20      20
7.1     25      25
8.1     15      15
1.2     10      10
2.2     40      40
3.2     15      15
4.2     15      15
5.2     10      10
6.2     20      20
7.2     25      25
8.2     15      15
1.3     50      50
2.3     60      60
3.3     25      25
4.3     20      20
5.3     20      20
6.3     55      55
7.3     50      50
8.3     35      35
1.4     50      50
2.4     60      60
3.4     25      25
4.4     20      20
5.4     20      20
6.4     55      55
7.4     50      50
8.4     35      35
;

******************************************* Optimal bounds on disaggregated variables

PARAMETER BigM_Conv_lt(S,M,T)              /*BigM for Disjunction 1, Conversion*/
/1*35 .1*4 .1*2 = 0/
;

PARAMETER BigM_Conv_gt(S,M,T)
/1*35 .1*4 .1*2 = 0/
;

LOOP((S_P1_OUT,M,T),
        BigM_Conv_lt(S_P1_OUT,M,T) = (Sup('1',T)/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2',T);
);

LOOP((S_P1_OUT,M,T),
        BigM_Conv_gt(S_P1_OUT,M,T) = (Sup('1',T)/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2',T);
);

LOOP((S_P2_OUT,M,T),
        BigM_Conv_lt(S_P2_OUT,M,T) = (Sup('1',T)/MolWeight('1')+Sup('6',T)/MolWeight('6')+(Sup('10',T)/MolWeight('10'))*(Gamma('12')/Gamma('11'))*Eta('3','2',T))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2',T);
);

LOOP((S_P2_OUT,M,T),
        BigM_Conv_gt(S_P2_OUT,M,T) = (Sup('1',T)/MolWeight('1'))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2',T);
);

LOOP((S_P3_OUT,M,T),
        BigM_Conv_lt(S_P3_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2',T);
);

LOOP((S_P3_OUT,M,T),
        BigM_Conv_gt(S_P3_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2',T);
);

LOOP((S_P4_OUT,M,T),
        BigM_Conv_lt(S_P4_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2',T);
);

LOOP((S_P4_OUT,M,T),
        BigM_Conv_gt(S_P4_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2',T);
);

LOOP((S_P5_OUT,M,T),
        BigM_Conv_lt(S_P5_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2',T);
);

LOOP((S_P5_OUT,M,T),
        BigM_Conv_gt(S_P5_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2',T);
);

LOOP((S_P6_OUT,M,T),
        BigM_Conv_lt(S_P6_OUT,M,T) = ((Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)+Sup('22',T)/MolWeight('22'))*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2',T);
);

LOOP((S_P6_OUT,M,T),
        BigM_Conv_gt(S_P6_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2',T);
);

LOOP((S_P7_OUT,M,T),
        BigM_Conv_lt(S_P7_OUT,M,T) = ((Sup('29',T)/MolWeight('29'))*(Gamma('31')/Gamma('30'))*Eta('8','2',T)+Sup('22',T)/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2',T);
);

LOOP((S_P7_OUT,M,T),
        BigM_Conv_gt(S_P7_OUT,M,T) = (Sup('22',T)/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2',T);
);

LOOP((S_P8_OUT,M,T),
        BigM_Conv_lt(S_P8_OUT,M,T) = (Sup('29',T)/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2',T);
);

LOOP((S_P8_OUT,M,T),
        BigM_Conv_gt(S_P8_OUT,M,T) = (Sup('29',T)/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2',T);
);


PARAMETER BigM_Cap(P,M,T)                   /*BigM for Disjunction 1, Capacity*/
/1*8 .1*4 .1*2 = 0/
;

LOOP((M,T),
        BigM_Cap('1',M,T) = Sup('1',T) - Cap('1',M,T);
);

LOOP((M,T),
        BigM_Cap('2',M,T) = Sup('1',T) + Sup('6',T) + Sup('10',T) - Cap('2',M,T);
);

LOOP((M,T),
        BigM_Cap('3',M,T) = Sup('10',T) - Cap('3',M,T);
);

LOOP((M,T),
        BigM_Cap('4',M,T) = Sup('10',T) - Cap('4',M,T);
);

LOOP((M,T),
        BigM_Cap('5',M,T) = Sup('10',T) - Cap('5',M,T);
);

LOOP((M,T),
        BigM_Cap('6',M,T) = Sup('10',T) + Sup('22',T) - Cap('6',M,T);
);

LOOP((M,T),
        BigM_Cap('7',M,T) = Sup('22',T) + Sup('29',T) - Cap('7',M,T);
);

LOOP((M,T),
        BigM_Cap('8',M,T) = Sup('29',T) - Cap('8',M,T);
);


PARAMETER BigM_ConvCapCost_lt(P,M,T)        /*BigM for Disjunction 2*/
/1*8 .1*4 .1*2 = 0/
;

PARAMETER BigM_ConvCapCost_gt(P,M,T)
/1*8 .1*4 .1*2 = 0/
;

LOOP((P,M,T),
        BigM_ConvCapCost_lt(P,M,T) = FixedCost_ConvCap(P,'4',T) - FixedCost_ConvCap(P,M,T);
);

LOOP((P,M,T),
        BigM_ConvCapCost_gt(P,M,T) = FixedCost_ConvCap(P,M,T);
);


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

Equivalence_Mass(S,T)

Demand(S_PROD,T)
Supply(S_RAW,T)

MassBalance_Node1(T)
MassBalance_Node2(T)
MassBalance_Node3(T)
MassBalance_Node4(T)
MassBalance_Node5(T)
MassBalance_Node6(T)
MassBalance_Node7(T)
MassBalance_Node8(T)
MassBalance_Node9(T)
MassBalance_Node10(T)
MassBalance_Node11(T)
MassBalance_Node12(T)

MassBalance_Process1(T)
MassBalance_Process2(T)
MassBalance_Process3(T)
MassBalance_Process4(T)
MassBalance_Process5(T)
MassBalance_Process6(T)
MassBalance_Process7(T)
MassBalance_Process8(T)

Limiting_Process2(T)
Limiting_Process6(T)
Limiting_Process7(T)

Disj1_Conv_Process1_lt(S_P1_OUT,M,T)
Disj1_Conv_Process1_gt(S_P1_OUT,M,T)
Disj1_Conv_Process2_lt(S_P2_OUT,M,T)
Disj1_Conv_Process2_gt(S_P2_OUT,M,T)
Disj1_Conv_Process3_lt(S_P3_OUT,M,T)
Disj1_Conv_Process3_gt(S_P3_OUT,M,T)
Disj1_Conv_Process4_lt(S_P4_OUT,M,T)
Disj1_Conv_Process4_gt(S_P4_OUT,M,T)
Disj1_Conv_Process5_lt(S_P5_OUT,M,T)
Disj1_Conv_Process5_gt(S_P5_OUT,M,T)
Disj1_Conv_Process6_lt(S_P6_OUT,M,T)
Disj1_Conv_Process6_gt(S_P6_OUT,M,T)
Disj1_Conv_Process7_lt(S_P7_OUT,M,T)
Disj1_Conv_Process7_gt(S_P7_OUT,M,T)
Disj1_Conv_Process8_lt(S_P8_OUT,M,T)
Disj1_Conv_Process8_gt(S_P8_OUT,M,T)

Disj1_Cap_Process1(M,T)
Disj1_Cap_Process2(M,T)
Disj1_Cap_Process3(M,T)
Disj1_Cap_Process4(M,T)
Disj1_Cap_Process5(M,T)
Disj1_Cap_Process6(M,T)
Disj1_Cap_Process7(M,T)
Disj1_Cap_Process8(M,T)

Disj2_lt(P,M,T)
Disj2_gt(P,M,T)

LimitingCost(T)

Sum_y(P,T)
Sum_w(P,T)

Logic_y(P,M,T,TAU)
Logic_w(P,M,T,TAU)
Logic_yw_M1(P,M,T)
Logic_yw_MlessM1(P,M,T)

*Interconnecting Equations

Inter1(T)
Inter2(T)
Inter3(T)
Inter4(T)

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

Objective.. obj =E= SUM(T,SUM(S_PROD,Price_Prod(S_PROD,T)*mf(S_PROD,T))) - SUM(T,SUM(S_RAW,Price_Raw(S_RAW,T)*mf(S_RAW,T)))
                   - SUM(T,SUM(M,SUM(P,FixedCost_ConvCap(P,M,T)*w(P,M,T)))) + SUM(T,SUM(I,FC(I,T)*R(I,T))) + SUM(T,SUM(K,PC(K,T)*X(K,T)));
;

Equivalence_Mass(S,T).. mf(S,T) =E= f(S,T)*MolWeight(S);

Demand(S_PROD,T).. mf(S_PROD,T) =G= Dem(S_PROD,T);
Supply(S_RAW,T)..  mf(S_RAW,T) =L= Sup(S_RAW,T);

MassBalance_Node1(T)..  SUM(S_N1_IN,mf(S_N1_IN,T)) =E= SUM(S_N1_OUT,mf(S_N1_OUT,T));
MassBalance_Node2(T)..  SUM(S_N2_IN,mf(S_N2_IN,T)) =E= SUM(S_N2_OUT,mf(S_N2_OUT,T));
MassBalance_Node3(T)..  SUM(S_N3_IN,mf(S_N3_IN,T)) =E= SUM(S_N3_OUT,mf(S_N3_OUT,T));
MassBalance_Node4(T)..  SUM(S_N4_IN,mf(S_N4_IN,T)) =E= SUM(S_N4_OUT,mf(S_N4_OUT,T));
MassBalance_Node5(T)..  SUM(S_N5_IN,mf(S_N5_IN,T)) =E= SUM(S_N5_OUT,mf(S_N5_OUT,T));
MassBalance_Node6(T)..  SUM(S_N6_IN,mf(S_N6_IN,T)) =E= SUM(S_N6_OUT,mf(S_N6_OUT,T));
MassBalance_Node7(T)..  SUM(S_N7_IN,mf(S_N7_IN,T)) =E= SUM(S_N7_OUT,mf(S_N7_OUT,T));
MassBalance_Node8(T)..  SUM(S_N8_IN,mf(S_N8_IN,T)) =E= SUM(S_N8_OUT,mf(S_N8_OUT,T));
MassBalance_Node9(T)..  SUM(S_N9_IN,mf(S_N9_IN,T)) =E= SUM(S_N9_OUT,mf(S_N9_OUT,T));
MassBalance_Node10(T).. SUM(S_N10_IN,mf(S_N10_IN,T)) =E= SUM(S_N10_OUT,mf(S_N10_OUT,T));
MassBalance_Node11(T).. SUM(S_N11_IN,mf(S_N11_IN,T)) =E= SUM(S_N11_OUT,mf(S_N11_OUT,T));
MassBalance_Node12(T).. SUM(S_N12_IN,mf(S_N12_IN,T)) =E= SUM(S_N12_OUT,mf(S_N12_OUT,T));

MassBalance_Process1(T).. SUM(S_P1_IN,mf(S_P1_IN,T)) =E= SUM(S_P1_OUT,mf(S_P1_OUT,T)) + mf_p1_unreacted(T);
MassBalance_Process2(T).. SUM(S_P2_IN,mf(S_P2_IN,T)) =E= SUM(S_P2_OUT,mf(S_P2_OUT,T)) + mf_p2_unreacted(T);
MassBalance_Process3(T).. SUM(S_P3_IN,mf(S_P3_IN,T)) =E= SUM(S_P3_OUT,mf(S_P3_OUT,T)) + mf_p3_unreacted(T);
MassBalance_Process4(T).. SUM(S_P4_IN,mf(S_P4_IN,T)) =E= SUM(S_P4_OUT,mf(S_P4_OUT,T)) + mf_p4_unreacted(T);
MassBalance_Process5(T).. SUM(S_P5_IN,mf(S_P5_IN,T)) =E= SUM(S_P5_OUT,mf(S_P5_OUT,T)) + mf_p5_unreacted(T);
MassBalance_Process6(T).. SUM(S_P6_IN,mf(S_P6_IN,T)) =E= SUM(S_P6_OUT,mf(S_P6_OUT,T)) + mf_p6_unreacted(T);
MassBalance_Process7(T).. SUM(S_P7_IN,mf(S_P7_IN,T)) =E= SUM(S_P7_OUT,mf(S_P7_OUT,T)) + mf_p7_unreacted(T);
MassBalance_Process8(T).. SUM(S_P8_IN,mf(S_P8_IN,T)) =E= SUM(S_P8_OUT,mf(S_P8_OUT,T)) + mf_p8_unreacted(T);

*Note: We add an additional constraint to ensure that conversion in every process is being done relative to limiting reactant (We assume limiting reactant is known apriori for every process).

Limiting_Process2(T).. f('3',T)*Gamma('3') =L= f('7',T)*Gamma('7');
Limiting_Process6(T).. f('16',T)*Gamma('16') =L= f('23',T)*Gamma('23');
Limiting_Process7(T).. f('24',T)*Gamma('24') =L= f('31',T)*Gamma('31');

*****************
*Disjunction 1 constraints

*Disjunction 1 constraints

Disj1_Conv_Process1_lt(S_P1_OUT,M,T).. f(S_P1_OUT,T) =L= f('2',T)*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M,T) + BigM_Conv_lt(S_P1_OUT,M,T)*(1-y('1',M,T));
Disj1_Conv_Process1_gt(S_P1_OUT,M,T).. f(S_P1_OUT,T) =G= f('2',T)*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M,T) - BigM_Conv_gt(S_P1_OUT,M,T)*(1-y('1',M,T));
Disj1_Conv_Process2_lt(S_P2_OUT,M,T).. f(S_P2_OUT,T) =L= f('3',T)*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M,T) + BigM_Conv_lt(S_P2_OUT,M,T)*(1-y('2',M,T));
Disj1_Conv_Process2_gt(S_P2_OUT,M,T).. f(S_P2_OUT,T) =G= f('3',T)*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M,T) - BigM_Conv_gt(S_P2_OUT,M,T)*(1-y('2',M,T));
Disj1_Conv_Process3_lt(S_P3_OUT,M,T).. f(S_P3_OUT,T) =L= f('11',T)*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M,T) + BigM_Conv_lt(S_P3_OUT,M,T)*(1-y('3',M,T));
Disj1_Conv_Process3_gt(S_P3_OUT,M,T).. f(S_P3_OUT,T) =G= f('11',T)*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M,T) - BigM_Conv_gt(S_P3_OUT,M,T)*(1-y('3',M,T));
Disj1_Conv_Process4_lt(S_P4_OUT,M,T).. f(S_P4_OUT,T) =L= f('14',T)*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M,T) + BigM_Conv_lt(S_P4_OUT,M,T)*(1-y('4',M,T));
Disj1_Conv_Process4_gt(S_P4_OUT,M,T).. f(S_P4_OUT,T) =G= f('14',T)*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M,T) - BigM_Conv_gt(S_P4_OUT,M,T)*(1-y('4',M,T));
Disj1_Conv_Process5_lt(S_P5_OUT,M,T).. f(S_P5_OUT,T) =L= f('17',T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M,T) + BigM_Conv_lt(S_P5_OUT,M,T)*(1-y('5',M,T));
Disj1_Conv_Process5_gt(S_P5_OUT,M,T).. f(S_P5_OUT,T) =G= f('17',T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M,T) - BigM_Conv_gt(S_P5_OUT,M,T)*(1-y('5',M,T));
Disj1_Conv_Process6_lt(S_P6_OUT,M,T).. f(S_P6_OUT,T) =L= f('16',T)*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M,T) + BigM_Conv_lt(S_P6_OUT,M,T)*(1-y('6',M,T));
Disj1_Conv_Process6_gt(S_P6_OUT,M,T).. f(S_P6_OUT,T) =G= f('16',T)*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M,T) - BigM_Conv_gt(S_P6_OUT,M,T)*(1-y('6',M,T));
Disj1_Conv_Process7_lt(S_P7_OUT,M,T).. f(S_P7_OUT,T) =L= f('24',T)*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M,T) + BigM_Conv_lt(S_P7_OUT,M,T)*(1-y('7',M,T));
Disj1_Conv_Process7_gt(S_P7_OUT,M,T).. f(S_P7_OUT,T) =G= f('24',T)*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M,T) - BigM_Conv_gt(S_P7_OUT,M,T)*(1-y('7',M,T));
Disj1_Conv_Process8_lt(S_P8_OUT,M,T).. f(S_P8_OUT,T) =L= f('30',T)*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M,T) + BigM_Conv_lt(S_P8_OUT,M,T)*(1-y('8',M,T));
Disj1_Conv_Process8_gt(S_P8_OUT,M,T).. f(S_P8_OUT,T) =G= f('30',T)*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M,T) - BigM_Conv_gt(S_P8_OUT,M,T)*(1-y('8',M,T));

Disj1_Cap_Process1(M,T).. SUM(S_P1_IN,mf(S_P1_IN,T)) =L= Cap('1',M,T) + BigM_Cap('1',M,T)*(1-y('1',M,T));
Disj1_Cap_Process2(M,T).. SUM(S_P2_IN,mf(S_P2_IN,T)) =L= Cap('2',M,T) + BigM_Cap('2',M,T)*(1-y('2',M,T));
Disj1_Cap_Process3(M,T).. SUM(S_P3_IN,mf(S_P3_IN,T)) =L= Cap('3',M,T) + BigM_Cap('3',M,T)*(1-y('3',M,T));
Disj1_Cap_Process4(M,T).. SUM(S_P4_IN,mf(S_P4_IN,T)) =L= Cap('4',M,T) + BigM_Cap('4',M,T)*(1-y('4',M,T));
Disj1_Cap_Process5(M,T).. SUM(S_P5_IN,mf(S_P5_IN,T)) =L= Cap('5',M,T) + BigM_Cap('5',M,T)*(1-y('5',M,T));
Disj1_Cap_Process6(M,T).. SUM(S_P6_IN,mf(S_P6_IN,T)) =L= Cap('6',M,T) + BigM_Cap('6',M,T)*(1-y('6',M,T));
Disj1_Cap_Process7(M,T).. SUM(S_P7_IN,mf(S_P7_IN,T)) =L= Cap('7',M,T) + BigM_Cap('7',M,T)*(1-y('7',M,T));
Disj1_Cap_Process8(M,T).. SUM(S_P8_IN,mf(S_P8_IN,T)) =L= Cap('8',M,T) + BigM_Cap('8',M,T)*(1-y('8',M,T));
*****************

*****************
*Disjunction 2 constraints

Disj2_lt(P,M,T).. convcapcost(P,T) =L= FixedCost_ConvCap(P,M,T) + BigM_ConvCapCost_lt(P,M,T)*(1-w(P,M,T));
Disj2_gt(P,M,T).. convcapcost(P,T) =G= FixedCost_ConvCap(P,M,T) - BigM_ConvCapCost_gt(P,M,T)*(1-w(P,M,T));
*****************

LimitingCost(T)..   SUM(P,convcapcost(P,T)) + SUM(S_RAW,Price_Raw(S_RAW,T)*mf(S_RAW,T)) =L= InvestmentLimit(T);

*Logic Constraints

Sum_y(P,T).. SUM(M,y(P,M,T)) =E= 1;
Sum_w(P,T).. SUM(M,w(P,M,T)) =E= 1;

Logic_y(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(T) LT ORD(TAU))..   y(P,M,T) =L= y(P,M,TAU);
Logic_w(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(TAU) NE ORD(T))..   w(P,M,T) =L= w(P,'1',TAU);
Logic_yw_M1(P,M,T)$(ORD(M) EQ 1)..                          y(P,M,T) =L= w(P,M,T);
Logic_yw_MlessM1(P,M,T)$(ORD(M) NE 1)..                     y(P,M,T) =L= w(P,M,T) + y(P,M,T-1);

*Interconnecting Streams
Inter1(T).. mf('5',T) =E= mf('32',T) + X('1',T);
Inter2(T).. mf('9',T) =E= mf('33',T) + X('12',T);
Inter3(T).. mf('20',T) =E= mf('34',T);
Inter4(T).. mf('21',T) =E= mf('35',T);

*Mass Balances
MB1(T)..    X('1',T)     -    X('2',T)  -    X('3',T)                    =E= 0;
MB2(T)..    X('6',T)     -    X('4',T)  -    X('5',T)                    =E= 0;
MB3(T)..    X('6',T)     -    X('7',T)  -    X('8',T)                    =E= 0;
MB4(T)..    X('8',T)     -    X('9',T)  -    X('10',T) -   X('11',T)     =E= 0;

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technically equations, but relax as less than or equal to inequalities (from physical considerations, the greater than or equal to inequalities are nonsense), which is why this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solely as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
DISJ_1_1_1(T).. X('4',T) =L= LOG(1+X('2',T)) + BIGM('1','1','1',T)*(1-Z('1',T));
DISJ_1_2_1(T).. X('2',T) =L= BIGM('1','2','1',T)*Z('1',T);
DISJ_2_2_1(T).. X('4',T) =L= BIGM('2','2','1',T)*Z('1',T);

DISJ_1_1_2(T).. X('5',T) =L= 1.2*LOG(1+X('3',T)) + BIGM('1','1','2',T)*(1-Z('2',T)) ;
DISJ_1_2_2(T).. X('3',T) =L= BIGM('1','2','2',T)*Z('2',T);
DISJ_2_2_2(T).. X('5',T) =L= BIGM('2','2','2',T)*Z('2',T);

DISJ_1_1_3(T).. X('13',T) =L= 0.75*X('9',T) + BIGM('1','1','3',T)*(1-Z('3',T));
DISJ_2_1_3(T).. X('13',T) =G= 0.75*X('9',T) - BIGM('2','1','3',T)*(1-Z('3',T));
DISJ_1_2_3(T).. X('9',T) =L= BIGM('1','2','3',T)*Z('3',T);
DISJ_2_2_3(T).. X('13',T) =L= BIGM('2','2','3',T)*Z('3',T);

DISJ_1_1_4(T).. X('14',T) =L= 1.5*LOG(1+X('10',T)) + BIGM('1','1','4',T)*(1-Z('4',T)) ;
DISJ_1_2_4(T).. X('10',T) =L= BIGM('1','2','4',T)*Z('4',T);
DISJ_2_2_4(T).. X('14',T) =L= BIGM('2','2','4',T)*Z('4',T);

DISJ_1_1_5(T).. X('15',T) =L= X('11',T) + BIGM('1','1','5',T)*(1-Z('5',T));
DISJ_2_1_5(T).. X('15',T) =G= X('11',T) - BIGM('2','1','5',T)*(1-Z('5',T));
DISJ_3_1_5(T).. X('15',T) =L= 0.5*X('12',T) + BIGM('3','1','5',T)*(1-Z('5',T));
DISJ_4_1_5(T).. X('15',T) =G= 0.5*X('12',T) - BIGM('4','1','5',T)*(1-Z('5',T));
DISJ_1_2_5(T).. X('11',T) =L= BIGM('1','2','5',T)*Z('5',T);
DISJ_2_2_5(T).. X('12',T) =L= BIGM('2','2','5',T)*Z('5',T);
DISJ_3_2_5(T).. X('15',T) =L= BIGM('3','2','5',T)*Z('5',T);

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

MODEL RETRO_8_SYNTH_5_MULTI_BIGM /ALL/;

OPTION LIMROW = 0;
OPTION LIMCOL = 0;
*OPTION SOLPRINT = OFF ;
*OPTION SYSOUT   = OFF ;
OPTION OPTCR = 0;
OPTION OPTCA = 0;
OPTION ITERLIM = 100000000;
OPTION RESLIM = 10800;
OPTION MIP = CPLEX;
OPTION NLP = conopt;
OPTION RMINLP = conopt;
OPTION MINLP  = dicopt;

*SOLVE RETRO_8_SYNTH_5_MULTI_BIGM USING RMINLP MAXIMIZING obj;

RETRO_8_SYNTH_5_MULTI_BIGM.NODLIM = 1000000;
RETRO_8_SYNTH_5_MULTI_BIGM.OPTFILE = 1;

SOLVE RETRO_8_SYNTH_5_MULTI_BIGM USING MINLP MAXIMIZING obj;
