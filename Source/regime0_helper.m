%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 0 HELPER

% This code mimicks regime1_helper, but for regime 0
% Note: D_2 is the input argument needed. Will be transformed to D_2a inside
% the function

function [aux,D_2a] = regime0_helper(D_3_r0,D_2,A_r0,B_r0,mu,bound)

%% prepare some auxiliary matrices
NY = size(A_r0,1);  % count the number of variables
NK = size(D_2,2);   % count the number of state variables (excluding i, but including r0shock)

% find the maximum value of k (which is the 3rd size of D_2)
aux.tD_r0=max(1,size(D_2,3));

% adjust D_2 matrix to account for r_0_shock and that in regime 0 i_t is
% jump var
D_2a = [D_2(:,2:end,:),D_2(:,1,:)*bound];
D_2a = cat(1,D_2a,repmat([zeros(1,NK-1),bound],1,1,aux.tD_r0));

% construct a series of matrices A, that take into account the
% uncertainty
aux.tA1_r0=mu*repmat(A_r0(:,1:NY-NK),1,1,aux.tD_r0);  % this part is for 'remaining in the negative shock'
aux.tA2_r0=reshape(D_2a,NY-NK,NK*aux.tD_r0);                 % we need the transition matrix of regime 2
aux.tA3_r0=(1-mu)*A_r0(:,1:NY-NK)*aux.tA2_r0;                % multiply each of them by the matrix A and by 1-mu
aux.tA4_r0=(reshape(aux.tA3_r0,NY,NK,aux.tD_r0)+repmat(A_r0(:,NY-NK+1:end),1,1,aux.tD_r0)); % add the elements from the matrix A
aux.tA5_r0=cat(2,aux.tA1_r0,aux.tA4_r0);                     % concatenate the two blocks

% preallocate matrices for the rref block matrices
aux.tC1_r0=zeros(NK,NK,aux.tD_r0);
aux.tC2_r0=zeros(NK,NY-NK,aux.tD_r0);
aux.tC3_r0=zeros(NY-NK,NK,aux.tD_r0);
aux.tC4_r0=zeros(NY-NK,NY-NK,aux.tD_r0);

for i=1:aux.tD_r0
    % compute the rref for each value of k in the vector of k (only for
    % positive k (IMPORTANT!)
    [aux.tC1_r0(:,:,i),aux.tC2_r0(:,:,i),aux.tC3_r0(:,:,i),aux.tC4_r0(:,:,i)] = rref_recursive_dg(aux.tA5_r0(:,:,i),B_r0,NK);
end

% rref for the case in which k=0
aux.tA6_r0=[A_r0(:,1:NY-NK)*mu,A_r0(:,NY-NK+1:end)+(1-mu)*A_r0(:,1:NY-NK)*D_3_r0];  % first construct the A matrix
[aux.tB1_r0,aux.tB2_r0,aux.tB3_r0,aux.tB4_r0] = rref_recursive_dg(aux.tA6_r0,B_r0,NK);        % then run the rref form