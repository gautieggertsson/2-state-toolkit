# README

*A Toolkit for Solving Models with a Lower Bound on Interest Rates of Stochastic Duration*  
Gauti B. Eggertsson,^ Sergey K. Egiev, Alessandro Lin, Josef Platzer and Luca Riva  

^ gauti_eggertsson@brown.edu  

This repository contains the MATLAB code base for the toolkit presented in Eggertsson et al. (2021), simple examples to show how the toolkit works as well as replication codes for the paper.


The Examples folder contains stand-alone files from which the user can learn how to use the toolkit and its features.
Many of these files are used to generate the results reported in the Eggertsson et al. (2021), so they often do not clear the workspace before execution. Please make sure your workspace is empty before executing them. 


## SIMPLE EXAMPLES

A complete guide to the following simple examples is included in Appendix B.

| Description                                    | File            |
| --                                             | --              |
| SIMPLE POLICY RULE WITH STATE VARIABLE         | Examples/ex_1.m |
| EXCLUDE REGIME 0 BUT SPECIFY EXOGENOUS T-TILDE | Examples/ex_2.m |
| EXCLUDE BOTH REGIME 0 AND EXOGENOUS T-TILDE    | Examples/ex_3.m |
| EXCLUDE REGIME 0 AND IMPOSE EXOGENOUS K        | Examples/ex_4.m |

*T-tilde:*
- T-tilde is 1 by default.
- The user can input an arbitrary value, if the "true" value is lower than the input AND regime 0 search is off, then there will likely be NEGATIVE RATES, before T-tilde. This last result will also be true if the "true" value is lower than the input AND regime 0 search is on. If the "true" value is higher than the input AND regime 0 search is off, then there will be POSITIVE implied rates, for periods where the model does impose them (regime 1).

*Regime 0 search:*
- Regime 0 search is 1 by default.
- Regime 0 search = 0 means that Regime 0 will not be searched for. Likely implying that the ELB is imposed too early.

*K-vector:*
- k-vector is [0 0 0 ..]  by default.
- the user can input a k-vector. However, if there is violation of the ELB in regime 3, then the toolbox will update the k-vector.
- to impose an exogenous k-vector, it is advised that the used sets off Regime 0 search. This also implies that in the initial periods, the implied rate may be positive, but the ELB would be imposed.

*Initial values:*
- initial values are [0 0 0 ..]  by default.
- the user should input values if there are state variables. (see file parameters.m)

The model is:
E_t(x_{t+1}) + sigma E_t(pi_{t+1}) + r^n_t = x_t + sigma i_t
beta E_t(pi_{t+1}) = pi_t - kappa x_t
i_t = max(0,psi_i i_{t-1} + (1-psi_i)(r_star + psi_pi pi_{t-1} + psi_x x_{t-1}))

- The jump variables are x_t, pi_t and i_t
- The pre-determined variables are x_{t-1}, pi_{t-1} and i_{t-1}
- The constants are r_star
- The shocks are r^n_t
- The vector xi_t = [x_t pi_t i_imp_t i_t x_{t-1} pi_{t-1} i_{t-1} r_star r^n_t]'

Note we add another jump variable i_imp_t (the implied Taylor rule, for exposition. See end of Common/matrices.m). Also, note how i_t needs to be the last jump variable.

## REPLICATION

| Description  | File                 | Runtime (sec) |
| --           | --                   | --            |
| FIGURE  1    | fig1/do_fig1.m       | 3             |
| FIGURE  2    | do_fig2.m            | 7             |
| FIGURE  3    | do_fig3.m            | 8             |
| FIGURE  4    | do_fig4.m            | 9             |
| FIGURE  5    | do_fig5.m            | 440           |
| FIGURE  6    | fig6/do_fig6.m       | 21            |
| FIGURE  7    | fig7/do_fig7.m       | 5             |
| FIGURE  8    | do_fig8.m            | 1             |
| FIGURE  9    | fig9_10/do_fig9_10.m | 780           |
| FIGURE 10    | fig9_10/do_fig9_10.m | 780           |
|              |                      |               |
| TABLE   2    | do_fig5.m            | 780           |
| TABLE   3    | fig7/do_fig9_10.m    | 780           |

### APPENDIX

| Description | File                     | Runtime (sec) |
| --          | --                       | --            |
| FIGURE A.1  | do_fig5.m                | 440           | 
| FIGURE A.2  | do_fig5.m                | 440           |
| FIGURE A.3  | do_fig5.m                | 440           |
| FIGURE A.4  | Appendix/A72/do_figA4.m  | 415           |
| FIGURE A.5  | Appendix/A72/do_figA4.m  | 415           |
| FIGURE A.6  | Appendix/A72/do_figA4.m  | 415           |
| FIGURE A.7  | Appendix/A72/do_figA4.m  | 415           |
| FIGURE A.8  | Appendix/A73/do_figA8.m  | 415           |
| FIGURE A.9  | Appendix/A73/do_figA8.m  | 415           |
| FIGURE A.10 | Appendix/A73/do_figA8.m  | 415           |
| FIGURE A.11 | Appendix/A73/do_figA8.m  | 415           |
| FIGURE A.12 | Appendix/A74/do_figA12.m | 220           |
| FIGURE A.13 | Appendix/A74/do_figA12.m | 220           |
| FIGURE A.14 | Appendix/A74/do_figA12.m | 220           |
| FIGURE A.15 | Appendix/A74/do_figA12.m | 220           |
| FIGURE A.16 | Appendix/A74/do_figA12.m | 220           |
| FIGURE A.17 | fig9_10/do_fig9_10.m     | 780           |
| FIGURE A.18 | fig9_10/do_fig9_10.m     | 780           |
| FIGURE A.19 | fig9_10/do_fig9_10.m     | 780           |
| FIGURE A.20 | fig9_10/do_fig9_10.m     | 780           |
|             |                          |               |
| TABLE A.3   | Appendix/A61/do_tabA3.m  | 18            |
| TABLE A.4   | Appendix/A62/do_tabA4.m  | 32            |
| TABLE A.5   | Appendix/A72/do_figA4.m  | 415           |
| TABLE A.6   | Appendix/A73/do_figA8.m  | 415           |
| TABLE A.8   | Appendix/A75/do_tabA8.m  | 26            |

Runtimes are measured on MATLAB R2020b (Windows 10 19042.867). 
CPU: Intel Core i7-6950X; RAM: 64GB. 
