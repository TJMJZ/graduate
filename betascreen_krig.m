%% betascreen_krig: function description
function [screened_output,krigbeta_ub,krigbeta_lb]  = betascreen_krig(input_flac,mech_thresh,beta_offset)

	[flac_num,col_num] = size(input_flac);


	iptfail_org = input_flac(find(input_flac(:,col_num)>mech_thresh),:);
	[iptfail_beta,iptfail] = gety_matrix(iptfail_org(:,1:(col_num-1)));
	betamin = min(iptfail_beta);
	krigbeta_lb = betamin-beta_offset;
	krigbeta_ub = krigbeta_lb+3*beta_offset;

	input_flac(find(input_flac(:,col_num)>mech_thresh),col_num) = 1;
	input_flac(find(input_flac(:,col_num)<=mech_thresh),col_num) = 0;

	soilpara_org = input_flac(:,1:(col_num-1));
	[soilpara_beta,soilpara] = gety_matrix(soilpara_org);

	screened_input = input_flac(find((soilpara_beta>krigbeta_lb)&(soilpara_beta<krigbeta_ub)),:);
	[betatemp,opty] = gety_matrix(screened_input(:,1:(col_num-1)));
	screened_output = [opty screened_input(:,col_num)];
end
	% kriginput = input(intersect((find(soilpara_beta>krigbeta_lb)),find(soilpara_beta<krigbeta_ub)),:);
