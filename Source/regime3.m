%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 3 FUNCTION

% General code for models with ZLB and two states Markov shocks
%
% This function produces transition matrices corresponding to the regime 3,
% where both the exogenous Markov shock is over and the constraint of the
% jump variable X is NOT binding.
%
% It takes the model matrices A and B and calls the functions reds.m and
% solds.m in order to get the tansition matrices. After that, it transforms
% the transition matrices in order to allow for the variable X to enter the
% equations as a state variable.

%% INPUTS
% The inputs of this particular code you must are:
% - model matrices
% - HIGH state Markov parameters (rh)
% - number of state variables

%% OUTPUTS
% This function delivers two transition matrices (D_3 and G_3) that
% will hold in regime 3

function [D_3,G_3,D_3a] = regime3(AAA,BBB,param)

A   = AAA;                % this matrix will be fed to reds and solds
% after some minor modification
B   = BBB;                % the same for this other matrix
NY  = size(AAA,1);        % this counts the number of variables
nshocks=size(param.rh,1); % counts the number of shocks
NK  = param.NS+nshocks;   % in regime 3 the shocks are treated as states
NX  = 1;                  % this is to preallocate the number of shocks
% (it will be useless) for reds and solds
C   = zeros(NY, NX);      % same for the matrix that multiply the shocks

%% substitute the value of the Markov vector in HIGH state in the matrices A and B
%   IMPORTANT it is substituting for the shocks value in all equations but
%   the shock equations
A(1:end-nshocks-1,end-nshocks+1:end)  = AAA(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.rh',NY-nshocks-1,1);
B(1:end-nshocks-1,end-nshocks+1:end)  = BBB(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.rh',NY-nshocks-1,1);
A(end,end-nshocks+1:end)  = AAA(end,end-nshocks+1:end).*param.rh';
B(end,end-nshocks+1:end)  = BBB(end,end-nshocks+1:end).*param.rh';

%% run reds and solds
reds
solds

%% correct for ROUNDING ERRORS
D = real(D);
G = real(G);

%% Save results to transition matrices from reds and solds
D_3 = D(1:NY-NK,:);
G_3 = G;

%% modify the transition matrix D_3 from REGIME3 to include the interest rate in the state variables

% preallocate an empty matrix
D_3a = zeros(NY-NK-1,NK+1);

% assign the coefficients of rows corresponding to jump variables
% excluding the nominal interest rate and columns corresponding to the
% state variables, for the interest rate we preallocated a 0
D_3a(:,2:end) = D_3(1:end-1,:);

D_3     = real(D_3);
D_3a    = real(D_3a);
G_3     = real(G_3);
