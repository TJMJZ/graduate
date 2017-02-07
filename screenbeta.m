%% screenbeta:screen input using upper-lower bound of beta
% input parameters: input-x or input-y(x is for orginal space y is for reduced space)
% X:1 Y:0
function [optpara,screened_index] = screenbeta(iptpara,XYidfer,betalb,betaub)

	if (XYidfer)
		[iptbeta,iptpara] = gety_matrix(iptpara);
	else
		iptbeta = getbeta_matrix(iptpara);
	end

	screened_index = find((iptbeta>beta_lb)&(iptbeta<beta_ub));
	optpara = iptpara(screened_index,:);
