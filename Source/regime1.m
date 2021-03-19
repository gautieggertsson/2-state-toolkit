%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 1 FUNCTION

% This function creates the transition matrices of regime 1 (by using the
% transition matrices in regimes 2 and 3) and traces the evolution of all
% the variables over time for each of the different contingency. The
% function also checkes that the contstraint is not violated in regime 3.

%% INPUT
% This function takes as inputs:
% - model matrices
% - LOW and HIGH state Markov parameters (rl, rh and mu)
% - transition matrix D_3a and D_3 from REGIME3
% - transition matrix D_2 from REGIME2
% - transition matrix G_3 from REGIME3
% - transition matrix G_2 from REGIME2
% - number of contingencies
% - the value of the variable that is constrained when it is constrained
% (e.g. 0 for the ZLB)
% - number of state variables not including the variable that is
% constrained under regimes 1 and 2
% - the indicator of whether to apply monotonicity assumption
% - the vector of durations k

%% OUTPUT
% It will deliver a series of two transition matrices (D and G)
% corresponding to the distance from the start of REGIME3

function [D_1_out, G_1_out, ResM_out, max_k_out,k_out,T_tilde] = ...
    regime1(AAA,BBB,D_3a,D_3,D_2,G_3,G_2,param,config,varargin)

% Input handler
p = inputParser;

addParameter(p,'verbose',0,@(x) isnumeric(x));
addParameter(p,'k_input',zeros(1,config.taumax),@(x) ismatrix(x));
addParameter(p,'T_tilde_input',1,@(x) isnumeric(x));
addParameter(p,'R0_search',1,@(x) isnumeric(x));

parse(p,varargin{:});
config.verbose = p.Results.verbose;
k_input = p.Results.k_input;
T_tilde_input = p.Results.T_tilde_input;
if T_tilde_input < 1
    disp('Error: T_tilde_input has to be larger-equal 1')
    return
end
R0_search = p.Results.R0_search;
clear p varargin;

A   = AAA;                  % this matrix will be fed to the rref function after some minor modification
B   = BBB;                  % same for this other matrix
NY  = size(AAA,1);          % count the number of variables
nshocks = size(param.sl,1); % count the number of shocks
NK  = param.NS+1;           % count the state variables + shocks + 1

D_1 = zeros((NY-NK),NK,(config.taumax-1)); % preallocate transition matrices
G_1 = zeros(NK,NK,(config.taumax-1));
max_length_2 = size(D_2,3); % count the maximum length of regime 2

in_handle = isfield(param,'init_cond');
if in_handle == 0
    param.init_cond = zeros(NY,1); % preallocate the vector xi
end

in_handle = isfield(config,'trh');
if in_handle == 0
    config.trh = -exp(-14); % threshold when ZLB understood as binding
end

%% substitute the value of the Markov vector in LOW state in the matrices A and B
%   IMPORTANT it is substituting for the shocks value in all equations but
%   the shock equations
A(1:end-nshocks-1,end-nshocks+1:end)  = AAA(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sl',NY-nshocks-1,1);
B(1:end-nshocks-1,end-nshocks+1:end)  = BBB(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sl',NY-nshocks-1,1);
A(end,end-nshocks+1:end)  = AAA(end,end-nshocks+1:end).*param.sl';
B(end,end-nshocks+1:end)  = BBB(end,end-nshocks+1:end).*param.sl';

%% substitute the policy rule and the interest rate coefficients to zero
A(end,:)        = zeros(1,NY);  % here we substitute the policy rule with all zeros
B(end,:)        = zeros(1,NY);  % in both the matrices
A(end,NY-NK+1)  = 1;            % here we substitute the interest rate entry with a one
B(end,NY-NK+1)  = 1;            % in both the matrices

%% call the auxiliary function that creates auxiliary matrices to find transition matrices
aux = regime1_helper(D_3a,D_2,A,B,param.mu);

% extend A, B, and D_3 to take into account r0shock. NOTE: r_0shock will be
% equal to 1
A0   = AAA;                  % this matrix will be fed to the rref function after some minor modification
B0   = BBB;
A0(1:end-nshocks-1,end-nshocks+1:end)  = AAA(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sl',NY-nshocks-1,1);
B0(1:end-nshocks-1,end-nshocks+1:end)  = BBB(1:end-nshocks-1,end-nshocks+1:end).*repmat(param.sl',NY-nshocks-1,1);
A0(end,end-nshocks+1:end)  = AAA(end,end-nshocks+1:end).*param.sl';
B0(end,end-nshocks+1:end)  = BBB(end,end-nshocks+1:end).*param.sl';

A_r0 = [A0,zeros(NY,1)];       % add column of zeros at the end
A_r0 = [A_r0;[zeros(1,NY),1]]; % add row of zeros, with 1 in last column for r_0_shock
B_r0 = [B0,zeros(NY,1)];       % add column of zeros at the end
B_r0 = [B_r0;[zeros(1,NY),1]]; % add row of zeros, with 1 in last column for r_0_shock
D_3_r0 = [D_3,zeros(size(D_3,1),1)];  % add column of zeros to D_3, because adding r_0_shock adds another state variable
[aux_r0,D_2a] = regime0_helper(D_3_r0,D_2,A_r0,B_r0,param.mu,config.bound);

aux.tB1_r0 = aux_r0.tB1_r0;    % move auxilary matrices from aux_r0 to aux
aux.tB2_r0 = aux_r0.tB2_r0;
aux.tB3_r0 = aux_r0.tB3_r0;
aux.tB4_r0 = aux_r0.tB4_r0;
aux.tC1_r0 = aux_r0.tC1_r0;
aux.tC2_r0 = aux_r0.tC2_r0;
aux.tC3_r0 = aux_r0.tC3_r0;
aux.tC4_r0 = aux_r0.tC4_r0;

%% start the loop to find T_tilde
T_tilde = T_tilde_input-1;     % start with T_tilde = 1. Could allow input that determines starting value
T_tilde_bad = 1; % initialize exit key of the loop

while T_tilde_bad
    k = k_input;
    T_tilde = T_tilde+1;
    if R0_search == 0
        T_tilde_bad = 0;
    end
    %% start the loop to find the right k-vector
    status_k_bad = 1; % initialize exit key of the loop
    
    while status_k_bad
        % call the function that traces the history of the variables and
        % returns a check on the correctness of the k-vector
        [D_1,G_1,ResM,wrong_tau,status_k_bad] = regime1_given_k(A,B,A_r0,A0,B_r0,B0,D_3a,D_3,G_3,D_2a,D_2,G_2,k,T_tilde,param.sl,param.sh,aux,config,param.init_cond);
        
        if wrong_tau < 0
            % if the guessed k works, then go out of k loop
            break
        end
        if status_k_bad
            % if the evolution turns out to be wrong at some contingency
            % then increse all the k from that contingency onwards
            if config.mono
                k(wrong_tau:end) = k(wrong_tau) + 1;
            else
                k(wrong_tau) = k(wrong_tau) + 1;
            end
            if config.verbose
                disp(strcat('Changing k of contingency', " ", num2str(wrong_tau)))
            end
        end
        if k(wrong_tau) >= max_length_2
            % if the updated k is too high, then stop all the code
            disp('ERROR: Guess a different maximum k.');
            break
        end
    end
    
    if wrong_tau > 0
        if k(wrong_tau) >= max_length_2
            % if the updated k is too high, then stop all the code
            disp('ERROR: Guess a different maximum k.');
            break
        end
    end
    
    % here check if i at t=T_tilde is really implied to be negative
    % without imposing ZLB. If it is not, the T_tilde is not correct,
    % and search for T_tilde will continue
    if T_tilde > 1 && status_k_bad == 0 && R0_search == 1
        if T_tilde > config.taumax
            if config.verbose
                disp('T_tilde status: good')
            end
            break
        end
        if config.verbose
            disp(strcat("Result matrix for period T_tilde-1, variable NY-NK+1, contingency T_tilde: ",num2str(ResM(T_tilde-1,NY-NK+1,T_tilde))));
            disp(strcat("T_tilde: ",num2str(T_tilde)))
        end
        
        
        if ResM(T_tilde-1,NY-NK+1,T_tilde) <= config.bound+config.trh
            if config.verbose
                disp('T_tilde status: good')
            end
            break
        end
    end
    
    %save output to hand out once correct T_tilde found
    max_k_out = max(k);
    k_out   = k;
    ResM_out = ResM;
    D_1_out     = real(D_1);
    G_1_out     = real(G_1);
    
end
if R0_search == 1
    T_tilde = T_tilde -1;
end
end
