function [y,exp_zlb,c,v,imp,irf] = out(ResM,IR,k,T_tilde,vars,param,V,cont,mod)

switch mod
    
    case 'eqnk'
        
        %% WELFARE LOSS
        ResM_pi = squeeze(ResM(:,vars.pi,:));
        ResM_x  = squeeze(ResM(:,vars.x,:));
        lambda  = [param.lagr_pi;param.lagr_x];
        target  = zeros(2,1);
        y = wloss(ResM_pi,ResM_x,lambda,target,param.beta,param.mu);
        
        %% VOLATILITY
        v(1)  = vol_loss(ResM,vars.x,0,param.beta,param.mu);
        v(2)  = vol_loss(ResM,vars.pi,0,param.beta,param.mu);
        v(3)  = vol_loss(ResM,vars.i,param.sh(1),param.beta,param.mu);
        
        %% INITIAL IMPACT
        imp(1) = 100*ResM(1,vars.x,2);
        imp(2) = 400*ResM(1,vars.pi,2);
       
        %% STORE IMPULSE RESPONSE AND FOR SELECTED CONTINGENCY AND AVERAGE
        for i = 1:length(V)
            eval(strcat('c(:,i) = ResM(:,vars.',string(V(i)),',cont);'))
            eval(strcat('irf(:,i) = IR(:,vars.',string(V(i)),');'))
        end
        
    case 'nyfed'
        
        % Rescale ResM
        ResM(:,vars.pi,:) = ResM(:,vars.pi,:)+log(param.pistar);
        ResM(:,vars.R,:)  = ResM(:,vars.R,:)+log(param.Rstarn);
        
        % Rescale IR
        IR(:,vars.pi,:) = IR(:,vars.pi,:)+log(param.pistar);
        IR(:,vars.R,:)  = IR(:,vars.R,:)+log(param.Rstarn);
        
        %% WELFARE LOSS
        ResM_pi = squeeze(ResM(:,vars.pi,:));
        ResM_y  = squeeze(ResM(:,vars.y,:));
        lambda  = [param.lagr_pi;param.lagr_x];
        target  = [log(param.pistar);0];
        y = wloss(ResM_pi,ResM_y,lambda,target,param.beta,param.mu);
        
        %% VOLATILITY
        v(1)  = vol_loss(ResM,vars.y,0,param.beta,param.mu);
        v(2)  = vol_loss(ResM,vars.pi,log(param.pistar),param.beta,param.mu);
        v(3)  = vol_loss(ResM,vars.R,log(param.Rstarn),param.beta,param.mu);
        
        %% INITIAL IMPACT
        imp(1) = 100*ResM(1,vars.y,2);
        imp(2) = 400*ResM(1,vars.pi,2);
        
        %% STORE IMPULSE RESPONSE FOR SELECTED CONTINGENCY
        for i = 1:length(V)
            eval(strcat('c(:,i) = ResM(:,vars.',string(V(i)),',cont);'))
            eval(strcat('irf(:,i) = IR(:,vars.',string(V(i)),');'))
        end
end

%% EXPECTED TIME AT ZLB
exp_zlb = 0;
for i = 2+(T_tilde-1):size(ResM,3)
    exp_zlb = exp_zlb+(i-1+k(i)-(T_tilde-1))*(param.mu)^(i-2)*(1-param.mu);
end

end