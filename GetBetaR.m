function [beta,R]=GetBetaR(DP)
global xmean xcov xsd corrMatrix
for i=1:length(xmean)
    slnx(i)=sqrt(log(1+xcov(i)^2));
    mlnx(i)=log(xmean(i))-0.5*slnx(i)^2;

end

for i=1:length(DP(:,1))
   for j=1:length(xmean)
      n(i,j)=(log(DP(i,j))-mlnx(j))/slnx(j); 
   end    
end

for i=1:length(DP(:,1))
    n(i,:)*corrMatrix*transpose(n(i,:));
    beta(i)=sqrt(n(i,:)*corrMatrix*transpose(n(i,:))); 
end

for i=1:length(DP(:,1))
 for j=1:i
   if i==j
       R(i,j)=1;
   else
       R(i,j)=n(i,:)*corrMatrix*transpose(n(j,:))/beta(i)/beta(j);
       R(j,i)=R(i,j);
   end
 end
end
