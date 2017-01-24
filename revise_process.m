clear
clc

global xmean xsd xcov corrMatrix xr
global codeFolder reviseFolder
xmean = [8000 38 1-0.2863 4641 2.00E-05*1.03e-6];  
xsd = [4000 6 0.065 8808 1.55E-05*1.03e-6];
xcov = xsd./xmean;
corrMatrix=[1,0,0,0,0
    0,1,0,0,0
    0,0,1,0,0
    0,0,0,1,0
    0,0,0,0,1];
xr = corrMatrix;
codeFolder = 'F:\mjz\revisedp\svm';
reviseFolder = 'F:\mjz\FLAC700_2\Exe32';
dp = [6833.55451877706	36.4104647492801	0.583995448899905	485.346918294071	4.99444566142512e-12];
[reviseddp] = revisedp(dp);
differ = gety(dp)-reviseddp
