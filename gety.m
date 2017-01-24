function y=gety(x)
global xmean xsd
covx=xsd./xmean;
for i=1:length(x)
   kexi=sqrt(log(1+covx(i)^2)) ;
   lamda=log(xmean(i))-0.5*kexi^2;
   y(i)=(log(x(i))-lamda)/kexi;     
end

