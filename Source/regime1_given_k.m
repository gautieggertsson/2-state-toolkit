%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 1 GIVEN K

% This function takes the transition matrices of regime 3, regime 2, the
% vector of durations corresponding to the different contingencies and the
% auxiliary matrices that were created by regime1_auxiliary.m
%
% It first finds the transition matrices of regime 1 (through the function
% regime1_find_transition.m) and then runs the model forward, given all the
% set of transition matrices (using the function regime1_fill_results.m).
% The latter function also tells whether the model as it is violates the
% constraint to a variable X

%% INPUT
% This function takes as inputs:
% - model matrices A and B under regime 1
% - transition matrices D_3a, D_3 and G_3 from REGIME3
% - transiton matrix D_2 and G_2
% - vector of guessed k
% - vectors of Markov process in HIGH and LOW states
% - auxiliary matrices in the structure aux
% - the value of the variable that is constrained when it is constrained
% (e.g. 0 for the ZLB)

%% OUTPUT
% It will deliver:
% - a series of two transition matrices (D and G) valid in regime 1, a
% matrix with the evolution of all the variables, a threshold tau for which
% the value of k was too small and a a status variable

function [D_1,G_1,ResM,wrong_tau,status] = regime1_given_k(A,B,A_r0,A0,B_r0,B0,D_3a,D_3,G_3,D_2a,D_2,G_2,k,T_tilde,rl,rh,aux,config,init_cond)

%NK      = size(D_2,2);  % count the state variables (including i)
%NY      = size(A,1);    % count the number of variables
%nshocks = size(rl,1);   % count the number of shocks
%taumax  = size(k,2);    % count the contingencies

%% find transition matrices starts
[D_0,G_0,D_1,G_1] = regime1_find_transition(A,B,A_r0,A0,B_r0,B0,aux,D_3,D_3a,D_2,D_2a,k,T_tilde,config.bound);

%% loop for filling the results in the history starts

[ResM,status,wrong_tau] = regime1_fill_results(D_0,G_0,D_1,D_2,D_3,G_1,G_2,G_3,k,T_tilde,rl,rh,config,init_cond);
