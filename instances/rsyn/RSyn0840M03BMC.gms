*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= Z*exp(x/Z) <=> x <= z*log(y/z) ; x >= (x1 - M(1-z))/c ; y = 1 + x2; Z = 1
*Retrofit-Synthesis Problem with 8 retrofit processes and 40 synthesis processes
*Three Periods (t=3)
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
T            /1*3/                        /*Time periods*/
M            /1*4/                        /*Conversion &OR capacity scenarios*/

I       /1*40/                            /* Number of process units */
K       /1*90/                            /* Number of streams */
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
      1      2     3
26    32    41    31
28    40    39    27
32    2      2     2
33    3      2     2
34    3      3     3
35    2      2     2
;

TABLE Price_Raw(S_RAW,T)                  /*Price of Raw Streams (in 1E3 of $ per 1E6 lbs)*/
      1      2      3
1     10     7      5
6     15     11     9
10    18     14     10
22    19     17     17
29    16     16     15
;

TABLE FixedCost_ConvCap(P,M,T)            /*Fixed Cost for Retrofit Conversion &OR Capacity (in 1E3 $)*/
        1       2         3
1.1     0       0         0
2.1     0       0         0
3.1     0       0         0
4.1     0       0         0
5.1     0       0         0
6.1     0       0         0
7.1     0       0         0
8.1     0       0         0
1.2     6       4         3
2.2     7       4         4
3.2     7       5         3
4.2     11      8         6
5.2     10      7         6
6.2     9       9         7
7.2     8       7         7
8.2     8       6         5
1.3     40      35        20
2.3     30      25        20
3.3     15      5         2
4.3     13      8         3
5.3     13      8         3
6.3     30      30        25
7.3     20      15        10
8.3     15      10        6
1.4     46      39        23
2.4     37      29        22
3.4     22      10        5
4.4     24      16        9
5.4     23      15        9
6.4     39      39        32
7.4     28      22        17
8.4     23      16        11
;

PARAMETER InvestmentLimit(T)              /*Limit on Total Investment (in 1E3 $ per period)*/
/ 1 = 4000
  2 = 3800
  3 = 3600/
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
        1       2       3
26      0.2     0.15    0.1
28      0.2     0.15    0.1
32      0.1     0.1     0.1
33      0.1     0.1     0.1
34      0.4     0.3     0.2
35      0.3     0.2     0.1
;

TABLE Sup(S_RAW,T)                        /*Supply of raw feed (in 1E6 lbs per time period)*/
        1       2       3
1       35     30       30
6       36     31       30
10      25     22       22
22      24     21       20
29      30     25       21
;

TABLE Eta(P,M,T)                          /*Conversion Rate*/
        1       2       3
1.1     0.8     0.8     0.8
2.1     0.9     0.9     0.9
3.1     0.85    0.85    0.85
4.1     0.85    0.85    0.85
5.1     0.75    0.75    0.75
6.1     0.8     0.8     0.8
7.1     0.85    0.85    0.85
8.1     0.8     0.8     0.8
1.2     0.85    0.85    0.85
2.2     0.95    0.95    0.95
3.2     0.98    0.98    0.98
4.2     0.9     0.9     0.9
5.2     0.95    0.95    0.95
6.2     0.85    0.85    0.85
7.2     0.95    0.95    0.95
8.2     0.92    0.92    0.92
1.3     0.8     0.8     0.8
2.3     0.9     0.9     0.9
3.3     0.85    0.85    0.85
4.3     0.85    0.85    0.85
5.3     0.9     0.9     0.9
6.3     0.8     0.8     0.8
7.3     0.85    0.85    0.85
8.3     0.8     0.8     0.8
1.4     0.85    0.85    0.85
2.4     0.95    0.95    0.95
3.4     0.98    0.98    0.98
4.4     0.9     0.9     0.9
5.4     0.95    0.95    0.95
6.4     0.85    0.85    0.85
7.4     0.95    0.95    0.95
8.4     0.92    0.92    0.92
;

TABLE Cap(P,M,T)                         /*Capacity limit on every process (in 1E6 lbs per time period)*/
        1       2       3
1.1     10      10      10
2.1     40      40      40
3.1     15      15      15
4.1     15      15      15
5.1     10      10      10
6.1     20      20      20
7.1     25      25      25
8.1     15      15      15
1.2     10      10      10
2.2     40      40      40
3.2     15      15      15
4.2     15      15      15
5.2     10      10      10
6.2     20      20      20
7.2     25      25      25
8.2     15      15      15
1.3     50      50      50
2.3     60      60      60
3.3     25      25      25
4.3     20      20      20
5.3     20      20      20
6.3     55      55      55
7.3     50      50      50
8.3     35      35      35
1.4     50      50      50
2.4     60      60      60
3.4     25      25      25
4.4     20      20      20
5.4     20      20      20
6.4     55      55      55
7.4     50      50      50
8.4     35      35      35
;

******************************************* Optimal bounds on disaggregated variables

PARAMETER BigM_Conv_lt(S,M,T)              /*BigM for Disjunction 1, Conversion*/
/1*35 .1*4 .1*3 = 0/
;

PARAMETER BigM_Conv_gt(S,M,T)
/1*35 .1*4 .1*3 = 0/
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
/1*8 .1*4 .1*3 = 0/
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
/1*8 .1*4 .1*3 = 0/
;

PARAMETER BigM_ConvCapCost_gt(P,M,T)
/1*8 .1*4 .1*3 = 0/
;

LOOP((P,M,T),
        BigM_ConvCapCost_lt(P,M,T) = FixedCost_ConvCap(P,'4',T) - FixedCost_ConvCap(P,M,T);
);

LOOP((P,M,T),
        BigM_ConvCapCost_gt(P,M,T) = FixedCost_ConvCap(P,M,T);
);


TABLE PC(K,T)              /* Cost coefficient in objective (Cost and revenue of raw material and products, respectively) */
                        1       2       3
                1       -1      -1      -1
                2       0       0       0
                3       0       0       0
                4       0       0       0
                5       0       0       0
                6       0       0       0
                7       5       10      5
                8       0       0       0
                9       0       0       0
                10      0       0       0
                11      0       0       0
                12      -2      -1      -2
                13      0       0       0
                14      0       0       0
                15      0       0       0
                16      0       0       0
                17      0       0       0
                18      0       0       0
                19      0       0       0
                20      0       0       0
                21      0       0       0
                22      0       0       0
                23      0       0       0
                24      0       0       0
                25      0       0       0
                26      0       0       0
                27      0       0       0
                28      0       0       0
                29      -10     -5      -5
                30      -5      -5      -5
                31      0       0       0
                32      0       0       0
                33      0       0       0
                34      0       0       0
                35      0       0       0
                36      0       0       0
                37      40      30      15
                38      15      20      25
                39      10      30      40
                40      30      20      20
                41      35      50      20
                42      20      30      35
                43      25      50      10
                44      15      20      20
                45      0       0       0
                46      0       0       0
                47      0       0       0
                48      0       0       0
                49      0       0       0
                50      0       0       0
                51      0       0       0
                52      30      40      40
                53      0       0       0
                54      0       0       0
                55      0       0       0
                56      0       0       0
                57      -1      -1      -1
                58      0       0       0
                59      0       0       0
                60      0       0       0
                61      0       0       0
                62      0       0       0
                63      0       0       0
                64      0       0       0
                65      0       0       0
                66      0       0       0
                67      0       0       0
                68      0       0       0
                69      0       0       0
                70      0       0       0
                71      0       0       0
                72      0       0       0
                73      0       0       0
                74      -5      -3      -4
                75      -1      -1      -1
                76      0       0       0
                77      0       0       0
                78      0       0       0
                79      0       0       0
                80      0       0       0
                81      0       0       0
                82      120     110     150
                83      140     120     100
                84      90      60      150
                85      80      90      120
                86      285     390     350
                87      290     405     190
                88      280     400     430
                89      290     300     240
                90      350     250     300

TABLE FC(I,T)             /* Fixed costs in objective */
                         1       2       3
                1       -5       -4      -6
                2       -8       -7      -6
                3       -6       -9      -4
                4       -10      -9      -5
                5       -6       -10     -6
                6       -7       -7      -4
                7       -4       -3      -2
                8       -5       -6      -7
                9       -2       -5      -2
                10      -4       -7      -4
                11      -3       -9      -3
                12      -7       -2      -9
                13      -3       -1      -9
                14      -2       -6      -3
                15      -4       -8      -1
                16      -2       -5      -2
                17      -3       -4      -3
                18      -5       -7      -6
                19      -2       -8      -4
                20      -1       -4      -1
                21      -2       -5      -2
                22      -9       -2      -9
                23      -5       -8      -4
                24      -2       -3      -8
                25      -10      -6      -3
                26      -4       -8      -7
                27      -7       -3      -9
                28      -4       -8      -6
                29      -2       -1      -3
                30      -8       -3      -4
                31      -9       -5      -1
                32      -3       -9      -5
                33      -5       -3      -3
                34      -5       -3      -2
                35      -6       -4      -6
                36      -2       -6      -6
                37      -6       -4      -3
                38      -3       -2      -1
                39      -5       -8      -6
                40      -9       -5      -2
;

PARAMETERS BIGM(E,D,I,T) /1*4 .1*2 .1*40 .1*3 = 0/;

*Note 1: the values of the Big-M parameters below are optimal.
*Note 2: We could have fixed the values of M(E,'1',I) (i.e. big-M values in first disjuncts) to anything strictly greater than 0 since optimal M(E,'1',I) values are obtained when Y(I) is equal to 0, which would force all values of X(K) in that constraint to 0 (we chose M(E,'1',I) =1).
*Note 3: The bounds available on X('1'), X('12'), X('29') and X('30') were written as X1_UP, X12_UP, X29_UP and X30_UP below in order to generate the optimal Big-Ms.

PARAMETERS
X1_UP(T)
/1 = 40
 2 = 40
 3 = 40/

X12_UP(T)
/1 = 30
 2 = 30
 3 = 30/

X29_UP(T)
/1 = 20
 2 = 20
 3 = 20/

X30_UP(T)
/1 = 20
 2 = 20
 3 = 20/

X57_UP(T)
/1 = 30
 2 = 30
 3 = 30/

X74_UP(T)
/1 = 25
 2 = 25
 3 = 25/

X75_UP(T)
/1 = 25
 2 = 25
 3 = 25/;

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
                        1       2      3
                1       5       4      6
                2       8       7      6
                3       6       9      4
                4       10      9      5
                5       6       10     6
                6       7       7      4
                7       4       3      2
                8       5       6      7
                9       2       5      2
                10      4       7      4
                11      3       9      3
                12      7       2      9
                13      3       1      9
                14      2       6      3
                15      4       8      1
                16      2       5      2
                17      3       4      3
                18      5       7      6
                19      2       8      4
                20      1       4      1
                21      2       5      2
                22      9       2      9
                23      5       8      4
                24      2       3      8
                25      10      6      3
                26      4       8      7
                27      7       3      9
                28      4       8      6
                29      2       1      3
                30      8       3      4
                31      9       5      1
                32      3       9      5
                33      5       3      3
                34      5       3      2
                35      6       4      6
                36      2       6      6
                37      6       4      3
                38      3       2      1
                39      5       8      6
                40      9       5      2
;

TABLE BIGM2_2(I,T)
                         1       2       3
                1       -5       -4      -6
                2       -8       -7      -6
                3       -6       -9      -4
                4       -10      -9      -5
                5       -6       -10     -6
                6       -7       -7      -4
                7       -4       -3      -2
                8       -5       -6      -7
                9       -2       -5      -2
                10      -4       -7      -4
                11      -3       -9      -3
                12      -7       -2      -9
                13      -3       -1      -9
                14      -2       -6      -3
                15      -4       -8      -1
                16      -2       -5      -2
                17      -3       -4      -3
                18      -5       -7      -6
                19      -2       -8      -4
                20      -1       -4      -1
                21      -2       -5      -2
                22      -9       -2      -9
                23      -5       -8      -4
                24      -2       -3      -8
                25      -10      -6      -3
                26      -4       -8      -7
                27      -7       -3      -9
                28      -4       -8      -6
                29      -2       -1      -3
                30      -8       -3      -4
                31      -9       -5      -1
                32      -3       -9      -5
                33      -5       -3      -3
                34      -5       -3      -2
                35      -6       -4      -6
                36      -2       -6      -6
                37      -6       -4      -3
                38      -3       -2      -1
                39      -5       -8      -6
                40      -9       -5      -2
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

LimitingCost(T)..   1E3*(SUM(P,convcapcost(P,T)) + SUM(S_RAW,Price_Raw(S_RAW,T)*mf(S_RAW,T))) =L= 1E3*InvestmentLimit(T);

*Logic Constraints

Sum_y(P,T).. SUM(M,y(P,M,T)) =E= 1;
Sum_w(P,T).. SUM(M,w(P,M,T)) =E= 1;

Logic_y(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(T) LT ORD(TAU))..   y(P,M,T) =L= y(P,M,TAU);
Logic_w(P,M,T,TAU)$(ORD(M) NE 1 AND ORD(TAU) NE ORD(T))..   w(P,M,T) =L= w(P,'1',TAU);
Logic_yw_M1(P,M,T)$(ORD(M) EQ 1)..                          y(P,M,T) =L= w(P,M,T);
Logic_yw_MlessM1(P,M,T)$(ORD(M) NE 1)..                     y(P,M,T) =L= w(P,M,T) + y(P,M,T-1) + y(P,M,T-2);

*Interconnecting Streams
Inter1(T).. mf('5',T) =E= mf('32',T) + X('1',T);
Inter2(T).. mf('9',T) =E= mf('33',T) + X('12',T);
Inter3(T).. mf('20',T) =E= mf('34',T) + X('29',T);
Inter4(T).. mf('21',T) =E= mf('35',T) + X('30',T);

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
Logic_ZR(I,T)..                                           Z(I,T) =L= R(I,T) + Z(I,T-1) + Z(I,T-2);

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
X.UP('1',T) = 40;
X.UP('12',T) = 30;
X.UP('29',T) = 20;
X.UP('30',T) = 20;
X.UP('57',T) = 30;
X.UP('74',T) = 25;
X.UP('75',T) = 25;

MODEL RETRO_8_SYNTH_40_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE RETRO_8_SYNTH_40_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
