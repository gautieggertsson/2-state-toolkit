function f=dGdsigmafcn(z,sigma)
f = -z*normpdf(z-sigma)/sigma;
end

