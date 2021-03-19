%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 2 FUNCTION

% This function takes the transition matrix D_3a, corresponding to the
% regime 3 and uses it in a recursive-backward way to find the transition
% matrix for the period before regime 3 starts, then using this result it
% finds the transition matrix for 2 periods before regime 3 starts and so
% on.
%
% The production of the transition matrices is done by the function
% recursive_dg.m which takes as inputs the 'next period transition matrix'
% D_prime and also takes some time-invariant matrices (C_1,C_2,C_3,C_4)
% from the function rref_recursive_dg.
%
% All the transition matrices are stored in one 3-dimension matrices D_2
% and G_2 where the third dimension corresponds to 'distance in time from
% regime 3'.

%% INPUT
% The inputs of this particular code you must are:
% - model matrices
% - HIGH state Markov parameters (rh)
% - transition matrix D_3a (no need for G_3) from REGIME3
% - the maximum length of REGIME2

%% OUTPUT
% This function delivers a series of two transition matrices (D and G)
% corresponding to the distance from the start of regime 3

function [D_2, G_2] = regime2(AAA,BBB,D_3a,param,config)

A           = AAA;              % this matrix will be fed to the rref function after some minor modification
B           = BBB;              % same for this other matrix
NY          = size(AAA,1);      % count the number of variables
nshocks     = size(param.sh,1); % count the number of shocks
NK          = size(D_3a,2);     % count the state variables + shocks + i

%% substitute the value of the Markov vector in HIGH state in the matrices A and B
%   IMPORTANT it is substituting for the shocks value in all equations but
%   the shock equations
A(1:end-nshocks-1,end-nshocks+1:end)  = AAA(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sh',NY-nshocks-1,1);
B(1:end-nshocks-1,end-nshocks+1:end)  = BBB(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sh',NY-nshocks-1,1);
A(end,end-nshocks+1:end)  = AAA(end,end-nshocks+1:end).*param.sh';
B(end,end-nshocks+1:end)  = BBB(end,end-nshocks+1:end).*param.sh';

%% substitute the policy rule and the interest rate coefficients to zero
%     A(:,NY-NK+1)    = zeros(NY,1);   % those are the coefficients of the matrices A and B
%     B(:,NY-NK+1)    = zeros(NY,1);   % corresponding to the interest rate
A(end,:)        = zeros(1,NY);   % here we substitute the policy rule with all zeros
B(end,:)        = zeros(1,NY);   % in both the matrices
A(end,NY-NK+1)  = 1;             % here we substitute the interest rate entry with a one
B(end,NY-NK+1)  = 1;             % in both the matrices

%% calculate the reduced row echelon form of the modified [A -B] from the function rref_recursivedg
[C_1,C_2,C_3,C_4] = rref_recursive_dg(A,B,NK);

%% start the recursive part
% preallocate the D_2 and G_2 matrices, which will be big matrices where
% each block/slice corresponds to one transition matrix depending on the
% periods before REGIME3 kicks in
D_2 = zeros((NY-NK),NK,config.max_length_2);
G_2 = zeros(NK,NK,config.max_length_2);

D_prime = D_3a; % preallocate the matrix from regime 3

for i = 1:config.max_length_2  % loop starts
    % here we call the recursive function and update the new D and G matrices
    [D_prime, G_2(:,:,i)]    = recursive_dg(C_1,C_2,C_3,C_4,D_prime);
    % here we save the new D matrix in the big D matrix (the G has been
    % saved in the previous step)
    D_2(:,:,i) = D_prime;
end

D_2     = real(D_2);
G_2     = real(G_2);
