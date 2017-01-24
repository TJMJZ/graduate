function x=getx(y)
global xmean xsd
covx=xsd./xmean;
for i=1:length(y)
   kexi=sqrt(log(1+covx(i)^2)) ;
   lamda=log(xmean(i))-0.5*kexi^2;
   x(i)=exp(lamda+kexi*y(i));     
end
% x(1,1)=x(1,1)*1000;
% flac unit shouldnt be changed here

