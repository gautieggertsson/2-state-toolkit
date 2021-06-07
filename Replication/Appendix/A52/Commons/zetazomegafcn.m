function f=zetazomegafcn(z,sigma,sprd)
mustar = mufcn(z,sigma,sprd);
f = omegafcn(z,sigma)*(dGammadomegafcn(z)-mustar*dGdomegafcn(z,sigma))/...
    (Gammafcn(z,sigma)-mustar*Gfcn(z,sigma));
end