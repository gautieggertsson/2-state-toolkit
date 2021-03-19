%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% IMPULSE RESPONSE

% Impulse response functions code for models with ZLB and two-state Markov
% shocks

%% PREALLOCATE
IR = zeros(param.NY,size(ResM,1));

%% PROBABILITY WEIGHTS
P = (1-param.mu)*param.mu.^[0:1:config.taumax-2]';
P(end) = param.mu^(config.taumax-2);

%% COMPUTE WEIGHTED AVERAGE
for v = 1:param.NY
      IR(v,:)=reshape(ResM(:,v,2:end),size(ResM,1),size(ResM,3)-1)*P;
end
 
IR=IR'; % flip so that first dimension is time
clear v i P
