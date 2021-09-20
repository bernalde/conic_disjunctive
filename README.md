# Conic Disjunctive Programs
This repository contains the numerical results for the manuscript "Convex Mixed-Integer Nonlinear Programs Derived from Generalized Disjunctive Programming using Cones" by David E. Bernal and Ignacio E. Grossmann.
This manuscript can be found in arXiv, and a copy of it is available [here](Conic_GDP_arXiv.pdf).

This repository includes implementations of the different problems are performed in GAMS and are available in the [instances](/instances) directory. The results analysis is done using Coin-OR software [Paver 2.0](https://github.com/coin-or/Paver), and the formatted output can be found as an HTML website [here](/https://bernalde.github.io/conic-disjunctive/).

- [trace_data](https://bernalde.github.io/conic-disjunctive/trace_data): trace files of the benchmark. For more information about trace file, please refer to [here](http://www.gamsworld.org/performance/trace.htm).

- [paver](https://github.com/bernalde/conic-disjunctive/paver): bash codes to obtain the paver report from trace files.

- [instances](https://github.com/bernalde/conic-disjunctive/instances): contains the GAMS implementation of the problem instances.

- [results](https://github.com/bernalde/conic-disjunctive/tree/main/results): paver reports of the numerical experiments.
