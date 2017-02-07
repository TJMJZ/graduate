%% betascreen: function description
function [screenedx] = betascreen(iptx,betal,betau)

	[iptbeta,ipty] = gety_matrix(iptx);
	screenedy = ipty(find((iptbeta>betal)&(iptbeta<betau)),:);

	screenedx = getx_matrix(screenedy);
