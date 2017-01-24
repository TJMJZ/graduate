%% functionname: function description
function [B] = calPfFun(DP)
global xmean xcov xsd corrMatrix



[beta,R]=GetBetaR(DP);
beta;

format long;

[LB,UB]=SysRel(beta,R);
B = [LB,UB];
normcdf(-beta);
