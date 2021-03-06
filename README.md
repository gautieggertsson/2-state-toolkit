# README

*A Toolkit for Solving Models with a Lower Bound on Interest Rates of Stochastic Duration*  
Gauti B. Eggertsson,^ Sergey K. Egiev, Alessandro Lin, Josef Platzer and Luca Riva  

^ gauti_eggertsson@brown.edu  

This repository contains the code base for the toolkit presented in Eggertsson et al. (2020), simple examples to show how the toolkit works as well as replication codes for the paper.


## SIMPLE EXAMPLES

| Description  | File |
| -- | -- |
| SIMPLE POLICY RULE WITH STATE VARIABLE | Examples/ex_1.m   |
| EXCLUDE REGIME 0 BUT SPECIFY EXOGENOUS T-TILDE | Examples/ex_2.m |
| EXCLUDE BOTH REGIME 0 AND EXOGENOUS T-TILDE | Examples/ex_3.m |
| EXCLUDE REGIME 0 AND IMPOSE EXOGENOUS K | Examples/ex_4.m |
| EXCLUDE INITIAL VALUES | Examples/ex_5.m |

The Examples folder contains files from which the user can learn how to use the toolkit and its features.

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

The model equations are:  
1. E_t(x_{t+1}) + sigma E_t(pi_{t+1}) + r^n_t = x_t + sigma i_t
2. beta E_t(pi_{t+1}) = pi_t - kappa x_t
3. i_t = max(0,psi_i i_{t-1} + (1-psi_i)(r_star + psi_pi pi_{t-1} + psi_x x_{t-1}))

- The jump variables are x_t, pi_t and i_t  
- The pre-determined variables are x_{t-1}, pi_{t-1} and i_{t-1}
- The constants are r_star
- The shocks are r^n_t
- The vector xi_t = [x_t pi_t i_imp_t i_t x_{t-1} pi_{t-1} i_{t-1} r_star r^n_t]'

Note we add another jump variable i_imp_t (the implied Taylor rule, for exposition. See end of Common/matrices.m). Also, note how i_t needs to be the last jump variable.

## REPLICATION

| Description  | File             |
| --           | --               | 
| FIGURE  1    | fig1/do_fig1.m   |  
| FIGURE  2    | do_fig2.m        |
| FIGURE  3    | do_fig3.m        |
| FIGURE  4    | do_fig4.m        |
| FIGURE  5    | do_fig5.m        |
| FIGURE  7    | fig7/do_fig7.m   | 
| FIGURE  8    | fig7/do_fig7.m   |
| FIGURE  9    | fig9/do_fig9.m   |  
| FIGURE 10    | fig10/do_fig10.m |
|              |                  |
| TABLE   2    | do_fig5.m        |
| TABLE   3    | fig7/do_fig7.m   |

### APPENDIX

| Description | File                     |
| --          | --                       |
| FIGURE A.1  | fig9/do_fig5.m           |
| FIGURE A.2  | fig9/do_fig5.m           |
| FIGURE A.3  | fig9/do_fig9.m           |
| FIGURE A.4  | Appendix/A62/do_figA4.m  |
| FIGURE A.5  | Appendix/A62/do_figA4.m  |
| FIGURE A.6  | Appendix/A62/do_figA4.m  |
| FIGURE A.7  | Appendix/A62/do_figA4.m  |
| FIGURE A.8  | Appendix/A62/do_figA8.m  |
| FIGURE A.9  | Appendix/A62/do_figA8.m  |
| FIGURE A.10 | Appendix/A62/do_figA8.m  |
| FIGURE A.11 | Appendix/A62/do_figA8.m  |
| FIGURE A.12 | Appendix/A64/do_figA12.m |
| FIGURE A.13 | Appendix/A64/do_figA12.m |
| FIGURE A.14 | Appendix/A64/do_figA12.m |
| FIGURE A.15 | Appendix/A64/do_figA12.m |
| FIGURE A.16 | fig9/do_fig9.m           | 
| FIGURE A.17 | fig7/do_fig7.m           |
| FIGURE A.18 | fig7/do_fig7.m           |
| FIGURE A.19 | fig7/do_fig7.m           |
| FIGURE A.20 | fig7/do_fig7.m           |
| FIGURE A.21 | fig7/do_fig7.m           |
|             |                          |
| TABLE A.3   | Appendix/A62/do_figA4.m  |
| TABLE A.4   | Appendix/A62/do_figA8.m  |
| TABLE A.5   | Appendix/A64/do_figA12.m |
| TABLE A.6   | Appendix/A65/do_tabA6.m  |
