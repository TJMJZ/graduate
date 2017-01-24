function b=objFORM(y)
global xmean xsd xr x1
b=sqrt(y*inv(xr)*transpose(y));