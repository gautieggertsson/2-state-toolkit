%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 1 HELPER

% This function creates a series of auxiliary matrices in order to take 
% into account the uncertainty in regime 1.
%
% simple explanation:
% you are in a period t and think that the regime 2 lasts for k periods, it
% follows that with probability 1-mu you will end up in regime 2 (k
% periods before regime 3 kicks in) and probability mu stay in the
% regime 1 (with the transition matrix corresponding to regime 1 of t+1)
%
% here we are constructing the matrices as functions of k, and we call them
% in the function regime1.m

%% INPUTS
% This function takes as inputs:
% - transiton matrices D_2 and D_3a
% - model matrices A and B in regime 1 (IMPORTANT!)
% - probability of the Markov process

%% OUTPUTS
% It will deliver a structure with auxiliary matrices to be used in the
% loop to calculate transition matrices in regime 1

function [aux] = regime1_helper(D_3a,D_2,A,B,mu)

%% prepare some auxiliary matrices
NY = size(A,1);     % count the number of variables
NK = size(D_2,2);   % count the number of state variables (including i)

% find the maximum value of k (which is the 3rd size of D_2)
aux.tD = max(1,size(D_2,3));

% construct a series of matrices A, that take into account the
% uncertainty
aux.tA1 = mu*repmat(A(:,1:NY-NK),1,1,aux.tD);  % this part is for 'remaining in the negative shock'
aux.tA2 = reshape(D_2,NY-NK,NK*aux.tD);               % we need the transition matrix of regime 2
aux.tA3 = (1-mu)*A(:,1:NY-NK)*aux.tA2;                 % multiply each of them by the matrix A and by 1-mu
aux.tA4 = (reshape(aux.tA3,NY,NK,aux.tD)+repmat(A(:,NY-NK+1:end),1,1,aux.tD)); % add the elements from the matrix A
aux.tA5 = cat(2,aux.tA1,aux.tA4);                     % concatenate the two blocks

% preallocate matrices for the rref block matrices
aux.tC1 = zeros(NK,NK,aux.tD);
aux.tC2 = zeros(NK,NY-NK,aux.tD);
aux.tC3 = zeros(NY-NK,NK,aux.tD);
aux.tC4 = zeros(NY-NK,NY-NK,aux.tD);

for i=1:aux.tD
    % compute the rref for each value of k in the vector of k (only for
    % positive k (IMPORTANT!)
    [aux.tC1(:,:,i),aux.tC2(:,:,i),aux.tC3(:,:,i),aux.tC4(:,:,i)] = rref_recursive_dg(aux.tA5(:,:,i),B,NK);
end

% rref for the case in which k=0
aux.tA6 = [A(:,1:NY-NK)*mu,A(:,NY-NK+1:end)+(1-mu)*A(:,1:NY-NK)*D_3a];  % first construct the A matrix
[aux.tB1,aux.tB2,aux.tB3,aux.tB4] = rref_recursive_dg(aux.tA6,B,NK);  % then run the rref form
