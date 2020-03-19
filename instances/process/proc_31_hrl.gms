*option limrow=10,limcol=10;

SET k          number of disjunctions                          /1*10/
    i          max number of terms in a single disjunction     /1*6/
    ki(k,i)    terms in disjunction
    de         max number of equations in a disjunctive term   /1*2/


BINARY VARIABLES    Y(k,i);

parameter demand /0.6/;

set fl "Flows" /1*24/;
alias(fl,fl1);
set pr "Processes" /1*31/;
table d(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31
1       1.06    1.1     1.05    1.13    1.07    1.05    1.01    1.12    1.07    1.05    1.05    1.07    1.01    1.18    1.07    1.13    1.1     1.06    1.16    1.15    1.17    1.19    1.15    1.13    1.13    1.09    1.08    1.17    1.19    1.04    1.16
2       1.17    1.1     1.1     1.03    1.16    1.17    1.17    1.03    1.11    1.12    1.07    1.07    1.16    1.03    1.05    1.13    1.04    1.14    1.05    1.1     1.16    1.16    1       1.05    1.16    1.18    1.01    1.09    1.05    1.08    1.06
3       1.12    1.04    1.02    1.07    1.01    1.05    1.12    1.18    1.03    1.05    1.04    1.19    1.08    1.15    1.01    1.02    1.07    1.17    1.06    1.1     1.02    1.1     1.15    1.05    1.02    1.05    1.14    1.03    1.1     1.18    1.01
4       1.14    1.13    1.02    1.05    1.14    1.12    1.01    1.05    1.08    1.2     1.16    1.12    1.02    1.15    1.11    1.04    1.15    1.11    1.04    1.19    1.06    1.16    1.18    1.05    1.11    1.12    1.14    1.04    1.06    1.05    1.04
5       1.14    1.2     1.01    1       1.07    1.01    1.13    1.04    1.06    1.02    1.15    1.04    1.09    1.12    1.11    1.03    1.18    1.14    1.1     1.15    1.01    1.1     1       1.11    1.11    1.02    1.13    1.17    1.11    1.05    1.06
6       1.18    1.16    1.18    1.11    1.18    1.16    1.16    1.15    1.11    1.04    1.07    1.11    1.01    1.16    1.19    1.12    1.17    1.08    1.19    1       1.08    1.11    1.06    1.13    1.07    1.03    1.14    1       1.19    1.05    1.04
7       1.18    1.02    1.12    1.1     1.09    1       1.06    1.2     1.12    1.13    1.19    1.12    1.11    1.07    1.06    1.03    1.14    1.04    1.19    1.13    1.15    1.07    1       1.14    1.02    1.14    1.06    1.18    1.02    1.13    1.14
8       1.02    1.01    1.17    1.07    1.18    1.17    1.16    1.18    1.19    1.05    1.19    1.09    1.01    1.18    1       1.11    1.08    1.05    1.08    1.1     1.08    1.05    1.13    1.15    1.06    1.13    1.06    1.08    1.07    1.02    1.01
9       1.02    1.07    1.1     1.06    1.01    1.12    1.08    1.13    1.06    1.2     1.1     1.13    1.17    1.19    1.17    1.07    1.07    1.15    1.01    1.03    1.04    1.16    1.12    1.01    1.19    1.06    1.2     1.19    1.19    1.17    1.04
10      1.03    1.09    1.19    1       1.04    1.1     1.18    1.03    1.09    1.01    1.02    1.02    1.06    1.01    1.1     1.09    1.16    1.12    1.18    1.17    1.19    1.09    1.08    1.17    1.12    1.03    1.11    1.02    1.13    1       1.04
11      1.12    1.09    1.13    1.08    1.19    1.12    1.16    1.16    1.18    1.13    1.06    1.07    1.05    1.15    1.09    1.09    1.04    1.13    1.1     1.1     1.05    1.12    1.01    1.07    1.06    1.02    1.07    1.06    1.1     1.09    1.07
12      1.11    1.17    1.02    1.03    1.17    1.13    1.03    1.02    1.02    1.04    1.01    1.12    1.1     1.05    1.16    1.1     1.11    1.11    1.16    1.16    1.2     1.13    1.12    1       1.06    1.01    1.12    1.08    1.1     1.18    1.05
13      1       1.2     1       1.12    1.2     1.05    1.15    1       1.04    1.14    1.06    1.1     1.05    1.1     1.16    1.06    1.06    1.05    1.04    1.12    1.19    1.04    1.02    1.05    1.02    1.05    1.02    1.1     1.05    1.15    1.12
14      1.16    1.16    1.14    1.1     1.14    1.14    1.01    1.09    1.1     1.2     1.15    1.18    1.1     1.05    1.08    1.1     1.03    1.1     1.16    1.12    1       1.16    1.13    1.08    1.19    1.11    1.09    1.17    1.07    1.15    1.07
15      1       1.04    1.04    1.02    1.12    1.09    1.12    1.02    1.06    1.17    1.13    1.12    1.19    1.03    1.04    1.08    1.15    1.05    1.14    1.06    1.06    1.03    1.19    1.13    1.1     1.2     1.16    1.01    1       1.06    1.01
16      1.08    1.16    1.05    1.12    1.02    1.01    1.2     1.19    1.13    1.01    1.03    1.12    1.02    1.12    1.16    1.1     1.18    1.19    1.18    1.19    1.16    1.18    1.1     1.02    1.12    1.17    1.03    1.08    1.13    1.05    1.18
17      1.04    1.07    1.13    1.04    1.04    1.15    1.1     1.1     1.18    1.03    1.13    1.02    1.07    1.18    1.05    1.1     1.17    1.03    1.12    1.06    1.07    1.13    1.16    1.17    1.01    1.09    1.18    1.12    1.12    1.1     1.01
18      1.16    1.13    1.03    1.05    1.15    1.12    1.03    1.14    1.13    1.13    1.16    1.07    1.01    1.06    1.07    1.04    1.08    1.09    1.06    1.09    1.01    1.07    1.1     1.1     1.18    1.05    1.02    1.08    1.07    1.14    1.17
19      1.06    1.01    1.09    1.03    1.1     1.07    1.18    1.07    1.06    1.15    1.17    1.13    1.2     1.11    1.02    1.1     1.17    1.18    1.13    1.07    1.11    1.01    1.17    1.01    1.06    1.14    1.02    1.09    1.17    1.06    1.02
20      1.2     1.17    1.03    1.06    1.18    1.18    1.18    1.12    1.07    1.17    1.07    1.04    1.14    1.15    1.19    1.02    1.13    1.06    1.15    1.1     1.18    1.07    1.13    1.13    1.01    1.19    1.12    1.03    1.09    1.07    1.11
21      1.08    1.09    1       1.15    1.02    1.12    1.18    1.03    1.15    1.01    1.06    1.12    1.1     1.14    1.14    1.05    1.05    1.19    1.07    1.12    1.13    1.08    1.05    1.17    1.12    1.13    1.2     1.15    1.06    1.18    1.05
22      1.09    1.05    1.16    1.12    1.05    1.07    1.06    1       1.16    1.02    1.16    1.05    1.12    1.14    1.12    1.16    1.09    1       1.03    1.16    1.17    1.09    1.14    1.14    1.2     1.11    1.15    1.16    1.08    1.19    1
23      1.09    1.12    1.17    1.18    1.02    1.19    1.06    1.1     1.19    1.16    1.09    1.09    1.03    1.2     1.01    1.14    1.04    1.16    1.15    1.13    1.16    1.16    1.13    1.02    1.2     1.04    1.17    1.06    1.16    1.01    1.14
24      1.02    1.12    1.12    1.02    1.12    1.1     1.04    1.03    1.18    1.1     1.08    1.01    1.06    1.01    1.09    1.19    1.03    1       1.07    1.14    1.09    1.1     1.17    1.04    1.19    1.11    1.02    1.1     1.12    1.1     1.15
;
table t(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31
1       1.17    1.29    1.14    1.18    1.24    1.12    1.19    1.18    1.11    1.18    1.05    1.12    1.14    1.25    1.12    1.29    1.02    1.28    1.08    1.22    1.04    1.21    1.06    1.3     1.18    1.19    1.27    1.07    1.07    1.14    1.02
2       1.21    1.21    1.18    1.02    1.01    1.26    1.21    1.25    1.29    1.14    1.27    1.09    1.01    1.04    1.02    1.01    1.19    1.23    1.17    1.01    1.25    1.16    1.14    1.07    1.11    1.15    1.05    1.08    1.24    1.01    1.04
3       1.14    1.26    1.06    1.1     1.19    1.23    1.21    1.3     1.25    1.23    1.16    1.09    1.07    1.27    1.07    1.01    1.17    1.08    1.26    1.16    1.16    1.15    1.13    1.15    1.2     1.1     1.13    1.22    1.28    1.08    1.17
4       1.19    1.11    1.03    1.2     1.06    1.04    1.02    1.23    1.06    1.27    1.1     1       1.2     1.25    1.02    1.05    1.23    1.02    1.14    1.24    1.19    1.23    1.13    1.23    1.02    1.06    1.01    1.22    1.23    1.2     1.1
5       1.18    1.13    1.02    1.02    1.08    1.27    1.15    1.11    1.16    1.24    1.24    1.06    1.01    1.06    1.19    1.24    1.01    1.16    1.06    1.18    1       1.19    1.3     1.17    1       1.23    1.27    1.17    1.07    1.09    1.17
6       1.25    1.18    1.29    1.22    1.12    1.26    1.08    1.21    1.27    1.18    1.06    1.08    1.18    1.1     1.27    1.21    1.08    1.3     1.16    1.12    1.21    1.11    1.11    1.19    1.02    1.25    1.25    1.09    1.06    1.08    1.15
7       1.16    1.04    1.28    1.1     1.12    1.11    1.15    1.1     1.07    1.17    1.11    1.22    1.03    1.2     1.22    1.25    1.05    1.02    1       1.29    1.05    1.19    1.01    1.25    1.08    1.18    1.27    1.21    1.28    1.07    1.09
8       1.24    1.12    1.27    1.13    1.18    1.18    1.01    1.21    1.27    1.1     1.01    1.16    1.24    1.2     1.07    1.1     1.05    1.11    1.03    1.26    1.18    1.18    1.23    1.16    1.24    1.25    1.16    1.09    1.19    1.02    1.12
9       1.26    1.25    1.19    1.14    1.08    1.08    1.15    1.27    1.25    1.12    1.29    1       1.01    1.16    1.24    1.28    1.07    1.14    1.1     1.1     1.12    1.26    1.09    1.29    1.01    1.16    1.26    1.05    1.06    1.23    1.11
10      1.14    1.13    1.18    1.08    1.3     1.09    1.01    1.09    1.05    1.21    1.16    1.26    1.02    1.02    1.14    1.18    1.28    1.27    1.16    1.21    1.25    1.24    1.21    1.13    1.02    1.22    1.03    1.07    1.09    1.14    1.05
11      1.13    1.17    1.09    1.26    1.21    1.01    1.18    1.21    1.25    1.09    1.04    1.2     1.15    1.26    1.17    1.2     1.06    1.3     1.16    1.23    1.22    1.25    1.16    1.26    1       1.11    1.28    1.04    1.07    1.09    1.1
12      1.01    1.06    1.21    1.18    1.23    1.19    1.01    1.27    1.29    1.07    1.13    1.01    1.06    1.06    1.02    1.21    1.24    1.15    1.08    1.08    1.08    1.14    1.21    1.05    1.07    1.14    1.29    1.27    1.2     1.13    1.08
13      1.24    1.04    1.13    1.22    1.16    1.19    1.14    1.05    1.03    1.17    1.13    1.15    1.23    1.05    1.16    1       1.04    1.23    1.16    1.12    1.3     1.06    1.28    1.06    1.07    1.04    1.2     1.1     1.02    1.25    1.15
14      1.17    1.05    1.12    1.03    1.14    1.06    1.07    1.17    1.2     1.09    1.21    1.24    1.1     1.26    1.07    1.14    1.24    1.12    1.13    1.07    1.26    1.15    1.11    1.26    1.18    1.2     1.22    1.2     1.19    1.09    1.18
15      1.01    1.18    1.27    1.02    1.16    1.19    1.19    1.08    1.04    1.29    1.1     1.07    1.14    1.01    1.3     1.19    1.26    1.26    1.04    1.25    1.11    1.18    1.07    1.24    1.23    1.07    1.23    1.24    1.01    1.01    1.05
16      1.19    1.01    1.13    1.3     1.24    1.2     1.09    1.17    1.13    1.23    1.01    1.29    1.19    1.06    1.19    1.07    1.14    1.1     1.02    1.02    1.15    1.09    1.3     1.1     1.04    1.29    1.29    1.17    1.17    1.04    1.05
17      1.22    1.22    1.02    1.2     1.21    1.04    1.25    1.07    1.16    1.29    1.17    1.23    1       1.16    1.12    1.02    1.06    1.19    1.29    1.27    1.06    1.26    1.01    1.02    1.25    1.12    1.09    1.11    1.24    1.26    1.11
18      1.24    1       1.21    1.15    1.1     1.22    1.24    1.2     1.17    1.03    1.07    1.25    1.03    1.02    1.03    1.12    1.12    1.11    1.28    1.03    1.06    1.07    1.22    1.2     1.26    1.09    1.03    1.18    1.09    1.18    1.25
19      1.01    1.19    1.07    1.04    1.29    1.02    1.05    1.15    1.27    1.04    1.24    1.08    1.1     1.28    1.17    1.26    1.26    1.19    1.1     1.08    1.09    1.13    1.2     1.19    1       1.06    1.16    1.07    1.29    1.04    1.06
20      1.28    1.04    1.08    1.08    1.17    1.19    1.08    1.08    1.24    1.02    1.05    1.11    1.07    1.15    1.13    1.18    1.2     1.21    1.25    1.2     1.07    1.02    1.09    1.15    1.05    1.04    1.03    1.23    1.05    1.21    1.05
21      1.09    1.21    1.24    1.01    1.04    1.04    1.03    1.01    1.12    1.14    1.08    1.13    1.05    1.3     1.03    1.23    1.1     1.24    1.14    1.12    1.24    1.08    1.07    1.13    1.22    1.19    1.26    1.3     1.22    1.04    1.11
22      1.21    1.3     1.04    1.18    1.29    1.1     1.1     1.04    1.21    1.13    1.11    1.19    1.21    1.13    1.08    1.02    1.09    1.25    1.15    1.25    1.22    1.01    1.01    1.11    1.27    1.02    1.15    1.07    1.3     1.16    1.28
23      1.29    1.01    1.14    1.09    1.14    1.12    1.22    1.27    1.16    1.02    1.25    1.14    1.24    1.28    1.07    1.17    1.15    1.04    1.19    1.15    1.14    1.11    1.24    1.11    1.03    1.08    1.26    1.28    1.25    1.27    1.19
24      1.26    1       1.08    1.12    1.24    1.22    1.05    1.17    1.01    1.05    1.01    1.24    1.26    1.28    1.25    1.08    1.11    1.26    1.26    1.16    1.01    1.26    1.09    1.3     1.15    1.01    1.26    1.26    1.04    1.11    1.03
;
table beta(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31
1       0.97    0.9     0.9     1.05    0.91    0.91    1.05    1.13    0.84    1.01    0.86    1       0.86    1       0.84    1.01    0.96    1.19    0.95    0.95    0.9     1.03    1.12    1       1.14    0.99    1.12    1.02    1.18    0.85    1.01
2       0.87    0.94    1.03    0.97    0.94    0.85    0.95    0.87    0.97    0.85    1.05    0.95    1.14    0.81    0.86    0.98    1.06    0.84    0.87    1.01    1.12    0.94    0.99    1.02    1.12    1.2     1.11    1.15    0.85    1.11    1.15
3       1.09    0.81    1.16    0.83    1.16    0.82    0.96    1.13    1.11    0.92    1.11    1.07    0.88    0.92    0.87    0.92    0.93    1.14    0.9     0.97    0.87    0.89    0.96    0.92    0.81    1.07    1.03    0.97    0.81    1.14    1.02
4       0.88    1.05    0.83    0.98    0.99    1.09    1.03    1.02    0.8     1.08    1.01    0.98    0.92    1.16    1.14    1.06    0.92    1.15    1.1     1.11    0.97    0.95    0.96    1.16    0.85    0.9     0.81    1.05    0.94    1       1.1
5       1.13    0.8     0.9     0.9     1.02    1.17    0.82    0.93    0.87    0.98    0.97    0.87    0.94    1.03    0.86    0.98    0.84    1       0.89    0.93    1.14    1.06    1.11    0.94    0.99    1.06    0.8     0.87    1.02    0.8     0.9
6       1       0.8     1.1     1.01    0.87    0.9     0.99    0.95    0.84    0.95    0.99    0.93    1.02    1.1     0.99    0.97    1.1     1.1     1.03    1.05    0.92    0.94    0.84    1.03    0.89    0.92    0.81    0.91    0.86    1.11    0.99
7       1.02    1.04    1.14    1.14    0.96    1.07    0.8     0.81    1.09    0.93    0.95    1.06    0.98    1.11    0.93    0.93    1.04    0.97    0.97    1.07    1.13    1.19    1.09    0.92    0.97    0.87    1.13    1.14    1.15    0.99    0.98
8       0.8     0.83    1       1.19    1.03    1.04    0.98    0.91    1.14    1.16    1.03    0.95    1       0.86    1.17    0.99    1.04    1.13    0.86    1.05    1.2     1.08    1.2     1       1       1.18    0.94    0.82    1.2     0.9     0.82
9       0.98    1.02    0.89    0.9     1.17    1.17    0.81    0.97    0.87    1.13    0.97    0.95    1.19    1.08    1.2     0.89    0.82    1.07    1.15    0.94    1.19    1.15    0.81    0.86    0.82    1.18    0.89    0.98    0.85    1.06    1.04
10      1.1     1.04    0.8     0.94    1.17    1       1.06    0.9     0.92    0.99    0.91    0.93    0.93    1       1.11    1       0.88    0.91    1.12    0.88    1.04    1.12    1.14    0.81    0.91    0.99    1.01    0.94    1.17    0.87    1.18
11      1.18    0.92    1.12    0.8     1.05    0.94    0.85    0.93    0.99    0.85    1.01    0.92    0.94    0.94    0.95    1.04    1.14    1.07    0.85    0.93    0.94    1.02    0.98    1.19    1.08    1.06    1.12    0.95    1.04    0.81    0.92
12      1.08    0.88    1.15    1.03    0.98    1.1     1.16    0.94    0.98    0.83    1.11    1.1     1.02    1.09    1.08    0.96    0.94    1.16    0.9     0.88    1.18    1.19    1.01    1.04    1.02    1.12    1.02    0.99    0.98    1.04    0.92
13      1.05    1.18    0.82    1.04    1       1.13    1.18    0.82    0.99    0.83    0.86    1.15    1.02    1.11    1.02    0.95    1.13    0.81    1.02    0.83    0.93    0.84    1.19    1.1     1.04    0.93    1.18    0.91    1.15    0.91    1.03
14      1.16    0.97    1.17    1.08    1.08    1.16    0.92    1.05    1.13    1.13    1.16    0.94    0.93    1.1     0.93    0.83    0.91    0.98    0.96    0.97    0.94    1.15    1.02    0.92    1.04    0.91    0.84    1.17    1.2     1       1.17
15      1.11    0.93    0.81    0.93    0.84    1.02    1.01    1.04    0.88    1.13    0.92    0.8     1.16    1.16    1.18    1.1     1.12    1.14    0.82    0.91    0.92    0.97    1.1     0.92    1       1.08    0.89    0.99    1.15    1.03    1.15
16      1.17    0.82    1.17    1.14    0.9     0.99    1       0.91    1.17    0.91    1.18    0.94    1.13    1.02    1.19    1.16    0.93    1.06    0.89    0.82    0.82    1.1     0.88    0.97    1.05    1.1     1.05    0.81    1.12    1.08    0.8
17      0.95    0.93    1.07    1.08    0.91    1.15    0.93    1.04    0.89    1.18    1.11    0.98    0.83    1.2     1       1.11    1.12    1.05    1.05    0.82    1.18    0.96    1.11    1.11    0.81    1.12    0.86    1.05    0.91    1.16    1.11
18      0.83    1.12    1.13    0.92    0.97    0.86    0.83    0.92    0.92    1.05    1.1     1.05    1.06    1.1     0.82    0.95    0.85    1.1     1.19    1.16    1       0.89    1.19    1.04    1.15    0.88    1.13    0.88    1.1     1.13    0.91
19      1       0.84    1.05    0.92    1.01    1.11    0.98    1.2     1.07    0.98    0.94    0.94    1.08    0.98    0.82    0.95    0.97    1.01    0.97    0.83    1.1     1.01    0.89    1.02    1.05    0.97    0.88    1.02    1.14    0.94    1.18
20      0.85    0.82    1.19    1.19    0.98    1.05    0.97    0.94    1.02    0.87    1.14    0.85    1.06    0.93    1.04    0.92    0.9     0.99    1.07    0.9     0.97    1.04    1.17    0.84    1.05    0.84    0.84    0.87    0.83    0.83    1.13
21      0.87    1.02    1.12    1.1     0.87    1.01    1.07    1.17    1.2     1.19    1.14    1.02    0.87    1.05    1.14    1.06    0.91    0.93    1.04    1.18    1.2     1.19    1.08    1.13    1.16    1.08    0.97    1.16    1.03    1.08    1
22      0.82    0.94    1.16    0.87    1.08    1.07    1.18    1.04    0.92    1.1     0.85    0.93    0.87    1       1.15    0.86    1.01    0.86    1.16    0.87    1.13    1.14    1.17    1.06    1.18    1.13    0.8     0.83    1.03    0.83    0.83
23      1.01    0.97    0.82    1.02    0.81    0.98    1.13    0.92    0.83    1.18    1.17    0.84    0.87    1.02    1.19    1.18    0.9     0.87    0.92    1.05    0.82    0.93    1.17    0.87    1.1     0.89    0.96    1.07    0.98    0.93    0.87
24      0.96    0.99    0.89    0.85    0.89    0.87    1.09    1.03    0.9     1.19    1.13    1.08    1.04    1.13    0.96    0.91    0.81    0.89    0.86    0.82    1.09    1.2     1.16    0.97    1.08    0.95    0.81    0.82    1.11    0.91    1.14
;
table gamma(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31
1       2.95    2.47    2.86    2.33    2.33    2.61    2.49    2.39    2.71    2.78    2.02    2.36    2.61    2.1     2.87    2.74    2.86    2.57    2.63    2.18    2.76    2.52    2.18    2.07    2.48    2.3     2.66    2.91    2.55    2.84    2.29
2       2.19    2.99    3       2.33    2.46    2.1     2.13    2.69    2       2.56    2.12    2.24    2.09    2.17    2.92    2.19    2.26    2.64    2.43    2.18    2.62    2.81    2.52    2.49    2.49    2.66    2.87    2.1     3       2.82    2.34
3       2.29    2.86    2.52    2.32    2.14    2.07    2.52    2.73    2.67    2.02    2.31    2.49    2.72    2.4     2.1     2.22    2.61    2.01    2.69    2.01    2.17    2.43    2.01    2.04    2.32    2.45    2.97    2.66    2.27    2.46    2.24
4       2.73    2.92    2.79    2.57    2.14    2.72    2.85    2.32    2.75    2.21    2.42    2.26    2.59    2.23    2.83    2.79    2.5     2.99    2.4     2.73    2.5     2.72    2.38    2.24    2.47    2.27    2.88    2.82    2.86    2.36    2.06
5       2.95    2.1     2.22    2.55    2.05    2.3     2.4     2.27    2.45    2.57    2.32    2.76    2.68    2.36    2.05    2.94    2.56    2.41    2.04    2.78    2.08    2.74    2.22    2.15    2.8     2.92    2.3     2.71    2.91    2.09    2.9
6       2.78    2.44    2.32    2.72    2.25    2.88    2.84    2.27    2.46    2.57    2.15    2.08    2.29    2.27    2.26    2.71    2.61    2.82    2.25    2.37    2.49    2.32    2.18    2.8     2.87    2.72    2.99    2.78    2.16    2.96    2.29
7       2.43    2.89    2.53    2.13    2.27    2.33    2.71    2.55    2.39    2.31    2.72    2.41    2.97    2.73    2.16    2.68    2.16    2.51    2.11    2.97    2.39    2.5     2.64    2.18    2.41    2.28    2.54    2.07    2.87    2.66    2.25
8       2.36    2.52    2.89    2.71    2.13    2.73    2.58    2.59    2.83    2.97    2.83    2.25    2.14    2.14    2.92    2.69    2.24    2.4     2.23    2.11    2.76    2.87    2.01    2.25    2.06    2.28    2.34    2.7     2.58    2.31    2.75
9       2.18    2.99    2.36    2.24    2.49    2.71    2.37    2.62    2.85    2.48    3       2.8     2.78    2.46    2.8     2.02    2.84    2.09    2.91    2.62    2.21    2.44    2.83    2.12    2.09    2.58    2.18    2.16    2.53    2.42    2.81
10      2.81    2.09    2.82    2.32    2.67    2.8     2.85    2.46    2.22    2.85    2.96    2.21    2.71    2.78    2.85    2.05    2.81    2.64    2.43    2.14    2.91    2.69    2.36    2.87    2.72    2.33    2.66    2.58    2.08    2.75    2.36
11      2.37    2.68    2.33    2.49    2.36    2.55    2.81    2.38    2.86    2.28    2.47    2.55    2.94    2.81    2.48    2.46    2.82    2.92    2.8     2.54    2.66    2.57    2.85    2.81    2.19    2.19    2.88    2.76    2.38    2.9     2.36
12      2.08    2.05    2.13    2.76    2.81    2.97    2.16    2.83    2.13    2.55    2.37    2.32    2.29    2.82    2.79    2.55    2.71    2.89    2.87    2.93    2.98    2.85    2.17    2.25    2.69    2.35    2.18    2.44    2.55    2.27    2.35
13      2.1     2.86    2.45    2.67    2.75    2.84    2.81    2.84    2.56    2.15    2.91    2.59    2.91    2.37    2.72    2.72    2.59    2.64    2.72    2.16    2.01    2.04    2.15    2.41    2.7     2.52    2.76    2.05    2.33    2.69    2.49
14      2.07    2.29    2.77    2.51    2.3     2.35    2.66    2.47    2.48    2.01    2.01    2.95    2.18    2.56    2.2     2.34    2.51    2.06    2.16    2.8     2.53    2.21    2.21    2.63    2.18    2.65    2.6     2.19    2.2     2       2.67
15      2.61    2.15    2.92    2.28    2.21    2.21    2.27    2.79    2.74    2.78    2.55    2.91    2.53    2.83    2.75    2.87    2.73    2.66    2.18    2.11    2.58    2.84    2.11    2.5     2.86    2.03    2.1     2.55    2.15    2.2     2.9
16      2.86    2.8     2.9     2.71    2.66    2.15    2.34    2.92    2.93    2.26    2.5     2.16    2.92    2.82    2.24    2.64    2.55    2.62    2.92    2.3     2.78    2.62    2.23    2.11    2.79    2.48    2.71    2.42    2.02    2.2     2.15
17      2.03    2.6     2.08    2.89    2.73    2.17    2.4     2.47    2.7     2.67    2.25    2.15    2.37    2.43    2.78    2.53    2.1     2.5     2.34    2.47    2.74    2.87    2.14    2.21    2.97    2.76    2.18    2.4     2.31    2.05    2.69
18      2.13    2.04    2.48    2.44    2.28    2.6     2.46    2.44    2.03    2.75    2.04    2.59    2.43    2.72    2.72    2       2.5     2.43    2.3     2.93    2.58    2.53    2.23    2.38    2.44    2.64    2.42    2.52    2.27    2.83    2.27
19      2.75    2.38    2.5     2.89    2.32    2.05    2.8     2.97    2.55    2.64    2.12    2.48    2.5     2.78    2.39    2.47    2.33    2.98    2.77    2.43    2.97    2.47    2.34    2.2     2.36    2.8     2.62    2.07    3       2.85    2.11
20      2.71    2.57    2.56    2.68    2.78    2.07    2.03    2.9     2.43    2.1     2.3     2.76    2.25    2.17    2.45    2.81    2.36    2.92    2.09    2.33    2.65    2.95    2.23    2.73    2.96    2.79    2.88    2.11    2.28    2.59    2.55
21      2.34    2.17    2.47    2.4     2.84    2.19    2.57    2.84    2.8     2.11    2.53    2.64    2.39    2.54    2.69    2.23    2.54    2.91    2.23    2.04    2.55    2.41    2.28    2       2.48    2.7     2.61    2.71    2.61    2.64    2.23
22      2.66    2.62    2.77    2.76    2.37    2.2     2.25    2.3     2.47    2.85    2.7     2.85    2.49    2.46    2.31    2.32    2.37    2.52    3       2.97    2.18    2.39    2.51    2.75    2.34    2.79    2.69    2.09    2.31    2.54    2.24
23      2.28    2.23    2.71    2.1     2.94    2.82    2.66    2.12    2.38    2.96    2.81    2.75    2.59    2.2     2.85    2.38    2.54    2.15    2.1     2.86    2.35    2.27    2.35    2.84    2.49    2.09    2.78    2.9     2.63    2.85    2.03
24      2.45    2.96    2.25    2.62    2.7     2.22    2.24    2.25    2.58    2.41    2.19    2.39    2.38    2.14    2.26    2.17    2.89    2.39    2.29    2.81    2.76    2.56    2.07    2.22    2.8     2.77    2.08    2.29    2.24    2.45    2.25
;

Set equip(k,pr)
/
1.(1,2,3,4)
2.(5,6)
3.(7,8,9)
4.(10,11)
5.(12,13,14)
6.(15,16)
7.(17,18)
8.(19,20,21)
9.(22,23,24,25,26)
10.(27,28,29,30,31)
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
3.8
4.9
5.10
6.14
7.15
8.16
9.20
10.21
/
;
Set flow_out(k,fl) "Outlet flow for the given disjunction"
/
1.6
2.7
3.11
4.12
5.13
6.17
7.18
8.19
9.22
10.23
/
;

Variables
F(fl)
,C(k)
, alpha
;


set nodes "Nodes in process network where mass balances are enforced" /1*8/;

table flows(nodes,fl) "Possible flows for mass balances"
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24
1
2                       -1                      -1      -1      1       1       1
3                                               -1      -1      1
4                               -1                                                      -1      -1              1       1
5                                       -1                                                              -1                      1
6                                                                                                                                       -1      -1      -1      1       1
7                                                                                                                                                       -1              1
8                                                                                                                                                                               -1      -1      1
;

set in(nodes,fl), out(nodes,fl);
in(nodes,fl)$(flows(nodes,fl)=-1)=yes;
out(nodes,fl)$(flows(nodes,fl)=1)=yes;

set input(k,fl), output(k,fl);
input(k,fl)$(flow_in(k,fl))=yes;
output(k,fl)$(flow_out(k,fl))=yes;

parameter cost(fl) Flow costs
/
1       1.89
2       1.65
3       1.56
4       2.96
5       2.87
6       0.24
7       0.29
8       0.12
9       0.16
10      0.12
11      0.29
12      0.27
13      0.23
14      0.23
15      0.21
16      0.16
17      0.21
18      0.28
19      0.18
20      0.28
21      0.22
22      0.28
23      0.16
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
*Initialize variables values for undefined terms
Y.l(k,i)=1;

*Disjunction inequalities
EQ_I_Disj(k,i,de)$ki(k,i).. 0 =G=
 + (sum((output(k,fl),input(k,fl1),Eq(k,i,pr)),(Y(k,i)+epsilon)*(d(fl,pr)*(EXP(Fs(k,i,fl)*t(fl,pr)/(Y(k,i)+epsilon))-1)) - Fs(k,i,fl1)))$((ord(de)=1))
 + sum(output(k,fl),Fs(k,i,fl))$((ord(de)=1) and ord(i) eq imax(k))

 + (sum((output(k,fl),Eq(k,i,pr)),( - Cs(k,i) + beta(fl,pr)*Fs(k,i,fl) + (y(k,i)+epsilon)*gamma(fl,pr))))$((ord(de)=2))
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

*option minlp = baron;

SOLVE prob USING minlp MINIMIZING alpha ;