%make all the parameter transformations according to NYFED code

param.zstar               = param.gam_nyfed;
param.rstar               = (1/param.beta)*exp(param.gam_nyfed);
param.rkstar              = param.sprd*(1/param.beta)*exp(param.gam_nyfed)-(1-param.delta);
param.omegastar           = (param.alpha^(param.alpha)*(1-param.alpha)^(1-param.alpha)*...
    param.rkstar^(-param.alpha)/(1+param.lambda_f))^(1/(1-param.alpha));
param.kstar               = (param.alpha/(1-param.alpha))*param.omegastar*param.Lstar/param.rkstar;
param.kbarstar            = param.kstar*exp(param.gam_nyfed);
param.istokbarst          = 1-((1-param.delta)/(exp(param.gam_nyfed)));
param.istar               = param.kbarstar*param.istokbarst;
param.ystar               = (param.kstar^param.alpha)*(param.Lstar^(1-param.alpha))-param.Bigphi;

if param.ystar <= 0
    dm([param.ystar,param.Lstar,param.kstar,param.Bigphi])
end

param.cstar               = (param.ystar/param.gstar)-param.istar;
param.xistar              = (1/param.cstar)*((1/(1-param.h*exp(-param.gam_nyfed)))-(param.h*param.beta/(exp(param.gam_nyfed)-param.h)));
param.phi                 = param.Lstar^(-param.nu_l)*param.omegastar*param.xistar/(1+param.lambda_w);
param.Rstarn              = param.pistar*param.rstar;
param.wstar               = (1/(1+param.lambda_f)*(param.alpha^param.alpha) * (1-param.alpha)^(1-param.alpha) * param.rkstar^(-param.alpha) )^(1/(1-param.alpha));
param.mstar               = (param.chi * param.Rstarn/(param.Rstarn-1) * param.xistar^(-1) )^(1 / param.nu_m);

% solve for sigmaomegastar and zomegastar
param.zwstar              = norminv(param.Fom);
param.sigma_omega_star    = fzero(@(sigma)zetaspbfcn(param.zwstar,sigma,param.sprd)-param.zeta_sp_b,0.5);
% zetaspbfcn(zwstar,sigwstar,sprd)-zeta_spb % check solution

% evaluate omegabarstar
param.omegabarstar = omegafcn(param.zwstar,param.sigma_omega_star);

% evaluate all BGG function elasticities
param.Gstar = Gfcn(param.zwstar,param.sigma_omega_star);
param.Gammastar = Gammafcn(param.zwstar,param.sigma_omega_star);
param.dGdomegastar = dGdomegafcn(param.zwstar,param.sigma_omega_star);
param.d2Gdomega2star = d2Gdomega2fcn(param.zwstar,param.sigma_omega_star);
param.dGammadomegastar = dGammadomegafcn(param.zwstar);
param.d2Gammadomega2star = d2Gammadomega2fcn(param.zwstar,param.sigma_omega_star);
param.dGdsigmastar = dGdsigmafcn(param.zwstar,param.sigma_omega_star);
param.d2Gdomegadsigmastar = d2Gdomegadsigmafcn(param.zwstar,param.sigma_omega_star);
param.dGammadsigmastar = dGammadsigmafcn(param.zwstar,param.sigma_omega_star);
param.d2Gammadomegadsigmastar = d2Gammadomegadsigmafcn(param.zwstar,param.sigma_omega_star);

% evaluate mu, nk, and Rhostar
param.muestar = mufcn(param.zwstar,param.sigma_omega_star,param.sprd);
param.nkstar = nkfcn(param.zwstar,param.sigma_omega_star,param.sprd);
param.shostar = 1/param.nkstar-1;

% evaluate wekstar and vkstar
param.wekstar = (1-param.gammstar/param.beta)*param.nkstar...
    -param.gammstar/param.beta*(param.sprd*(1-param.muestar*param.Gstar)-1);
param.vkstar = (param.nkstar-param.wekstar)/param.gammstar;

% evaluate nstar and vstar
param.nstar = param.nkstar*param.kstar;
param.vstar = param.vkstar*param.kstar;

% a couple of combinations
param.GammamuG = param.Gammastar-param.muestar*param.Gstar;
param.GammamuGprime = param.dGammadomegastar-param.muestar*param.dGdomegastar;

% elasticities wrt omegabar
param.zeta_bw = zetabomegafcn(param.zwstar,param.sigma_omega_star,param.sprd);
param.zeta_zw = zetazomegafcn(param.zwstar,param.sigma_omega_star,param.sprd);
param.zeta_bw_zw = param.zeta_bw/param.zeta_zw;

% elasticities wrt sigw
param.zeta_bsigw = param.sigma_omega_star*(((1-param.muestar*param.dGdsigmastar/param.dGammadsigmastar)/...
    (1-param.muestar*param.dGdomegastar/param.dGammadomegastar)-1)*param.dGammadsigmastar*param.sprd+...
    param.muestar*param.nkstar*(param.dGdomegastar*param.d2Gammadomegadsigmastar-param.dGammadomegastar*param.d2Gdomegadsigmastar)/...
    param.GammamuGprime^2)/...
    ((1-param.Gammastar)*param.sprd+param.dGammadomegastar/param.GammamuGprime*(1-param.nkstar));
param.zeta_zsigw = param.sigma_omega_star*(param.dGammadsigmastar-param.muestar*param.dGdsigmastar)/param.GammamuG;
param.zeta_spsigw = (param.zeta_bw_zw*param.zeta_zsigw-param.zeta_bsigw)/(1-param.zeta_bw_zw);

% elasticities wrt mue
param.zeta_bmue = param.muestar*(param.nkstar*param.dGammadomegastar*param.dGdomegastar/param.GammamuGprime+param.dGammadomegastar*param.Gstar*param.sprd)/...
    ((1-param.Gammastar)*param.GammamuGprime*param.sprd+param.dGammadomegastar*(1-param.nkstar));
param.zeta_zmue = -param.muestar*param.Gstar/param.GammamuG;
param.zeta_spmue = (param.zeta_bw_zw*param.zeta_zmue-param.zeta_bmue)/(1-param.zeta_bw_zw);

% some ratios/elasticities
param.Rkstar = param.sprd*param.pistar*param.rstar; % (rkstar+1-delta)/ups*pistar;
param.zeta_Gw = param.dGdomegastar/param.Gstar*param.omegabarstar;
param.zeta_Gsigw = param.dGdsigmastar/param.Gstar*param.sigma_omega_star;

% % elasticities for equity equation
% zeta_vRk = Rkstar/pistar/exp(zstar)/vkstar*(1-muestar*Gstar*(1-zeta_Gw/zeta_zw));
% zeta_vR = 1/bet/vkstar*(1-nkstar+muestar*Gstar*sprd*zeta_Gw/zeta_zw);
% zeta_vqk = Rkstar/pistar/exp(zstar)/vkstar*(1-muestar*Gstar*...
%     (1+zeta_Gw/zeta_zw*nkstar/(1-nkstar)))-1/bet/vkstar;
% zeta_vn = 1/bet*nkstar/vkstar+...
%     Rkstar/pistar/exp(zstar)/vkstar*muestar*Gstar*zeta_Gw/zeta_zw/Rhostar;
% zeta_vmue = Rkstar/pistar/exp(zstar)/vkstar*muestar*Gstar*(1-zeta_Gw*zeta_zmue/zeta_zw);
% zeta_vsigw = Rkstar/pistar/exp(zstar)/vkstar*muestar*Gstar*(zeta_Gsigw-zeta_Gw/zeta_zw*zeta_zsigw);

% elasticities for the net worth evolution
param.zeta_nRk = param.gammstar*param.Rkstar/param.pistar/exp(param.zstar)*(1+param.shostar)*(1-param.muestar*param.Gstar*(1-param.zeta_Gw/param.zeta_zw));
param.zeta_nR = param.gammstar/param.beta*(1+param.shostar)*(1-param.nkstar+param.muestar*param.Gstar*param.sprd*param.zeta_Gw/param.zeta_zw);
param.zeta_nqk = param.gammstar*param.Rkstar/param.pistar/exp(param.zstar)*(1+param.shostar)*(1-param.muestar*param.Gstar*(1+param.zeta_Gw/param.zeta_zw/param.shostar))...
    -param.gammstar/param.beta*(1+param.shostar);
param.zeta_nn = param.gammstar/param.beta+param.gammstar*param.Rkstar/param.pistar/exp(param.zstar)*(1+param.shostar)*param.muestar*param.Gstar*param.zeta_Gw/param.zeta_zw/param.shostar;
param.zeta_nmue = param.gammstar*param.Rkstar/param.pistar/exp(param.zstar)*(1+param.shostar)*param.muestar*param.Gstar*(1-param.zeta_Gw*param.zeta_zmue/param.zeta_zw);
param.zeta_nsigw = param.gammstar*param.Rkstar/param.pistar/exp(param.zstar)*(1+param.shostar)*param.muestar*param.Gstar*(param.zeta_Gsigw-param.zeta_Gw/param.zeta_zw*param.zeta_zsigw);

%%%%%%%%%%%%%%%%%%%%%%%%%stop copy from their code

%transform several variables into our notation
param.zeta_sp_sigma_omega =  param.zeta_spsigw;
param.zeta_n_r_tilde_k    =  param.zeta_nRk;
param.zeta_n_r            =  param.zeta_nR;
param.zeta_n_q_k          =  param.zeta_nqk;
param.zeta_n_n            =  param.zeta_nn;
param.zeta_n_sigma_omega  =  param.zeta_nsigw;
param.sigma_omega_tilde   =  param.zeta_sp_sigma_omega * param.sigma_omega_star; %%%only enters through shock!

