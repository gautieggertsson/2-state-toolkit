function f=dGammadsigmafcn(z,sigma)
f = -normpdf(z-sigma);
end