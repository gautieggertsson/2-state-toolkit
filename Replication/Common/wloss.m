% function to calculate expected welfare loss implied by quadratic loss
% function with two state shock with absorbing state
% Josef Platzer, 10/22/19
% INPUTS: 
%   ResM ... time x var x contingency matrix of variables
%   lambda ... column vector with weight on inflation and output [w_pi; w_x]
%   target ... column vector with central bank targets for inflation and
%   output [target_pi; target_x]
%   beta      ... discount factor (scalar)
%   mu        ... probabilty to stay in low state (scalar)
% OUTPUT:
%   y   ´... expected welfare loss (scalar)

function y = wloss(ResM_pi,ResM_x,lambda,target,beta,mu)
tmax   = size(ResM_pi,1);
taumax = size(ResM_pi,2);

util     = 0;  
%cum_prob = 0;  %cumulated probability. to check if sums to one
for itau = 2:taumax   %loop over tau
    if itau < taumax   
        util_it = 0;
        for it = 1:tmax %loop over t
            util_it = util_it + beta^it*(lambda'*([ResM_pi(it,itau);ResM_x(it,itau)]-target).^2);
        end
        util = util + util_it*mu^(itau-2)*(1-mu);
%       cum_prob = cum_prob + mu^(itau-2)*(1-mu); %for check if sum to one
    else %at taumax return to high state with prob 1
        util_it = 0;
        for it = 1:tmax
            util_it = util_it + beta^it*(lambda'*([ResM_pi(it,itau);ResM_x(it,itau)]-target).^2);
        end
        util = util + util_it*mu^(itau-2);
%       cum_prob = cum_prob + mu^(itau-2); %for check if sum to one
    end
end

y = util;