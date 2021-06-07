function f=d2Gammadomega2fcn(z,sigma)
f = -normpdf(z)/omegafcn(z,sigma)/sigma;
end