%% getx_matrix: function description
function [optx] = getx_matrix(ipty)

	global xmean xsd xcov

	[M,N] = size(ipty);
	for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
	end
	kexi_t = repmat(kexi,M,1);
	lamda_t = repmat(lamda,M,1);

	optx = exp(lamda_t+kexi_t.*ipty);

end
