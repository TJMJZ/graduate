function [x_beta,opty] = gety_matrix(iptx)

global xmean xsd rx
[M,N]=size(iptx);

for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end

kexi_t = repmat(kexi,M,1);
lamda_t = repmat(lamda,M,1);
opty=(log(iptx)-lamda_t)./kexi_t;

x_beta = sqrt(sum(opty.^2,2));




