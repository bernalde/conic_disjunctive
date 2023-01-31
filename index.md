<head>
    <script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
    <script type="text/x-mathjax-config">
        MathJax.Hub.Config({
            tex2jax: {
            skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
            inlineMath: [['$','$']]
            }
        });
    </script>
</head>

## Description


Find here the PAVER reports used in the paper: **"Convex Mixed-Integer Nonlinear Programs Derived from Generalized Disjunctive Programming using Cones"** by D.E. Bernal and I.E. Grossmann are available in the <a href="Conic_GDP_arXiv.pdf" download>repository</a> and [arXiv](http://arxiv.org/abs/2109.09657).


## Algorithms/Methods/Instances
The comparison here includes the conic and nonlinear representation of several convex generalized disjunctive programming problems.
The instances can be classified into two major families, quadratic (which are representable using the second-order cone) and exponential.

Among the quadratic instances (217 problems) include:
- [Contrained Layout problems](https://minlp.org/library/problem/index.php?i=306&lib=MINLP).
- [k-Mean clustering problems](https://minlp.org/library/problem/index.php?i=307&lib=MINLP).
- Random quadratic GDP problems.

The exponential instances (208 problems) include:
- [Process Superstructure optimization](https://minlp.org/library/problem/index.php?i=113&lib=GDP).
- [Retrofit Synthesis Problems](http://egon.cheme.cmu.edu/ibm/page.htm).
- Logistic Regression Problems.
- Random exponential GDP problems.

In particular, the reformulations considered were:
- Big-M reformulation.
- Conic-based Big-M reformulation (especially for exponential instances since the structure is not automatically identified, as is the case with Second-Order Conic constraints).
- $\varepsilon$-approximation of Hull Reformulation (HR) according to [Furman, Sawaya, Grossmann](https://doi.org/10.1007/s10589-020-00176-0)
- Exact conic formulation of the Hull Reformulation (HR).

The solvers considered for these problems are the following:
- CPLEX 12.9 for Big-M and HR of quadratic instances.
- MOSEK 9.0.98 for the conic instances.
- BARON 19.7.
- KNITRO 11.1.

Moreover, the instances were solved by controlling the Branch and Bound search using SBB and solving the nonlinear and conic subproblems with KNITRO and MOSEK, respectively.

## Paver Reports

[Complete benchmark results](https://bernalde.github.io/conic_disjunctive/results/cones.html/)

The reports can also be downloaded from the [repository](https://github.com/bernalde/conic-disjunctive).
