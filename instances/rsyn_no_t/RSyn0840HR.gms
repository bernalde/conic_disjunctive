*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Convexification by sum disaggregation and binary continuous product linearization (done twice)
*disj.. z + v2 >= z*exp(x) <=> x <= log((z+v2)/z) ; c*z*x = c*w >= v1;
*y = z*exp(x): y >= z; y <= exp(v1_ub/c)*z;    y >= exp(x) - (1-z)*exp(v1_ub/c);   y <= exp(x) - (1-z) (removed because nonconvex and inactive)
*w = z*x: w >= 0; c*w <= v1_up*z; c*w >= c*x - (1-z)*v1_ub; w <= x;
*Retrofit-Synthesis Problem with 8 retrofit processes and 40 synthesis processes
*One Periods (t=1)
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

S            /1*35/                       /*Retrofit Streams*/
P            /1*8/                        /*Number of Retrofit Processes*/
M            /1*4/                        /*Conversion &OR capacity scenarios*/

K            /1*90/                       /* Number of Synthesis Streams */
I            /1*40/                       /* Number of Synthesis Processes */
D            /1*2/                        /* Number of disjuncts per disjunction for Synthesis portion */
E            /1*4/                        /* Maximum number of equations within every disjunct of every disjunction for Synthesis portion - used only for indexing big-M parameters */


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

*Epsilon used in the reformulation of non-linear constraints in disjunctions.
SCALAR  ES      /1E-6/;

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

zmf(S,M)                               /*Convex Hull disaggregated variables*/
zf(S,M)
zconvcapcost(P,M)

y(P,M)                                        /*Retrofit variable for conversion &OR capacity*/
                                        /*Retrofit variable for conversion &OR capacity fixed cost enforcement*/
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

zmf(S,M)
zf(S,M)
zconvcapcost(P,M)

X(K),V(K,D,I)
;

BINARY VARIABLES

y(P,M)
Z(I)
;

****************************************************** DATA FOR RETROFIT PORTION *****************************************************

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

PARAMETER Bnd_Conv(S,M)                 /*Bounds for Disjunction 1, Conversion*/
/1*35 .1*4 = 0/
;

LOOP((S_P1_OUT,M),
        Bnd_Conv(S_P1_OUT,M) = (Sup('1')/MolWeight('1'))*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1','2');
);

LOOP((S_P2_OUT,M),
        Bnd_Conv(S_P2_OUT,M) = (Sup('1')/MolWeight('1')+Sup('6')/MolWeight('6')+(Sup('10')/MolWeight('10'))*(Gamma('12')/Gamma('11'))*Eta('3','2'))*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2','2');
);

LOOP((S_P3_OUT,M),
        Bnd_Conv(S_P3_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3','2');
);

LOOP((S_P4_OUT,M),
        Bnd_Conv(S_P4_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4','2');
);

LOOP((S_P5_OUT,M),
        Bnd_Conv(S_P5_OUT,M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5','2');
);

LOOP((S_P6_OUT,M),
        Bnd_Conv(S_P6_OUT,M) = ((Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2')+Sup('22')/MolWeight('22'))*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6','2');
);

LOOP((S_P7_OUT,M),
        Bnd_Conv(S_P7_OUT,M) = ((Sup('29')/MolWeight('29'))*(Gamma('31')/Gamma('30'))*Eta('8','2')+Sup('22')/MolWeight('22'))*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7','2');
);

LOOP((S_P8_OUT,M),
        Bnd_Conv(S_P8_OUT,M) = (Sup('29')/MolWeight('29'))*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8','2');
);

PARAMETER Bnd_Conv_Lim(S,M)
/1*35 .1*4  = 0/
;

LOOP((M),
        Bnd_Conv_Lim('2',M) = Sup('1')/MolWeight('1');
);

LOOP((M),
        Bnd_Conv_Lim('3',M) = Sup('1')/MolWeight('1');
);

LOOP((M),
        Bnd_Conv_Lim('11',M) = Sup('10')/MolWeight('10');
);

LOOP((M),
        Bnd_Conv_Lim('14',M) = Sup('10')/MolWeight('10');
);

LOOP((M),
        Bnd_Conv_Lim('17',M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2');
);

LOOP((M),
        Bnd_Conv_Lim('16',M) = (Sup('10')/MolWeight('10'))*(Gamma('15')/Gamma('14'))*Eta('4','2');
);

LOOP((M),
        Bnd_Conv_Lim('24',M) = Sup('22')/MolWeight('22');
);

LOOP((M),
        Bnd_Conv_Lim('30',M) = Sup('29')/MolWeight('29');
);


PARAMETER Bnd_Cap(S,M)                   /*Bounds for Disjunction 1, Capacity*/
/1*35 .1*4 = 0/
;

LOOP((M),
        Bnd_Cap('2',M) = Sup('1');
);

LOOP((M),
        Bnd_Cap('3',M) = Sup('1');
);

LOOP((M),
        Bnd_Cap('7',M) = Sup('6') + Sup('10');
);

LOOP((M),
        Bnd_Cap('11',M) = Sup('10');
);

LOOP((M),
        Bnd_Cap('14',M) = Sup('10');
);

LOOP((M),
        Bnd_Cap('17',M) = Sup('10');
);

LOOP((M),
        Bnd_Cap('16',M) = Sup('10');
);

LOOP((M),
        Bnd_Cap('23',M) = Sup('22');
);

LOOP((M),
        Bnd_Cap('24',M) = Sup('22');
);

LOOP((M),
        Bnd_Cap('31',M) = Sup('29');
);

LOOP((M),
        Bnd_Cap('30',M) = Sup('29');
);


PARAMETER Bnd_ConvCapCost(P,M)            /*Bounds for Disjunction 2*/
/1*8 .1*4 = 0/
;

LOOP((P,M),
        Bnd_ConvCapCost(P,M) = FixedCost_ConvCap(P,M);
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

PARAMETER UB(K,D,I) /1*90 .1*2 .1*40 = 0/;

*Note: The bounds available on X('1'), X('12'), X('29'), X('30'), X('57'), X('74') and X('75') were written as X1_UP, X12_UP, X29_UP, X30_UP, X57_UP, X74_UP and X75_UP below in order to generate the optimal upper bounds on the disaggregated variables.


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

UB('32','1','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('32','2','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('41','1','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('41','2','16') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

UB('33','1','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('33','2','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('42','1','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);
UB('42','2','17') = 0.6*MAX(1.2*LOG(1+X1_UP),0.5*X12_UP);

UB('34','1','18') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('34','2','18') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('43','1','18') = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('43','2','18') = 0.75*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

UB('35','1','19') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('35','2','19') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('44','1','19') = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('44','2','19') = 0.8*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

UB('36','1','20') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('36','2','20') = 1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP));
UB('45','1','20') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('45','2','20') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));

*For values of UB in the range of 21-40, simply replace the upper bound of X('1') wherever it's present in 1-20 with the upper bound of X('45') (i.e. replace X1_UB with 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))
UB('47','1','21') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('47','2','21') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('49','1','21') = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('49','2','21') = LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

UB('48','1','22') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('48','2','22') = 0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))));
UB('50','1','22') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('50','2','22') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

UB('54','1','23') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('54','2','23') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('58','1','23') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('58','2','23') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));

UB('55','1','24') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('55','2','24') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('59','1','24') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('59','2','24') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

UB('56','1','25') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('56','2','25') = 1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('57','1','25') = X57_UP;
UB('57','2','25') = X57_UP;
UB('60','1','25') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('60','2','25') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

UB('61','1','26') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('61','2','26') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('66','1','26') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('66','2','26') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

UB('62','1','27') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('62','2','27') = 0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))));
UB('67','1','27') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('67','2','27') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));

UB('59','1','28') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('59','2','28') = 1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('68','1','28') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('68','2','28') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));

UB('63','1','29') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('63','2','29') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('69','1','29') = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('69','2','29') = 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

UB('64','1','30') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('64','2','30') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('70','1','30') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('70','2','30') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

UB('65','1','31') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('65','2','31') = MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('71','1','31') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('71','2','31') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));

UB('66','1','32') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('66','2','32') = 1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('74','1','32') = X74_UP;
UB('74','2','32') = X74_UP;
UB('82','1','32') = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))))), X74_UP);
UB('82','2','32') = MAX(0.9*1.25*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))))), X74_UP);

UB('67','1','33') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('67','2','33') = 0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))));
UB('83','1','33') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('83','2','33') = LOG(1+(0.9*LOG(1+(0.75*1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));

UB('72','1','34') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('72','2','34') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('84','1','34') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))));
UB('84','2','34') = 0.7*LOG(1+(LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))));

UB('73','1','35') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('73','2','35') = LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))));
UB('76','1','35') = X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('76','2','35') = X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('85','1','35') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))), 0.65*LOG(1+X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));
UB('85','2','35') = MAX(0.65*LOG(1+LOG(1+(1.5*LOG(1+(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP)))))))))), 0.65*LOG(1+X75_UP + 0.9*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

UB('77','1','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('77','2','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('86','1','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('86','2','36') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

UB('78','1','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('78','2','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('87','1','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);
UB('87','2','37') = 0.6*MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP);

UB('79','1','38') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('79','2','38') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('88','1','38') = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));
UB('88','2','38') = 0.75*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

UB('80','1','39') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('80','2','39') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('89','1','39') = 0.8*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));
UB('89','2','39') = 0.8*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));

UB('81','1','40') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('81','2','40') = 1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP));
UB('90','1','40') = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));
UB('90','2','40') = 0.85*LOG(1+1.1*LOG(1+MAX(1.2*LOG(1+0.85*LOG(1+(1.1*LOG(1+MAX(1.2*LOG(1+X1_UP),0.5*X12_UP))))), 0.5*X57_UP)));



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

Disj1_Conv_Process1_Dis(S_P1_OUT)
Disj1_Conv_Process1_Dis_Lim
Disj1_Conv_Process2_Dis(S_P2_OUT)
Disj1_Conv_Process2_Dis_Lim
Disj1_Conv_Process3_Dis(S_P3_OUT)
Disj1_Conv_Process3_Dis_Lim
Disj1_Conv_Process4_Dis(S_P4_OUT)
Disj1_Conv_Process4_Dis_Lim
Disj1_Conv_Process5_Dis(S_P5_OUT)
Disj1_Conv_Process5_Dis_Lim
Disj1_Conv_Process6_Dis(S_P6_OUT)
Disj1_Conv_Process6_Dis_Lim
Disj1_Conv_Process7_Dis(S_P7_OUT)
Disj1_Conv_Process7_Dis_Lim
Disj1_Conv_Process8_Dis(S_P8_OUT)
Disj1_Conv_Process8_Dis_Lim

Disj1_Conv_Process1_Bnd(S_P1_OUT,M)
Disj1_Conv_Process2_Bnd(S_P2_OUT,M)
Disj1_Conv_Process3_Bnd(S_P3_OUT,M)
Disj1_Conv_Process4_Bnd(S_P4_OUT,M)
Disj1_Conv_Process5_Bnd(S_P5_OUT,M)
Disj1_Conv_Process6_Bnd(S_P6_OUT,M)
Disj1_Conv_Process7_Bnd(S_P7_OUT,M)
Disj1_Conv_Process8_Bnd(S_P8_OUT,M)

Disj1_Conv_Process1_Bnd_Lim(M)
Disj1_Conv_Process2_Bnd_Lim(M)
Disj1_Conv_Process3_Bnd_Lim(M)
Disj1_Conv_Process4_Bnd_Lim(M)
Disj1_Conv_Process5_Bnd_Lim(M)
Disj1_Conv_Process6_Bnd_Lim(M)
Disj1_Conv_Process7_Bnd_Lim(M)
Disj1_Conv_Process8_Bnd_Lim(M)

Disj1_Conv_Process1(S_P1_OUT,M)
Disj1_Conv_Process2(S_P2_OUT,M)
Disj1_Conv_Process3(S_P3_OUT,M)
Disj1_Conv_Process4(S_P4_OUT,M)
Disj1_Conv_Process5(S_P5_OUT,M)
Disj1_Conv_Process6(S_P6_OUT,M)
Disj1_Conv_Process7(S_P7_OUT,M)
Disj1_Conv_Process8(S_P8_OUT,M)

Disj1_Cap_Process1_Dis(S_P1_IN)
Disj1_Cap_Process2_Dis(S_P2_IN)
Disj1_Cap_Process3_Dis(S_P3_IN)
Disj1_Cap_Process4_Dis(S_P4_IN)
Disj1_Cap_Process5_Dis(S_P5_IN)
Disj1_Cap_Process6_Dis(S_P6_IN)
Disj1_Cap_Process7_Dis(S_P7_IN)
Disj1_Cap_Process8_Dis(S_P8_IN)

Disj1_Cap_Process1_Bnd(S_P1_IN,M)
Disj1_Cap_Process2_Bnd(S_P2_IN,M)
Disj1_Cap_Process3_Bnd(S_P3_IN,M)
Disj1_Cap_Process4_Bnd(S_P4_IN,M)
Disj1_Cap_Process5_Bnd(S_P5_IN,M)
Disj1_Cap_Process6_Bnd(S_P6_IN,M)
Disj1_Cap_Process7_Bnd(S_P7_IN,M)
Disj1_Cap_Process8_Bnd(S_P8_IN,M)

Disj1_Cap_Process1(M)
Disj1_Cap_Process2(M)
Disj1_Cap_Process3(M)
Disj1_Cap_Process4(M)
Disj1_Cap_Process5(M)
Disj1_Cap_Process6(M)
Disj1_Cap_Process7(M)
Disj1_Cap_Process8(M)

Disj2_Dis(P)

Disj2_Bnd(P,M)

Disj2(P,M)

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

DISJ_1_1_16
DISJ_1_2_16
DISJ_2_2_16
DISJ_1_3_16
DISJ_2_3_16
DISJ_1_4_16
DISJ_2_4_16
DISJ_3_4_16
DISJ_4_4_16

DISJ_1_1_17
DISJ_1_2_17
DISJ_2_2_17
DISJ_1_3_17
DISJ_2_3_17
DISJ_1_4_17
DISJ_2_4_17
DISJ_3_4_17
DISJ_4_4_17

DISJ_1_1_18
DISJ_1_2_18
DISJ_2_2_18
DISJ_1_3_18
DISJ_2_3_18
DISJ_1_4_18
DISJ_2_4_18
DISJ_3_4_18
DISJ_4_4_18

DISJ_1_1_19
DISJ_1_2_19
DISJ_2_2_19
DISJ_1_3_19
DISJ_2_3_19
DISJ_1_4_19
DISJ_2_4_19
DISJ_3_4_19
DISJ_4_4_19

DISJ_1_1_20
DISJ_1_2_20
DISJ_2_2_20
DISJ_1_3_20
DISJ_2_3_20
DISJ_1_4_20
DISJ_2_4_20
DISJ_3_4_20
DISJ_4_4_20

DISJ_1_1_21
DISJ_1_2_21
DISJ_2_2_21
DISJ_1_3_21
DISJ_2_3_21
DISJ_1_4_21
DISJ_2_4_21
DISJ_3_4_21
DISJ_4_4_21

DISJ_1_1_22
DISJ_1_2_22
DISJ_2_2_22
DISJ_1_3_22
DISJ_2_3_22
DISJ_1_4_22
DISJ_2_4_22
DISJ_3_4_22
DISJ_4_4_22

DISJ_1_1_23
DISJ_1_2_23
DISJ_2_2_23
DISJ_1_3_23
DISJ_2_3_23
DISJ_1_4_23
DISJ_2_4_23
DISJ_3_4_23
DISJ_4_4_23

DISJ_1_1_24
DISJ_1_2_24
DISJ_2_2_24
DISJ_1_3_24
DISJ_2_3_24
DISJ_1_4_24
DISJ_2_4_24
DISJ_3_4_24
DISJ_4_4_24

DISJ_1_1_25
DISJ_2_1_25
DISJ_1_2_25
DISJ_2_2_25
DISJ_3_2_25
DISJ_1_3_25
DISJ_2_3_25
DISJ_3_3_25
DISJ_1_4_25
DISJ_2_4_25
DISJ_3_4_25
DISJ_4_4_25
DISJ_5_4_25
DISJ_6_4_25

DISJ_1_1_26
DISJ_1_2_26
DISJ_2_2_26
DISJ_1_3_26
DISJ_2_3_26
DISJ_1_4_26
DISJ_2_4_26
DISJ_3_4_26
DISJ_4_4_26

DISJ_1_1_27
DISJ_1_2_27
DISJ_2_2_27
DISJ_1_3_27
DISJ_2_3_27
DISJ_1_4_27
DISJ_2_4_27
DISJ_3_4_27
DISJ_4_4_27

DISJ_1_1_28
DISJ_1_2_28
DISJ_2_2_28
DISJ_1_3_28
DISJ_2_3_28
DISJ_1_4_28
DISJ_2_4_28
DISJ_3_4_28
DISJ_4_4_28

DISJ_1_1_29
DISJ_1_2_29
DISJ_2_2_29
DISJ_1_3_29
DISJ_2_3_29
DISJ_1_4_29
DISJ_2_4_29
DISJ_3_4_29
DISJ_4_4_29

DISJ_1_1_30
DISJ_1_2_30
DISJ_2_2_30
DISJ_1_3_30
DISJ_2_3_30
DISJ_1_4_30
DISJ_2_4_30
DISJ_3_4_30
DISJ_4_4_30

DISJ_1_1_31
DISJ_1_2_31
DISJ_2_2_31
DISJ_1_3_31
DISJ_2_3_31
DISJ_1_4_31
DISJ_2_4_31
DISJ_3_4_31
DISJ_4_4_31

DISJ_1_1_32
DISJ_2_1_32
DISJ_1_2_32
DISJ_2_2_32
DISJ_3_2_32
DISJ_1_3_32
DISJ_2_3_32
DISJ_3_3_32
DISJ_1_4_32
DISJ_2_4_32
DISJ_3_4_32
DISJ_4_4_32
DISJ_5_4_32
DISJ_6_4_32

DISJ_1_1_33
DISJ_1_2_33
DISJ_2_2_33
DISJ_1_3_33
DISJ_2_3_33
DISJ_1_4_33
DISJ_2_4_33
DISJ_3_4_33
DISJ_4_4_33

DISJ_1_1_34
DISJ_1_2_34
DISJ_2_2_34
DISJ_1_3_34
DISJ_2_3_34
DISJ_1_4_34
DISJ_2_4_34
DISJ_3_4_34
DISJ_4_4_34

DISJ_1_1_35
DISJ_2_1_35
DISJ_1_2_35
DISJ_2_2_35
DISJ_3_2_35
DISJ_1_3_35
DISJ_2_3_35
DISJ_3_3_35
DISJ_1_4_35
DISJ_2_4_35
DISJ_3_4_35
DISJ_4_4_35
DISJ_5_4_35
DISJ_6_4_35

DISJ_1_1_36
DISJ_1_2_36
DISJ_2_2_36
DISJ_1_3_36
DISJ_2_3_36
DISJ_1_4_36
DISJ_2_4_36
DISJ_3_4_36
DISJ_4_4_36

DISJ_1_1_37
DISJ_1_2_37
DISJ_2_2_37
DISJ_1_3_37
DISJ_2_3_37
DISJ_1_4_37
DISJ_2_4_37
DISJ_3_4_37
DISJ_4_4_37

DISJ_1_1_38
DISJ_1_2_38
DISJ_2_2_38
DISJ_1_3_38
DISJ_2_3_38
DISJ_1_4_38
DISJ_2_4_38
DISJ_3_4_38
DISJ_4_4_38

DISJ_1_1_39
DISJ_1_2_39
DISJ_2_2_39
DISJ_1_3_39
DISJ_2_3_39
DISJ_1_4_39
DISJ_2_4_39
DISJ_3_4_39
DISJ_4_4_39

DISJ_1_1_40
DISJ_1_2_40
DISJ_2_2_40
DISJ_1_3_40
DISJ_2_3_40
DISJ_1_4_40
DISJ_2_4_40
DISJ_3_4_40
DISJ_4_4_40

D1,
L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L20
L21,L22,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54;

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

*Disaggregated variables for conversion
Disj1_Conv_Process1_Dis(S_P1_OUT).. f(S_P1_OUT) =E= SUM(M,zf(S_P1_OUT,M));
Disj1_Conv_Process1_Dis_Lim..      f('2') =E= SUM(M,zf('2',M));
Disj1_Conv_Process2_Dis(S_P2_OUT).. f(S_P2_OUT) =E= SUM(M,zf(S_P2_OUT,M));
Disj1_Conv_Process2_Dis_Lim..      f('3') =E= SUM(M,zf('3',M));
Disj1_Conv_Process3_Dis(S_P3_OUT).. f(S_P3_OUT) =E= SUM(M,zf(S_P3_OUT,M));
Disj1_Conv_Process3_Dis_Lim..      f('11') =E= SUM(M,zf('11',M));
Disj1_Conv_Process4_Dis(S_P4_OUT).. f(S_P4_OUT) =E= SUM(M,zf(S_P4_OUT,M));
Disj1_Conv_Process4_Dis_Lim..      f('14') =E= SUM(M,zf('14',M));
Disj1_Conv_Process5_Dis(S_P5_OUT).. f(S_P5_OUT) =E= SUM(M,zf(S_P5_OUT,M));
Disj1_Conv_Process5_Dis_Lim..      f('17') =E= SUM(M,zf('17',M));
Disj1_Conv_Process6_Dis(S_P6_OUT).. f(S_P6_OUT) =E= SUM(M,zf(S_P6_OUT,M));
Disj1_Conv_Process6_Dis_Lim..      f('16') =E= SUM(M,zf('16',M));
Disj1_Conv_Process7_Dis(S_P7_OUT).. f(S_P7_OUT) =E= SUM(M,zf(S_P7_OUT,M));
Disj1_Conv_Process7_Dis_Lim..      f('24') =E= SUM(M,zf('24',M));
Disj1_Conv_Process8_Dis(S_P8_OUT).. f(S_P8_OUT) =E= SUM(M,zf(S_P8_OUT,M));
Disj1_Conv_Process8_Dis_Lim..      f('30') =E= SUM(M,zf('30',M));

*Bounds on disaggregated variables for conversion
Disj1_Conv_Process1_Bnd(S_P1_OUT,M).. zf(S_P1_OUT,M) =L= Bnd_Conv(S_P1_OUT,M)*y('1',M);
Disj1_Conv_Process2_Bnd(S_P2_OUT,M).. zf(S_P2_OUT,M) =L= Bnd_Conv(S_P2_OUT,M)*y('2',M);
Disj1_Conv_Process3_Bnd(S_P3_OUT,M).. zf(S_P3_OUT,M) =L= Bnd_Conv(S_P3_OUT,M)*y('3',M);
Disj1_Conv_Process4_Bnd(S_P4_OUT,M).. zf(S_P4_OUT,M) =L= Bnd_Conv(S_P4_OUT,M)*y('4',M);
Disj1_Conv_Process5_Bnd(S_P5_OUT,M).. zf(S_P5_OUT,M) =L= Bnd_Conv(S_P5_OUT,M)*y('5',M);
Disj1_Conv_Process6_Bnd(S_P6_OUT,M).. zf(S_P6_OUT,M) =L= Bnd_Conv(S_P6_OUT,M)*y('6',M);
Disj1_Conv_Process7_Bnd(S_P7_OUT,M).. zf(S_P7_OUT,M) =L= Bnd_Conv(S_P7_OUT,M)*y('7',M);
Disj1_Conv_Process8_Bnd(S_P8_OUT,M).. zf(S_P8_OUT,M) =L= Bnd_Conv(S_P8_OUT,M)*y('8',M);

Disj1_Conv_Process1_Bnd_Lim(M).. zf('2',M) =L= Bnd_Conv_Lim('2',M)*y('1',M);
Disj1_Conv_Process2_Bnd_Lim(M).. zf('3',M) =L= Bnd_Conv_Lim('3',M)*y('2',M);
Disj1_Conv_Process3_Bnd_Lim(M).. zf('11',M) =L= Bnd_Conv_Lim('11',M)*y('3',M);
Disj1_Conv_Process4_Bnd_Lim(M).. zf('14',M) =L= Bnd_Conv_Lim('14',M)*y('4',M);
Disj1_Conv_Process5_Bnd_Lim(M).. zf('17',M) =L= Bnd_Conv_Lim('17',M)*y('5',M);
Disj1_Conv_Process6_Bnd_Lim(M).. zf('16',M) =L= Bnd_Conv_Lim('16',M)*y('6',M);
Disj1_Conv_Process7_Bnd_Lim(M).. zf('24',M) =L= Bnd_Conv_Lim('24',M)*y('7',M);
Disj1_Conv_Process8_Bnd_Lim(M).. zf('30',M) =L= Bnd_Conv_Lim('30',M)*y('8',M);

*Constraints in disjuncts for conversion
Disj1_Conv_Process1(S_P1_OUT,M).. zf(S_P1_OUT,M) - zf('2',M)*(Gamma(S_P1_OUT)/Gamma('2'))*Eta('1',M) =E= 0*y('1',M);
Disj1_Conv_Process2(S_P2_OUT,M).. zf(S_P2_OUT,M) - zf('3',M)*(Gamma(S_P2_OUT)/Gamma('3'))*Eta('2',M) =E= 0*y('2',M);
Disj1_Conv_Process3(S_P3_OUT,M).. zf(S_P3_OUT,M) - zf('11',M)*(Gamma(S_P3_OUT)/Gamma('11'))*Eta('3',M) =E= 0*y('3',M);
Disj1_Conv_Process4(S_P4_OUT,M).. zf(S_P4_OUT,M) - zf('14',M)*(Gamma(S_P4_OUT)/Gamma('14'))*Eta('4',M) =E= 0*y('4',M);
Disj1_Conv_Process5(S_P5_OUT,M).. zf(S_P5_OUT,M) - zf('17',M)*(Gamma(S_P5_OUT)/Gamma('17'))*Eta('5',M) =E= 0*y('5',M);
Disj1_Conv_Process6(S_P6_OUT,M).. zf(S_P6_OUT,M) - zf('16',M)*(Gamma(S_P6_OUT)/Gamma('16'))*Eta('6',M) =E= 0*y('6',M);
Disj1_Conv_Process7(S_P7_OUT,M).. zf(S_P7_OUT,M) - zf('24',M)*(Gamma(S_P7_OUT)/Gamma('24'))*Eta('7',M) =E= 0*y('7',M);
Disj1_Conv_Process8(S_P8_OUT,M).. zf(S_P8_OUT,M) - zf('30',M)*(Gamma(S_P8_OUT)/Gamma('30'))*Eta('8',M) =E= 0*y('8',M);

*Disaggregated variables for capacity
Disj1_Cap_Process1_Dis(S_P1_IN).. mf(S_P1_IN) =E= SUM(M,zmf(S_P1_IN,M));
Disj1_Cap_Process2_Dis(S_P2_IN).. mf(S_P2_IN) =E= SUM(M,zmf(S_P2_IN,M));
Disj1_Cap_Process3_Dis(S_P3_IN).. mf(S_P3_IN) =E= SUM(M,zmf(S_P3_IN,M));
Disj1_Cap_Process4_Dis(S_P4_IN).. mf(S_P4_IN) =E= SUM(M,zmf(S_P4_IN,M));
Disj1_Cap_Process5_Dis(S_P5_IN).. mf(S_P5_IN) =E= SUM(M,zmf(S_P5_IN,M));
Disj1_Cap_Process6_Dis(S_P6_IN).. mf(S_P6_IN) =E= SUM(M,zmf(S_P6_IN,M));
Disj1_Cap_Process7_Dis(S_P7_IN).. mf(S_P7_IN) =E= SUM(M,zmf(S_P7_IN,M));
Disj1_Cap_Process8_Dis(S_P8_IN).. mf(S_P8_IN) =E= SUM(M,zmf(S_P8_IN,M));

*Bounds on disaggregated variables for capacity
Disj1_Cap_Process1_Bnd(S_P1_IN,M).. zmf(S_P1_IN,M) =L= Bnd_Cap(S_P1_IN,M)*y('1',M);
Disj1_Cap_Process2_Bnd(S_P2_IN,M).. zmf(S_P2_IN,M) =L= Bnd_Cap(S_P2_IN,M)*y('2',M);
Disj1_Cap_Process3_Bnd(S_P3_IN,M).. zmf(S_P3_IN,M) =L= Bnd_Cap(S_P3_IN,M)*y('3',M);
Disj1_Cap_Process4_Bnd(S_P4_IN,M).. zmf(S_P4_IN,M) =L= Bnd_Cap(S_P4_IN,M)*y('4',M);
Disj1_Cap_Process5_Bnd(S_P5_IN,M).. zmf(S_P5_IN,M) =L= Bnd_Cap(S_P5_IN,M)*y('5',M);
Disj1_Cap_Process6_Bnd(S_P6_IN,M).. zmf(S_P6_IN,M) =L= Bnd_Cap(S_P6_IN,M)*y('6',M);
Disj1_Cap_Process7_Bnd(S_P7_IN,M).. zmf(S_P7_IN,M) =L= Bnd_Cap(S_P7_IN,M)*y('7',M);
Disj1_Cap_Process8_Bnd(S_P8_IN,M).. zmf(S_P8_IN,M) =L= Bnd_Cap(S_P8_IN,M)*y('8',M);

*Constraints in disjuncts for capacity
Disj1_Cap_Process1(M).. SUM(S_P1_IN,zmf(S_P1_IN,M)) =L= Cap('1',M)*y('1',M);
Disj1_Cap_Process2(M).. SUM(S_P2_IN,zmf(S_P2_IN,M)) =L= Cap('2',M)*y('2',M);
Disj1_Cap_Process3(M).. SUM(S_P3_IN,zmf(S_P3_IN,M)) =L= Cap('3',M)*y('3',M);
Disj1_Cap_Process4(M).. SUM(S_P4_IN,zmf(S_P4_IN,M)) =L= Cap('4',M)*y('4',M);
Disj1_Cap_Process5(M).. SUM(S_P5_IN,zmf(S_P5_IN,M)) =L= Cap('5',M)*y('5',M);
Disj1_Cap_Process6(M).. SUM(S_P6_IN,zmf(S_P6_IN,M)) =L= Cap('6',M)*y('6',M);
Disj1_Cap_Process7(M).. SUM(S_P7_IN,zmf(S_P7_IN,M)) =L= Cap('7',M)*y('7',M);
Disj1_Cap_Process8(M).. SUM(S_P8_IN,zmf(S_P8_IN,M)) =L= Cap('8',M)*y('8',M);
*****************

*****************
*Disjunction 2 constraints

*Disaggregated variables
Disj2_Dis(P).. convcapcost(P) =E= SUM(M,zconvcapcost(P,M));

*Bounds on disaggregated variables
Disj2_Bnd(P,M).. zconvcapcost(P,M) =L= Bnd_ConvCapCost(P,M)*y(P,M);

*Constraints in disjuncts
Disj2(P,M).. zconvcapcost(P,M) =E= FixedCost_ConvCap(P,M)*y(P,M);
*****************

LimitingCost..   SUM(P,convcapcost(P)) + SUM(S_RAW,Price_Raw(S_RAW)*mf(S_RAW)) =L= InvestmentLimit;

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
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in Sawaya & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

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

DISJ_1_1_16.. V('41','1','16') - V('32','1','16') =E= 0;
DISJ_1_2_16.. V('32','2','16') =E= 0;
DISJ_2_2_16.. V('41','2','16') =E= 0;
DISJ_1_3_16.. X('32') =E= SUM(D,V('32',D,'16'));
DISJ_2_3_16.. X('41') =E= SUM(D,V('41',D,'16'));
DISJ_1_4_16.. V('32','1','16') =L= UB('32','1','16')*Z('16');
DISJ_2_4_16.. V('32','2','16') =L= UB('32','2','16')*(1-Z('16'));
DISJ_3_4_16.. V('41','1','16') =L= UB('41','1','16')*Z('16');
DISJ_4_4_16.. V('41','2','16') =L= UB('41','2','16')*(1-Z('16'));

DISJ_1_1_17.. V('42','1','17') - V('33','1','17') =E= 0;
DISJ_1_2_17.. V('33','2','17') =E= 0;
DISJ_2_2_17.. V('42','2','17') =E= 0;
DISJ_1_3_17.. X('33') =E= SUM(D,V('33',D,'17'));
DISJ_2_3_17.. X('42') =E= SUM(D,V('42',D,'17'));
DISJ_1_4_17.. V('33','1','17') =L= UB('33','1','17')*Z('17');
DISJ_2_4_17.. V('33','2','17') =L= UB('33','2','17')*(1-Z('17'));
DISJ_3_4_17.. V('42','1','17') =L= UB('42','1','17')*Z('17');
DISJ_4_4_17.. V('42','2','17') =L= UB('42','2','17')*(1-Z('17'));

*DISJ_1_1_18.. (Z('18')+ES)*(V('43','1','18')/(Z('18')+ES) - 0.75*LOG(1+V('34','1','18')/(Z('18')+ES))) =L= 0;
positive variable X_DISJ_1_1_18, Y_DISJ_1_1_18, W_DISJ_1_1_18;
X_DISJ_1_1_18.up = UB('43','1','18')/(0.75*1);
W_DISJ_1_1_18.up = UB('43','1','18')/(0.75*1);
Y_DISJ_1_1_18.up = exp(UB('43','1','18')/(0.75*1));
equation d_DISJ_1_1_18;
equation a_DISJ_1_1_18, b_DISJ_1_1_18, c_DISJ_1_1_18;
equation e_DISJ_1_1_18, f_DISJ_1_1_18, g_DISJ_1_1_18;
DISJ_1_1_18.. Z('18')+V('34','1','18') =G= Y_DISJ_1_1_18;
d_DISJ_1_1_18.. 0.75*W_DISJ_1_1_18 =G= V('43','1','18');
a_DISJ_1_1_18.. Y_DISJ_1_1_18 =G= Z('18');
b_DISJ_1_1_18.. Y_DISJ_1_1_18 =L= Z('18')*exp(UB('43','1','18')/(0.75*1));
c_DISJ_1_1_18.. Y_DISJ_1_1_18 =G= exp(X_DISJ_1_1_18) - (1-Z('18'));
e_DISJ_1_1_18.. 0.75*W_DISJ_1_1_18 =L= Z('18')*UB('43','1','18');
f_DISJ_1_1_18.. 0.75*W_DISJ_1_1_18 =G= 0.75*X_DISJ_1_1_18 - (1-Z('18'))*UB('43','1','18');
g_DISJ_1_1_18.. W_DISJ_1_1_18 =L= X_DISJ_1_1_18;
DISJ_1_2_18.. V('34','2','18') =E= 0;
DISJ_2_2_18.. V('43','2','18') =E= 0;
DISJ_1_3_18.. X('34') =E= SUM(D,V('34',D,'18'));
DISJ_2_3_18.. X('43') =E= SUM(D,V('43',D,'18'));
DISJ_1_4_18.. V('34','1','18') =L= UB('34','1','18')*Z('18');
DISJ_2_4_18.. V('34','2','18') =L= UB('34','2','18')*(1-Z('18'));
DISJ_3_4_18.. V('43','1','18') =L= UB('43','1','18')*Z('18');
DISJ_4_4_18.. V('43','2','18') =L= UB('43','2','18')*(1-Z('18'));

*DISJ_1_1_19.. (Z('19')+ES)*(V('44','1','19')/(Z('19')+ES) - 0.8*LOG(1+V('35','1','19')/(Z('19')+ES))) =L= 0;
positive variable X_DISJ_1_1_19, Y_DISJ_1_1_19, W_DISJ_1_1_19;
X_DISJ_1_1_19.up = UB('44','1','19')/(0.8*1);
W_DISJ_1_1_19.up = UB('44','1','19')/(0.8*1);
Y_DISJ_1_1_19.up = exp(UB('44','1','19')/(0.8*1));
equation d_DISJ_1_1_19;
equation a_DISJ_1_1_19, b_DISJ_1_1_19, c_DISJ_1_1_19;
equation e_DISJ_1_1_19, f_DISJ_1_1_19, g_DISJ_1_1_19;
DISJ_1_1_19.. Z('19')+V('35','1','19') =G= Y_DISJ_1_1_19;
d_DISJ_1_1_19.. 0.8*W_DISJ_1_1_19 =G= V('44','1','19');
a_DISJ_1_1_19.. Y_DISJ_1_1_19 =G= Z('19');
b_DISJ_1_1_19.. Y_DISJ_1_1_19 =L= Z('19')*exp(UB('44','1','19')/(0.8*1));
c_DISJ_1_1_19.. Y_DISJ_1_1_19 =G= exp(X_DISJ_1_1_19) - (1-Z('19'));
e_DISJ_1_1_19.. 0.8*W_DISJ_1_1_19 =L= Z('19')*UB('44','1','19');
f_DISJ_1_1_19.. 0.8*W_DISJ_1_1_19 =G= 0.8*X_DISJ_1_1_19 - (1-Z('19'))*UB('44','1','19');
g_DISJ_1_1_19.. W_DISJ_1_1_19 =L= X_DISJ_1_1_19;
DISJ_1_2_19.. V('35','2','19') =E= 0;
DISJ_2_2_19.. V('44','2','19') =E= 0;
DISJ_1_3_19.. X('35') =E= SUM(D,V('35',D,'19'));
DISJ_2_3_19.. X('44') =E= SUM(D,V('44',D,'19'));
DISJ_1_4_19.. V('35','1','19') =L= UB('35','1','19')*Z('19');
DISJ_2_4_19.. V('35','2','19') =L= UB('35','2','19')*(1-Z('19'));
DISJ_3_4_19.. V('44','1','19') =L= UB('44','1','19')*Z('19');
DISJ_4_4_19.. V('44','2','19') =L= UB('44','2','19')*(1-Z('19'));

*DISJ_1_1_20.. (Z('20')+ES)*(V('45','1','20')/(Z('20')+ES) - 0.85*LOG(1+V('36','1','20')/(Z('20')+ES))) =L= 0;
positive variable X_DISJ_1_1_20, Y_DISJ_1_1_20, W_DISJ_1_1_20;
X_DISJ_1_1_20.up = UB('45','1','20')/(0.85*1);
W_DISJ_1_1_20.up = UB('45','1','20')/(0.85*1);
Y_DISJ_1_1_20.up = exp(UB('45','1','20')/(0.85*1));
equation d_DISJ_1_1_20;
equation a_DISJ_1_1_20, b_DISJ_1_1_20, c_DISJ_1_1_20;
equation e_DISJ_1_1_20, f_DISJ_1_1_20, g_DISJ_1_1_20;
DISJ_1_1_20.. Z('20')+V('36','1','20') =G= Y_DISJ_1_1_20;
d_DISJ_1_1_20.. 0.85*W_DISJ_1_1_20 =G= V('45','1','20');
a_DISJ_1_1_20.. Y_DISJ_1_1_20 =G= Z('20');
b_DISJ_1_1_20.. Y_DISJ_1_1_20 =L= Z('20')*exp(UB('45','1','20')/(0.85*1));
c_DISJ_1_1_20.. Y_DISJ_1_1_20 =G= exp(X_DISJ_1_1_20) - (1-Z('20'));
e_DISJ_1_1_20.. 0.85*W_DISJ_1_1_20 =L= Z('20')*UB('45','1','20');
f_DISJ_1_1_20.. 0.85*W_DISJ_1_1_20 =G= 0.85*X_DISJ_1_1_20 - (1-Z('20'))*UB('45','1','20');
g_DISJ_1_1_20.. W_DISJ_1_1_20 =L= X_DISJ_1_1_20;
DISJ_1_2_20.. V('36','2','20') =E= 0;
DISJ_2_2_20.. V('45','2','20') =E= 0;
DISJ_1_3_20.. X('36') =E= SUM(D,V('36',D,'20'));
DISJ_2_3_20.. X('45') =E= SUM(D,V('45',D,'20'));
DISJ_1_4_20.. V('36','1','20') =L= UB('36','1','20')*Z('20');
DISJ_2_4_20.. V('36','2','20') =L= UB('36','2','20')*(1-Z('20'));
DISJ_3_4_20.. V('45','1','20') =L= UB('45','1','20')*Z('20');
DISJ_4_4_20.. V('45','2','20') =L= UB('45','2','20')*(1-Z('20'));

*Form of disjunctions 21-30 is the same as that of first 20 disjunctions
*DISJ_1_1_21.. (Z('21')+ES)*(V('49','1','21')/(Z('21')+ES) - LOG(1+V('47','1','21')/(Z('21')+ES))) =L= 0;
positive variable X_DISJ_1_1_21, Y_DISJ_1_1_21, W_DISJ_1_1_21;
X_DISJ_1_1_21.up = UB('49','1','21')/(1*1);
W_DISJ_1_1_21.up = UB('49','1','21')/(1*1);
Y_DISJ_1_1_21.up = exp(UB('49','1','21')/(1*1));
equation d_DISJ_1_1_21;
equation a_DISJ_1_1_21, b_DISJ_1_1_21, c_DISJ_1_1_21;
equation e_DISJ_1_1_21, f_DISJ_1_1_21, g_DISJ_1_1_21;
DISJ_1_1_21.. Z('21')+V('47','1','21') =G= Y_DISJ_1_1_21;
d_DISJ_1_1_21.. 1*W_DISJ_1_1_21 =G= V('49','1','21');
a_DISJ_1_1_21.. Y_DISJ_1_1_21 =G= Z('21');
b_DISJ_1_1_21.. Y_DISJ_1_1_21 =L= Z('21')*exp(UB('49','1','21')/(1*1));
c_DISJ_1_1_21.. Y_DISJ_1_1_21 =G= exp(X_DISJ_1_1_21) - (1-Z('21'));
e_DISJ_1_1_21.. 1*W_DISJ_1_1_21 =L= Z('21')*UB('49','1','21');
f_DISJ_1_1_21.. 1*W_DISJ_1_1_21 =G= 1*X_DISJ_1_1_21 - (1-Z('21'))*UB('49','1','21');
g_DISJ_1_1_21.. W_DISJ_1_1_21 =L= X_DISJ_1_1_21;
DISJ_1_2_21.. V('47','2','21') =E= 0;
DISJ_2_2_21.. V('49','2','21') =E= 0;
DISJ_1_3_21.. X('47') =E= SUM(D,V('47',D,'21'));
DISJ_2_3_21.. X('49') =E= SUM(D,V('49',D,'21'));
DISJ_1_4_21.. V('47','1','21') =L= UB('47','1','21')*Z('21');
DISJ_2_4_21.. V('47','2','21') =L= UB('47','2','21')*(1-Z('21'));
DISJ_3_4_21.. V('49','1','21') =L= UB('49','1','21')*Z('21');
DISJ_4_4_21.. V('49','2','21') =L= UB('49','2','21')*(1-Z('21'));

*DISJ_1_1_22.. (Z('22')+ES)*(V('50','1','22')/(Z('22')+ES) - 1.2*LOG(1+V('48','1','22')/(Z('22')+ES))) =L= 0;
positive variable X_DISJ_1_1_22, Y_DISJ_1_1_22, W_DISJ_1_1_22;
X_DISJ_1_1_22.up = UB('50','1','22')/(1.2*1);
W_DISJ_1_1_22.up = UB('50','1','22')/(1.2*1);
Y_DISJ_1_1_22.up = exp(UB('50','1','22')/(1.2*1));
equation d_DISJ_1_1_22;
equation a_DISJ_1_1_22, b_DISJ_1_1_22, c_DISJ_1_1_22;
equation e_DISJ_1_1_22, f_DISJ_1_1_22, g_DISJ_1_1_22;
DISJ_1_1_22.. Z('22')+V('48','1','22') =G= Y_DISJ_1_1_22;
d_DISJ_1_1_22.. 1.2*W_DISJ_1_1_22 =G= V('50','1','22');
a_DISJ_1_1_22.. Y_DISJ_1_1_22 =G= Z('22');
b_DISJ_1_1_22.. Y_DISJ_1_1_22 =L= Z('22')*exp(UB('50','1','22')/(1.2*1));
c_DISJ_1_1_22.. Y_DISJ_1_1_22 =G= exp(X_DISJ_1_1_22) - (1-Z('22'));
e_DISJ_1_1_22.. 1.2*W_DISJ_1_1_22 =L= Z('22')*UB('50','1','22');
f_DISJ_1_1_22.. 1.2*W_DISJ_1_1_22 =G= 1.2*X_DISJ_1_1_22 - (1-Z('22'))*UB('50','1','22');
g_DISJ_1_1_22.. W_DISJ_1_1_22 =L= X_DISJ_1_1_22;
DISJ_1_2_22.. V('48','2','22') =E= 0;
DISJ_2_2_22.. V('50','2','22') =E= 0;
DISJ_1_3_22.. X('48') =E= SUM(D,V('48',D,'22'));
DISJ_2_3_22.. X('50') =E= SUM(D,V('50',D,'22'));
DISJ_1_4_22.. V('48','1','22') =L= UB('48','1','22')*Z('22');
DISJ_2_4_22.. V('48','2','22') =L= UB('48','2','22')*(1-Z('22'));
DISJ_3_4_22.. V('50','1','22') =L= UB('50','1','22')*Z('22');
DISJ_4_4_22.. V('50','2','22') =L= UB('50','2','22')*(1-Z('22'));

DISJ_1_1_23.. V('58','1','23') - 0.75*V('54','1','23') =E= 0;
DISJ_1_2_23.. V('54','2','23') =E= 0;
DISJ_2_2_23.. V('58','2','23') =E= 0;
DISJ_1_3_23.. X('54') =E= SUM(D,V('54',D,'23'));
DISJ_2_3_23.. X('58') =E= SUM(D,V('58',D,'23'));
DISJ_1_4_23.. V('54','1','23') =L= UB('54','1','23')*Z('23');
DISJ_2_4_23.. V('54','2','23') =L= UB('54','2','23')*(1-Z('23'));
DISJ_3_4_23.. V('58','1','23') =L= UB('58','1','23')*Z('23');
DISJ_4_4_23.. V('58','2','23') =L= UB('58','2','23')*(1-Z('23'));

*DISJ_1_1_24.. (Z('24')+ES)*(V('59','1','24')/(Z('24')+ES) - 1.5*LOG(1+V('55','1','24')/(Z('24')+ES))) =L= 0;
positive variable X_DISJ_1_1_24, Y_DISJ_1_1_24, W_DISJ_1_1_24;
X_DISJ_1_1_24.up = UB('59','1','24')/(1.5*1);
W_DISJ_1_1_24.up = UB('59','1','24')/(1.5*1);
Y_DISJ_1_1_24.up = exp(UB('59','1','24')/(1.5*1));
equation d_DISJ_1_1_24;
equation a_DISJ_1_1_24, b_DISJ_1_1_24, c_DISJ_1_1_24;
equation e_DISJ_1_1_24, f_DISJ_1_1_24, g_DISJ_1_1_24;
DISJ_1_1_24.. Z('24')+V('55','1','24') =G= Y_DISJ_1_1_24;
d_DISJ_1_1_24.. 1.5*W_DISJ_1_1_24 =G= V('59','1','24');
a_DISJ_1_1_24.. Y_DISJ_1_1_24 =G= Z('24');
b_DISJ_1_1_24.. Y_DISJ_1_1_24 =L= Z('24')*exp(UB('59','1','24')/(1.5*1));
c_DISJ_1_1_24.. Y_DISJ_1_1_24 =G= exp(X_DISJ_1_1_24) - (1-Z('24'));
e_DISJ_1_1_24.. 1.5*W_DISJ_1_1_24 =L= Z('24')*UB('59','1','24');
f_DISJ_1_1_24.. 1.5*W_DISJ_1_1_24 =G= 1.5*X_DISJ_1_1_24 - (1-Z('24'))*UB('59','1','24');
g_DISJ_1_1_24.. W_DISJ_1_1_24 =L= X_DISJ_1_1_24;
DISJ_1_2_24.. V('55','2','24') =E= 0;
DISJ_2_2_24.. V('59','2','24') =E= 0;
DISJ_1_3_24.. X('55') =E= SUM(D,V('55',D,'24'));
DISJ_2_3_24.. X('59') =E= SUM(D,V('59',D,'24'));
DISJ_1_4_24.. V('55','1','24') =L= UB('55','1','24')*Z('24');
DISJ_2_4_24.. V('55','2','24') =L= UB('55','2','24')*(1-Z('24'));
DISJ_3_4_24.. V('59','1','24') =L= UB('59','1','24')*Z('24');
DISJ_4_4_24.. V('59','2','24') =L= UB('59','2','24')*(1-Z('24'));

DISJ_1_1_25.. V('60','1','25') - V('56','1','25') =E= 0;
DISJ_2_1_25.. V('60','1','25') - 0.5*V('57','1','25') =E= 0;
DISJ_1_2_25.. V('56','2','25') =E= 0;
DISJ_2_2_25.. V('57','2','25') =E= 0;
DISJ_3_2_25.. V('60','2','25') =E= 0;
DISJ_1_3_25.. X('56') =E= SUM(D,V('56',D,'25'));
DISJ_2_3_25.. X('57') =E= SUM(D,V('57',D,'25'));
DISJ_3_3_25.. X('60') =E= SUM(D,V('60',D,'25'));
DISJ_1_4_25.. V('56','1','25') =L= UB('56','1','25')*Z('25');
DISJ_2_4_25.. V('56','2','25') =L= UB('56','2','25')*(1-Z('25'));
DISJ_3_4_25.. V('57','1','25') =L= UB('57','1','25')*Z('25');
DISJ_4_4_25.. V('57','2','25') =L= UB('57','2','25')*(1-Z('25'));
DISJ_5_4_25.. V('60','1','25') =L= UB('60','1','25')*Z('25');
DISJ_6_4_25.. V('60','2','25') =L= UB('60','2','25')*(1-Z('25'));

*DISJ_1_1_26.. (Z('26')+ES)*(V('66','1','26')/(Z('26')+ES) - 1.25*LOG(1+V('61','1','26')/(Z('26')+ES))) =L= 0;
positive variable X_DISJ_1_1_26, Y_DISJ_1_1_26, W_DISJ_1_1_26;
X_DISJ_1_1_26.up = UB('66','1','26')/(1.25*1);
W_DISJ_1_1_26.up = UB('66','1','26')/(1.25*1);
Y_DISJ_1_1_26.up = exp(UB('66','1','26')/(1.25*1));
equation d_DISJ_1_1_26;
equation a_DISJ_1_1_26, b_DISJ_1_1_26, c_DISJ_1_1_26;
equation e_DISJ_1_1_26, f_DISJ_1_1_26, g_DISJ_1_1_26;
DISJ_1_1_26.. Z('26')+V('61','1','26') =G= Y_DISJ_1_1_26;
d_DISJ_1_1_26.. 1.25*W_DISJ_1_1_26 =G= V('66','1','26');
a_DISJ_1_1_26.. Y_DISJ_1_1_26 =G= Z('26');
b_DISJ_1_1_26.. Y_DISJ_1_1_26 =L= Z('26')*exp(UB('66','1','26')/(1.25*1));
c_DISJ_1_1_26.. Y_DISJ_1_1_26 =G= exp(X_DISJ_1_1_26) - (1-Z('26'));
e_DISJ_1_1_26.. 1.25*W_DISJ_1_1_26 =L= Z('26')*UB('66','1','26');
f_DISJ_1_1_26.. 1.25*W_DISJ_1_1_26 =G= 1.25*X_DISJ_1_1_26 - (1-Z('26'))*UB('66','1','26');
g_DISJ_1_1_26.. W_DISJ_1_1_26 =L= X_DISJ_1_1_26;
DISJ_1_2_26.. V('61','2','26') =E= 0;
DISJ_2_2_26.. V('66','2','26') =E= 0;
DISJ_1_3_26.. X('61') =E= SUM(D,V('61',D,'26'));
DISJ_2_3_26.. X('66') =E= SUM(D,V('66',D,'26'));
DISJ_1_4_26.. V('61','1','26') =L= UB('61','1','26')*Z('26');
DISJ_2_4_26.. V('61','2','26') =L= UB('61','2','26')*(1-Z('26'));
DISJ_3_4_26.. V('66','1','26') =L= UB('66','1','26')*Z('26');
DISJ_4_4_26.. V('66','2','26') =L= UB('66','2','26')*(1-Z('26'));

*DISJ_1_1_27.. (Z('27')+ES)*(V('67','1','27')/(Z('27')+ES) - 0.9*LOG(1+V('62','1','27')/(Z('27')+ES))) =L= 0;
positive variable X_DISJ_1_1_27, Y_DISJ_1_1_27, W_DISJ_1_1_27;
X_DISJ_1_1_27.up = UB('67','1','27')/(0.9*1);
W_DISJ_1_1_27.up = UB('67','1','27')/(0.9*1);
Y_DISJ_1_1_27.up = exp(UB('67','1','27')/(0.9*1));
equation d_DISJ_1_1_27;
equation a_DISJ_1_1_27, b_DISJ_1_1_27, c_DISJ_1_1_27;
equation e_DISJ_1_1_27, f_DISJ_1_1_27, g_DISJ_1_1_27;
DISJ_1_1_27.. Z('27')+V('62','1','27') =G= Y_DISJ_1_1_27;
d_DISJ_1_1_27.. 0.9*W_DISJ_1_1_27 =G= V('67','1','27');
a_DISJ_1_1_27.. Y_DISJ_1_1_27 =G= Z('27');
b_DISJ_1_1_27.. Y_DISJ_1_1_27 =L= Z('27')*exp(UB('67','1','27')/(0.9*1));
c_DISJ_1_1_27.. Y_DISJ_1_1_27 =G= exp(X_DISJ_1_1_27) - (1-Z('27'));
e_DISJ_1_1_27.. 0.9*W_DISJ_1_1_27 =L= Z('27')*UB('67','1','27');
f_DISJ_1_1_27.. 0.9*W_DISJ_1_1_27 =G= 0.9*X_DISJ_1_1_27 - (1-Z('27'))*UB('67','1','27');
g_DISJ_1_1_27.. W_DISJ_1_1_27 =L= X_DISJ_1_1_27;
DISJ_1_2_27.. V('62','2','27') =E= 0;
DISJ_2_2_27.. V('67','2','27') =E= 0;
DISJ_1_3_27.. X('62') =E= SUM(D,V('62',D,'27'));
DISJ_2_3_27.. X('67') =E= SUM(D,V('67',D,'27'));
DISJ_1_4_27.. V('62','1','27') =L= UB('62','1','27')*Z('27');
DISJ_2_4_27.. V('62','2','27') =L= UB('62','2','27')*(1-Z('27'));
DISJ_3_4_27.. V('67','1','27') =L= UB('67','1','27')*Z('27');
DISJ_4_4_27.. V('67','2','27') =L= UB('67','2','27')*(1-Z('27'));

*DISJ_1_1_28.. (Z('28')+ES)*(V('68','1','28')/(Z('28')+ES) - LOG(1+V('59','1','28')/(Z('28')+ES))) =L= 0;
positive variable X_DISJ_1_1_28, Y_DISJ_1_1_28, W_DISJ_1_1_28;
X_DISJ_1_1_28.up = UB('68','1','28')/(1*1);
W_DISJ_1_1_28.up = UB('68','1','28')/(1*1);
Y_DISJ_1_1_28.up = exp(UB('68','1','28')/(1*1));
equation d_DISJ_1_1_28;
equation a_DISJ_1_1_28, b_DISJ_1_1_28, c_DISJ_1_1_28;
equation e_DISJ_1_1_28, f_DISJ_1_1_28, g_DISJ_1_1_28;
DISJ_1_1_28.. Z('28')+V('59','1','28') =G= Y_DISJ_1_1_28;
d_DISJ_1_1_28.. 1*W_DISJ_1_1_28 =G= V('68','1','28');
a_DISJ_1_1_28.. Y_DISJ_1_1_28 =G= Z('28');
b_DISJ_1_1_28.. Y_DISJ_1_1_28 =L= Z('28')*exp(UB('68','1','28')/(1*1));
c_DISJ_1_1_28.. Y_DISJ_1_1_28 =G= exp(X_DISJ_1_1_28) - (1-Z('28'));
e_DISJ_1_1_28.. 1*W_DISJ_1_1_28 =L= Z('28')*UB('68','1','28');
f_DISJ_1_1_28.. 1*W_DISJ_1_1_28 =G= 1*X_DISJ_1_1_28 - (1-Z('28'))*UB('68','1','28');
g_DISJ_1_1_28.. W_DISJ_1_1_28 =L= X_DISJ_1_1_28;
DISJ_1_2_28.. V('59','2','28') =E= 0;
DISJ_2_2_28.. V('68','2','28') =E= 0;
DISJ_1_3_28.. X('59') =E= SUM(D,V('59',D,'28'));
DISJ_2_3_28.. X('68') =E= SUM(D,V('68',D,'28'));
DISJ_1_4_28.. V('59','1','28') =L= UB('59','1','28')*Z('28');
DISJ_2_4_28.. V('59','2','28') =L= UB('59','2','28')*(1-Z('28'));
DISJ_3_4_28.. V('68','1','28') =L= UB('68','1','28')*Z('28');
DISJ_4_4_28.. V('68','2','28') =L= UB('68','2','28')*(1-Z('28'));

DISJ_1_1_29.. V('69','1','29') - 0.9*V('63','1','29') =E= 0;
DISJ_1_2_29.. V('63','2','29') =E= 0;
DISJ_2_2_29.. V('69','2','29') =E= 0;
DISJ_1_3_29.. X('63') =E= SUM(D,V('63',D,'29'));
DISJ_2_3_29.. X('69') =E= SUM(D,V('69',D,'29'));
DISJ_1_4_29.. V('63','1','29') =L= UB('63','1','29')*Z('29');
DISJ_2_4_29.. V('63','2','29') =L= UB('63','2','29')*(1-Z('29'));
DISJ_3_4_29.. V('69','1','29') =L= UB('69','1','29')*Z('29');
DISJ_4_4_29.. V('69','2','29') =L= UB('69','2','29')*(1-Z('29'));

DISJ_1_1_30.. V('70','1','30') - 0.6*V('64','1','30') =E= 0;
DISJ_1_2_30.. V('64','2','30') =E= 0;
DISJ_2_2_30.. V('70','2','30') =E= 0;
DISJ_1_3_30.. X('64') =E= SUM(D,V('64',D,'30'));
DISJ_2_3_30.. X('70') =E= SUM(D,V('70',D,'30'));
DISJ_1_4_30.. V('64','1','30') =L= UB('64','1','30')*Z('30');
DISJ_2_4_30.. V('64','2','30') =L= UB('64','2','30')*(1-Z('30'));
DISJ_3_4_30.. V('70','1','30') =L= UB('70','1','30')*Z('30');
DISJ_4_4_30.. V('70','2','30') =L= UB('70','2','30')*(1-Z('30'));

*DISJ_1_1_31.. (Z('31')+ES)*(V('71','1','31')/(Z('31')+ES) - 1.1*LOG(1+V('65','1','31')/(Z('31')+ES))) =L= 0;
positive variable X_DISJ_1_1_31, Y_DISJ_1_1_31, W_DISJ_1_1_31;
X_DISJ_1_1_31.up = UB('71','1','31')/(1.1*1);
W_DISJ_1_1_31.up = UB('71','1','31')/(1.1*1);
Y_DISJ_1_1_31.up = exp(UB('71','1','31')/(1.1*1));
equation d_DISJ_1_1_31;
equation a_DISJ_1_1_31, b_DISJ_1_1_31, c_DISJ_1_1_31;
equation e_DISJ_1_1_31, f_DISJ_1_1_31, g_DISJ_1_1_31;
DISJ_1_1_31.. Z('31')+V('65','1','31') =G= Y_DISJ_1_1_31;
d_DISJ_1_1_31.. 1.1*W_DISJ_1_1_31 =G= V('71','1','31');
a_DISJ_1_1_31.. Y_DISJ_1_1_31 =G= Z('31');
b_DISJ_1_1_31.. Y_DISJ_1_1_31 =L= Z('31')*exp(UB('71','1','31')/(1.1*1));
c_DISJ_1_1_31.. Y_DISJ_1_1_31 =G= exp(X_DISJ_1_1_31) - (1-Z('31'));
e_DISJ_1_1_31.. 1.1*W_DISJ_1_1_31 =L= Z('31')*UB('71','1','31');
f_DISJ_1_1_31.. 1.1*W_DISJ_1_1_31 =G= 1.1*X_DISJ_1_1_31 - (1-Z('31'))*UB('71','1','31');
g_DISJ_1_1_31.. W_DISJ_1_1_31 =L= X_DISJ_1_1_31;
DISJ_1_2_31.. V('65','2','31') =E= 0;
DISJ_2_2_31.. V('71','2','31') =E= 0;
DISJ_1_3_31.. X('65') =E= SUM(D,V('65',D,'31'));
DISJ_2_3_31.. X('71') =E= SUM(D,V('71',D,'31'));
DISJ_1_4_31.. V('65','1','31') =L= UB('65','1','31')*Z('31');
DISJ_2_4_31.. V('65','2','31') =L= UB('65','2','31')*(1-Z('31'));
DISJ_3_4_31.. V('71','1','31') =L= UB('71','1','31')*Z('31');
DISJ_4_4_31.. V('71','2','31') =L= UB('71','2','31')*(1-Z('31'));

DISJ_1_1_32.. V('82','1','32') - 0.9*V('66','1','32') =E= 0;
DISJ_2_1_32.. V('82','1','32') - V('74','1','32') =E= 0;
DISJ_1_2_32.. V('66','2','32') =E= 0;
DISJ_2_2_32.. V('74','2','32') =E= 0;
DISJ_3_2_32.. V('82','2','32') =E= 0;
DISJ_1_3_32.. X('66') =E= SUM(D,V('66',D,'32'));
DISJ_2_3_32.. X('74') =E= SUM(D,V('74',D,'32'));
DISJ_3_3_32.. X('82') =E= SUM(D,V('82',D,'32'));
DISJ_1_4_32.. V('66','1','32') =L= UB('66','1','32')*Z('32');
DISJ_2_4_32.. V('66','2','32') =L= UB('66','2','32')*(1-Z('32'));
DISJ_3_4_32.. V('74','1','32') =L= UB('74','1','32')*Z('32');
DISJ_4_4_32.. V('74','2','32') =L= UB('74','2','32')*(1-Z('32'));
DISJ_5_4_32.. V('82','1','32') =L= UB('82','1','32')*Z('32');
DISJ_6_4_32.. V('82','2','32') =L= UB('82','2','32')*(1-Z('32'));

*DISJ_1_1_33.. (Z('33')+ES)*(V('83','1','33')/(Z('33')+ES) - LOG(1+V('67','1','33')/(Z('33')+ES))) =L= 0;
positive variable X_DISJ_1_1_33, Y_DISJ_1_1_33, W_DISJ_1_1_33;
X_DISJ_1_1_33.up = UB('83','1','33')/(1*1);
W_DISJ_1_1_33.up = UB('83','1','33')/(1*1);
Y_DISJ_1_1_33.up = exp(UB('83','1','33')/(1*1));
equation d_DISJ_1_1_33;
equation a_DISJ_1_1_33, b_DISJ_1_1_33, c_DISJ_1_1_33;
equation e_DISJ_1_1_33, f_DISJ_1_1_33, g_DISJ_1_1_33;
DISJ_1_1_33.. Z('33')+V('67','1','33') =G= Y_DISJ_1_1_33;
d_DISJ_1_1_33.. 1*W_DISJ_1_1_33 =G= V('83','1','33');
a_DISJ_1_1_33.. Y_DISJ_1_1_33 =G= Z('33');
b_DISJ_1_1_33.. Y_DISJ_1_1_33 =L= Z('33')*exp(UB('83','1','33')/(1*1));
c_DISJ_1_1_33.. Y_DISJ_1_1_33 =G= exp(X_DISJ_1_1_33) - (1-Z('33'));
e_DISJ_1_1_33.. 1*W_DISJ_1_1_33 =L= Z('33')*UB('83','1','33');
f_DISJ_1_1_33.. 1*W_DISJ_1_1_33 =G= 1*X_DISJ_1_1_33 - (1-Z('33'))*UB('83','1','33');
g_DISJ_1_1_33.. W_DISJ_1_1_33 =L= X_DISJ_1_1_33;
DISJ_1_2_33.. V('67','2','33') =E= 0;
DISJ_2_2_33.. V('83','2','33') =E= 0;
DISJ_1_3_33.. X('67') =E= SUM(D,V('67',D,'33'));
DISJ_2_3_33.. X('83') =E= SUM(D,V('83',D,'33'));
DISJ_1_4_33.. V('67','1','33') =L= UB('67','1','33')*Z('33');
DISJ_2_4_33.. V('67','2','33') =L= UB('67','2','33')*(1-Z('33'));
DISJ_3_4_33.. V('83','1','33') =L= UB('83','1','33')*Z('33');
DISJ_4_4_33.. V('83','2','33') =L= UB('83','2','33')*(1-Z('33'));

*DISJ_1_1_34.. (Z('34')+ES)*(V('84','1','34')/(Z('34')+ES) - 0.7*LOG(1+V('72','1','34')/(Z('34')+ES))) =L= 0;
positive variable X_DISJ_1_1_34, Y_DISJ_1_1_34, W_DISJ_1_1_34;
X_DISJ_1_1_34.up = UB('84','1','34')/(0.7*1);
W_DISJ_1_1_34.up = UB('84','1','34')/(0.7*1);
Y_DISJ_1_1_34.up = exp(UB('84','1','34')/(0.7*1));
equation d_DISJ_1_1_34;
equation a_DISJ_1_1_34, b_DISJ_1_1_34, c_DISJ_1_1_34;
equation e_DISJ_1_1_34, f_DISJ_1_1_34, g_DISJ_1_1_34;
DISJ_1_1_34.. Z('34')+V('72','1','34') =G= Y_DISJ_1_1_34;
d_DISJ_1_1_34.. 0.7*W_DISJ_1_1_34 =G= V('84','1','34');
a_DISJ_1_1_34.. Y_DISJ_1_1_34 =G= Z('34');
b_DISJ_1_1_34.. Y_DISJ_1_1_34 =L= Z('34')*exp(UB('84','1','34')/(0.7*1));
c_DISJ_1_1_34.. Y_DISJ_1_1_34 =G= exp(X_DISJ_1_1_34) - (1-Z('34'));
e_DISJ_1_1_34.. 0.7*W_DISJ_1_1_34 =L= Z('34')*UB('84','1','34');
f_DISJ_1_1_34.. 0.7*W_DISJ_1_1_34 =G= 0.7*X_DISJ_1_1_34 - (1-Z('34'))*UB('84','1','34');
g_DISJ_1_1_34.. W_DISJ_1_1_34 =L= X_DISJ_1_1_34;
DISJ_1_2_34.. V('72','2','34') =E= 0;
DISJ_2_2_34.. V('84','2','34') =E= 0;
DISJ_1_3_34.. X('72') =E= SUM(D,V('72',D,'34'));
DISJ_2_3_34.. X('84') =E= SUM(D,V('84',D,'34'));
DISJ_1_4_34.. V('72','1','34') =L= UB('72','1','34')*Z('34');
DISJ_2_4_34.. V('72','2','34') =L= UB('72','2','34')*(1-Z('34'));
DISJ_3_4_34.. V('84','1','34') =L= UB('84','1','34')*Z('34');
DISJ_4_4_34.. V('84','2','34') =L= UB('84','2','34')*(1-Z('34'));

*DISJ_1_1_35.. (Z('35')+ES)*(V('85','1','35')/(Z('35')+ES) - 0.65*LOG(1+(V('73','1','35'))/(Z('35')+ES))) =L= 0;
positive variable X_DISJ_1_1_35, Y_DISJ_1_1_35, W_DISJ_1_1_35;
X_DISJ_1_1_35.up = UB('85','1','35')/(0.65*1);
W_DISJ_1_1_35.up = UB('85','1','35')/(0.65*1);
Y_DISJ_1_1_35.up = exp(UB('85','1','35')/(0.65*1));
equation d_DISJ_1_1_35;
equation a_DISJ_1_1_35, b_DISJ_1_1_35, c_DISJ_1_1_35;
equation e_DISJ_1_1_35, f_DISJ_1_1_35, g_DISJ_1_1_35;
DISJ_1_1_35.. Z('35')+V('73','1','35') =G= Y_DISJ_1_1_35;
d_DISJ_1_1_35.. 0.65*W_DISJ_1_1_35 =G= V('85','1','35');
a_DISJ_1_1_35.. Y_DISJ_1_1_35 =G= Z('35');
b_DISJ_1_1_35.. Y_DISJ_1_1_35 =L= Z('35')*exp(UB('85','1','35')/(0.65*1));
c_DISJ_1_1_35.. Y_DISJ_1_1_35 =G= exp(X_DISJ_1_1_35) - (1-Z('35'));
e_DISJ_1_1_35.. 0.65*W_DISJ_1_1_35 =L= Z('35')*UB('85','1','35');
f_DISJ_1_1_35.. 0.65*W_DISJ_1_1_35 =G= 0.65*X_DISJ_1_1_35 - (1-Z('35'))*UB('85','1','35');
g_DISJ_1_1_35.. W_DISJ_1_1_35 =L= X_DISJ_1_1_35;
*DISJ_2_1_35.. (Z('35')+ES)*(V('85','1','35')/(Z('35')+ES) - 0.65*LOG(1+(V('76','1','35'))/(Z('35')+ES))) =L= 0;
positive variable X_DISJ_2_1_35, Y_DISJ_2_1_35, W_DISJ_2_1_35;
X_DISJ_2_1_35.up = UB('85','1','35')/(0.65*1);
W_DISJ_2_1_35.up = UB('85','1','35')/(0.65*1);
Y_DISJ_2_1_35.up = exp(UB('85','1','35')/(0.65*1));
equation d_DISJ_2_1_35;
equation a_DISJ_2_1_35, b_DISJ_2_1_35, c_DISJ_2_1_35;
equation e_DISJ_2_1_35, f_DISJ_2_1_35, g_DISJ_2_1_35;
DISJ_2_1_35.. Z('35')+V('76','1','35') =G= Y_DISJ_2_1_35;
d_DISJ_2_1_35.. 0.65*W_DISJ_2_1_35 =G= V('85','1','35');
a_DISJ_2_1_35.. Y_DISJ_2_1_35 =G= Z('35');
b_DISJ_2_1_35.. Y_DISJ_2_1_35 =L= Z('35')*exp(UB('85','1','35')/(0.65*1));
c_DISJ_2_1_35.. Y_DISJ_2_1_35 =G= exp(X_DISJ_2_1_35) - (1-Z('35'));
e_DISJ_2_1_35.. 0.65*W_DISJ_2_1_35 =L= Z('35')*UB('85','1','35');
f_DISJ_2_1_35.. 0.65*W_DISJ_2_1_35 =G= 0.65*X_DISJ_2_1_35 - (1-Z('35'))*UB('85','1','35');
g_DISJ_2_1_35.. W_DISJ_2_1_35 =L= X_DISJ_2_1_35;
DISJ_1_2_35.. V('73','2','35') =E= 0;
DISJ_2_2_35.. V('76','2','35') =E= 0;
DISJ_3_2_35.. V('85','2','35') =E= 0;
DISJ_1_3_35.. X('73') =E= SUM(D,V('73',D,'35'));
DISJ_2_3_35.. X('76') =E= SUM(D,V('76',D,'35'));
DISJ_3_3_35.. X('85') =E= SUM(D,V('85',D,'35'));
DISJ_1_4_35.. V('73','1','35') =L= UB('73','1','35')*Z('35');
DISJ_2_4_35.. V('73','2','35') =L= UB('73','2','35')*(1-Z('35'));
DISJ_3_4_35.. V('76','1','35') =L= UB('76','1','35')*Z('35');
DISJ_4_4_35.. V('76','2','35') =L= UB('76','2','35')*(1-Z('35'));
DISJ_5_4_35.. V('85','1','35') =L= UB('85','1','35')*Z('35');
DISJ_6_4_35.. V('85','2','35') =L= UB('85','2','35')*(1-Z('35'));

DISJ_1_1_36.. V('86','1','36') - V('77','1','36') =E= 0;
DISJ_1_2_36.. V('77','2','36') =E= 0;
DISJ_2_2_36.. V('86','2','36') =E= 0;
DISJ_1_3_36.. X('77') =E= SUM(D,V('77',D,'36'));
DISJ_2_3_36.. X('86') =E= SUM(D,V('86',D,'36'));
DISJ_1_4_36.. V('77','1','36') =L= UB('77','1','36')*Z('36');
DISJ_2_4_36.. V('77','2','36') =L= UB('77','2','36')*(1-Z('36'));
DISJ_3_4_36.. V('86','1','36') =L= UB('86','1','36')*Z('36');
DISJ_4_4_36.. V('86','2','36') =L= UB('86','2','36')*(1-Z('36'));

DISJ_1_1_37.. V('87','1','37') - V('78','1','37') =E= 0;
DISJ_1_2_37.. V('78','2','37') =E= 0;
DISJ_2_2_37.. V('87','2','37') =E= 0;
DISJ_1_3_37.. X('78') =E= SUM(D,V('78',D,'37'));
DISJ_2_3_37.. X('87') =E= SUM(D,V('87',D,'37'));
DISJ_1_4_37.. V('78','1','37') =L= UB('78','1','37')*Z('37');
DISJ_2_4_37.. V('78','2','37') =L= UB('78','2','37')*(1-Z('37'));
DISJ_3_4_37.. V('87','1','37') =L= UB('87','1','37')*Z('37');
DISJ_4_4_37.. V('87','2','37') =L= UB('87','2','37')*(1-Z('37'));

*DISJ_1_1_38.. (Z('38')+ES)*(V('88','1','38')/(Z('38')+ES) - 0.75*LOG(1+V('79','1','38')/(Z('38')+ES))) =L= 0;
positive variable X_DISJ_1_1_38, Y_DISJ_1_1_38, W_DISJ_1_1_38;
X_DISJ_1_1_38.up = UB('88','1','38')/(0.75*1);
W_DISJ_1_1_38.up = UB('88','1','38')/(0.75*1);
Y_DISJ_1_1_38.up = exp(UB('88','1','38')/(0.75*1));
equation d_DISJ_1_1_38;
equation a_DISJ_1_1_38, b_DISJ_1_1_38, c_DISJ_1_1_38;
equation e_DISJ_1_1_38, f_DISJ_1_1_38, g_DISJ_1_1_38;
DISJ_1_1_38.. Z('38')+V('79','1','38') =G= Y_DISJ_1_1_38;
d_DISJ_1_1_38.. 0.75*W_DISJ_1_1_38 =G= V('88','1','38');
a_DISJ_1_1_38.. Y_DISJ_1_1_38 =G= Z('38');
b_DISJ_1_1_38.. Y_DISJ_1_1_38 =L= Z('38')*exp(UB('88','1','38')/(0.75*1));
c_DISJ_1_1_38.. Y_DISJ_1_1_38 =G= exp(X_DISJ_1_1_38) - (1-Z('38'));
e_DISJ_1_1_38.. 0.75*W_DISJ_1_1_38 =L= Z('38')*UB('88','1','38');
f_DISJ_1_1_38.. 0.75*W_DISJ_1_1_38 =G= 0.75*X_DISJ_1_1_38 - (1-Z('38'))*UB('88','1','38');
g_DISJ_1_1_38.. W_DISJ_1_1_38 =L= X_DISJ_1_1_38;
DISJ_1_2_38.. V('79','2','38') =E= 0;
DISJ_2_2_38.. V('88','2','38') =E= 0;
DISJ_1_3_38.. X('79') =E= SUM(D,V('79',D,'38'));
DISJ_2_3_38.. X('88') =E= SUM(D,V('88',D,'38'));
DISJ_1_4_38.. V('79','1','38') =L= UB('79','1','38')*Z('38');
DISJ_2_4_38.. V('79','2','38') =L= UB('79','2','38')*(1-Z('38'));
DISJ_3_4_38.. V('88','1','38') =L= UB('88','1','38')*Z('38');
DISJ_4_4_38.. V('88','2','38') =L= UB('88','2','38')*(1-Z('38'));

*DISJ_1_1_39.. (Z('39')+ES)*(V('89','1','39')/(Z('39')+ES) - 0.8*LOG(1+V('80','1','39')/(Z('39')+ES))) =L= 0;
positive variable X_DISJ_1_1_39, Y_DISJ_1_1_39, W_DISJ_1_1_39;
X_DISJ_1_1_39.up = UB('89','1','39')/(0.8*1);
W_DISJ_1_1_39.up = UB('89','1','39')/(0.8*1);
Y_DISJ_1_1_39.up = exp(UB('89','1','39')/(0.8*1));
equation d_DISJ_1_1_39;
equation a_DISJ_1_1_39, b_DISJ_1_1_39, c_DISJ_1_1_39;
equation e_DISJ_1_1_39, f_DISJ_1_1_39, g_DISJ_1_1_39;
DISJ_1_1_39.. Z('39')+V('80','1','39') =G= Y_DISJ_1_1_39;
d_DISJ_1_1_39.. 0.8*W_DISJ_1_1_39 =G= V('89','1','39');
a_DISJ_1_1_39.. Y_DISJ_1_1_39 =G= Z('39');
b_DISJ_1_1_39.. Y_DISJ_1_1_39 =L= Z('39')*exp(UB('89','1','39')/(0.8*1));
c_DISJ_1_1_39.. Y_DISJ_1_1_39 =G= exp(X_DISJ_1_1_39) - (1-Z('39'));
e_DISJ_1_1_39.. 0.8*W_DISJ_1_1_39 =L= Z('39')*UB('89','1','39');
f_DISJ_1_1_39.. 0.8*W_DISJ_1_1_39 =G= 0.8*X_DISJ_1_1_39 - (1-Z('39'))*UB('89','1','39');
g_DISJ_1_1_39.. W_DISJ_1_1_39 =L= X_DISJ_1_1_39;
DISJ_1_2_39.. V('80','2','39') =E= 0;
DISJ_2_2_39.. V('89','2','39') =E= 0;
DISJ_1_3_39.. X('80') =E= SUM(D,V('80',D,'39'));
DISJ_2_3_39.. X('89') =E= SUM(D,V('89',D,'39'));
DISJ_1_4_39.. V('80','1','39') =L= UB('80','1','39')*Z('39');
DISJ_2_4_39.. V('80','2','39') =L= UB('80','2','39')*(1-Z('39'));
DISJ_3_4_39.. V('89','1','39') =L= UB('89','1','39')*Z('39');
DISJ_4_4_39.. V('89','2','39') =L= UB('89','2','39')*(1-Z('39'));

*DISJ_1_1_40.. (Z('40')+ES)*(V('90','1','40')/(Z('40')+ES) - 0.85*LOG(1+V('81','1','40')/(Z('40')+ES))) =L= 0;
positive variable X_DISJ_1_1_40, Y_DISJ_1_1_40, W_DISJ_1_1_40;
X_DISJ_1_1_40.up = UB('90','1','40')/(0.85*1);
W_DISJ_1_1_40.up = UB('90','1','40')/(0.85*1);
Y_DISJ_1_1_40.up = exp(UB('90','1','40')/(0.85*1));
equation d_DISJ_1_1_40;
equation a_DISJ_1_1_40, b_DISJ_1_1_40, c_DISJ_1_1_40;
equation e_DISJ_1_1_40, f_DISJ_1_1_40, g_DISJ_1_1_40;
DISJ_1_1_40.. Z('40')+V('81','1','40') =G= Y_DISJ_1_1_40;
d_DISJ_1_1_40.. 0.85*W_DISJ_1_1_40 =G= V('90','1','40');
a_DISJ_1_1_40.. Y_DISJ_1_1_40 =G= Z('40');
b_DISJ_1_1_40.. Y_DISJ_1_1_40 =L= Z('40')*exp(UB('90','1','40')/(0.85*1));
c_DISJ_1_1_40.. Y_DISJ_1_1_40 =G= exp(X_DISJ_1_1_40) - (1-Z('40'));
e_DISJ_1_1_40.. 0.85*W_DISJ_1_1_40 =L= Z('40')*UB('90','1','40');
f_DISJ_1_1_40.. 0.85*W_DISJ_1_1_40 =G= 0.85*X_DISJ_1_1_40 - (1-Z('40'))*UB('90','1','40');
g_DISJ_1_1_40.. W_DISJ_1_1_40 =L= X_DISJ_1_1_40;
DISJ_1_2_40.. V('81','2','40') =E= 0;
DISJ_2_2_40.. V('90','2','40') =E= 0;
DISJ_1_3_40.. X('81') =E= SUM(D,V('81',D,'40'));
DISJ_2_3_40.. X('90') =E= SUM(D,V('90',D,'40'));
DISJ_1_4_40.. V('81','1','40') =L= UB('81','1','40')*Z('40');
DISJ_2_4_40.. V('81','2','40') =L= UB('81','2','40')*(1-Z('40'));
DISJ_3_4_40.. V('90','1','40') =L= UB('90','1','40')*Z('40');
DISJ_4_4_40.. V('90','2','40') =L= UB('90','2','40')*(1-Z('40'));

*Design Specifications
D1..  Z('1') + Z('2')                           =E= 1;

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

V.up(K,D,I) = UB(K,D,I);
MODEL RETROFIT_8_SYNTHESIS_40_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE RETROFIT_8_SYNTHESIS_40_CH USING %TYPE% MAXIMIZING OBJ;
