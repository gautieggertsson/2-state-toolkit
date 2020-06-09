function f=d2Gdomegadsigmafcn(z,sigma)
f = -normpdf(z)*(1-z*(z-sigma))/sigma^2;
end
