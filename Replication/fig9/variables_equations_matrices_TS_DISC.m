% Variables
vars.x       = 1;   % comment
vars.pi      = 2;   % comment
vars.i       = 3;   % comment   
vars.r       = 4;   % comment 

% Equations
eq.is     = 1;  % comment
eq.pc     = 2;  % comment 
eq.r      = 3;  % comment
eq.i      = 4;  % comment

% Matrices
param.NY = 4;
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);
    
% Output equation
AAA(eq.is,vars.x)        = 1;
AAA(eq.is,vars.pi)       = param.sigma;
BBB(eq.is,vars.x)        = 1;
BBB(eq.is,vars.i)        = param.sigma;
BBB(eq.is,vars.r)        = -param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)       = param.beta;
BBB(eq.pc,vars.pi)       = 1;
BBB(eq.pc,vars.x)        = -param.kappa; 

% Natural-r constant
AAA(eq.r,vars.r)         = 1;
BBB(eq.r,vars.r)         = 1;

% Nominal interest rate
BBB(eq.i,vars.i)        = 1;
BBB(eq.i,vars.pi)       = -param.phi_pi;
BBB(eq.i,vars.r)        = -1; 

param.NS = 0;