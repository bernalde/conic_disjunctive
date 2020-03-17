*Retrofit-Synthesis Problem with 8 retrofit processes and 40 synthesis processes
*One Period (t=1)
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

/26 =   35
 28 =   28
 32 =   2
 33 =   3
 34 =   5
 35 =   4/
;

PARAMETER Price_Raw(S_RAW)                  /*Price of Raw Streams (in 1E3 of $ per 1E6 lbs)*/

/1 =    10
 6  =   15
 10 =   18
 22 =   19
 29 =   16/
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

/26  =    1.2
 28  =    1.2
 32  =    1.1
 33  =    1.1
 34  =    1.4
 35  =    1.3/
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
Inter3.. mf('20') =E= mf('34') + X('29');
Inter4.. mf('21') =E= mf('35') + X('30');

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

DISJ_1_1_11.. X('26') =L= 1.1*LOG(1+X('20')) + BIGM('1','1','11')*(1-Z('11')) ;
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

DISJ_1_1_13.. X('38') =L= LOG(1+X('22')) + BIGM('1','1','13')*(1-Z('13')) ;
DISJ_1_2_13.. X('22') =L= BIGM('1','2','13')*Z('13');
X.up('22') = BIGM('1','2','13');
DISJ_2_2_13.. X('38') =L= BIGM('2','2','13')*Z('13');
X.up('38') = BIGM('2','2','13');

DISJ_1_1_14.. X('39') =L= 0.7*LOG(1+X('27')) + BIGM('1','1','14')*(1-Z('14')) ;
DISJ_1_2_14.. X('27') =L= BIGM('1','2','14')*Z('14');
X.up('27') = BIGM('1','2','14');
DISJ_2_2_14.. X('39') =L= BIGM('2','2','14')*Z('14');
X.up('39') = BIGM('2','2','14');

DISJ_1_1_15.. X('40') =L= 0.65*LOG(1+X('28')) + BIGM('1','1','15')*(1-Z('15')) ;
DISJ_2_1_15.. X('40') =L= 0.65*LOG(1+X('31')) + BIGM('2','1','15')*(1-Z('15')) ;
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

DISJ_1_1_18.. X('43') =L= 0.75*LOG(1+X('34')) + BIGM('1','1','18')*(1-Z('18')) ;
DISJ_1_2_18.. X('34') =L= BIGM('1','2','18')*Z('18');
X.up('34') = BIGM('1','2','18');
DISJ_2_2_18.. X('43') =L= BIGM('2','2','18')*Z('18');
X.up('43') = BIGM('2','2','18');

DISJ_1_1_19.. X('44') =L= 0.8*LOG(1+X('35')) + BIGM('1','1','19')*(1-Z('19')) ;
DISJ_1_2_19.. X('35') =L= BIGM('1','2','19')*Z('19');
X.up('35') = BIGM('1','2','19');
DISJ_2_2_19.. X('44') =L= BIGM('2','2','19')*Z('19');
X.up('44') = BIGM('2','2','19');

DISJ_1_1_20.. X('45') =L= 0.85*LOG(1+X('36')) + BIGM('1','1','20')*(1-Z('20')) ;
DISJ_1_2_20.. X('36') =L= BIGM('1','2','20')*Z('20');
X.up('36') = BIGM('1','2','20');
DISJ_2_2_20.. X('45') =L= BIGM('2','2','20')*Z('20');
X.up('45') = BIGM('2','2','20');

DISJ_1_1_21.. X('49') =L= LOG(1+X('47')) + BIGM('1','1','21')*(1-Z('21'));
DISJ_1_2_21.. X('47') =L= BIGM('1','2','21')*Z('21');
X.up('47') = BIGM('1','2','21');
DISJ_2_2_21.. X('49') =L= BIGM('2','2','21')*Z('21');
X.up('49') = BIGM('2','2','21');

DISJ_1_1_22.. X('50') =L= 1.2*LOG(1+X('48')) + BIGM('1','1','22')*(1-Z('22')) ;
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

DISJ_1_1_24.. X('59') =L= 1.5*LOG(1+X('55')) + BIGM('1','1','24')*(1-Z('24')) ;
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

DISJ_1_1_26.. X('66') =L= 1.25*LOG(1+X('61')) + BIGM('1','1','26')*(1-Z('26')) ;
DISJ_1_2_26.. X('61') =L= BIGM('1','2','26')*Z('26');
X.up('61') = BIGM('1','2','26');
DISJ_2_2_26.. X('66') =L= BIGM('2','2','26')*Z('26');
X.up('66') = BIGM('2','2','26');

DISJ_1_1_27.. X('67') =L= 0.9*LOG(1+X('62')) + BIGM('1','1','27')*(1-Z('27')) ;
DISJ_1_2_27.. X('62') =L= BIGM('1','2','27')*Z('27');
X.up('62') = BIGM('1','2','27');
DISJ_2_2_27.. X('67') =L= BIGM('2','2','27')*Z('27');
X.up('67') = BIGM('2','2','27');

DISJ_1_1_28.. X('68') =L= LOG(1+X('59')) + BIGM('1','1','28')*(1-Z('28')) ;
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

DISJ_1_1_31.. X('71') =L= 1.1*LOG(1+X('65')) + BIGM('1','1','31')*(1-Z('31')) ;
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

DISJ_1_1_33.. X('83') =L= LOG(1+X('67')) + BIGM('1','1','33')*(1-Z('33')) ;
DISJ_1_2_33.. X('67') =L= BIGM('1','2','33')*Z('33');
X.up('67') = BIGM('1','2','33');
DISJ_2_2_33.. X('83') =L= BIGM('2','2','33')*Z('33');
X.up('83') = BIGM('2','2','33');

DISJ_1_1_34.. X('84') =L= 0.7*LOG(1+X('72')) + BIGM('1','1','34')*(1-Z('34')) ;
DISJ_1_2_34.. X('72') =L= BIGM('1','2','34')*Z('34');
X.up('72') = BIGM('1','2','34');
DISJ_2_2_34.. X('84') =L= BIGM('2','2','34')*Z('34');
X.up('84') = BIGM('2','2','34');

DISJ_1_1_35.. X('85') =L= 0.65*LOG(1+X('73')) + BIGM('1','1','35')*(1-Z('35')) ;
DISJ_2_1_35.. X('85') =L= 0.65*LOG(1+X('76')) + BIGM('2','1','35')*(1-Z('35')) ;
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

DISJ_1_1_38.. X('88') =L= 0.75*LOG(1+X('79')) + BIGM('1','1','38')*(1-Z('38')) ;
DISJ_1_2_38.. X('79') =L= BIGM('1','2','38')*Z('38');
X.up('79') = BIGM('1','2','38');
DISJ_2_2_38.. X('88') =L= BIGM('2','2','38')*Z('38');
X.up('88') = BIGM('2','2','38');

DISJ_1_1_39.. X('89') =L= 0.8*LOG(1+X('80')) + BIGM('1','1','39')*(1-Z('39')) ;
DISJ_1_2_39.. X('80') =L= BIGM('1','2','39')*Z('39');
X.up('80') = BIGM('1','2','39');
DISJ_2_2_39.. X('89') =L= BIGM('2','2','39')*Z('39');
X.up('89') = BIGM('2','2','39');

DISJ_1_1_40.. X('90') =L= 0.85*LOG(1+X('81')) + BIGM('1','1','40')*(1-Z('40')) ;
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

MODEL RETRO_8_SYNTH_40_MULTI_BIGM /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE RETRO_8_SYNTH_40_MULTI_BIGM USING %TYPE% MAXIMIZING OBJ;
