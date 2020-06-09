function f=d2Gdomega2fcn(z,sigma)
f = -z*normpdf(z)/omegafcn(z,sigma)/sigma^2;
end