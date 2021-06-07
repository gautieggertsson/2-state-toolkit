function f=nkfcn(z,sigma,sprd)
f = 1-(Gammafcn(z,sigma)-mufcn(z,sigma,sprd)*Gfcn(z,sigma))*sprd;
end
