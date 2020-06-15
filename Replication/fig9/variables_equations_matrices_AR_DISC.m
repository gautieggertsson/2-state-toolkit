% Variables
vars.x       = 1;
vars.pi      = 2;
vars.i       = 3;   
vars.r       = 4;   
vars.u       = 5;   
vars.rb      = 6; 

% Equations
eq.is     = 1;
eq.pc     = 2; 
eq.r      = 3;
eq.u      = 4;
eq.rb     = 5;
eq.i      = 6;

% Matrices
param.NY = 6;
AAA = zeros(param.NY,param.NY);
BBB = zeros(param.NY,param.NY);
    
% Output equation
AAA(eq.is,vars.x)        = 1;
AAA(eq.is,vars.pi)       = param.sigma;
BBB(eq.is,vars.x)        = 1;
BBB(eq.is,vars.i)        = param.sigma;
AAA(eq.is,vars.r)        = param.sigma;

% Inflation equation
AAA(eq.pc,vars.pi)       = param.beta;
BBB(eq.pc,vars.pi)       = 1;
BBB(eq.pc,vars.x)        = -param.kappa; 

% Natural-r constant
AAA(eq.r,vars.r)         = 1;
BBB(eq.r,vars.r)         = param.rho;
BBB(eq.r,vars.rb)         = 1-param.rho;
BBB(eq.r,vars.u)         = 1;

% Natural-r constant
AAA(eq.rb,vars.rb)         = 1;
BBB(eq.rb,vars.rb)         = 1;

% Natural-u constant
AAA(eq.u,vars.u)         = 1;
BBB(eq.u,vars.u)         = 1;

% Nominal interest rate
BBB(eq.i,vars.i)        = 1;
BBB(eq.i,vars.pi)       = -param.phi_pi;
BBB(eq.i,vars.r)        = -1; 

param.NS = 1;