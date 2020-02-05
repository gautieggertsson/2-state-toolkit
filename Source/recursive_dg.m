%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% RECURSIVE-BACKWARD-TRANSITION DG-function

% This function produces transition matrices, given the transition matrix
% of a period after and a series of auxiliary matrices that are produced in
% the function rref_recursive_dg.m
%
% EXAMPLE (extended, see also rref_recursive_dg):
% The linear model is: A*E_t(xi_{t+1})=B*xi_{t}, where the vector
% xi_{t}=[z_{t};p_{t}] where z is a vector of JUMP variables and P is a
% vector of predetermined variables.
% The model then becomes:
%   |A1 A2|*|E_t(z_{t+1})| = |B1 B2|*|z_{t}  |
%   |A3 A4| |    p_{t}   |   |B3 B4| |p_{t-1}|
%
%   |A1 A2 -B1 -B2|*|E_t(z_{t+1})| = |0|
%   |A3 A4 -B3 -B4| |   p_{t}    |   |0|
%                   |   z_{t}    |
%                   |  p_{t-1}   |
%
%   |A2 -B1 -B2 A1|*|    p_{t}   | = |0|
%   |A4 -B3 -B4 A3| |    z_{t}   |   |0|
%                   |   p_{t-1}  |
%                   |E_t(z_{t+1})|
%
%   |1 0 -C1 -C2|*|    p_{t}   | = |0|
%   |0 1 -C3 -C4| |    z_{t}   |   |0|
%                 |   p_{t-1}  |
%                 |E_t(z_{t+1})|
%
%   p_{t} = C1*p_{t-1}+C2*E_t(z_{t+1})
%   z_{t} = C2*p_{t-1}+C4*E_t(z_{t+1})
%
% KNOWING E_t(z_{t+1}) = D_prime*p_{t}:
%
%   p_{t} = C1*p_{t-1}+C2*D_prime*p_{t}
%   z_{t} = C3*p_{t-1}+C4*D_prime*p_{t}
%
%   (eye-C2*D_prime)*p_{t}  = C1*p_{t-1}
%   z_{t}                   = C3*p_{t-1}+C4*D_prime*p_{t}
%
%   p_{t} = ((eye-C2*D_prime)^(-1))*C1*p_{t-1}
%   z_{t} = C3*p_{t-1}+C4*D_prime*p_{t}
%
%   p_{t} = ((eye-C2*D_prime)^(-1))*C1*p_{t-1}
%   z_{t} = C3*p_{t-1}+C4*D_prime*((eye-C2*D_prime)^(-1))*C1*p_{t-1}
%
%   p_{t} = ((eye-C2*D_prime)^(-1))*C1*p_{t-1}
%   z_{t} = (C3+C4*D_prime*((eye-C2*D_prime)^(-1))*C1)*p_{t-1}
%
%   D = ((eye-C2*D_prime)^(-1))*C1
%   G = (C3+C4*D_prime*((eye-C2*D_prime)^(-1))*C1)

%% INPUTS
% This function takes as inputs:
% - four matrix blocks from the reduced row echelon form
% - one transition matrix (the one of the jump variables) from period after

%% OUTPUTS
% This function delivers:
% - a new transition matrix D
% - a new transition matrix G

function [D,G] = recursive_dg(C_1,C_2,C_3,C_4,D_prime)

% this is the size of the identity in the next step (is NK)
NK=size(C_1,1);
% get transition matrix G
G=((eye(NK)-C_2*D_prime)^(-1))*C_1;
% get transition matrix D
D=C_3+C_4*D_prime*G;
% see the appendix for more details on the formulas

%% NUMERICAL ERRORS
D = real(D);
G = real(G);
end