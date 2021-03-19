%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REDUCED ROW-ECHELON FORM FOR RECURSIVE BACKWARD TRANSITION DG-FUNCTION

% This function takes a linear model A*E_t(xi_{t+1})=B*xi_{t} and
% transforms it into a simpler version using reduced row echelon form.
%
% It is used to provide auxiliary matrices to use in other functions such
% as regime1.m and regime2.m
%
% EXAMPLE:
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
% The function produces the matrices C1 C2 C3 C4.

%% INPUT
% This function takes as input:
% - matrices A and B
% - number of state variables

%% OUTPUT
% This function delivers 4 matrix blocks corresponding to a reduced row
% echelon form of a modified matrix

function [C_1,C_2,C_3,C_4] = rref_recursive_dg(A,B,NK)

% the matrix for which we take the rref is formed by the state
% variables block of A, then -B and then the jump variables block of A
NY  = size(A,1);                % counts the number of variabls
C   = rref([A(:,NY-NK+1:end) -B A(:,1:NY-NK)]); % get the rref form
C   = -(C(:,NY+1:end));         % get rid of the identity part
C_1 = C(1:NK,1:NK);             % store the first block
C_2 = C(1:NK,NK+1:end);         % store the second block
C_3 = C(NK+1:end,1:NK);         % store the third block
C_4 = C(NK+1:end,NK+1:end);     % store the fourth block
end
