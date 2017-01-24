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
codeFolder = 'F:\mjz\revisedp\svm';
reviseFolder = 'F:\mjz\FLAC700_2\Exe32';

% setup basic parameters
APOSITION = 3;
mech_thresh = 1e-3;
cosdp_thresh = 0.5;
failnumlimit = 3000;
valisvm_percent = 0.15;
calsvm_percent = 1- valisvm_percent;
beta_offset = 0.5;

lowerBound = -4;
upperBound = 0.5;
N = 1000000;
sampleRangeL = -4;
sampleRangeU = 0;

% load data and initialize
input = load('fosList.dat');
input(:,1) = [];
[flac_num,col_num] = size(input);
calsvm_num = fix(flac_num*calsvm_percent);
valisvm_num = flac_num - calsvm_num;

% a to b convert
% a b relationship a = 1-b is in original(which is x) space
xmean(:,APOSITION) = 1-xmean(:,APOSITION);
input(:,APOSITION) = 1-input(:,APOSITION);

% process data: 
% convert mechratio to fail-nofail logical
% convert para from orignal space(x-space) to y-space
% isolate IO:para and result
input(find(input(:,col_num)>mech_thresh),col_num) = 1;
input(find(input(:,col_num)<=mech_thresh),col_num) = 0;
soilpara_org = input(:,1:(col_num-1));
[soilpara_beta,soilpara] = gety_matrix(soilpara_org);
failstat = logical(input(:,col_num));

ical = soilpara(1:calsvm_num,:);
ocal = failstat(1:calsvm_num,:);
ival = soilpara((calsvm_num+1):flac_num,:);
oval = failstat((calsvm_num+1):flac_num,:);

% start SVM process
% note that svm-process is done in y-space
options = statset('Display','iter','MaxIter',50000);
SVMstruct = svmtrain(ical,ocal,'kernel_function','quadratic','options',options);
oval_svm = svmclassify(SVMstruct,ival);
misspercent_svm = sum(xor(oval_svm,oval))/valisvm_num;
%SVMstruct = svmtrain(ical,ocal,'kernel_function','rbf','rbf_sigma',1);
%SVMstruct = svmtrain(ical,ocal);


% generate samples:in x-space, should convert to y-space to do things
for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end
xmin=exp(lamda+sampleRangeL*kexi);
xmax=exp(lamda+sampleRangeU*kexi);
Sample100Set1 = MvLogNRand( xmean , xsd , N , corrMatrix );
parfor l= 1:N
	if prod((Sample100Set1(l,:)>xmin).*(Sample100Set1(l,:)<xmax))
		temp100Set1(l,:) = Sample100Set1(l,:);
	end
end
Sample100Set1 = temp100Set1(find(temp100Set1(:,1)),:);
clear temp100Set1
[mcsample_beta,mcsample_y] = gety_matrix(Sample100Set1);

% find dp using svm

mcClasses_svm = svmclassify(SVMstruct,mcsample_y);
mcfail_svm_y = mcsample_y(find(mcClasses_svm(:,1)==1),:);
[svmfail_m,svmfail_n] = size(mcfail_svm_y);
if svmfail_m>failnumlimit
	svmfail_num = failnumlimit;
else
	svmfail_num = svmfail_m;
end

[svm_yrep,svm_dpbeta,svm_dpcorr] = findmajormodes_y(mcfail_svm_y(1:svmfail_num,:),cosdp_thresh);
svm_xrep = getx_matrix(svm_yrep);
svm_sysfp = calPfFun(svm_xrep);

% revise svm_based dp
svm_xrep = svm_xrep(1,:);
[svm_reviseddp] = revisedp(svm_xrep);
svm_sysfp_rvs = calPfFun(svm_reviseddp);
svm_dpdiffer = gety(svm_xrep)-svm_reviseddp;
svm_betadiffer = sqrt(sum(svm_dpdiffer.^2));
svm_fpdiffer = abs(svm_sysfp-svm_sysfp_rvs)/svm_sysfp_rvs;

