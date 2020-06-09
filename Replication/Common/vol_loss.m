% Josef Platzer, 10/22/19
% function to calculate volatility of variable. Amounts to loss for
% particular loss function: squared deviation of variable from steady state
% value:
% 
%   loss = E sum_t=0^infty beta^t(x-bar_x)^2   
% 
% INPUTS:
%   ResM ... time x var x contingency matrix of variables or tie x
%   contigency matrix
%   variable ... scalar of element in ResM, dim 2, for which to calculate, i.e.
%   the variable for which to calculate loss
%          NOTE: don't hand in strucutre, but scalar
%   SSval ... steady state value of variable (scalar)
%   beta      ... discount factor (scalar)
%   mu        ... probabilty to stay in low state (scalar)
% OUTPUT:
%   y   ´... expected welfare loss (scalar)

function loss = vol_loss(ResM,variable,SSval,beta,mu)

dimension = size(size(ResM),2);

if dimension ~= 2
    if dimension == 3
    ResM_Mat = ResM(:,variable,:);
    ResM_Mat = permute(ResM_Mat,[1 3 2]);
    else
        disp('ResM input wrong: array dimension must be 2 or 3')
        pause
    end
else
    ResM_Mat = ResM;
end

tmax   = size(ResM_Mat,1);
taumax = size(ResM_Mat,2);

util     = 0;
%cum_prob = 0;  %cumulated probability. to check if sums to one
for itau = 2:taumax   %loop over tau
    if itau < taumax
        util_it = 0;
        for it = 1:tmax %loop over t
            util_it = util_it + beta^it*(ResM_Mat(it,itau)-SSval)^2;
        end
        util = util + util_it*mu^(itau-2)*(1-mu);
        %       cum_prob = cum_prob + mu^(itau-2)*(1-mu); %for check if sum to one
    else %at taumax return to high state with prob 1
        util_it = 0;
        for it = 1:tmax
            util_it = util_it + beta^it*(ResM_Mat(it,itau)-SSval)^2;
        end
        util = util + util_it*mu^(itau-2);
        %       cum_prob = cum_prob + mu^(itau-2); %for check if sum to one
    end
end

loss = util;