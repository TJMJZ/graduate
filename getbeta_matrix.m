%% getbeta_matrix: get ipt_y beta
% input para should be in reduced space

function [ipt_beta] = getbeta_matrix(ipt_y)
	
	ipt_beta = sqrt(sum(ipt_y.^2,2));
