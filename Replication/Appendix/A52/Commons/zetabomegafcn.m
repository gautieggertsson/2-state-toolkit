function f=zetabomegafcn(z,sigma,sprd)
nk = nkfcn(z,sigma,sprd);
mustar = mufcn(z,sigma,sprd);
omegastar = omegafcn(z,sigma);
Gammastar = Gammafcn(z,sigma);
Gstar = Gfcn(z,sigma);
dGammadomegastar = dGammadomegafcn(z);
dGdomegastar = dGdomegafcn(z,sigma);
d2Gammadomega2star = d2Gammadomega2fcn(z,sigma);
d2Gdomega2star = d2Gdomega2fcn(z,sigma);
f = omegastar*mustar*nk*(d2Gammadomega2star*dGdomegastar-d2Gdomega2star*dGammadomegastar)/...
    (dGammadomegastar-mustar*dGdomegastar)^2/sprd/...
    (1-Gammastar+dGammadomegastar*(Gammastar-mustar*Gstar)/(dGammadomegastar-mustar*dGdomegastar));
end