execseed =         8;
set      k               disjunctions                    /1*10/
         i               disjunctive terms               /1*5/
         j               dimension of variables          /1*10/
;
alias(i,ii);
alias(j,jj);


**** END USER INPUT

* printing results
set      reform          /
                         BM
                         HR
                         HRL
                         HR2
                         HR2conv
                         HR2c
                         rBM
                         rHR
                         rHRL
                         rHR2
                         rHR2conv
                         /
;
set      metrics         /
                         obj
                         time
                         node
                         gap
                         /
;
set      solvers         /
                         CONOPT
                         IPOPT
                         KNITRO
                         GUROBI
                         CPLEX
                         BARON
                         SBB_CONOPT
                         SBB_IPOPT
                         SBB_KNITRO
                         SBB_GUROBI
                         SBB_CPLEX
                         SBB_MOSEK
                         MOSEK
                         DICOPT_IPOPT_GUROBI
                         DICOPT_MOSEK_GUROBI
                         SCIP
                         /
;
set      mods            /
                         BM
                         HR
                         HR2
                         HR2c
                         HR2conv
                         /
;
set      stats           /
                         nvars
                         neqs
                         ndvars
                         /
;

parameter        results(metrics,reform,solvers)
                 prob_stat(stats,mods);

* Generate random problem

parameters       c(j)            cost coefficient for variable j
                 a1(k,i,j)       quadratic coefficient for variable j
                 a2(k,i,j)       linear coefficient for variable j
                 a3(k,i)         constant coefficient
                 x_up(j)         upper bound for var j
                 x_lo(j)         lower bound for var j
                 M(k,i)
                 lambda(k,j)
;

c(j)       = uniform(-1,1)*1000;
a1(k,i,j)  = uniform(.01,1);
a2(k,i,j)  = uniform(-1,1);
a3(k,i)    = uniform(-1,1);
x_up(j)    = 100;
x_lo(j)    = -100;


* Begin problem

variables        obj
                 x(j)
                 ni(k,i,j)
                 ni_cone(k,i,j)
;

binary variable  y(k,i);

positive variable t(k,i);

equations        objective
                 disj_BM
                 sum_bin
                 disag
                 disj_HRLee
                 disj_HR
                 bound_up
                 bound_lo
                 disag2
                 disj_HR2
                 disj_HR2conv
                 disj_HR2c
                 extr_HR2
                 cone_HR2
                 bound_up2
                 bound_lo2
;

*Variable bounds
parameter ni_center(k,i,j),ni_min(k,i,j),ni_max(k,i,j),max_dev(k,i,j);

ni_center(k,i,j) = -a2(k,i,j)/(2*a1(k,i,j));
ni.up(k,i,j) = min((-a2(k,i,j)+sqrt(sqr(a2(k,i,j))-4*a1(k,i,j)*(a3(k,i)-1+sum(jj$(ord(j) ne ord(jj)),a1(k,i,jj)*sqr(ni_center(k,i,jj))+a2(k,i,jj)*ni_center(k,i,jj)))))/(2*a1(k,i,j)),x_up(j));
ni.lo(k,i,j) = max((-a2(k,i,j)-sqrt(sqr(a2(k,i,j))-4*a1(k,i,j)*(a3(k,i)-1+sum(jj$(ord(j) ne ord(jj)),a1(k,i,jj)*sqr(ni_center(k,i,jj))+a2(k,i,jj)*ni_center(k,i,jj)))))/(2*a1(k,i,j)),x_lo(j));
x.up(j) = min(smax((k,i),ni.up(k,i,j)),x_up(j)) ;
x.lo(j) = max(smin((k,i),ni.lo(k,i,j)),x_lo(j)) ;
ni_cone.up(k,i,j) = sqrt(2*a1(k,i,j))*ni.up(k,i,j) ;
ni_cone.lo(k,i,j) = sqrt(2*a1(k,i,j))*ni.lo(k,i,j) ;
t.up(k,i) = min(1 - a3(k,i) + max(-sum(j,a2(k,i,j)*ni.up(k,i,j)),-sum(j,a2(k,i,j)*ni.lo(k,i,j))),
            max(sum(j,a1(k,i,j)*sqr(ni.up(k,i,j))),sum(j,a1(k,i,j)*sqr(ni.lo(k,i,j)))));

*Calculation M parameter
ni_min(k,i,j) = (-a2(k,i,j)-sqrt(sqr(a2(k,i,j))-4*a1(k,i,j)*(a3(k,i)-1+sum(jj$(ord(j) ne ord(jj)),a1(k,i,jj)*sqr(ni_center(k,i,jj))+a2(k,i,jj)*ni_center(k,i,jj)))))/(2*a1(k,i,j));
ni_max(k,i,j) = (-a2(k,i,j)+sqrt(sqr(a2(k,i,j))-4*a1(k,i,j)*(a3(k,i)-1+sum(jj$(ord(j) ne ord(jj)),a1(k,i,jj)*sqr(ni_center(k,i,jj))+a2(k,i,jj)*ni_center(k,i,jj)))))/(2*a1(k,i,j));
max_dev(k,i,j) = max(smax(ii,abs(ni_center(k,i,j)-ni_min(k,ii,j))),smax(ii,abs(ni_center(k,i,j)-ni_max(k,ii,j))));
M(k,i) = sum(j,sqr(max_dev(k,i,j))*a1(k,i,j)) + a3(k,i) - sum(j, a1(k,i,j)*sqr(ni_center(k,i,j)));

scalar epsilon /1e-4/;

objective ..               obj =e= sum(j,c(j)*x(j));
disj_BM(k,i)..             sum(j,a1(k,i,j)*sqr(x(j))) + sum(j,a2(k,i,j)*x(j)) + a3(k,i) =l= 1 + M(k,i)*(1-y(k,i));
sum_bin(k)..               sum(i,y(k,i)) =e= 1;

*HR
disj_HRLee(k,i)..          sum(j,a1(k,i,j)*sqr(ni(k,i,j)))/(y(k,i)+epsilon) + sum(j,a2(k,i,j)*ni(k,i,j)) =l= (1 - a3(k,i))*y(k,i);
disj_HR(k,i)..             sum(j,a1(k,i,j)*sqr(ni(k,i,j)))/(y(k,i)*(1-epsilon)+epsilon) + sum(j,a2(k,i,j)*ni(k,i,j)) =l= (1 - a3(k,i))*y(k,i);
disag(k,j)..               sum(i,ni(k,i,j)) =e= x(j);
bound_up(k,i,j)..          ni(k,i,j) =l= x_up(j)*y(k,i);
bound_lo(k,i,j)..          ni(k,i,j) =g= x_lo(j)*y(k,i);

*HR2
disj_HR2(k,i)..            (y(k,i)*t(k,i)) =g= sum(j,a1(k,i,j)*sqr(ni(k,i,j)));
disj_HR2conv(k,i)..        sqr(y(k,i) + t(k,i)) =g= (sum(j,a1(k,i,j)*sqr(ni(k,i,j)))*4 + sqr(y(k,i) - t(k,i)));
extr_HR2(k,i)..            t(k,i) + sum(j,a2(k,i,j)*ni(k,i,j)) =l= (1 - a3(k,i))*y(k,i);

disj_HR2c(k,i)..           2*(y(k,i)*t(k,i)) =g= sum(j,sqr(ni_cone(k,i,j)));
cone_HR2(k,i,j)..          ni_cone(k,i,j) =e= sqrt(2*a1(k,i,j))*ni(k,i,j);

model prob_BM /objective,disj_BM,sum_bin/;
model prob_HR /objective,disj_HR,sum_bin,disag,bound_up,bound_lo/;
model prob_HRL /objective,disj_HRLee,sum_bin,disag,bound_up,bound_lo/;
model prob_HR2 /objective,disj_HR2,sum_bin,disag,bound_up,bound_lo,extr_HR2/;
model prob_HR2conv /objective,disj_HR2conv,sum_bin,disag,bound_up,bound_lo,extr_HR2/;
model prob_HR2c /objective,disj_HR2c,sum_bin,disag,bound_up,bound_lo,extr_HR2,cone_HR2/;

prob_BM.nodLim = 1e8;
prob_HR.nodLim = 1e8;
prob_HRL.nodLim = 1e8;
prob_HR2.nodLim = 1e8;
prob_HR2c.nodLim = 1e8;

option   optcr = 1e-5
         reslim = 3600
         iterlim = 1e9
         solprint = off
         limrow = 0
         limcol = 0
         bratio = 1
         threads = 1
;
* Solve BM reformulation continuous relaxations
x.l(j) = 1;
y.l(k,i) = 1;
ni.l(k,i,j) = 1;



$if not set MINLP $set MINLP MINLP
Solve prob_HRL using %MINLP% minimizing obj;
