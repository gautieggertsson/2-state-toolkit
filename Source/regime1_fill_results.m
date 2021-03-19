%% A TOOLKIT FOR SOLVING MODELS WITH A ZERO LOWER BOUND ON INTEREST RATES
% (C) Eggertsson G., Egiev S., Lin A., Platzer J. and Riva L.

%% REGIME 1 TO FILL RESULTS IN THE HISTORY FUNCTION

% This function takes the transition matrices for all the regimes and the
% vector k of guesses durations. It then runs the model forward according
% to such transition matrices and checks that in the first period of
% regime 3 the constraint of the variable X is NOT violated

%% INPUT
% This function takes as inputs:
% - transition matrix D_1
% - transition matrix D_2
% - transition matrix D_3 (not D_3a !!!)
% - transition matrix G_1
% - transition matrix G_2
% - transition matrix G_3
% - vector k
% - shocks in HIGH state
% - shocks in LOW state
% - the value of the variable that is constrained when it is constrained
% (e.g. 0 for the ZLB)

%% OUTPUT
% It will deliver:
% - one matrix in 3 dimensions, tracing the evolutions of the variables
% across different contingencies
% - the status of the whether the constraint is violated or not
% - the contingency at which the constraint is violatedù

function [ResM,status_bad,wrong_tau] = regime1_fill_results(D_0,G_0,D_1,...
    D_2,D_3,G_1,G_2,G_3,k,T_tilde,rl,rh,config,init_cond)

% constraint is thought as binding
taumax =size(k,2);  % count the max contingency
time = floor((taumax+size(D_2,3))*1.1); % set for how long, forward, to run the model
NY = size(D_1,1)+size(G_1,1);   % count the variables
ResM=zeros(time,NY,taumax);     % preallocate the matrix of results
NK=size(D_1,2);                 % count the state variables (NS+nshocks+interest rate) 
nshocks = size(rl,1);           % count the shocks

%% enlarge and pile up the transition matrices
% for regime 3
T3 = [D_3; G_3];                % stock up the actual transition matrix
T3 = [zeros(NY,NY-NK+1), T3];   % add zeros for the jump variables

% for regime 2
T2 = cat(1,D_2,G_2);            % stock up the actual transition matrix
T2 = cat(2,zeros(NY,NY-NK,size(T2,3)),T2);  % add zeros for the jump variables

% for regime 1
T1 = cat(1,D_1,G_1);            % stock up the actual transition matrix
T1 = cat(2,zeros(NY,NY-NK,size(T1,3)),T1);  % add zeros for the jump variables

% for regime 0
T0 = cat(1,D_0,G_0);            % stock up the actual transition matrix
T0 = cat(2,zeros(NY+1,NY-NK+1,size(T0,3)),T0); % add zeros for the jump variables; NOTE: i_t considered to be jump!!!

%% construct history
status_bad = 0;    % preallocate a status variable
wrong_tau = -1;     % preallocate the wrong tau
for tau=2:taumax

    if tau == 2
        newy =init_cond;          % preallocate vector xi

        newy =[newy(1:NY-nshocks,1); ones(nshocks,1)];  % preallocate vector xi (with one for the shocks)
        
        if T_tilde == 1
        newy(NY-NK+1,1) = config.bound;    % give the constrained value to the variable that has a constraint
        end
        
    else
        %reconstruct newy of tau-1 from previous contingency
        %T1 has block of zeros in first NY-NK columns anyway
        if tau-1 == T_tilde %just entered in regime 1
            newy = ResM(tau-1,:,tau-1)';
            newy(NY-NK+1,1) = config.bound;
            newy(NY-nshocks+1:end) = ones(nshocks,1);
        elseif tau-1 > T_tilde
            newy              = ResM(tau-1,:,tau-1)';
            newy(NY-NK+1,1)   = config.bound;
            newy(NY-nshocks+1:end) = ones(nshocks,1);
        elseif tau-1 < T_tilde
            newy              = ResM(tau-1,:,tau-1)';
            newy(NY-nshocks+1:end) = ones(nshocks,1);
        end
    end
    
    if tau-1 < T_tilde
        % in regime 0
        t=tau-1;
        ResM(t,NY-NK+2:end,tau)   = newy(NY-NK+2:end,1);    % fill the state variables
        newy                      = T0(:,:,t)*[newy;1];     % calculate the new xi; NOTE: make sure that T0 is filled accordingly; NOTE: T0 is NY+1 x NY+1
        newy                      = newy(1:end-1);          % drop the NY+1
        ResM(t,1:NY-NK+1,tau)     = newy(1:NY-NK+1,1);      % fill the jump variables
        ResM(t,end-nshocks+1:end,tau) = rl;                 % fill the actual shock in the variables
    else
        
        % in regime 1
        t=tau-1;
        ResM(t,NY-NK+1:end,tau)   = newy(NY-NK+1:end,1);    % fill the state variables;
        newy                      = T1(:,:,t-(T_tilde-1))*newy;
        ResM(t,1:NY-NK,tau)       = newy(1:NY-NK,1);            % fill the jump variables
        ResM(t,end-nshocks+1:end,tau) = rl;                 % fill the actual shock in the variables
    end
    
    % in regime 2   
    if T_tilde >= tau && k(tau)>0 
        % coming from R0: impose i to bound, because otherwise will ResM
        % with i not equal to bound
        newy(NY-NK+1) = config.bound;
    end
    for t=tau:tau+k(tau)-1
        ResM(t,NY-NK+1:end,tau)   = newy(NY-NK+1:end,1);    % fill the state variables
        newy                      = T2(:,:,k(tau)-(t-tau))*newy;                 % calculate the new xi
        ResM(t,1:NY-NK,tau)       = newy(1:NY-NK,1);            % fill the jump variables
        ResM(t,end-nshocks+1:end,tau) = rh;                 % fill the actual shock in the variables
    end
    
    
    
    % in regime 3
    t=tau+k(tau);
    ResM(t,NY-NK+2:end,tau)   = newy(NY-NK+2:end,1);    % fill the state variables
    newy                      = T3*newy;                                     % calculate the new xi
    ResM(t,1:NY-NK+1,tau)     = newy(1:NY-NK+1,1);        % fill the jump variables
    ResM(t,end-nshocks+1:end,tau) = rh;                 % fill the actual shock in the variables
    if ResM(t,NY-NK+1,tau)<(config.bound+config.trh)
        % check if the first period of regime 3 violates the
        % constraint
        wrong_tau = tau;    % if so, this contingency must be saved as wrong
        if config.verbose 
            disp(strcat("ResM(t,NY-NK+1,tau): ",num2str(ResM(t,NY-NK+1,tau))));
            fprintf('Negative interest rate in regime 3!\n\n');
        end
        status_bad = 1;
        break;
    end
end

% fill remaining t
if status_bad == 0
    for tau=2:taumax
        if tau > 2
            %fill up missing values in regime 1
            ResM(1:tau-2,:,tau) = ResM(1:tau-2,:,tau-1);        %take history for regime one from previous tau
        end
        
        %fill up missing values in regime 3
        
        %get correct newy; 
        newy = zeros(NY,1);
        newy(NY-NK+2:end) = ResM(tau+k(tau),NY-NK+2:end,tau);
        newy(NY-nshocks+1:end) = ones(nshocks,1);                   %only NY-NK+2:end needed, because T3 has block of
        %zeros in first NY-NK+1 columns anyway
        newy              = T3*newy;                                %update "newy" by one period
        
        for t=tau+k(tau)+1:size(ResM,1)                         % continue with filling results for remaining t
            ResM(t,NY-NK+2:end,tau)   = newy(NY-NK+2:end,1);    % fill the state variables
            newy                      = T3*newy;                % calculate the new xi
            ResM(t,1:NY-NK+1,tau)     = newy(1:NY-NK+1,1);      % fill the jump variables
            ResM(t,end-nshocks+1:end,tau) = rh;                 % fill the actual shock in the variables  
        end
    end
end
