function [beta,n] = getn(x,xmean,xsd,Rx)
[M,N]=size(x);
for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end

for i=1:1:M
    for j=1:1:N
        n(i,j)=(log(x(i,j))-lamda(j))/kexi(j);
    end
end

for i=1:1:M
beta(i)=sqrt(n(i,:)*inv(Rx)*transpose(n(i,:)));
end

size(beta);
beta=beta';


