SET k          number of disjunctions                          /1*6/
    i          max number of terms in a single disjunction     /1*5/
    ki(k,i)    terms in disjunction
    de         max number of equations in a disjunctive term   /1*2/


BINARY VARIABLES    Y(k,i);

parameter demand /0.6/;

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

Set equip(k,pr)
/
1.(1,2,3,4)
2.(5,6)
*2.5
3.(7,8,9)
4.(10,11)
5.(12,13)
6.(14,15)
/
;

parameter count;
parameter imax(k) "Actual maximum number of terms per disjunction"
set Eq(k,i,pr);
loop(k,
	count = 0;
	loop(pr,
		if(equip(k,pr),count = count + 1;
		loop(i,
			if(ord(i) eq count, Eq(k,i,pr) = yes; );
		);
		);
	);
	imax(k) = count + 1;
);


loop(k,
     ki(k,i)$((ord(i)<=imax(k)))=yes;
);

PARAMETER kieq(k,i) number of equation in disjunctive terms;
kieq(k,i) = 2;

PARAMETER disjterms(k);
disjterms(k) = sum(ki(k,i),1);

Set flow_in(k,fl) "Inlet flow for the given disjunction"
/
1.1
2.2
3.5
4.6
5.9
6.10
/
;
Set flow_out(k,fl) "Outlet flow for the given disjunction"
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
,C(k)
,alpha
;


set nodes "Nodes in process network where mass balances are enforced" /1*5/;

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

set input(k,fl), output(k,fl);
input(k,fl)$(flow_in(k,fl))=yes;
output(k,fl)$(flow_out(k,fl))=yes;

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
         EQ_I_Disj(k,i,de) disjunctive inequality constraints
         fobj "Objective function"
         mass_balance(nodes)
         dummy             dummy to get all disjunction variables in the model
        disagf(k,fl)    flows disaggregation constraint for convex hull reformulation
        disagc(k)       costs disaggregation constraint for convex hull reformulation
        boundsf_up(k,i,fl)      flow upper bounds constraints for convex hull reformulation
        boundsf_lo(k,i,fl)      flow lower bounds constraints for convex hull reformulation
        boundsc_up(k,i)         cost upper bounds constraints for convex hull reformulation
        boundsc_lo(k,i)         cost lower bounds constraints for convex hull reformulation
;

* Bounds on variables --------------------------
parameter Flo(fl), Fup(fl);
Flo(fl) = 0;
Flo(fl)$(ord(fl) eq card(fl)) = demand;
Fup(fl) = 4;

parameter Clo(k), Cup(k);
Clo(k) = 0;
Cup(k) = 4.2;

scalar epsilon /1e-4/;

*Disaggregated variables
positive variables fs(k,i,fl), cs(k,i);

* Objective function definition
fobj.. alpha =G= sum(fl,cost(fl)*F(fl)) + sum(k,C(k));
*Mass balances
mass_balance(nodes).. sum(in(nodes,fl),F(fl)) =G= sum(out(nodes,fl),F(fl));
*Conic reformulation in exponential cone Kexp(x1,x2,x3):x1 >= x2*exp(x3/x2), x2 >= 0;
*g(v1,v2): v1 >= y*exp(F*t/y) <=> Kexp(v1,y,F*t);
*Conic formulation
*0 >= d*(v1-y)-F2; v1 >= y*exp(v2/y) <=> Kexp(v1,v2,v3); v2 == F*t
*Initialize variables values for undefined terms
Y.l(k,i)=1;
equation extra_const1, extra_const2;
positive variable extra_var1(k,i,fl,pr), extra_var2(k,i,fl,pr);
extra_const2(k,i,pr,fl)$(ki(k,i) and Eq(k,i,pr) and output(k,fl)).. extra_var2(k,i,fl,pr) =E= Fs(k,i,fl)*t(fl,pr);
extra_const1(k,i,pr,fl)$(ki(k,i) and Eq(k,i,pr) and output(k,fl)).. extra_var1(k,i,fl,pr) =G= Y(k,i)*EXP(extra_var2(k,i,fl,pr)/(Y(k,i)));

*Disjunction inequalities
EQ_I_Disj(k,i,de)$ki(k,i).. 0 =G=
 + (sum((output(k,fl),input(k,fl1),Eq(k,i,pr)),(d(fl,pr)*(extra_var1(k,i,fl,pr)-Y(k,i))) - Fs(k,i,fl1)))$((ord(de)=1))
 + sum(output(k,fl),Fs(k,i,fl))$((ord(de)=1) and ord(i) eq imax(k))

 + (sum((output(k,fl),Eq(k,i,pr)),( - Cs(k,i) + beta(fl,pr)*Fs(k,i,fl) + y(k,i)*gamma(fl,pr))))$((ord(de)=2))
 + (Cs(k,i))$((ord(de)=2) and ord(i) eq imax(k))
;

*Flows and cost disaggregated variables
disagf(k,fl)$(output(k,fl) or input(k,fl)).. sum(i$ki(k,i),fs(k,i,fl)) =e= f(fl);
disagc(k).. sum(i$ki(k,i),Cs(k,i)) =e= C(k);

*Bounds on the disaggregated flow variables
boundsf_up(k,i,fl)$((output(k,fl) or input(k,fl)) and ki(k,i))..          fs(k,i,fl) =l= Fup(fl)*y(k,i);
boundsf_lo(k,i,fl)$((output(k,fl) or input(k,fl)) and ki(k,i))..          fs(k,i,fl) =g= Flo(fl)*y(k,i);

fs.lo(k,i,fl)$(output(k,fl) or input(k,fl)) = Flo(fl);
fs.up(k,i,fl)$(output(k,fl) or input(k,fl)) = Fup(fl);

*Bounds on the disaggregated cost variables
boundsc_up(k,i)$ki(k,i)..          Cs(k,i) =l= Cup(k)*y(k,i);
boundsc_lo(k,i)$ki(k,i)..          Cs(k,i) =g= Clo(k)*y(k,i);

Cs.lo(k,i) = Clo(k);
Cs.up(k,i) = Cup(k);

*Extra logic XOR constraint
dummy(k).. sum(i$ki(k,i), Y(k,i)) =e= 1;

F.lo(fl) = Flo(fl);
F.up(fl) = Fup(fl);
C.lo(k) = Clo(k);
C.up(k) = Cup(k);
alpha.up=sum(k,Cup(k)) + sum(fl,Fup(fl));
alpha.lo=0;

MODEL prob / ALL / ;

*option minlp = mosek;

SOLVE prob USING minlp MINIMIZING alpha ;

