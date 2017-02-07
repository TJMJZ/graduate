function GenPara = genParaFun(lowerBound,upperBound)

global xmean xcov xsd corrMatrix
global totalNum


Cx=(xsd'*xsd).*corrMatrix;
for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end


%the following code is to draw samples from original space 
xmin=exp(lamda+lowerBound*kexi);
xmax=exp(lamda+upperBound*kexi);



% xmin=max((lowerBound*xsd+xmean),[0,0])
% xmax=upperBound*xsd+xmean
X=lhsu(xmin,xmax,totalNum);

%the following code is to draw samples from standard space
%and convert back to original space
% nmin = [-1;-1];
% nmax = [1;1];
% N = lhsu(nmin,nmax,totalNum);
% for i = 1:totalNum
% 	for j = 1:2
% 		X(i,j) = exp(lamda(j)-N(i,j)*kexi(j));
% 	end
% end


GenPara=X;
% GenPara=floor(GenPara*10)/10;




    

