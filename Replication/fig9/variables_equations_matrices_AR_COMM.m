% Variables
vars.x       = 1;   % comment
vars.pi      = 2;   % comment 
vars.i       = 3;   % comment      
vars.phi1    = 4;   % comment
vars.phi2    = 5;   % comment
vars.r       = 6;   % comment 
vars.u       = 7;   % comment   
vars.rb      = 8;   % comment 
 


% Equations
eq.is     = 1;  % comment
eq.pc     = 2;  % comment
eq.foc_x  = 3;  % comment
eq.foc_pi = 4;  % comment  
eq.r      = 5;    
eq.u      = 6;  % comment
eq.rb     = 7;  % comment
eq.i      = 8;  % interest rate 

 

% Matrices
param.NY = 8;
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

% FOC output gap
AAA(eq.foc_x,vars.phi1)  = -1;
AAA(eq.foc_x,vars.phi2)  = param.kappa;
BBB(eq.foc_x,vars.x)     = param.lagr_x;
BBB(eq.foc_x,vars.phi1)  = -param.beta^(-1);

% FOC inflation
AAA(eq.foc_pi,vars.phi2) = -1;
BBB(eq.foc_pi,vars.phi1) = -param.beta^(-1)*param.sigma;
BBB(eq.foc_pi,vars.phi2) = -1;
BBB(eq.foc_pi,vars.pi)   = 1;

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
AAA(eq.i,vars.phi1)      = 1; 



param.NS = 3;