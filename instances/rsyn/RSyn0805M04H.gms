*Retrofit-Synthesis Problem with 8 retrofit processes and 5 synthesis processes
*Four Periods (t=4)
*Convex-Hull Version

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
T            /1*4/                        /*Time periods*/
M            /1*4/                        /*Conversion &OR capacity scenarios*/

I       /1*5/                            /* Number of process units */
K       /1*15/                            /* Number of streams */
D       /1*2/                             /* Number of disjuncts per disjunction */


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

*Epsilon used for RHS of non-linear constraints in disjunctions.
SCALAR  ES      /1E-6/;

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

zmf(S,M,T)                               /*Convex Hull disaggregated variables*/
zf(S,M,T)
zconvcapcost(P,M,T)
COST(I,T)

y(P,M,T)                                        /*Retrofit variable for conversion &OR capacity*/
w(P,M,T)                                        /*Retrofit variable for conversion &OR capacity fixed cost enforcement*/

X(K,T),V(K,D,I,T),Z(I,T),R(I,T)

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

zmf(S,M,T)
zf(S,M,T)
zconvcapcost(P,M,T)
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
      1      2     3      4
26    32    41    31      35
28    40    39    27      36
32    3      3     3      3
33    2      2     2      2
34    20    23    32      22
35    21    25    22      25
;

TABLE Price_Raw(S_RAW,T)                  /*Price of Raw Streams (in 1E3 of $ per 1E6 lbs)*/
      1      2      3      4
1     10     7      5      5
6     15     11     9      9
10    18     14     10     9
22    19     17     17     16
29    16     16     15     12
;

TABLE FixedCost_ConvCap(P,M,T)            /*Fixed Cost for Retrofit Conversion &OR Capacity (in 1E3 $)*/
        1       2         3       4
1.1     0       0         0       0
2.1     0       0         0       0
3.1     0       0         0       0
4.1     0       0         0       0
5.1     0       0         0       0
6.1     0       0         0       0
7.1     0       0         0       0
8.1     0       0         0       0
1.2     6       4         3       3
2.2     7       4         4       4
3.2     7       5         3       3
4.2     11      8         6       5
5.2     10      7         6       6
6.2     9       9         7       6
7.2     8       7         7       4
8.2     8       6         5       3
1.3     40      35        20      20
2.3     30      25        20      20
3.3     15      5         2       2
4.3     13      8         3       3
5.3     13      8         3       2
6.3     30      30        25      20
7.3     20      15        10      10
8.3     15      10        6       3
1.4     46      39        23      23
2.4     37      29        22      24
3.4     22      10        5       5
4.4     24      16        9       8
5.4     23      15        9       8
6.4     39      39        32      26
7.4     28      22        17      14
8.4     23      16        11      6
;

PARAMETER InvestmentLimit(T)              /*Limit on Total Investment (in 1E3 $ per period)*/
/ 1 = 4000
  2 = 3800
  3 = 3600
  4 = 3500/
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
        1        2       3       4
26      1.2     1.15    1.1      1.1
28      1.2     1.15    1.1      1.4
32      1.1     1.1     1.1      1.1
33      1.1     1.1     1.1      1.1
34      1.4     1.3     1.2      1.15
35      1.3     1.2     1.1      1.1
;

TABLE Sup(S_RAW,T)                        /*Supply of raw feed (in 1E6 lbs per time period)*/
        1       2       3        4
1       35     30       30       30
6       36     31       30       28
10      25     22       22       20
22      24     21       20       20
29      30     25       21       19
;

TABLE Eta(P,M,T)                          /*Conversion Rate*/
        1       2       3        4
1.1     0.8     0.8     0.8      0.8
2.1     0.9     0.9     0.9      0.9
3.1     0.85    0.85    0.85     0.85
4.1     0.85    0.85    0.85     0.85
5.1     0.75    0.75    0.75     0.75
6.1     0.8     0.8     0.8      0.8
7.1     0.85    0.85    0.85     0.85
8.1     0.8     0.8     0.8      0.8
1.2     0.85    0.85    0.85     0.85
2.2     0.95    0.95    0.95     0.95
3.2     0.98    0.98    0.98     0.98
4.2     0.9     0.9     0.9      0.9
5.2     0.95    0.95    0.95     0.95
6.2     0.85    0.85    0.85     0.85
7.2     0.95    0.95    0.95     0.95
8.2     0.92    0.92    0.92     0.92
1.3     0.8     0.8     0.8      0.8
2.3     0.9     0.9     0.9      0.9
3.3     0.85    0.85    0.85     0.85
4.3     0.85    0.85    0.85     0.85
5.3     0.9     0.9     0.9      0.9
6.3     0.8     0.8     0.8      0.8
7.3     0.85    0.85    0.85     0.85
8.3     0.8     0.8     0.8      0.8
1.4     0.85    0.85    0.85     0.85
2.4     0.95    0.95    0.95     0.95
3.4     0.98    0.98    0.98     0.98
4.4     0.9     0.9     0.9      0.9
5.4     0.95    0.95    0.95     0.95
6.4     0.85    0.85    0.85     0.85
7.4     0.95    0.95    0.95     0.95
8.4     0.92    0.92    0.92     0.92
;

TABLE Cap(P,M,T)                         /*Capacity limit on every process (in 1E6 lbs per time period)*/
        1       2       3        4
1.1     10      10      10       10
2.1     40      40      40       40
3.1     15      15      15       15
4.1     15      15      15       15
5.1     10      10      10       10
6.1     20      20      20       20
7.1     25      25      25       25
8.1     15      15      15       15
1.2     10      10      10       10
2.2     40      40      40       40
3.2     15      15      15       15
4.2     15      15      15       15
5.2     10      10      10       10
6.2     20      20      20       20
7.2     25      25      25       25
8.2     15      15      15       15
1.3     50      50      50       50
2.3     60      60      60       60
3.3     25      25      25       25
4.3     20      20      20       20
5.3     20      20      20       20
6.3     55      55      55       55
7.3     50      50      50       50
8.3     35      35      35       35
1.4     50      50      50       50
2.4     60      60      60       60
3.4     25      25      25       25
4.4     20      20      20       20
5.4     20      20      20       20
6.4     55      55      55       55
7.4     50      50      50       50
8.4     35      35      35       35
;

******************************************* Optimal bounds on disaggregated variables

PARAMETER Bnd_Conv(S,M,T)                 /*Bounds for Disjunction 1, Conversion*/
/1*35 .1*4 .1*4 = 0/
;

LOOP((S_P1_OUT,M,T),
        Bnd_Conv(S_P1_OUT,M,T) = (Sup('1',T)/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2',T);
);

LOOP((S_P2_OUT,M,T),
        Bnd_Conv(S_P2_OUT,M,T) = (Sup('1',T)/MolWeight('1')+Sup('6',T)/MolWeight('6')+(Sup('10',T)/MolWeight('10'))*(Gamma('12')/Gamma('11'))*Eta('3','2',T))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2',T);
);

LOOP((S_P3_OUT,M,T),
        Bnd_Conv(S_P3_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2',T);
);

LOOP((S_P4_OUT,M,T),
        Bnd_Conv(S_P4_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2',T);
);

LOOP((S_P5_OUT,M,T),
        Bnd_Conv(S_P5_OUT,M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2',T);
);

LOOP((S_P6_OUT,M,T),
        Bnd_Conv(S_P6_OUT,M,T) = ((Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T)+Sup('22',T)/MolWeight('22'))*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2',T);
);

LOOP((S_P7_OUT,M,T),
        Bnd_Conv(S_P7_OUT,M,T) = ((Sup('29',T)/MolWeight('29'))*(Gamma('31')/Gamma('30'))*Eta('8','2',T)+Sup('22',T)/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2',T);
);

LOOP((S_P8_OUT,M,T),
        Bnd_Conv(S_P8_OUT,M,T) = (Sup('29',T)/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2',T);
);

PARAMETER Bnd_Conv_Lim(S,M,T)
/1*35 .1*4 .1*4 = 0/
;

LOOP((M,T),
        Bnd_Conv_Lim('2',M,T) = Sup('1',T)/MolWeight('1');
);

LOOP((M,T),
        Bnd_Conv_Lim('3',M,T) = Sup('1',T)/MolWeight('1');
);

LOOP((M,T),
        Bnd_Conv_Lim('11',M,T) = Sup('10',T)/MolWeight('10');
);

LOOP((M,T),
        Bnd_Conv_Lim('14',M,T) = Sup('10',T)/MolWeight('10');
);

LOOP((M,T),
        Bnd_Conv_Lim('17',M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T);
);

LOOP((M,T),
        Bnd_Conv_Lim('16',M,T) = (Sup('10',T)/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2',T);
);

LOOP((M,T),
        Bnd_Conv_Lim('24',M,T) = Sup('22',T)/MolWeight('22');
);

LOOP((M,T),
        Bnd_Conv_Lim('30',M,T) = Sup('29',T)/MolWeight('29');
);


PARAMETER Bnd_Cap(S,M,T)                   /*Bounds for Disjunction 1, Capacity*/
/1*35 .1*4 .1*4 = 0/
;

LOOP((M,T),
        Bnd_Cap('2',M,T) = Sup('1',T);
);

LOOP((M,T),
        Bnd_Cap('3',M,T) = Sup('1',T);
);

LOOP((M,T),
        Bnd_Cap('7',M,T) = Sup('6',T) + Sup('10',T);
);

LOOP((M,T),
        Bnd_Cap('11',M,T) = Sup('10',T);
);

LOOP((M,T),
        Bnd_Cap('14',M,T) = Sup('10',T);
);

LOOP((M,T),
        Bnd_Cap('17',M,T) = Sup('10',T);
);

LOOP((M,T),
        Bnd_Cap('16',M,T) = Sup('10',T);
);

LOOP((M,T),
        Bnd_Cap('23',M,T) = Sup('22',T);
);

LOOP((M,T),
        Bnd_Cap('24',M,T) = Sup('22',T);
);

LOOP((M,T),
        Bnd_Cap('31',M,T) = Sup('29',T);
);

LOOP((M,T),
        Bnd_Cap('30',M,T) = Sup('29',T);
);


PARAMETER Bnd_ConvCapCost(P,M,T)            /*Bounds for Disjunction 2*/
/1*8 .1*4 .1*4 = 0/
;

LOOP((P,M,T),
        Bnd_ConvCapCost(P,M,T) = FixedCost_ConvCap(P,M,T);
);


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
                13      80      90      120      100
                14      285     390     350      300
                15      290     405     190      340

TABLE FC(I,T)             /* Fixed costs in objective */
                         1       2       3        4
                1       -5       -4      -6       -3
                2       -8       -7      -6       -5
                3       -6       -9      -4       -3
                4       -10      -9      -5       -6
                5       -6       -10     -6       -9
;

PARAMETER UB(K,D,I,T) /1*15 .1*2 .1*5 .1*4= 0/;

*Note: The bounds available on X('1'), X('12'), X('29'), X('30'), X('57'), X('74') and X('75') were written as X1_UP, X12_UP, X29_UP, X30_UP, X57_UP, X74_UP and X75_UP below in order to generate the optimal upper bounds on the disaggregated variables.


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

Disj1_Conv_Process1_Dis(S_P1_OUT,T)
Disj1_Conv_Process1_Dis_Lim(T)
Disj1_Conv_Process2_Dis(S_P2_OUT,T)
Disj1_Conv_Process2_Dis_Lim(T)
Disj1_Conv_Process3_Dis(S_P3_OUT,T)
Disj1_Conv_Process3_Dis_Lim(T)
Disj1_Conv_Process4_Dis(S_P4_OUT,T)
Disj1_Conv_Process4_Dis_Lim(T)
Disj1_Conv_Process5_Dis(S_P5_OUT,T)
Disj1_Conv_Process5_Dis_Lim(T)
Disj1_Conv_Process6_Dis(S_P6_OUT,T)
Disj1_Conv_Process6_Dis_Lim(T)
Disj1_Conv_Process7_Dis(S_P7_OUT,T)
Disj1_Conv_Process7_Dis_Lim(T)
Disj1_Conv_Process8_Dis(S_P8_OUT,T)
Disj1_Conv_Process8_Dis_Lim(T)

Disj1_Conv_Process1_Bnd(S_P1_OUT,M,T)
Disj1_Conv_Process2_Bnd(S_P2_OUT,M,T)
Disj1_Conv_Process3_Bnd(S_P3_OUT,M,T)
Disj1_Conv_Process4_Bnd(S_P4_OUT,M,T)
Disj1_Conv_Process5_Bnd(S_P5_OUT,M,T)
Disj1_Conv_Process6_Bnd(S_P6_OUT,M,T)
Disj1_Conv_Process7_Bnd(S_P7_OUT,M,T)
Disj1_Conv_Process8_Bnd(S_P8_OUT,M,T)

Disj1_Conv_Process1_Bnd_Lim(M,T)
Disj1_Conv_Process2_Bnd_Lim(M,T)
Disj1_Conv_Process3_Bnd_Lim(M,T)
Disj1_Conv_Process4_Bnd_Lim(M,T)
Disj1_Conv_Process5_Bnd_Lim(M,T)
Disj1_Conv_Process6_Bnd_Lim(M,T)
Disj1_Conv_Process7_Bnd_Lim(M,T)
Disj1_Conv_Process8_Bnd_Lim(M,T)

Disj1_Conv_Process1(S_P1_OUT,M,T)
Disj1_Conv_Process2(S_P2_OUT,M,T)
Disj1_Conv_Process3(S_P3_OUT,M,T)
Disj1_Conv_Process4(S_P4_OUT,M,T)
Disj1_Conv_Process5(S_P5_OUT,M,T)
Disj1_Conv_Process6(S_P6_OUT,M,T)
Disj1_Conv_Process7(S_P7_OUT,M,T)
Disj1_Conv_Process8(S_P8_OUT,M,T)

Disj1_Cap_Process1_Dis(S_P1_IN,T)
Disj1_Cap_Process2_Dis(S_P2_IN,T)
Disj1_Cap_Process3_Dis(S_P3_IN,T)
Disj1_Cap_Process4_Dis(S_P4_IN,T)
Disj1_Cap_Process5_Dis(S_P5_IN,T)
Disj1_Cap_Process6_Dis(S_P6_IN,T)
Disj1_Cap_Process7_Dis(S_P7_IN,T)
Disj1_Cap_Process8_Dis(S_P8_IN,T)

Disj1_Cap_Process1_Bnd(S_P1_IN,M,T)
Disj1_Cap_Process2_Bnd(S_P2_IN,M,T)
Disj1_Cap_Process3_Bnd(S_P3_IN,M,T)
Disj1_Cap_Process4_Bnd(S_P4_IN,M,T)
Disj1_Cap_Process5_Bnd(S_P5_IN,M,T)
Disj1_Cap_Process6_Bnd(S_P6_IN,M,T)
Disj1_Cap_Process7_Bnd(S_P7_IN,M,T)
Disj1_Cap_Process8_Bnd(S_P8_IN,M,T)

Disj1_Cap_Process1(M,T)
Disj1_Cap_Process2(M,T)
Disj1_Cap_Process3(M,T)
Disj1_Cap_Process4(M,T)
Disj1_Cap_Process5(M,T)
Disj1_Cap_Process6(M,T)
Disj1_Cap_Process7(M,T)
Disj1_Cap_Process8(M,T)

Disj2_Dis(P,T)

Disj2_Bnd(P,M,T)

Disj2(P,M,T)

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

DISJ2_Synthesis(I,T)

Logic_Z(I,T,TAU)
Logic_R(I,T,TAU)
Logic_ZR(I,T)

D1(T)
L1(T),L2(T),L3(T);

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

*Disaggregated variables for conversion
Disj1_Conv_Process1_Dis(S_P1_OUT,T).. f(S_P1_OUT,T) =E= SUM(M,zf(S_P1_OUT,M,T));
Disj1_Conv_Process1_Dis_Lim(T)..      f('2',T) =E= SUM(M,zf('2',M,T));
Disj1_Conv_Process2_Dis(S_P2_OUT,T).. f(S_P2_OUT,T) =E= SUM(M,zf(S_P2_OUT,M,T));
Disj1_Conv_Process2_Dis_Lim(T)..      f('3',T) =E= SUM(M,zf('3',M,T));
Disj1_Conv_Process3_Dis(S_P3_OUT,T).. f(S_P3_OUT,T) =E= SUM(M,zf(S_P3_OUT,M,T));
Disj1_Conv_Process3_Dis_Lim(T)..      f('11',T) =E= SUM(M,zf('11',M,T));
Disj1_Conv_Process4_Dis(S_P4_OUT,T).. f(S_P4_OUT,T) =E= SUM(M,zf(S_P4_OUT,M,T));
Disj1_Conv_Process4_Dis_Lim(T)..      f('14',T) =E= SUM(M,zf('14',M,T));
Disj1_Conv_Process5_Dis(S_P5_OUT,T).. f(S_P5_OUT,T) =E= SUM(M,zf(S_P5_OUT,M,T));
Disj1_Conv_Process5_Dis_Lim(T)..      f('17',T) =E= SUM(M,zf('17',M,T));
Disj1_Conv_Process6_Dis(S_P6_OUT,T).. f(S_P6_OUT,T) =E= SUM(M,zf(S_P6_OUT,M,T));
Disj1_Conv_Process6_Dis_Lim(T)..      f('16',T) =E= SUM(M,zf('16',M,T));
Disj1_Conv_Process7_Dis(S_P7_OUT,T).. f(S_P7_OUT,T) =E= SUM(M,zf(S_P7_OUT,M,T));
Disj1_Conv_Process7_Dis_Lim(T)..      f('24',T) =E= SUM(M,zf('24',M,T));
Disj1_Conv_Process8_Dis(S_P8_OUT,T).. f(S_P8_OUT,T) =E= SUM(M,zf(S_P8_OUT,M,T));
Disj1_Conv_Process8_Dis_Lim(T)..      f('30',T) =E= SUM(M,zf('30',M,T));

*Bounds on disaggregated variables for conversion
Disj1_Conv_Process1_Bnd(S_P1_OUT,M,T).. zf(S_P1_OUT,M,T) =L= Bnd_Conv(S_P1_OUT,M,T)*y('1',M,T);
Disj1_Conv_Process2_Bnd(S_P2_OUT,M,T).. zf(S_P2_OUT,M,T) =L= Bnd_Conv(S_P2_OUT,M,T)*y('2',M,T);
Disj1_Conv_Process3_Bnd(S_P3_OUT,M,T).. zf(S_P3_OUT,M,T) =L= Bnd_Conv(S_P3_OUT,M,T)*y('3',M,T);
Disj1_Conv_Process4_Bnd(S_P4_OUT,M,T).. zf(S_P4_OUT,M,T) =L= Bnd_Conv(S_P4_OUT,M,T)*y('4',M,T);
Disj1_Conv_Process5_Bnd(S_P5_OUT,M,T).. zf(S_P5_OUT,M,T) =L= Bnd_Conv(S_P5_OUT,M,T)*y('5',M,T);
Disj1_Conv_Process6_Bnd(S_P6_OUT,M,T).. zf(S_P6_OUT,M,T) =L= Bnd_Conv(S_P6_OUT,M,T)*y('6',M,T);
Disj1_Conv_Process7_Bnd(S_P7_OUT,M,T).. zf(S_P7_OUT,M,T) =L= Bnd_Conv(S_P7_OUT,M,T)*y('7',M,T);
Disj1_Conv_Process8_Bnd(S_P8_OUT,M,T).. zf(S_P8_OUT,M,T) =L= Bnd_Conv(S_P8_OUT,M,T)*y('8',M,T);

Disj1_Conv_Process1_Bnd_Lim(M,T).. zf('2',M,T) =L= Bnd_Conv_Lim('2',M,T)*y('1',M,T);
Disj1_Conv_Process2_Bnd_Lim(M,T).. zf('3',M,T) =L= Bnd_Conv_Lim('3',M,T)*y('2',M,T);
Disj1_Conv_Process3_Bnd_Lim(M,T).. zf('11',M,T) =L= Bnd_Conv_Lim('11',M,T)*y('3',M,T);
Disj1_Conv_Process4_Bnd_Lim(M,T).. zf('14',M,T) =L= Bnd_Conv_Lim('14',M,T)*y('4',M,T);
Disj1_Conv_Process5_Bnd_Lim(M,T).. zf('17',M,T) =L= Bnd_Conv_Lim('17',M,T)*y('5',M,T);
Disj1_Conv_Process6_Bnd_Lim(M,T).. zf('16',M,T) =L= Bnd_Conv_Lim('16',M,T)*y('6',M,T);
Disj1_Conv_Process7_Bnd_Lim(M,T).. zf('24',M,T) =L= Bnd_Conv_Lim('24',M,T)*y('7',M,T);
Disj1_Conv_Process8_Bnd_Lim(M,T).. zf('30',M,T) =L= Bnd_Conv_Lim('30',M,T)*y('8',M,T);

*Constraints in disjuncts for conversion
Disj1_Conv_Process1(S_P1_OUT,M,T).. zf(S_P1_OUT,M,T) - zf('2',M,T)*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M,T) =E= 0*y('1',M,T);
Disj1_Conv_Process2(S_P2_OUT,M,T).. zf(S_P2_OUT,M,T) - zf('3',M,T)*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M,T) =E= 0*y('2',M,T);
Disj1_Conv_Process3(S_P3_OUT,M,T).. zf(S_P3_OUT,M,T) - zf('11',M,T)*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M,T) =E= 0*y('3',M,T);
Disj1_Conv_Process4(S_P4_OUT,M,T).. zf(S_P4_OUT,M,T) - zf('14',M,T)*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M,T) =E= 0*y('4',M,T);
Disj1_Conv_Process5(S_P5_OUT,M,T).. zf(S_P5_OUT,M,T) - zf('17',M,T)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M,T) =E= 0*y('5',M,T);
Disj1_Conv_Process6(S_P6_OUT,M,T).. zf(S_P6_OUT,M,T) - zf('16',M,T)*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M,T) =E= 0*y('6',M,T);
Disj1_Conv_Process7(S_P7_OUT,M,T).. zf(S_P7_OUT,M,T) - zf('24',M,T)*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M,T) =E= 0*y('7',M,T);
Disj1_Conv_Process8(S_P8_OUT,M,T).. zf(S_P8_OUT,M,T) - zf('30',M,T)*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M,T) =E= 0*y('8',M,T);

*Disaggregated variables for capacity
Disj1_Cap_Process1_Dis(S_P1_IN,T).. mf(S_P1_IN,T) =E= SUM(M,zmf(S_P1_IN,M,T));
Disj1_Cap_Process2_Dis(S_P2_IN,T).. mf(S_P2_IN,T) =E= SUM(M,zmf(S_P2_IN,M,T));
Disj1_Cap_Process3_Dis(S_P3_IN,T).. mf(S_P3_IN,T) =E= SUM(M,zmf(S_P3_IN,M,T));
Disj1_Cap_Process4_Dis(S_P4_IN,T).. mf(S_P4_IN,T) =E= SUM(M,zmf(S_P4_IN,M,T));
Disj1_Cap_Process5_Dis(S_P5_IN,T).. mf(S_P5_IN,T) =E= SUM(M,zmf(S_P5_IN,M,T));
Disj1_Cap_Process6_Dis(S_P6_IN,T).. mf(S_P6_IN,T) =E= SUM(M,zmf(S_P6_IN,M,T));
Disj1_Cap_Process7_Dis(S_P7_IN,T).. mf(S_P7_IN,T) =E= SUM(M,zmf(S_P7_IN,M,T));
Disj1_Cap_Process8_Dis(S_P8_IN,T).. mf(S_P8_IN,T) =E= SUM(M,zmf(S_P8_IN,M,T));

*Bounds on disaggregated variables for capacity
Disj1_Cap_Process1_Bnd(S_P1_IN,M,T).. zmf(S_P1_IN,M,T) =L= Bnd_Cap(S_P1_IN,M,T)*y('1',M,T);
Disj1_Cap_Process2_Bnd(S_P2_IN,M,T).. zmf(S_P2_IN,M,T) =L= Bnd_Cap(S_P2_IN,M,T)*y('2',M,T);
Disj1_Cap_Process3_Bnd(S_P3_IN,M,T).. zmf(S_P3_IN,M,T) =L= Bnd_Cap(S_P3_IN,M,T)*y('3',M,T);
Disj1_Cap_Process4_Bnd(S_P4_IN,M,T).. zmf(S_P4_IN,M,T) =L= Bnd_Cap(S_P4_IN,M,T)*y('4',M,T);
Disj1_Cap_Process5_Bnd(S_P5_IN,M,T).. zmf(S_P5_IN,M,T) =L= Bnd_Cap(S_P5_IN,M,T)*y('5',M,T);
Disj1_Cap_Process6_Bnd(S_P6_IN,M,T).. zmf(S_P6_IN,M,T) =L= Bnd_Cap(S_P6_IN,M,T)*y('6',M,T);
Disj1_Cap_Process7_Bnd(S_P7_IN,M,T).. zmf(S_P7_IN,M,T) =L= Bnd_Cap(S_P7_IN,M,T)*y('7',M,T);
Disj1_Cap_Process8_Bnd(S_P8_IN,M,T).. zmf(S_P8_IN,M,T) =L= Bnd_Cap(S_P8_IN,M,T)*y('8',M,T);

*Constraints in disjuncts for capacity
Disj1_Cap_Process1(M,T).. SUM(S_P1_IN,zmf(S_P1_IN,M,T)) =L= Cap('1',M,T)*y('1',M,T);
Disj1_Cap_Process2(M,T).. SUM(S_P2_IN,zmf(S_P2_IN,M,T)) =L= Cap('2',M,T)*y('2',M,T);
Disj1_Cap_Process3(M,T).. SUM(S_P3_IN,zmf(S_P3_IN,M,T)) =L= Cap('3',M,T)*y('3',M,T);
Disj1_Cap_Process4(M,T).. SUM(S_P4_IN,zmf(S_P4_IN,M,T)) =L= Cap('4',M,T)*y('4',M,T);
Disj1_Cap_Process5(M,T).. SUM(S_P5_IN,zmf(S_P5_IN,M,T)) =L= Cap('5',M,T)*y('5',M,T);
Disj1_Cap_Process6(M,T).. SUM(S_P6_IN,zmf(S_P6_IN,M,T)) =L= Cap('6',M,T)*y('6',M,T);
Disj1_Cap_Process7(M,T).. SUM(S_P7_IN,zmf(S_P7_IN,M,T)) =L= Cap('7',M,T)*y('7',M,T);
Disj1_Cap_Process8(M,T).. SUM(S_P8_IN,zmf(S_P8_IN,M,T)) =L= Cap('8',M,T)*y('8',M,T);
*****************

*****************
*Disjunction 2 constraints

*Disaggregated variables
Disj2_Dis(P,T).. convcapcost(P,T) =E= SUM(M,zconvcapcost(P,M,T));

*Bounds on disaggregated variables
Disj2_Bnd(P,M,T).. zconvcapcost(P,M,T) =L= Bnd_ConvCapCost(P,M,T)*w(P,M,T);

*Constraints in disjuncts
Disj2(P,M,T).. zconvcapcost(P,M,T) =E= FixedCost_ConvCap(P,M,T)*w(P,M,T);
*****************

LimitingCost(T)..   SUM(P,convcapcost(P,T)) + SUM(S_RAW,Price_Raw(S_RAW,T)*mf(S_RAW,T)) =L= InvestmentLimit(T);

Sum_y(P,T).. SUM(M,y(P,M,T)) =E= 1;
Sum_w(P,T).. SUM(M,w(P,M,T)) =E= 1;

Logic_y(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(T) LT ORD(TAU))..   y(P,M,T) =L= y(P,M,TAU);
Logic_w(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(TAU) NE ORD(T))..   w(P,M,T) =L= w(P,'1',TAU);
Logic_yw_M1(P,M,T)$(ORD(M) EQ 1)..                          y(P,M,T) =L= w(P,M,T);
Logic_yw_MlessM1(P,M,T)$(ORD(M) NE 1)..                     y(P,M,T) =L= w(P,M,T) + y(P,M,T-1) + y(P,M,T-2) + y(P,M,T-3);

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
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in Sawaya & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

DISJ_1_1_1(T).. (Z('1',T)+ES)*(V('4','1','1',T)/(Z('1',T)+ES) - LOG(1+V('2','1','1',T)/(Z('1',T)+ES))) =L= 0;
DISJ_1_2_1(T).. V('2','2','1',T) =E= 0;
DISJ_2_2_1(T).. V('4','2','1',T) =E= 0;
DISJ_1_3_1(T).. X('2',T) =E= SUM(D,V('2',D,'1',T));
DISJ_2_3_1(T).. X('4',T) =E= SUM(D,V('4',D,'1',T));
DISJ_1_4_1(T).. V('2','1','1',T) =L= UB('2','1','1',T)*Z('1',T);
DISJ_2_4_1(T).. V('2','2','1',T) =L= UB('2','2','1',T)*(1-Z('1',T));
DISJ_3_4_1(T).. V('4','1','1',T) =L= UB('4','1','1',T)*Z('1',T);
DISJ_4_4_1(T).. V('4','2','1',T) =L= UB('4','2','1',T)*(1-Z('1',T));

DISJ_1_1_2(T).. (Z('2',T)+ES)*(V('5','1','2',T)/(Z('2',T)+ES) - 1.2*LOG(1+V('3','1','2',T)/(Z('2',T)+ES))) =L= 0;
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

DISJ_1_1_4(T).. (Z('4',T)+ES)*(V('14','1','4',T)/(Z('4',T)+ES) - 1.5*LOG(1+V('10','1','4',T)/(Z('4',T)+ES))) =L= 0;
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

*Constraints in disjunct 2
DISJ2_Synthesis(I,T).. COST(I,T) =E= FC(I,T)*R(I,T);
*****************

Logic_Z(I,T,TAU)$(ORD(T) LT ORD(TAU))..                   Z(I,T) =L= Z(I,TAU);
Logic_R(I,T,TAU)$(ORD(TAU) NE ORD(T))..                   R(I,T) + R(I,TAU) =L= 1;
Logic_ZR(I,T)..                                           Z(I,T) =L= R(I,T) + Z(I,T-1) + Z(I,T-2) + Z(I,T-3);


*Design Specifications
D1(T)..  Z('1',T) + Z('2',T)                              =E= 1;

*Logic Cuts (that were deduced bZ inspection from the superstructure -- used to aid in the optimization)

L1(T)..  -Z('3',T) + Z('1',T) + Z('2',T)                  =G= 0;
L2(T)..  -Z('4',T) + Z('1',T) + Z('2',T)                  =G= 0;
L3(T)..  -Z('5',T) + Z('1',T) + Z('2',T)                  =G= 0;

* Bounds
X.UP('1',T) = 40;
X.UP('12',T) = 30;

MODEL RETRO_8_SYNTH_5_MULTI_CH /ALL/;

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
OPTION MINLP  = sbb;

*SOLVE RETRO_8_SYNTH_5_MULTI_CH USING RMINLP MAXIMIZING obj;

RETRO_8_SYNTH_5_MULTI_CH.NODLIM = 1000000;
RETRO_8_SYNTH_5_MULTI_CH.OPTFILE = 1;

SOLVE RETRO_8_SYNTH_5_MULTI_CH USING MINLP MAXIMIZING obj;