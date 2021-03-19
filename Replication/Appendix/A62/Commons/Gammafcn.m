function f=Gammafcn(z,sigma)
f = omegafcn(z,sigma)*(1-normcdf(z))+normcdf(z-sigma);
end