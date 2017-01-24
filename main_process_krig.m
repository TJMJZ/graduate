clear
clc
global xmean xsd xcov corrMatrix xr
global codeFolder reviseFolder
xmean = [8000 38 0.2863 4641 2.00E-05*1.03e-6];  
xsd = [4000 6 0.065 8808 1.55E-05*1.03e-6];
 xcov = xsd./xmean;
corrMatrix=[1,0,0,0,0
    0,1,0,0,0
    0,0,1,0,0
    0,0,0,1,0
    0,0,0,0,1];
rx = corrMatrix;
paradim = length(xmean);
codeFolder = 'F:\mjz\revisedp\krig';
reviseFolder = 'F:\mjz\FLAC700_2\Exe32';

% setup basic parameters
APOSITION = 3;
mech_thresh = 1e-3;
cosdp_thresh = 0.7;
logical_thresh =0.45;
failnumlimit = 3000;
calkrig_limit = 1500;
valikrig_percent = 0.15;
calkrig_percent = 1- valikrig_percent;
beta_offset = 1;

lowerBound = -4;
upperBound = 0.5;
N = 10000000;
sampleRangeL = -4;
sampleRangeU = 0;

% load data and initialize
input_flac = load('fosList.dat');
input_flac(:,1) = [];

% a to b convert
% a b relationship a = 1-b is in original(which is x) space
xmean(:,APOSITION) = 1-xmean(:,APOSITION);
input_flac(:,APOSITION) = 1-input_flac(:,APOSITION);

% process data: 
% convert mechratio to fail-nofail logical
% convert para from orignal space(x-space) to y-space
% isolate IO:para and result

[screened_ipt,krigbeta_ub,krigbeta_lb] = betascreen_krig(input_flac,mech_thresh,beta_offset);

[krig_num,ipt_dim] = size(screened_ipt);
calkrig_num = fix(krig_num*calkrig_percent);
if calkrig_num>calkrig_limit
  calkrig_num =calkrig_limit;
end
valikrig_num = krig_num - calkrig_num;

failstat = logical(screened_ipt(:,ipt_dim));

ical = screened_ipt(1:calkrig_num,1:ipt_dim-1);
ocal = failstat(1:calkrig_num,:);
ival = screened_ipt((calkrig_num+1):krig_num,1:ipt_dim-1);
oval = failstat((calkrig_num+1):krig_num,:);

q0=ones(1,paradim);
  %temp=xsd.^2;
    %q0=1./temp;
lb=ones(1,paradim)/1e5;
ub=1e5*ones(1,paradim);

disp('fitting kriging');
[kM000100, perf0]=dacefit(ical,ocal,@regpoly2,@correxp,q0,lb,ub);
valikrig_result=valiKrigLogical(kM000100,ival, oval,logical_thresh)/valikrig_num;

disp('processing samples');
% generate samples:in x-space, should convert to y-space to do things
Sample100Set1 = MvLogNRand( xmean , xsd , N , corrMatrix );

for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end
xmin=exp(lamda+sampleRangeL*kexi);
xmax=exp(lamda+sampleRangeU*kexi);

parfor l= 1:N
  if prod((Sample100Set1(l,:)>xmin).*(Sample100Set1(l,:)<xmax))
    temp100Set1(l,:) = Sample100Set1(l,:);
  end
end
Sample100Set1 = temp100Set1(find(temp100Set1(:,1)),:);
clear temp100Set1

[orgsamples_beta,orgsamples_y] = gety_matrix(Sample100Set1);
screensample_idx = find((orgsamples_beta>krigbeta_lb)&(orgsamples_beta<krigbeta_ub));
mcsample_y = orgsamples_y(screensample_idx,:);
mcsample_beta = orgsamples_beta(screensample_idx,:);

clear orgsamples_y orgsamples_beta

disp('looking for failure point');
mcsample_rst=(predictor(mcsample_y,kM000100)>(logical_thresh));

mcfail_y = mcsample_y(find(mcsample_rst),:);

[krigfail_m,krigfail_n] = size(mcfail_y);
if krigfail_m>failnumlimit
	krigfail_num = failnumlimit;
else
	krigfail_num = krigfail_m;
end

[krig_yrep,krig_dpbeta,krig_dpcorr] = findmajormodes_y(mcfail_y(1:krigfail_num,:),cosdp_thresh);
krig_xrep = getx_matrix(krig_yrep);
krig_sysfp = calPfFun(krig_xrep);

% revise krig_based dp
krig_xrep = krig_xrep(1,:);
[krig_reviseddp] = revisedp(krig_xrep);
krig_sysfp_rvs = calPfFun(getx(krig_reviseddp));
krig_dpdiffer = gety(krig_xrep)-krig_reviseddp;
krig_betadiffer = sqrt(sum(krig_dpdiffer.^2));
krig_fpdiffer = abs(krig_sysfp-krig_sysfp_rvs)/krig_sysfp_rvs;

