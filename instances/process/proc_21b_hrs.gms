SET k          number of disjunctions                          /1*21/
    j          previous disjunctions                            /1*6/
    de         max number of equations in a disjunctive term   /1*2/


BINARY VARIABLES    Y(k);

set fl "Flows" /1*13/;
alias(fl,fl1);
set pr "Processes" /1*15/;
table d(fl,pr)
         1           2           3           4           5           6           7           8           9           10          11          12          13          14          15
1        1.05        1.17        1.1         1.03        1.02        1.02        1.17        1.15        1.01        1.1         1.14        1.08        1.14        1.1         1
2        1.16        1.14        1.02        1.05        1.02        1.16        1.06        1.02        1.16        1.04        1.11        1.19        1.14        1.15        1.03
3        1.12        1.17        1.05        1.11        1.13        1.02        1.1         1.17        1.19        1.17        1.14        1.09        1.11        1.14        1.11
4        1.2         1.04        1.05        1.14        1.07        1.12        1.04        1.15        1.09        1           1.04        1.06        1.16        1.15        1.07
5        1.04        1.08        1.15        1.19        1.14        1.08        1.16        1.18        1.06        1.08        1.1         1.17        1.11        1.04        1.06
6        1.19        1           1.18        1.11        1.11        1.01        1.15        1.05        1.2         1.02        1.11        1           1.16        1.19        1.13
7        1.15        1.11        1.17        1.07        1.16        1.04        1.18        1.07        1.19        1.18        1.15        1.14        1.14        1.18        1.2
8        1           1.17        1.07        1.13        1.07        1.19        1.14        1.18        1.17        1.1         1.14        1.11        1.18        1.04        1.03
9        1.06        1.02        1.13        1.05        1.14        1.11        1.05        1.15        1.2         1.05        1.06        1.15        1.08        1.13        1.13
10       1.1         1.05        1.12        1.07        1.13        1           1.08        1.17        1.07        1.03        1.12        1.19        1.17        1.05        1.1
11       1.06        1.08        1.17        1.01        1.09        1           1.17        1.11        1.05        1.15        1.15        1.03        1.08        1.06        1.03
12       1.02        1.13        1.18        1.18        1.17        1.05        1.09        1.17        1.19        1.13        1.13        1.14        1.11        1.19        1.15
13       1.18        1.19        1.07        1.01        1.19        1           1.03        1.16        1.13        1.12        1.16        1           1.12        1.18        1.18
;
table t(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15
1       1.26    1.12    1.28    1.15    1.05    1.2     1.2     1.13    1.3     1.18    1.11    1.12    1.16    1.15    1.09
2       1.28    1.08    1.28    1.04    1.11    1.1     1.23    1.02    1.3     1.04    1.05    1.07    1.11    1.25    1.02
3       1.07    1.03    1.07    1.24    1.1     1.23    1.03    1.12    1.02    1.25    1.2     1.01    1.07    1.02    1.22
4       1.05    1.15    1.05    1.24    1.14    1.2     1.11    1.19    1.27    1.07    1.01    1.17    1.24    1.19    1.08
5       1.16    1.1     1.22    1.27    1.27    1.26    1.1     1.1     1.18    1.27    1.09    1.21    1.01    1.17    1.17
6       1.06    1.29    1.12    1.22    1.28    1.2     1.2     1.29    1.15    1.22    1.19    1.27    1.19    1.09    1.22
7       1.15    1.24    1.18    1.24    1.21    1.2     1.29    1.11    1.25    1.13    1.16    1.22    1.08    1.22    1.29
8       1.24    1.14    1.22    1.01    1.03    1       1.23    1.02    1.26    1.24    1.03    1.22    1.19    1.04    1.13
9       1.05    1.15    1.06    1.19    1.29    1.21    1.13    1.14    1.22    1.09    1.18    1.12    1.03    1.11    1.06
10      1.28    1.09    1.12    1.21    1.12    1.08    1.11    1.18    1.07    1.1     1.19    1.27    1.24    1.27    1.19
11      1.2     1.02    1.09    1.08    1.23    1.17    1.01    1.23    1.08    1.12    1.23    1.16    1.05    1.19    1.29
12      1.22    1.17    1.01    1.14    1.19    1.22    1.21    1.28    1.01    1.29    1.23    1.06    1.04    1.26    1.04
13      1.01    1.01    1.08    1.21    1.25    1.17    1.08    1.24    1.24    1.25    1.06    1.24    1.17    1.23    1.04
;
table beta(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15
1       1.04    1.09    1.04    1.1     1.02    0.85    1.07    1.03    1.02    1       0.9     1.1     1.13    1.01    0.86
2       1.16    0.84    1.12    0.93    0.91    1.09    0.82    1.17    0.96    1       1.12    0.85    1.19    1.13    0.81
3       0.92    0.94    0.97    0.86    1.03    1.14    1.18    1.02    0.97    1.18    1.14    0.98    1.08    1.15    0.89
4       1.15    1.19    0.93    1.13    1.13    0.81    1.09    0.98    1.09    1.18    1.16    0.96    0.82    0.97    0.91
5       0.89    1.11    0.99    1.09    1.15    0.86    1.05    0.93    1.08    1.04    1.04    1.08    0.99    1.19    1.07
6       1       0.86    0.93    1.17    1.12    0.96    1.11    0.92    1.11    0.84    0.89    1.06    1.13    0.95    1.15
7       1.05    1.19    1.19    1.04    1.03    0.86    0.88    1.05    0.84    1.19    1.19    1.18    1.14    0.88    1.19
8       0.8     1.09    1.08    1.01    1.16    1.1     0.92    1.18    1.19    1.05    0.99    0.86    1.17    1.1     0.97
9       0.96    1.04    1.13    0.9     0.85    1.05    1       1.1     1.11    1.11    0.92    0.92    0.81    1.05    0.89
10      1.16    1.07    0.87    1.15    0.86    0.96    0.88    1.09    0.92    0.94    0.85    0.97    1.04    1.09    0.93
11      1.03    1.07    1.17    0.85    0.96    0.92    1.09    1.05    0.99    1.2     0.96    1.06    0.95    0.9     0.9
12      1.13    0.88    0.89    1.14    1.16    1.15    1.16    0.84    1.14    0.95    1.19    1.19    1.12    0.85    0.94
13      0.84    1.17    0.98    0.87    0.93    1.01    0.89    1.04    0.86    0.81    0.86    1.08    0.96    1.2     0.89
;
table gamma(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15
1       2.85    2.56    2.33    2.26    2.49    2.69    2.07    2.85    2.09    2.33    2.21    2.23    2.68    2.51    2.1
2       2.4     2.44    2.86    2.4     2.89    2.56    2.7     2.31    2.91    2.96    2.36    2.9     2.92    2.93    2.73
3       2.69    2.72    2.46    2.21    2.4     2.6     2.52    2.51    2.95    2.56    2.88    2.03    2.86    2.63    2.77
4       2.32    2.86    2.25    2.18    2.1     2.22    2.06    2.86    2.84    2.34    2.8     2.68    2.57    3       2.06
5       2.26    2.18    2.51    2.97    2.79    2.65    2.97    2.85    2.43    2.59    2.08    2.53    2.15    2.66    2.35
6       2.22    2.53    2.63    2.51    2.22    2.63    2.36    2.32    2.21    2.54    2.43    2.64    2.35    2.86    2.65
7       2.77    2.52    2.47    2.37    2.99    2.95    2.48    2.11    2.55    2.53    2.4     2.93    2.73    2.17    2.1
8       2.79    2.57    2.59    2.66    2.29    2.58    2.04    2.36    2.45    2.04    2.53    2.84    2.05    2.88    2.21
9       2.17    2.29    2.96    2.46    2.56    2.59    2.25    2.33    2.59    2.91    2.39    2.19    2.2     2.03    2.88
10      3       2.34    2.87    2.72    2.78    2.8     2.74    2.03    2.39    2.45    2.14    2.5     2.06    2.35    2.04
11      2.72    2.48    2.9     2.26    2.4     2.27    2.78    2.39    2.49    2.92    2.47    2.52    2.67    2.82    2.89
12      2.1     2.37    2.09    2.73    2.39    2.17    2.72    2.68    2.17    2.03    2.76    2.67    2.94    2.53    2.24
13      2.11    2.03    2.7     2.77    2.61    2.95    2.21    2.1     2.22    2.38    2.51    2.66    2.92    2.89    2.94
;

Set equip(j,pr)
/
1.(1,2,3,4)
2.(5,6)
3.(7,8,9)
4.(10,11)
5.(12,13)
6.(14,15)
/
;

parameter count;
set Eq(k,j,pr);
set Eq2(k,j);
loop(j,
        count = 0;
        loop(pr,
                if(equip(j,pr),count = count + 1;
                        loop(k,
                                if(ord(k) eq ord(pr),
                                        Eq(k,j,pr) = yes;
                                        Eq2(k,j) = yes;
                                );
                                if(ord(j) eq (ord(k)-card(pr)),
                                        Eq2(k,j) = yes;
                                );
                        );
                );
        );
);

Set flow_in(j,fl) "Inlet flow for the given disjunction"
/
1.1
2.2
3.5
4.6
5.9
6.10
/
;
Set flow_out(j,fl) "Outlet flow for the given disjunction"
/
1.3
2.4
3.7
4.8
5.11
6.12
/
;

Variables
F(fl)
,C(j)
,alpha
;


set nodes "Nodes in process network where mass balances are enforced" /1*12/;

table flows(nodes,fl) "Possible flows for mass balances"
        1       2       3       4       5       6       7       8       9       10      11      12      13
1                       -1      -1      1
2                               -1              1
3                       -1      -1      1       1
4                                                       -1      -1      1       1
5                                                                                       -1      -1      1
;


set in(nodes,fl), out(nodes,fl);
in(nodes,fl)$(flows(nodes,fl)=-1)=yes;
out(nodes,fl)$(flows(nodes,fl)=1)=yes;

set input(j,fl), output(j,fl);
input(j,fl)$(flow_in(j,fl))=yes;
output(j,fl)$(flow_out(j,fl))=yes;

parameter cost(fl) Flow costs
/
1        0.65
2        0.74
3        0.18
4        0.11
5        0.21
6        0.12
7        0.26
8        0.29
9        0.22
10        0.11
11        0.19
12        0.16
/
;

Equations
         EQ_I_Disj(k,de) disjunctive inequality constraints
         fobj "Objective function"
         mass_balance(nodes)
         disjunction(j) "disjunctions given by equality constraints"
        disagf(j,fl)    flows disaggregation constraint for convex hull reformulation
        disagc(j)       costs disaggregation constraint for convex hull reformulation
        boundsf_up(k,j,fl)      flow upper bounds constraints for convex hull reformulation
        boundsf_lo(k,j,fl)      flow lower bounds constraints for convex hull reformulation
        boundsc_up(k,j)         cost upper bounds constraints for convex hull reformulation
        boundsc_lo(k,j)         cost lower bounds constraints for convex hull reformulation
        boundsFagg_up(k,j,fl)      aggregated flow upper bounds constraints for convex hull reformulation
        boundsCagg_up(k,j)      aggregated flow upper bounds constraints for convex hull reformulation
;
scalar epsilon /1e-4/;
positive variables Fs(k,fl), Cs(k,j);
* Bounds on variables --------------------------
parameter Flo(fl), Fup(fl);
Flo(fl) = 0;
Flo(fl)$(ord(fl) eq card(fl)) = 0.6;
Fup(fl) = 4;
parameter Clo(j), Cup(j);
Clo(j) = 0;
Cup(j) = 4.2;

alias(k,k1);
alias(k,k2);
* Objective function definition
fobj.. alpha =G= sum(fl,cost(fl)*F(fl)) + sum(j,C(j));
*Mass balances
mass_balance(nodes).. sum(in(nodes,fl),F(fl)) =G= sum(out(nodes,fl),F(fl));
*Logical implications for disaggregation
disjunction(j).. sum((k1,equip(j,pr))$(ord(k1) eq ord(pr)),Y(k1)) + sum(k2$(ord(k2) eq card(pr)),Y(k2 + ord(j))) =G= 1;
*Inequalities appearing in the disjunctions
EQ_I_Disj(k,de)..
 + (sum((output(j,fl),input(j,fl1),Eq(k,j,pr)),((1-epsilon)*Y(k) + epsilon)*(d(fl,pr)*(EXP(Fs(k,fl)*t(fl,pr)/((1-epsilon)*Y(k) + epsilon))-1)) - Fs(k,fl1)))$((ord(de)=1))
 + (sum((output(j,fl),Eq(k,j,pr)),( - Cs(k,j) + beta(fl,pr)*Fs(k,fl) + y(k)*gamma(fl,pr))))$((ord(de)=2))
=L= 0
;
*Aggregated variable bounds activated by binary variables
boundsFagg_up(k,j,fl)$((output(j,fl)) and Eq2(k,j) and ord(k) > card(pr)).. F(fl) =l= (Fup(fl)*(1-y(k)));
boundsCagg_up(k,j)$(Eq2(k,j) and ord(k) > card(pr)).. C(j) =l= (Cup(j)*(1-y(k)));
*Disaggregation constraints
disagf(j,fl)$((output(j,fl) or input(j,fl))).. sum(k$(Eq2(k,j) and ord(k) <= card(pr)),fs(k,fl)) =e= f(fl);
disagc(j).. sum(k$(Eq2(k,j) and ord(k) <= card(pr)),Cs(k,j)) =e= C(j);
*Disaggregated variable bounds activated by binary variables
boundsf_up(k,j,fl)$((output(j,fl) or input(j,fl)) and Eq2(k,j) and ord(k) <= card(pr))..          fs(k,fl) =l= (Fup(fl)*y(k));
boundsf_lo(k,j,fl)$((output(j,fl) or input(j,fl)) and Eq2(k,j) and ord(k) <= card(pr))..          fs(k,fl) =g= (Flo(fl)*y(k));
fs.lo(k,fl) = Flo(fl);
fs.up(k,fl) = Fup(fl);
boundsc_up(k,j)$(Eq2(k,j) and ord(k) <= card(pr))..          Cs(k,j) =l= (Cup(j)*y(k));
boundsc_lo(k,j)$(Eq2(k,j) and ord(k) <= card(pr))..          Cs(k,j) =g= (Clo(j)*y(k));

F.lo(fl) = Flo(fl);
F.up(fl) = Fup(fl);
C.lo(j) = Clo(j);
C.up(j) = Cup(j);
alpha.up=sum(j,Cup(j)) + sum(fl,Fup(fl));
alpha.lo=0;

MODEL prob / ALL / ;

*option minlp = baron;

SOLVE prob USING minlp MINIMIZING alpha ;