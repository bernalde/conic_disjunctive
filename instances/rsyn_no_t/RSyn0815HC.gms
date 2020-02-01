*Disaggregated constraint using conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 <= c*log(1+v2) <=> Kexp(1+v2,1,v1/c);
*G(v1,v2): v1 <= z*c*log(1+v2/z) <=> v1 <= z*c*log(x/z), x = z+v2 <=> Kexp(x,z,v1/c), x = z+v2;
*Conic formulation (notice duplicates of binary variables because of single variable per cones)
*disj.. y >= z*exp(x/z) <=> x <= z*log(y/z) ; x >= v1/c ; y = z + v2
*Retrofit-Synthesis Problem with 8 retrofit processes and 15 synthesis processes
*One Period (t=1)
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

K            /1*40/                       /* Number of Synthesis Streams */
I            /1*15/                       /* Number of Synthesis Processes */
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

/26 =   23
 28 =   19
 32 =   2
 33 =   3
 34 =   5
 35 =   4/
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

*Disjunctions
*Note 1: The non-linear constraints inside the disjunctions are technicallZ equations, but relax as less than or equal to inequalities (from phZsical considerations, the greater than or equal to inequalities are nonsense), which is whZ this problem is convex.
*Note 2: The equations setting flows equal to 0 in the second disjunct relax solelZ as less than or equal to inequalities, since the greater than or equal to inequalities are redundant (and are thus omitted).
*Note 3: The non-linear constraints within each disjunction have been modififed from their original form in Lee & Grossmann's "New Algorithms for Non-Linear Generalized Disjunctive Programming" to the form presented in SawaZa & Grossmann's Short Note on the "Computational Implementation of the Non-Linear Convex Hull".

*DISJ_1_1_1.. (Z('1')+ES)*(V('4','1','1')/(Z('1')+ES) - LOG(1+V('2','1','1')/(Z('1')+ES))) =L= 0;
positive variable X_DISJ_1_1_1, Y_DISJ_1_1_1;
X_DISJ_1_1_1.up = UB('4','1','1')/(1*1);
Y_DISJ_1_1_1.up = UB('2','1','1') + 1;
equation d_DISJ_1_1_1;
equation c_DISJ_1_1_1;
Z.l('1') = 1;
DISJ_1_1_1.. Y_DISJ_1_1_1 =G= Z('1')*exp(X_DISJ_1_1_1/Z('1'));
c_DISJ_1_1_1.. X_DISJ_1_1_1 =G= V('4','1','1')/(1*1);
d_DISJ_1_1_1.. Y_DISJ_1_1_1 =E= Z('1')+V('2','1','1');
DISJ_1_2_1.. V('2','2','1') =E= 0;
DISJ_2_2_1.. V('4','2','1') =E= 0;
DISJ_1_3_1.. X('2') =E= SUM(D,V('2',D,'1'));
DISJ_2_3_1.. X('4') =E= SUM(D,V('4',D,'1'));
DISJ_1_4_1.. V('2','1','1') =L= UB('2','1','1')*Z('1');
DISJ_2_4_1.. V('2','2','1') =L= UB('2','2','1')*(1-Z('1'));
DISJ_3_4_1.. V('4','1','1') =L= UB('4','1','1')*Z('1');
DISJ_4_4_1.. V('4','2','1') =L= UB('4','2','1')*(1-Z('1'));

*DISJ_1_1_2.. (Z('2')+ES)*(V('5','1','2')/(Z('2')+ES) - 1.2*LOG(1+V('3','1','2')/(Z('2')+ES))) =L= 0;
positive variable X_DISJ_1_1_2, Y_DISJ_1_1_2;
X_DISJ_1_1_2.up = UB('5','1','2')/(1.2*1);
Y_DISJ_1_1_2.up = UB('3','1','2') + 1;
equation d_DISJ_1_1_2;
equation c_DISJ_1_1_2;
Z.l('2') = 1;
DISJ_1_1_2.. Y_DISJ_1_1_2 =G= Z('2')*exp(X_DISJ_1_1_2/Z('2'));
c_DISJ_1_1_2.. X_DISJ_1_1_2 =G= V('5','1','2')/(1.2*1);
d_DISJ_1_1_2.. Y_DISJ_1_1_2 =E= Z('2')+V('3','1','2');
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
positive variable X_DISJ_1_1_4, Y_DISJ_1_1_4;
X_DISJ_1_1_4.up = UB('14','1','4')/(1.5*1);
Y_DISJ_1_1_4.up = UB('10','1','4') + 1;
equation d_DISJ_1_1_4;
equation c_DISJ_1_1_4;
Z.l('4') = 1;
DISJ_1_1_4.. Y_DISJ_1_1_4 =G= Z('4')*exp(X_DISJ_1_1_4/Z('4'));
c_DISJ_1_1_4.. X_DISJ_1_1_4 =G= V('14','1','4')/(1.5*1);
d_DISJ_1_1_4.. Y_DISJ_1_1_4 =E= Z('4')+V('10','1','4');
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
positive variable X_DISJ_1_1_6, Y_DISJ_1_1_6;
X_DISJ_1_1_6.up = UB('21','1','6')/(1.25*1);
Y_DISJ_1_1_6.up = UB('16','1','6') + 1;
equation d_DISJ_1_1_6;
equation c_DISJ_1_1_6;
Z.l('6') = 1;
DISJ_1_1_6.. Y_DISJ_1_1_6 =G= Z('6')*exp(X_DISJ_1_1_6/Z('6'));
c_DISJ_1_1_6.. X_DISJ_1_1_6 =G= V('21','1','6')/(1.25*1);
d_DISJ_1_1_6.. Y_DISJ_1_1_6 =E= Z('6')+V('16','1','6');
DISJ_1_2_6.. V('16','2','6') =E= 0;
DISJ_2_2_6.. V('21','2','6') =E= 0;
DISJ_1_3_6.. X('16') =E= SUM(D,V('16',D,'6'));
DISJ_2_3_6.. X('21') =E= SUM(D,V('21',D,'6'));
DISJ_1_4_6.. V('16','1','6') =L= UB('16','1','6')*Z('6');
DISJ_2_4_6.. V('16','2','6') =L= UB('16','2','6')*(1-Z('6'));
DISJ_3_4_6.. V('21','1','6') =L= UB('21','1','6')*Z('6');
DISJ_4_4_6.. V('21','2','6') =L= UB('21','2','6')*(1-Z('6'));

*DISJ_1_1_7.. (Z('7')+ES)*(V('22','1','7')/(Z('7')+ES) - 0.9*LOG(1+V('17','1','7')/(Z('7')+ES))) =L= 0;
positive variable X_DISJ_1_1_7, Y_DISJ_1_1_7;
X_DISJ_1_1_7.up = UB('22','1','7')/(0.9*1);
Y_DISJ_1_1_7.up = UB('17','1','7') + 1;
equation d_DISJ_1_1_7;
equation c_DISJ_1_1_7;
Z.l('7') = 1;
DISJ_1_1_7.. Y_DISJ_1_1_7 =G= Z('7')*exp(X_DISJ_1_1_7/Z('7'));
c_DISJ_1_1_7.. X_DISJ_1_1_7 =G= V('22','1','7')/(0.9*1);
d_DISJ_1_1_7.. Y_DISJ_1_1_7 =E= Z('7')+V('17','1','7');
DISJ_1_2_7.. V('17','2','7') =E= 0;
DISJ_2_2_7.. V('22','2','7') =E= 0;
DISJ_1_3_7.. X('17') =E= SUM(D,V('17',D,'7'));
DISJ_2_3_7.. X('22') =E= SUM(D,V('22',D,'7'));
DISJ_1_4_7.. V('17','1','7') =L= UB('17','1','7')*Z('7');
DISJ_2_4_7.. V('17','2','7') =L= UB('17','2','7')*(1-Z('7'));
DISJ_3_4_7.. V('22','1','7') =L= UB('22','1','7')*Z('7');
DISJ_4_4_7.. V('22','2','7') =L= UB('22','2','7')*(1-Z('7'));

*DISJ_1_1_8.. (Z('8')+ES)*(V('23','1','8')/(Z('8')+ES) - LOG(1+V('14','1','8')/(Z('8')+ES))) =L= 0;
positive variable X_DISJ_1_1_8, Y_DISJ_1_1_8;
X_DISJ_1_1_8.up = UB('23','1','8')/(1*1);
Y_DISJ_1_1_8.up = UB('14','1','8') + 1;
equation d_DISJ_1_1_8;
equation c_DISJ_1_1_8;
Z.l('8') = 1;
DISJ_1_1_8.. Y_DISJ_1_1_8 =G= Z('8')*exp(X_DISJ_1_1_8/Z('8'));
c_DISJ_1_1_8.. X_DISJ_1_1_8 =G= V('23','1','8')/(1*1);
d_DISJ_1_1_8.. Y_DISJ_1_1_8 =E= Z('8')+V('14','1','8');
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
positive variable X_DISJ_1_1_11, Y_DISJ_1_1_11;
X_DISJ_1_1_11.up = UB('26','1','11')/(1.1*1);
Y_DISJ_1_1_11.up = UB('20','1','11') + 1;
equation d_DISJ_1_1_11;
equation c_DISJ_1_1_11;
Z.l('11') = 1;
DISJ_1_1_11.. Y_DISJ_1_1_11 =G= Z('11')*exp(X_DISJ_1_1_11/Z('11'));
c_DISJ_1_1_11.. X_DISJ_1_1_11 =G= V('26','1','11')/(1.1*1);
d_DISJ_1_1_11.. Y_DISJ_1_1_11 =E= Z('11')+V('20','1','11');
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
positive variable X_DISJ_1_1_13, Y_DISJ_1_1_13;
X_DISJ_1_1_13.up = UB('38','1','13')/(1*1);
Y_DISJ_1_1_13.up = UB('22','1','13') + 1;
equation d_DISJ_1_1_13;
equation c_DISJ_1_1_13;
Z.l('13') = 1;
DISJ_1_1_13.. Y_DISJ_1_1_13 =G= Z('13')*exp(X_DISJ_1_1_13/Z('13'));
c_DISJ_1_1_13.. X_DISJ_1_1_13 =G= V('38','1','13')/(1*1);
d_DISJ_1_1_13.. Y_DISJ_1_1_13 =E= Z('13')+V('22','1','13');
DISJ_1_2_13.. V('22','2','13') =E= 0;
DISJ_2_2_13.. V('38','2','13') =E= 0;
DISJ_1_3_13.. X('22') =E= SUM(D,V('22',D,'13'));
DISJ_2_3_13.. X('38') =E= SUM(D,V('38',D,'13'));
DISJ_1_4_13.. V('22','1','13') =L= UB('22','1','13')*Z('13');
DISJ_2_4_13.. V('22','2','13') =L= UB('22','2','13')*(1-Z('13'));
DISJ_3_4_13.. V('38','1','13') =L= UB('38','1','13')*Z('13');
DISJ_4_4_13.. V('38','2','13') =L= UB('38','2','13')*(1-Z('13'));

*DISJ_1_1_14.. (Z('14')+ES)*(V('39','1','14')/(Z('14')+ES) - 0.7*LOG(1+V('27','1','14')/(Z('14')+ES))) =L= 0;
positive variable X_DISJ_1_1_14, Y_DISJ_1_1_14;
X_DISJ_1_1_14.up = UB('39','1','14')/(0.7*1);
Y_DISJ_1_1_14.up = UB('27','1','14') + 1;
equation d_DISJ_1_1_14;
equation c_DISJ_1_1_14;
Z.l('14') = 1;
DISJ_1_1_14.. Y_DISJ_1_1_14 =G= Z('14')*exp(X_DISJ_1_1_14/Z('14'));
c_DISJ_1_1_14.. X_DISJ_1_1_14 =G= V('39','1','14')/(0.7*1);
d_DISJ_1_1_14.. Y_DISJ_1_1_14 =E= Z('14')+V('27','1','14');
DISJ_1_2_14.. V('27','2','14') =E= 0;
DISJ_2_2_14.. V('39','2','14') =E= 0;
DISJ_1_3_14.. X('27') =E= SUM(D,V('27',D,'14'));
DISJ_2_3_14.. X('39') =E= SUM(D,V('39',D,'14'));
DISJ_1_4_14.. V('27','1','14') =L= UB('27','1','14')*Z('14');
DISJ_2_4_14.. V('27','2','14') =L= UB('27','2','14')*(1-Z('14'));
DISJ_3_4_14.. V('39','1','14') =L= UB('39','1','14')*Z('14');
DISJ_4_4_14.. V('39','2','14') =L= UB('39','2','14')*(1-Z('14'));

*DISJ_1_1_15.. (Z('15')+ES)*(V('40','1','15')/(Z('15')+ES) - 0.65*LOG(1+(V('28','1','15'))/(Z('15')+ES))) =L= 0;
positive variable X_DISJ_1_1_15, Y_DISJ_1_1_15;
X_DISJ_1_1_15.up = UB('40','1','15')/(0.65*1);
Y_DISJ_1_1_15.up = UB('28','1','15') + 1;
equation d_DISJ_1_1_15;
equation c_DISJ_1_1_15;
Z.l('15') = 1;
DISJ_1_1_15.. Y_DISJ_1_1_15 =G= Z('15')*exp(X_DISJ_1_1_15/Z('15'));
c_DISJ_1_1_15.. X_DISJ_1_1_15 =G= V('40','1','15')/(0.65*1);
d_DISJ_1_1_15.. Y_DISJ_1_1_15 =E= Z('15')+V('28','1','15');
*DISJ_2_1_15.. (Z('15')+ES)*(V('40','1','15')/(Z('15')+ES) - 0.65*LOG(1+(V('31','1','15'))/(Z('15')+ES))) =L= 0;
positive variable X_DISJ_2_1_15, Y_DISJ_2_1_15;
X_DISJ_2_1_15.up = UB('40','1','15')/(0.65*1);
Y_DISJ_2_1_15.up = UB('31','1','15') + 1;
equation d_DISJ_2_1_15;
equation c_DISJ_2_1_15;
binary variable Z15;
equation Z15_eq;
Z15.l = 1;
Z15_eq.. Z15 =E= Z('15');
DISJ_2_1_15.. Y_DISJ_2_1_15 =G= Z15*exp(X_DISJ_2_1_15/Z15);
c_DISJ_2_1_15.. X_DISJ_2_1_15 =G= V('40','1','15')/(0.65*1);
d_DISJ_2_1_15.. Y_DISJ_2_1_15 =E= Z15+V('31','1','15');
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
MODEL RETROFIT_8_SYNTHESIS_15_CH /ALL/;
OPTION LIMROW = 0;
OPTION LIMCOL = 0;
$if not set RTYPE $set RTYPE rMINLP
$if not set TYPE $set TYPE MINLP
SOLVE RETROFIT_8_SYNTHESIS_15_CH USING %TYPE% MAXIMIZING OBJ;
