SET k          number of disjunctions                          /1*10/
    i          max number of terms in a single disjunction     /1*8/
    ki(k,i)    terms in disjunction
    de         max number of equations in a disjunctive term   /1*2/

BINARY VARIABLES    Y(k,i);

parameter demand /0.6/;


parameter M1(k,i,de);
M1('1','1','1')=0.0312;
M1('1','1','2')=2.53;
M1('1','2','1')=0.2138;
M1('1','2','2')=2.53;
M1('1','3','1')=0.0001;
M1('1','3','2')=2.46;
M1('1','4','1')=0.4231;
M1('1','4','2')=2.23;
M1('1','5','1')=1.3844;
M1('1','5','2')=4.2;
M1('2','1','1')=0.0001;
M1('2','1','2')=2.98;
M1('2','2','1')=0.4601;
M1('2','2','2')=2.98;
M1('2','3','1')=1.3281;
M1('2','3','2')=4.2;
M1('3','1','1')=1.0633;
M1('3','1','2')=2.79;
M1('3','2','1')=0.9048;
M1('3','2','2')=2.79;
M1('3','3','1')=0.0001;
M1('3','3','2')=2.42;
M1('3','4','1')=1.4144;
M1('3','4','2')=4.2;
M1('4','1','1')=0.0001;
M1('4','1','2')=2.5;
M1('4','2','1')=0.3027;
M1('4','2','2')=2.5;
M1('4','3','1')=1.4279;
M1('4','3','2')=4.2;
M1('5','1','1')=3.1587;
M1('5','1','2')=2.7;
M1('5','2','1')=0.0001;
M1('5','2','2')=2.7;
M1('5','3','1')=0.6678;
M1('5','3','2')=2.5;
M1('5','4','1')=1.5881;
M1('5','4','2')=2.94;
M1('5','5','1')=1.5702;
M1('5','5','2')=4.2;
M1('6','1','2')=2.15;
M1('6','2','1')=0.3698;
M1('6','2','2')=2.51;
M1('6','3','1')=1.2323;
M1('6','3','2')=4.2;
M1('7','1','1')=0.0001;
M1('7','1','2')=2.98;
M1('7','2','1')=0.2885;
M1('7','2','2')=2.98;
M1('7','3','1')=1.2135;
M1('7','3','2')=4.2;
M1('8','1','1')=1.115;
M1('8','1','2')=4.2;
M1('8','2','1')=0.0001;
M1('8','2','2')=2.58;
M1('8','3','1')=1.9988;
M1('8','3','2')=2.58;
M1('8','4','1')=1.5412;
M1('8','4','2')=4.2;
M1('9','1','1')=1.0437;
M1('9','1','2')=4.2;
M1('9','2','1')=0.0001;
M1('9','2','2')=2.94;
M1('9','3','1')=0.022;
M1('9','3','2')=2.94;
M1('9','4','1')=1.3107;
M1('9','4','2')=2.51;
M1('9','5','1')=1.5249;
M1('9','5','2')=2.57;
M1('9','6','1')=0.6216;
M1('9','6','2')=2.57;
M1('9','7','1')=0.6866;
M1('9','7','2')=2.29;
M1('9','8','1')=1.427;
M1('9','8','2')=4.2;
M1('10','1','1')=1.6796;
M1('10','1','2')=2.8;
M1('10','2','1')=0.0001;
M1('10','2','2')=2.83;
M1('10','3','1')=0.9092;
M1('10','3','2')=2.83;
M1('10','4','1')=0.299;
M1('10','4','2')=2.6;
M1('10','5','1')=2.1057;
M1('10','5','2')=2.13;
M1('10','6','1')=0.1009;
M1('10','6','2')=2.16;
M1('10','7','1')=0.9919;
M1('10','7','2')=2.22;
M1('10','8','1')=1.5104;
M1('10','8','2')=4.2;

set fl "Flows" /1*24/;
alias(fl,fl1);
set pr "Processes" /1*36/;
table d(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31      32      33      34      35      36
1       1.06    1.13    1.05    1.03    1.15    1.18    1.17    1.15    1.13    1       1.09    1.02    1.01    1.02    1.15    1.11    1.08    1.07    1.06    1.03    1.06    1.08    1.12    1.1     1.15    1.01    1.16    1.05    1.16    1.01    1.11    1.03    1.17    1.09    1.13    1.02
2       1.03    1.04    1.12    1.2     1.15    1.18    1.03    1       1.17    1.06    1.1     1.07    1.01    1.17    1.04    1.15    1.19    1.19    1.12    1.17    1.15    1.09    1.18    1.17    1       1.18    1.11    1.12    1.17    1.08    1.18    1.11    1.12    1.18    1.19    1.16
3       1.15    1.1     1.16    1.08    1.08    1.07    1.06    1.19    1.01    1.17    1.14    1.15    1.08    1.16    1.03    1.17    1.01    1.1     1.18    1.19    1.12    1.13    1.12    1.09    1.03    1.02    1.09    1.11    1.09    1.17    1.18    1.02    1.19    1.09    1.11    1.17
4       1.06    1       1.18    1.1     1.15    1.15    1.04    1.06    1.04    1       1.07    1.08    1.14    1.03    1.12    1.08    1.06    1.16    1.1     1.01    1.19    1.12    1.05    1.16    1.14    1.15    1.04    1.17    1       1.13    1.17    1.19    1.01    1.15    1       1.04
5       1.16    1.15    1.09    1.18    1.11    1.18    1.12    1.1     1.13    1.04    1.06    1.11    1.17    1.08    1.15    1.09    1.14    1.2     1.07    1.18    1.02    1.08    1.16    1.04    1.19    1.11    1.12    1.12    1.13    1.12    1.12    1.18    1.1     1.1     1       1.05
6       1.03    1.04    1.04    1.15    1.15    1.12    1.19    1.05    1.19    1.17    1.12    1.01    1.03    1.05    1.07    1.01    1.11    1.14    1.05    1       1.09    1.19    1.19    1.04    1.06    1.15    1.13    1.14    1.12    1.19    1.13    1.01    1.14    1.19    1.15    1.12
7       1.06    1.07    1.06    1.01    1.14    1.02    1.2     1.17    1.17    1.08    1.15    1.17    1.03    1.01    1.15    1.14    1.01    1.17    1.15    1.12    1.1     1.01    1.13    1.12    1.15    1.07    1.02    1.19    1.09    1.04    1.12    1.16    1       1.14    1.13    1.04
8       1.04    1.03    1.19    1.19    1.02    1.11    1.03    1.13    1.1     1.14    1.12    1.19    1.19    1.06    1.07    1.18    1.11    1.11    1.04    1.19    1.18    1.05    1.19    1.18    1.04    1.03    1.13    1.11    1.08    1.02    1.02    1.15    1.13    1.12    1.06    1.13
9       1.19    1.11    1.17    1.19    1.05    1.17    1.06    1.06    1.15    1.11    1.12    1.07    1.17    1.15    1.2     1.13    1.05    1.17    1.18    1.13    1.16    1.15    1.19    1.18    1.08    1.11    1.17    1.11    1.06    1.1     1.08    1.11    1.11    1.2     1.06    1.18
10      1.17    1.01    1.07    1       1.18    1.17    1.14    1.02    1.19    1.17    1.15    1.18    1.15    1.13    1.13    1.1     1.12    1.02    1.04    1.13    1.2     1.19    1.08    1.18    1.15    1.18    1.05    1.02    1.02    1.18    1.15    1.08    1.1     1.08    1.11    1.11
11      1.11    1.08    1.08    1.14    1.18    1.16    1.06    1.1     1.15    1.19    1.18    1.19    1.04    1.16    1.04    1.2     1.04    1.06    1.06    1.17    1.04    1.14    1.07    1.15    1.04    1.05    1.01    1.1     1.14    1.15    1.06    1       1.09    1.19    1.19    1.05
12      1.04    1.03    1.06    1.04    1.14    1.03    1.08    1.06    1.14    1.15    1.15    1.2     1.05    1.01    1.14    1.09    1.13    1.15    1.16    1.19    1.13    1.14    1.2     1.08    1.05    1.1     1.03    1.05    1.02    1.01    1.15    1.15    1.04    1.1     1.09    1.17
13      1.14    1.06    1.02    1.19    1.08    1.18    1.09    1.14    1.18    1.03    1.2     1.17    1.03    1.09    1.12    1.16    1.11    1.15    1.12    1.2     1.06    1.02    1.15    1.17    1.17    1.12    1.03    1.01    1.12    1.15    1.13    1.14    1.09    1.05    1.2     1.02
14      1.12    1.16    1.06    1.13    1.09    1.13    1.16    1.06    1.2     1.16    1.04    1.1     1.05    1.15    1.15    1.06    1.01    1.11    1.16    1.02    1.19    1.06    1.2     1.09    1.05    1.16    1.09    1.04    1.05    1.02    1.02    1.1     1.12    1.04    1.11    1.05
15      1.13    1.12    1.1     1.02    1.15    1.16    1.08    1.02    1.03    1.04    1.01    1.17    1.01    1.01    1.08    1.15    1.02    1.2     1.05    1.02    1.11    1.07    1.18    1.15    1.01    1.09    1.1     1.17    1.01    1.05    1.16    1.05    1.12    1.1     1.16    1.12
16      1.16    1.1     1.17    1.18    1.01    1.09    1.18    1.02    1.09    1.03    1.08    1.15    1.11    1.05    1.17    1.09    1.1     1.09    1.17    1.15    1       1.08    1.02    1.16    1.13    1.05    1.04    1.13    1.17    1.12    1.18    1.16    1.06    1.08    1.08    1.14
17      1.01    1.03    1.1     1.13    1.11    1.16    1.18    1.03    1.15    1.08    1.1     1.08    1.03    1.09    1.03    1.2     1.12    1.16    1.11    1.07    1.03    1.14    1.13    1.15    1.05    1.18    1.2     1.06    1.19    1.1     1.07    1.12    1.02    1.18    1.01    1.02
18      1       1.09    1.01    1.15    1.05    1.08    1.08    1.14    1.14    1.02    1.15    1.1     1       1.03    1.09    1.07    1.17    1.14    1.09    1.18    1.03    1.06    1.19    1.1     1.06    1.02    1.17    1       1.08    1.08    1.12    1.09    1.1     1.11    1.12    1.16
19      1.2     1.06    1.19    1.01    1.19    1.18    1.07    1.04    1.02    1.09    1.12    1.05    1.14    1.03    1.1     1.13    1.02    1.17    1.11    1.15    1.09    1.08    1.11    1.03    1.04    1.01    1.19    1.15    1.1     1.13    1.06    1.05    1.04    1.02    1.14    1.18
20      1.06    1.14    1.09    1       1.01    1.09    1.15    1.13    1.12    1.16    1.02    1.17    1       1.1     1.13    1.17    1.02    1.02    1.02    1.16    1.03    1.13    1.11    1.13    1.02    1.19    1.01    1.18    1.19    1.19    1.02    1.12    1.11    1.12    1.15    1.03
21      1.15    1.2     1.09    1.06    1.13    1.08    1.09    1.1     1.07    1.17    1.11    1.12    1.17    1.07    1.02    1.11    1       1.14    1.13    1.07    1.05    1.17    1.03    1.14    1.03    1.14    1.16    1.2     1.01    1.15    1.17    1.12    1.09    1.2     1.12    1
22      1.17    1.19    1.03    1.09    1.11    1.18    1.05    1.08    1.01    1.17    1.03    1.06    1.1     1.16    1       1.09    1.06    1.18    1.2     1.06    1.01    1.1     1.13    1.05    1.11    1.11    1.06    1       1.05    1.04    1.04    1.18    1.06    1.16    1.1     1.18
23      1.12    1.19    1.11    1.18    1.09    1.11    1.1     1.06    1.19    1.05    1.13    1.08    1.02    1.08    1.17    1.17    1.04    1.09    1.16    1.02    1.08    1.1     1.05    1.01    1.07    1.03    1.07    1.02    1.15    1.05    1.03    1.03    1.15    1.07    1.14    1.17
24      1.17    1.2     1.13    1.13    1.03    1.18    1.04    1.17    1.17    1.13    1.03    1.08    1.11    1.19    1.09    1.08    1.05    1.05    1.02    1.06    1.09    1.07    1.05    1.16    1.18    1.18    1.06    1.04    1       1.12    1.2     1.03    1.13    1.05    1.2     1.02
;
table t(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31      32      33      34      35      36
1       1.09    1.19    1.13    1.17    1.15    1.3     1.06    1.18    1.23    1.19    1.26    1.19    1.29    1.15    1.23    1.26    1.24    1.03    1.28    1.23    1.1     1.18    1.1     1.1     1.12    1.22    1.14    1.23    1.11    1.04    1.26    1.08    1       1.15    1.05    1.03
2       1.28    1.11    1.3     1.23    1.09    1.18    1.22    1.13    1.19    1.02    1.17    1.11    1.02    1.08    1.08    1.16    1.29    1.29    1.14    1.16    1       1.21    1.12    1.03    1.17    1.23    1.01    1.02    1.1     1.26    1.25    1.1     1.15    1.22    1.3     1.06
3       1.1     1       1.24    1.01    1.09    1.27    1.05    1.24    1.21    1.27    1.23    1.26    1.03    1.11    1.17    1.11    1.26    1.26    1.19    1.28    1.26    1.08    1.19    1.1     1.26    1.17    1.04    1.16    1.03    1.23    1.08    1.04    1.06    1.29    1.27    1.1
4       1.23    1.1     1.09    1.19    1.25    1.26    1.27    1.14    1.17    1.24    1.19    1.2     1.14    1.01    1.17    1.07    1.2     1.26    1.01    1.24    1.15    1.08    1.04    1.18    1.11    1.22    1.25    1.23    1.15    1.02    1.18    1.2     1.22    1.01    1.12    1.2
5       1.28    1.15    1.09    1.27    1.06    1.27    1.12    1.19    1.06    1.1     1.29    1.25    1.02    1.28    1.24    1.21    1.17    1.07    1.28    1.22    1.1     1.1     1.22    1       1.02    1.17    1.23    1.23    1.14    1.25    1.06    1.28    1.07    1.18    1.11    1.18
6       1.15    1.17    1.14    1.14    1.03    1.23    1.23    1.09    1.15    1.01    1.2     1.07    1       1.21    1.23    1.1     1.24    1.24    1.03    1.08    1.2     1.04    1.25    1.07    1.12    1.25    1.25    1.28    1.21    1.28    1.26    1.05    1.28    1.2     1.18    1.05
7       1.11    1.15    1.03    1.2     1.03    1.2     1.15    1.29    1.19    1.1     1.13    1.3     1.25    1.22    1.18    1.21    1.19    1.19    1.14    1.13    1.27    1.09    1.16    1.05    1.14    1.23    1.25    1.24    1.25    1.02    1.18    1.08    1.09    1.02    1       1.09
8       1.09    1.02    1.23    1.14    1.01    1.17    1.18    1.1     1.11    1.22    1.16    1.14    1.27    1.26    1.25    1.15    1.14    1.15    1.24    1.08    1.3     1.14    1.29    1.03    1.26    1.17    1.13    1.16    1.01    1.11    1.27    1.3     1.14    1.25    1       1.1
9       1.28    1.26    1.22    1.07    1.21    1.11    1.06    1.05    1.13    1.28    1.12    1.1     1.06    1.26    1.07    1.02    1.24    1.19    1.14    1.08    1.07    1.17    1.14    1.2     1.27    1.22    1.04    1.29    1.08    1.13    1.17    1.27    1.25    1.23    1.24    1.29
10      1.24    1.29    1.17    1.12    1.17    1.29    1.05    1.19    1.08    1.04    1.24    1       1.19    1.2     1.06    1.1     1.18    1.16    1.26    1.1     1.21    1.05    1.19    1.17    1.28    1.04    1.3     1.03    1.12    1.05    1.25    1.09    1.19    1.29    1.25    1.16
11      1.02    1.26    1.13    1.28    1.17    1.18    1.24    1.2     1.06    1.11    1.24    1.03    1.13    1.21    1.2     1.2     1.01    1.12    1.04    1.2     1.26    1.24    1.25    1.02    1.18    1.15    1.2     1.03    1.15    1.04    1.1     1.19    1.03    1.2     1.07    1.19
12      1.09    1.26    1.01    1.07    1.15    1.04    1.09    1.01    1.14    1.05    1.09    1.11    1.27    1.17    1.1     1.14    1.15    1.15    1.21    1.17    1.06    1.08    1.12    1.25    1.27    1.23    1.25    1.01    1.28    1.3     1.18    1.24    1       1.23    1.29    1.08
13      1       1.11    1.19    1.28    1.2     1.13    1.18    1.24    1.28    1.22    1.02    1.25    1.01    1.06    1.14    1.08    1.21    1.22    1.05    1.27    1.26    1.19    1.01    1.29    1.19    1.26    1.27    1.03    1.04    1.19    1.16    1.1     1.22    1.01    1.07    1.12
14      1.25    1.1     1.17    1.25    1.27    1.15    1.26    1.02    1.07    1.03    1.05    1.21    1.06    1.11    1.28    1.29    1.12    1.14    1.02    1.25    1.11    1.05    1.15    1.03    1.11    1.23    1.07    1.16    1.02    1.05    1.04    1.17    1.2     1.16    1.22    1.01
15      1       1.08    1.15    1.1     1.19    1.18    1.21    1.15    1.04    1.09    1.04    1.21    1.25    1.06    1.17    1.07    1.2     1.14    1.07    1.01    1.02    1.13    1.17    1.16    1.29    1.1     1.17    1.28    1       1.11    1.14    1.16    1.11    1.17    1.05    1.16
16      1.06    1.2     1.27    1.08    1.08    1.01    1.22    1.26    1.19    1       1.09    1.1     1.25    1.3     1.11    1.14    1.16    1.26    1.17    1.3     1.23    1.08    1.04    1.04    1.14    1.2     1.03    1.22    1.16    1.21    1.07    1.05    1.23    1.15    1.2     1.07
17      1.28    1.04    1.01    1.28    1.18    1.21    1.05    1.18    1.16    1.13    1.11    1.17    1.16    1.07    1.04    1.19    1.29    1.14    1.08    1.26    1.03    1.17    1.03    1.26    1.14    1.08    1.18    1.05    1.22    1.24    1.26    1.23    1.05    1.14    1.03    1.01
18      1.09    1.27    1.08    1.23    1.2     1.15    1.27    1.04    1.13    1.2     1.09    1.17    1.1     1.12    1.13    1.26    1.16    1.18    1.27    1.22    1.17    1.22    1.28    1.28    1.22    1.08    1.08    1.27    1.14    1.14    1.27    1.18    1.14    1.17    1.27    1.25
19      1.16    1.13    1.28    1.05    1.07    1.27    1.09    1.3     1.1     1.11    1.02    1.04    1.1     1.18    1.09    1.3     1.08    1.29    1.13    1.1     1       1.22    1.21    1.21    1.3     1.04    1.22    1.19    1.23    1.08    1.05    1.08    1.15    1.01    1.16    1.11
20      1.26    1.22    1.15    1.14    1.18    1.23    1.14    1.15    1.12    1.18    1.03    1.2     1.28    1.14    1.29    1.23    1.16    1.2     1.24    1.11    1.23    1.09    1.16    1       1.26    1.03    1.05    1.28    1.19    1.02    1.14    1.23    1.11    1.12    1.16    1.09
21      1.12    1.27    1.08    1.13    1.25    1.22    1.06    1.16    1.03    1.24    1.16    1.14    1.2     1       1.27    1.17    1.23    1.01    1.27    1.16    1.22    1.19    1.11    1.23    1.14    1.09    1.17    1.02    1.24    1.04    1.17    1.12    1.24    1.21    1.12    1.29
22      1.11    1.18    1.3     1.07    1.06    1.25    1.09    1.23    1.05    1.16    1.03    1.1     1.13    1.27    1.16    1.02    1.08    1.29    1.29    1.01    1.26    1.12    1.19    1.1     1.07    1.23    1.28    1.21    1.19    1.22    1.1     1.23    1.18    1.21    1.16    1.13
23      1.06    1.27    1.1     1.2     1.22    1.29    1.04    1.02    1.13    1.18    1.12    1.08    1.11    1.17    1.27    1.03    1.28    1.16    1.24    1.24    1.16    1.25    1.03    1.13    1.28    1.01    1.03    1.05    1.13    1.23    1.05    1.16    1.03    1.26    1.01    1.1
24      1.01    1.28    1.22    1.19    1.01    1.15    1.17    1.12    1.02    1.08    1.18    1.14    1.24    1.26    1.06    1.01    1.21    1.29    1.08    1.22    1.06    1.16    1.1     1.01    1.04    1.26    1.17    1.08    1.14    1.13    1.11    1.24    1.13    1.28    1.22    1.09
;
table beta(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31      32      33      34      35      36
1       1.02    1.14    1.03    1.02    0.86    0.8     0.89    1.14    1.01    0.95    1       1.18    1.09    0.81    0.87    0.92    0.82    0.81    0.94    0.97    1       0.96    0.9     0.98    1       1.09    0.97    0.82    1.07    0.95    1.05    1.18    0.85    0.81    0.92    0.94
2       1.09    1.02    1.07    1.11    0.96    0.96    1.1     1       0.92    0.9     1.08    0.9     0.9     1.01    0.85    0.98    0.99    0.88    0.81    1.05    1.03    0.93    1.17    1.14    0.86    1.05    0.88    0.99    1.04    0.91    0.93    0.88    0.97    0.82    0.97    0.91
3       1.16    1.08    0.87    0.89    0.87    1.17    0.84    0.95    1.19    1.08    0.88    1.09    1.18    0.92    0.93    0.82    0.96    0.9     1.07    1.18    0.98    1.12    1.06    1       1.19    0.86    1.06    1.06    0.99    1.16    0.82    1.06    0.81    1.18    1.02    1.11
4       0.92    1.03    1       1.09    1.17    0.99    1.09    0.97    1.11    1.09    1.04    1.09    0.84    0.83    1.13    0.84    1.09    1.07    0.93    1.07    1.03    1.11    1.12    1.11    0.97    1.03    1.01    0.81    0.85    0.88    0.89    0.86    1.03    0.85    1.17    1
5       1.02    1.12    1.18    0.98    1.14    0.85    1.17    0.84    1.17    1.08    0.94    1.14    0.96    0.93    0.97    0.85    1.02    0.9     0.99    1.18    1.14    0.97    0.96    0.94    1.15    1.15    0.9     1.02    1.18    1.14    1.17    0.81    1.04    1.02    0.85    1.17
6       1.19    0.81    1.2     1.14    0.98    1.01    1.02    0.86    0.82    1.05    0.89    1.09    0.98    0.99    0.91    0.93    0.88    0.9     0.91    1.14    1.1     1.07    1.08    1.17    0.94    1.12    1.19    0.87    1.01    1.04    0.84    0.8     0.85    0.99    1.06    1.07
7       0.87    1.05    0.87    0.98    1.05    0.84    1.12    0.82    1.02    0.87    0.83    1.08    0.93    0.86    0.9     0.81    1.03    1       1.01    1.1     0.97    1.04    1.12    1.07    0.85    0.98    0.9     0.92    1.03    0.9     0.98    1.07    1.19    1.03    0.88    0.89
8       0.86    1.04    0.88    0.94    0.98    1.01    1.05    0.91    0.89    1.2     0.94    1.15    1.12    1.09    0.98    1.15    1.07    1.08    0.95    1.07    1.05    1.16    1.11    1.07    1.06    0.89    0.85    0.9     1.07    1.13    1.1     1.13    0.9     1.09    0.84    0.99
9       1.08    0.95    1.09    1       0.98    1.16    0.87    1.14    1.03    1.08    1.01    0.95    0.88    0.96    1       1.14    0.86    0.87    1.1     1.1     0.99    0.92    0.8     0.97    0.98    1.03    0.95    1.19    1.18    0.97    1.12    0.82    1.09    1.13    0.86    1.18
10      1.13    0.97    0.86    0.9     1.06    0.9     0.96    1.08    0.89    1.03    0.89    1.02    1.13    1.03    0.95    1.04    1.03    1.01    0.88    0.96    0.94    1.11    0.83    0.95    1.05    0.84    0.89    0.97    0.81    0.92    0.84    1.08    1.19    0.84    0.85    0.92
11      0.82    0.87    1.01    0.89    0.97    0.84    0.95    1.16    1.01    1.18    0.95    0.81    0.92    0.81    1.2     1.03    1.1     1.1     1.01    1       0.82    1.11    0.94    0.93    1.1     1.08    0.83    0.81    1.13    1.13    1.14    0.8     0.91    0.83    1.06    1.09
12      1.07    1.13    1       0.92    0.94    1.17    1.03    1.17    1.04    0.89    0.98    1.03    0.81    0.93    1.14    0.96    0.96    1.13    0.88    0.82    1.07    0.97    0.97    1.1     0.98    0.8     0.81    0.93    1       1.08    0.99    0.95    0.99    1.08    0.92    1.06
13      0.86    0.84    1.17    1.03    0.89    0.86    0.95    1.04    0.81    1.05    0.88    1.02    0.81    1.02    1.15    0.99    0.93    1.02    1.13    1.15    1.17    1.18    1.16    1.11    0.93    1.04    1.03    0.98    0.9     0.95    1.16    1.13    1.03    1       1.12    0.87
14      1.1     1.08    1.05    1.02    1.12    1       0.87    1.1     1.16    0.83    0.94    1.06    0.93    1.04    0.91    0.96    1.16    1.2     0.89    1.19    1.14    0.98    0.81    0.87    0.85    0.97    1.11    0.9     1.12    1.01    1.04    1.17    0.98    1.02    0.96    1.15
15      1.12    0.8     1.06    1.2     0.88    1.06    1.16    0.91    0.92    0.89    0.82    0.8     0.89    0.84    1.01    0.83    0.82    1.19    1.08    1.12    1.08    0.88    0.93    1.14    0.82    0.86    0.85    1.01    1.09    0.92    1.01    0.93    0.9     0.83    1.05    1.03
16      1.18    0.93    1.07    0.96    1.09    0.94    0.95    1.13    0.97    0.85    0.85    1.05    0.81    0.95    1.13    0.99    0.88    1.09    1.04    1.1     1.08    0.95    0.89    1.11    1.17    1.02    1.07    0.81    1.06    1.13    0.87    1.12    1.04    0.88    0.8     0.82
17      0.91    1       1.07    1.08    1.12    1.14    1.17    0.99    1.08    0.86    1.16    0.96    1.01    1.09    0.91    1.16    0.82    0.84    1.06    0.93    0.92    0.95    0.86    0.82    1.09    0.87    1.2     0.81    1.02    0.91    1.04    0.88    0.9     0.99    1.09    1.02
18      1.19    1.19    0.99    0.88    0.94    1.11    0.9     1.04    0.89    0.86    1.12    1.11    0.85    1.11    1.07    1.15    1.14    1.1     0.9     1.2     1.01    0.93    1.17    0.96    0.93    0.89    0.86    1.11    1.01    1.08    1.2     1.02    1.11    1.01    0.92    0.84
19      1       0.82    1.15    0.91    1.01    0.86    1.19    1.12    1.17    1.06    1.05    1.03    1.05    0.99    1.13    1.03    0.83    0.86    0.88    0.88    1       0.9     0.98    0.94    1.15    0.9     1.06    0.84    1.12    1.15    1.11    1.05    1.08    1.11    1.16    0.91
20      0.99    1.07    0.82    0.98    1.11    1.06    0.91    0.99    0.97    0.83    1.06    0.96    1.18    0.85    1.1     1.12    0.96    0.82    1.17    1.17    0.8     0.9     1.16    0.88    0.89    1.05    1.14    0.97    1.11    1.08    0.9     1.1     0.82    0.87    1.14    0.81
21      1.08    0.99    0.97    0.98    1.12    0.89    0.97    1.07    1.14    1.16    1.19    0.81    0.88    1.05    1.06    0.94    0.82    1.02    0.96    1.12    0.83    0.91    0.92    1.13    0.86    0.9     0.93    1.17    1.13    0.9     1.04    0.93    0.9     0.89    1.02    0.86
22      0.94    1.14    0.97    0.99    0.88    1.13    0.92    0.91    1.16    1.14    0.9     0.8     1.07    1.13    0.92    1.18    1.13    1.02    0.9     1.11    0.81    1.05    1.06    0.93    0.91    0.9     1.12    0.87    1.15    0.84    1.2     0.85    1.09    1.08    1.02    1.18
23      0.9     0.89    1       1.1     0.99    1.17    1.14    1.15    0.93    0.93    0.96    1.19    0.87    0.96    1.16    0.97    1.11    1.07    0.93    0.89    0.81    1.12    0.81    0.97    1       0.82    0.87    1.01    1.07    1.17    0.86    1.19    1.16    1.04    1.19    0.96
24      0.83    1.06    0.99    1.19    0.99    0.84    0.99    1       1.16    0.98    0.92    0.89    0.97    1.18    0.94    1.07    1.02    0.85    0.98    0.83    0.81    0.86    1.16    0.97    1.19    0.93    1.07    0.84    0.95    0.91    1.08    1.11    1.19    1.01    0.83    0.99
;
table gamma(fl,pr)
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24      25      26      27      28      29      30      31      32      33      34      35      36
1       2.79    2.8     2.08    2.53    2.22    2.99    2.17    2.38    2.68    2.78    2.08    2.85    2.76    2.18    2.31    2.59    2.97    2.27    2.74    2.22    2.84    2.66    2.62    2.21    2.49    2.54    2.31    2.94    2.96    2.06    2.94    2.39    2.18    2.56    2.45    2.26
2       2.76    2.9     2.45    2.77    2.94    2.62    2.99    2.91    2.39    2.82    2.63    2.22    2.9     2.58    2.28    2.98    2.29    2.51    2.35    2.86    2.05    2.62    2.8     2.08    2.51    2.43    2.03    2.31    2.87    2.27    2.78    2.64    2.59    2.59    2.51    2.57
3       2.67    2.47    2.98    2.37    2.04    2.65    2.97    2.63    2.98    2.48    2.49    2.17    2.05    2.5     2.58    2.03    2.35    2.77    2.21    2.11    2.98    2.39    2.79    2.51    2.61    2.33    2.03    3       2.87    2.81    2.24    2.91    2.87    2.88    2.19    2.23
4       2.6     2.18    2.45    2.43    2.66    2.75    2.28    2.97    2.81    2.43    2.07    2.59    2.9     2.09    2.54    2.19    2.17    2.35    2.03    2.53    2.09    2.05    2.71    2.41    2.5     2.55    2.19    2.3     2.92    2.35    2.13    2.94    3       2.11    2.69    2.38
5       2.04    2.82    2.67    2.03    2.42    2.31    2.23    2.65    2.66    2.78    2.1     2.98    2.68    2.1     2.13    2.48    2.15    2.93    2.48    2.43    2.06    2.37    2.5     2.42    2.32    2.57    2.46    2.5     2.59    2.22    2.84    2.83    2.09    2.79    2.47    2.87
6       2.53    2.46    2.1     2.23    2.69    2.62    2.72    2.11    2.19    2.06    2.04    2.31    2.39    2.16    3       2.99    2.22    2.81    2.98    2.86    2.82    2.78    2.68    2.27    2.29    2.83    2.52    2.68    2.32    2.74    2.4     2.37    2.88    2.79    2.37    2.61
7       2.77    2.68    2.43    2.07    2.98    2.04    2.1     2.89    2.73    2.8     2.35    2.01    2.17    2.94    2.04    2.28    2.23    2.24    2.85    2.16    2.48    2.24    2.42    2.35    2.2     2.13    2.97    2.81    2.49    2.03    2.92    2.6     2.15    2.06    2.2     2.29
8       2.15    2.61    2.24    2.85    2.73    2.38    2.73    2.58    2.66    2.67    2.74    2.57    2.19    2.96    2.52    2.35    2.44    2.08    2.2     2.67    2.71    2.91    2.96    2.94    2.5     2.29    2.44    2.72    2.59    2.26    2.52    2.89    2.82    2.97    2.12    2.52
9       2.92    2.25    2.61    2.75    2.74    2.18    2.27    2.81    2.71    2.93    2.51    2.65    2.88    2.35    2.3     2.85    2.36    2.43    2.46    2.57    2.09    2.79    2.97    2.57    2.47    2.24    2.23    2.28    2.68    2.39    2.63    2.18    2.81    2.17    2.88    2.03
10      2.63    2.23    2.33    2.87    2.9     2.27    2.55    2.17    2.28    2.1     2.54    2.07    2.49    2.94    2.39    2.53    2.51    2.66    2.03    2.05    2.05    2.94    2.97    2.89    2.74    2.73    2.8     2.48    2.67    2.85    2.06    2.53    2.1     2.62    2.94    2.39
11      2.2     2.74    2.38    2.81    2.33    2.8     2.79    2.42    2.04    2.21    2.53    2.74    2.65    2.35    2.79    2.97    2.19    2.6     2.37    2.67    2.06    2.61    2.47    2.93    2.71    2.95    2.62    2.02    2.74    2.29    2.38    2.17    2.28    2.88    2.54    2.35
12      2.62    2.95    2.27    2.6     2.4     2.88    2.52    2.66    2.74    2.5     2.37    2.89    2.47    2.11    2.27    2.87    2.27    2.27    2.15    2.17    2.46    2.33    2.34    2.89    2.34    2.84    2.04    2.17    2.21    2.4     2.9     2.8     2.15    2.81    2.04    2.84
13      2.07    2.59    2.75    2.04    2.45    2.73    2.22    2.76    2       2.39    2.65    2.7     2.02    2.5     2.94    2.24    2.24    2.73    2.06    2.74    2.18    2.68    2.71    2.01    2.61    2.32    2.37    2.11    2.83    2.56    2.96    2.76    2.34    2.7     2.54    2.02
14      2.77    2.13    2.03    3       2.45    2.34    2.44    2.42    2.48    2.46    2.89    2.28    2.99    2.07    2.84    2.08    2.18    2.46    2.34    2.28    2.5     2.3     2.96    2.47    2.38    2.66    2.9     2.3     2.46    2.86    2.86    2.31    2.5     2.83    2.74    2.75
15      2.95    2.04    2.01    2.92    2.38    2.39    2.48    2.59    2.13    2.6     2.82    2.04    2.44    2.65    2.3     2.81    2.77    2.76    2.43    2.18    2.96    2.53    2.81    2.13    2.32    3       2.26    2.74    2.5     2.03    2.31    2.14    2.37    2.12    2.69    2.38
16      2.73    2.07    2.7     2.39    2.69    2.67    2.05    2.5     2.78    2.9     2.85    2.19    2.96    2.14    2.35    2.47    2.17    2.91    2.11    2.65    2.79    2.19    2.5     2.46    2.8     2.59    2.4     2.45    2.33    2.42    2.04    2.86    2.7     2.11    2.36    2.31
17      2.61    2.47    2.2     2.14    2.33    2.75    2.73    2.76    2.28    2.05    2.05    2.45    2.19    2.62    2.27    2.15    2.51    2.78    2.57    2.36    2.6     2.54    2.73    2.1     2.92    2.24    2.63    2.77    2.05    2.8     2.84    2.17    2.19    2.04    2.3     2.74
18      2.93    2.73    2.81    2.09    2.82    2.24    2.34    2.44    2.3     2.95    2.33    2.95    2.5     2.57    2.14    2.25    2.05    2.98    2.25    2.42    2.89    2.97    2.53    2.7     2.49    2.67    2.86    2.09    2.78    2.23    2.93    2.33    2.13    2.57    2.02    2.43
19      2.96    2.39    2.81    2.15    2.85    2.41    2.57    2.02    2.29    2.01    2.5     2.22    2.01    2.34    2.02    2.92    2.21    2.88    2.49    2.57    2.58    2.02    2.16    2.99    2.84    2.51    2.67    2.09    2.16    2.87    2.63    2.37    2.51    2.74    2.2     2.05
20      2.39    2.39    2.85    2.39    2.64    2.5     2.67    2.73    2.46    2.05    2.18    2.09    2.29    2.24    2.52    2.55    2.93    2.06    2.61    2.92    2.71    2.85    2.05    2.37    2.76    2.44    2.27    2.36    2.02    2.96    2.84    2.19    2.99    2.62    2.51    2.47
21      2.82    2.99    2.58    2.58    2.4     2.22    2.78    2.44    2.41    2.99    2.65    2.01    2.89    2.76    2.7     2.41    2.28    2.85    2.52    2.95    2.91    2.04    2.38    2.24    2.98    2.16    2.84    2.37    2.62    2.84    2.48    2.99    2.63    2.94    2.77    2.94
22      2.75    2.44    2.55    2.79    2.01    2.47    2.55    2.6     2.41    2.91    2.51    2.75    2.2     2.1     2.84    2.28    2.09    2.89    2.66    2.93    2.17    2.67    2.66    2.94    2.03    2.51    2.57    2.29    2.03    2.27    2.38    2.35    2.84    2.93    2.46    2.44
23      2.82    2.62    2.66    2.23    2.04    2.95    2.68    2.06    2.72    2.41    2.85    2.98    2.43    2.23    2.76    2.55    2.59    2.04    2.65    2.68    2.05    2.08    2.57    2.73    2.32    2.23    2.92    2.42    2.47    2.8     2.83    2.6     2.08    2.13    2.16    2.22
24      2.95    2.73    2.32    2.03    2.71    2.28    2.13    2.58    2.69    2.39    2.54    2.03    2.96    2.71    2.26    2.1     2.83    2.56    2.84    2       2.2     2.29    2.31    2.6     2.59    2.6     2.25    2.8     2.75    2.67    2.23    2.32    2.05    2.23    2.02    2.58
;

Set equip(k,pr)
/
1.(1,2,3,4)
2.(5,6)
3.(7,8,9)
4.(10,11)
5.(12,13,14,15)
6.(16,17)
7.(18,19)
8.(20,21,22)
9.(23,24,25,26,27,28,29)
10.(30,31,32,33,34,35,36)
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
display Eq, imax;
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
*, obj
;


set nodes "Nodes in process network where mass balances are enforced" /1*8/;

table flows(nodes,fl) "Possible flows for mass balances"
        1       2       3       4       5       6       7       8       9       10      11      12      13      14      15      16      17      18      19      20      21      22      23      24
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
;

* Objective function definition
fobj.. alpha =G= sum(fl,cost(fl)*F(fl)) + sum(k,C(k));
*Mass balances
mass_balance(nodes).. sum(in(nodes,fl),F(fl)) =G= sum(out(nodes,fl),F(fl));

EQ_I_Disj(k,i,de)$ki(k,i).. M1(k,i,de)*(1-Y(k,i)) =G=
 + (sum((output(k,fl),input(k,fl1),Eq(k,i,pr)),(d(fl,pr)*(EXP(F(fl)*t(fl,pr))-1)) - F(fl1)))$((ord(de)=1))
 + sum(output(k,fl),F(fl))$((ord(de)=1) and ord(i) eq imax(k))

 + (sum((output(k,fl),Eq(k,i,pr)),( - C(k) + beta(fl,pr)*F(fl) + gamma(fl,pr))))$((ord(de)=2))
 + (C(k))$((ord(de)=2) and ord(i) eq imax(k))
;

*OBJECTIVE.. obj =G= alpha;
dummy(k).. sum(i$ki(k,i), Y(k,i)) =e= 1;

* Bounds on variables --------------------------
parameter Flo(fl), Fup(fl);
Flo(fl) = 0;
Flo(fl)$(ord(fl) eq card(fl)) = demand;
Fup(fl) = 4;

parameter Clo(k), Cup(k);
Clo(k) = 0;
Cup(k) = 4.2;

F.lo(fl) = Flo(fl);
F.up(fl) = Fup(fl);
C.lo(k) = Clo(k);
C.up(k) = Cup(k);
alpha.up=sum(k,Cup(k)) + sum(fl,Fup(fl));
alpha.lo=0;

MODEL prob / ALL / ;

*option minlp = baron;


SOLVE prob USING minlp MINIMIZING alpha ;

