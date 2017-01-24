clear,clc
global xmean xcov xsd corrMatrix

xmean=[120000 160000];
xcov=[0.3 0.3];% coefficient of variation 
xsd=xmean.*xcov;
corrMatrix=[1 0
    		0 1];

DP = [75714.45371	73441.94686
48522.30988	152912.501];
dp2 = [
    94163	67805
    50567	151120] ;

% 0	94163	67805	0.99
% 0	94419	68718	1
% 0	47790	150770	0.96
% 0	50567	151120	1.01
dp3 = [89959.50753	71119.68145
49261.82363	151805.1603];
B3 = calPfFun(dp3)

B = calPfFun(DP)
B2 = calPfFun(dp2)
