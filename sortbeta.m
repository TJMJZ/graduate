function [beta2,DP2,i]=sortbeta(beta,DP)

XX=[beta DP];
[candel, i] = sort(XX(:,1));
 XX2 = XX(i,:);
%XX2(1:10,:)
beta2=XX2(:,1);
[m,n] = size(DP);
DP2=XX2(:,2:(2+n-1));

