%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 1 TRANSITION MATRICES

% This function takes the transition matrices from regime 3 and regime 2
% and the auxiliary matrices created in regime1_auxiliary.m to find the
% transition matrices, given a vector k of durations of regime 2.
%
% The function works in a recursive and backwards fashion, so that the
% counter i stands for the periods away from the very last contingency. So
% that if i=2, it means t=taumax-i, and we are looking for transition
% matrices for such a period.
%
% In the case i=1, meaning that the next period the shock is costruct to
% be over (so that the shock is over with probability 1) and that the
% corresponding guess for k is positive, then we have to take into account
% that next period we think that we will end up in regime 2 for k periods.
%
% In the case i=1, meaning that the next period the shock is costruct to
% be over (so that the shock is over with probability 1) and that the
% corresponding guess for k is ZERO, then we have to take into account
% that next period we think that we will end up in regime 3.
%
% In the case i>1, meaning that the next period the shock is not be with
% NOT be over w/prob=1, and that the corresponding guess for k is positive,
% then we have to take into account that next period we think that we will
% end up w/prob=1-mu in regime 2 for k periods or remain in regime 1
% (using the transition matrix of the period after, namely taumax-i+1.
%
% In the case i>1, meaning that the next period the shock is not be with
% NOT be over w/prob=1, and that the corresponding guess for k is 0, then
% we have to take into account that next period we think that we will end
% up w/prob=1-mu in regime 3 for or remain in regime 1 (using the
% transition matrix of the period after, namely taumax-i+1.

%% INPUTS
% This function takes as inputs:
% - model matrices A and B
% - auxiliary matrices
% - transition matrix D_2
% - transition matrix D_3a
% - k vector

%% OUTPUTS
% It will deliver:
% - a series of transition matrices D_1 and G_1

function [D_0,G_0,D_1,G_1] = regime1_find_transition(A,B,A_r0,A0,B_r0,B0,aux,D_3,D_3a,D_2,D_2a,k,T_tilde,bound)

NK      = size(D_2,2);  % count the state variables
taumax  = size(k,2);    % counts the max contingency
NY      = size(A,1);    % count the variables
D_1     =   zeros((NY-NK),NK,taumax-T_tilde); % preallocate the result matrices
G_1     =   zeros(NK,NK,(taumax-T_tilde));
D_0     =   zeros(NY-(NK-1),NK-1+1,T_tilde-1);
G_0     =   zeros(NK-1+1,NK-1+1,(T_tilde-1));

mu0  = 0;            % mu1 = 0 when last contingency is at stake

%% loop to find transition matrices starts
for i=1:taumax-1
    if i == 1
        if k(taumax-i+1) > 0
            if T_tilde < taumax - i + 1
                % CASE 1
                % R1 to R2 w/p = 1
                tA=[ A(:,1:NY-NK)*mu0,A(:,NY-NK+1:end)+(1-mu0)*...
                    A(:,1:NY-NK)*D_2(:,:,k(taumax-i+1))];
                % calculate the rref for this particular case
                [tE1,tE2,tE3,tE4] = rref_recursive_dg(tA,B,NK);
                % find the transition matrices for this case
                [D_1(:,:,taumax-T_tilde+1-i),G_1(:,:,taumax-T_tilde+1-i)]=recursive_dg...
                    (tE1,tE2,tE3,tE4,D_2(:,:,k(taumax-i+1)));
            elseif T_tilde == taumax - i + 1
                % CASE 2
                % R0 to R2 w/p = 1 (need to adjust matrices)
                tA=[A_r0(:,1:NY+1-(NK+1-1))*mu0,A_r0(:,NY+1-(NK+1-1)+1:end)+(1-mu0)*A_r0(:,1:NY+1-(NK+1-1))*D_2a(:,:,k(taumax-i+1))];
                % calculate the rref for this particular case
                [tE1,tE2,tE3,tE4] = rref_recursive_dg(tA,B_r0,NK+1-1);
                % find the transition matrices for this case
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = recursive_dg(tE1,tE2,tE3,tE4,D_2a(:,:,k(taumax-i+1)));
            end
        elseif k(taumax-i+1) == 0
            if T_tilde < taumax - i + 1
                % CASE 3
                % R1 to R3 w/p = 1
                tA=[ A(:,1:NY-NK)*mu0,A(:,NY-NK+1:end)+(1-mu0)*A(:,1:NY-NK)*D_3a];
                % calculate the rref for this particular case
                [tE1,tE2,tE3,tE4] = rref_recursive_dg(tA,B,NK);
                % find the transition matrices for this case
                [D_1(:,:,taumax-T_tilde+1-i),G_1(:,:,taumax-T_tilde+1-i)] = recursive_dg(tE1,tE2,tE3,tE4,D_3a);
            elseif T_tilde == taumax - i + 1
                % CASE 4
                % R1 to R2 w/p = 1
                tA=[ A_r0(:,1:NY+1-(NK+1-1))*mu0,A_r0(:,NY+1-(NK+1-1)+1:end)+(1-mu0)*A_r0(:,1:NY+1-(NK+1-1))*[D_3 zeros(size(D_3,1),1)]];
                % calculate the rref for this particular case
                [tE1,tE2,tE3,tE4] = rref_recursive_dg(tA,B_r0,NK+1-1);
                % find the transition matrices for this case
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = recursive_dg(tE1,tE2,tE3,tE4,[D_3 zeros(size(D_3,1),1)]);
            end
        end
    elseif i >1
        if k(taumax-i+1) > 0
            if T_tilde < taumax - i + 1
                % CASE 5
                % R1 to R2 w/p = 1-mu, R1 to R1 w/p = mu
                [D_1(:,:,taumax-T_tilde+1-i),G_1(:,:,taumax-T_tilde+1-i)] = ...
                    recursive_dg(aux.tC1(:,:,k(taumax-i+1)),...
                    aux.tC2(:,:,k(taumax-i+1)),aux.tC3(:,:,k(taumax-i+1)),...
                    aux.tC4(:,:,k(taumax-i+1)),D_1(:,:,(taumax-T_tilde+1-i+1)));
            elseif T_tilde == taumax - i + 1
                % CASE 6
                % R0 to R2 w/p = 1-mu, R0 to R1 w/p = mu
                D_1_1a = [D_1(:,2:end,1),D_1(:,1,1)*bound];
                D_1_1a = [D_1_1a;[zeros(1,size(D_1,2)-1),bound]];
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = ...
                    recursive_dg(aux.tC1_r0(:,:,k(taumax-i+1)),...
                    aux.tC2_r0(:,:,k(taumax-i+1)),aux.tC3_r0(:,:,k(taumax-i+1)),...
                    aux.tC4_r0(:,:,k(taumax-i+1)),D_1_1a);
            elseif T_tilde > taumax - i + 1
                % CASE 7
                % R0 to R2 w/p = 1-mu, R0 to R0 w/p = mu
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = ...
                    recursive_dg(aux.tC1_r0(:,:,k(taumax-i+1)),...
                    aux.tC2_r0(:,:,k(taumax-i+1)),aux.tC3_r0(:,:,k(taumax-i+1)),...
                    aux.tC4_r0(:,:,k(taumax-i+1)),D_0(:,:,taumax-i+1));
            end
        elseif k(taumax-i+1) == 0
            if T_tilde < taumax - i + 1
                % CASE 8
                % R1 to R3 w/p = 1-mu, R1 to R1 w/p = mu
                [D_1(:,:,taumax-T_tilde+1-i),G_1(:,:,taumax-T_tilde+1-i)] = recursive_dg...
                    (aux.tB1,aux.tB2,aux.tB3,aux.tB4,D_1(:,:,(taumax-T_tilde+1-i+1)));
            elseif T_tilde == taumax - i + 1
                % CASE 9
                % R0 to R3 w/p = 1-mu, R0 to R1 w/p = mu
                D_1_1a = [D_1(:,2:end,1),D_1(:,1,1)*bound];
                D_1_1a = [D_1_1a;[zeros(1,size(D_1,2)-1),bound]];
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = ...
                    recursive_dg(aux.tB1_r0(:,:),...
                    aux.tB2_r0(:,:),aux.tB3_r0(:,:),...
                    aux.tB4_r0(:,:),D_1_1a);
            elseif T_tilde > taumax - i + 1
                % CASE 10
                % R0 to R3 w/p = 1-mu, R0 to R0 w/p = mu
                [D_0(:,:,taumax-i),G_0(:,:,taumax-i)] = ...
                    recursive_dg(aux.tB1_r0(:,:),...
                    aux.tB2_r0(:,:),aux.tB3_r0(:,:),...
                    aux.tB4_r0(:,:),D_0(:,:,taumax-i+1));
            end
        end
    end
end