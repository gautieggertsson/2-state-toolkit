function f=zetaspbfcn(z,sigma,sprd)
zetaratio = zetabomegafcn(z,sigma,sprd)/zetazomegafcn(z,sigma,sprd);
nk = nkfcn(z,sigma,sprd);
f = -zetaratio/(1-zetaratio)*nk/(1-nk);
end