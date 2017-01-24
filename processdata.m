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


totalNum = 3000;
input = load('fosList.dat');
thresh = 1e-3;
input(:,1) = [];

[m,n] = size(input);

% [b,input(:,1:n-1)] = getn(input(:,1:n-1),xmean,xsd,corrMatrix)
input(:,3) = 1-input(:,3);

input(find(input(:,n)>thresh),n) = 1;
input(find(input(:,n)<=thresh),n) = 0;
ipt = input(:,1:(n-1));
[ibeta,ipt] = getn(input(:,1:(n-1)),xmean,xsd,corrMatrix);
opt = logical(input(:,n));
num = 2900;
ical = ipt(1:num,:);
ival = ipt((num+1):m,:);
ocal = opt(1:num,:);
oval = opt((num+1):m,:);

%SVMstruct = svmtrain(ical,ocal,'kernel_function','rbf','rbf_sigma',1);
%SVMstruct = svmtrain(ical,ocal);
options = statset('Display','iter','MaxIter',50000);
SVMstruct = svmtrain(ical,ocal,'kernel_function','quadratic','options',options);
newClasses = svmclassify(SVMstruct,ival);
rst = sum(xor(newClasses,oval));


% interface

lowerBound = -4;
upperBound = 0.5;
N = 1000000;
sampleRangeL = -4;
sampleRangeU = 0;

for i=1:length(xmean)
           kexi(i)=sqrt(log(1+(xsd(i)/xmean(i))^2)) ;
           lamda(i)=log(xmean(i))-0.5*kexi(i)^2;
end



xmin=exp(lamda+sampleRangeL*kexi);
xmax=exp(lamda+sampleRangeU*kexi);


Sample100Set1 = MvLogNRand( xmean , xsd , N , corrMatrix );


for l= 1:N
	if prod((Sample100Set1(l,:)>xmin).*(Sample100Set1(l,:)<xmax))
		temp100Set1(l,:) = Sample100Set1(l,:);
	end
end

Sample100Set1 = temp100Set1(find(temp100Set1(:,1)),:);
clear temp100Set1
mcClasses = svmclassify(SVMstruct,Sample100Set1);
mcfail = Sample100Set1(find(mcClasses(:,1)==1),:);

[xrep,minbeta,minbetaCor] = findMajorModes(mcfail,0.7);

sysfp = calPfFun(xrep)

[dpbeta,dpR] = GetBetaR(xrep);


xrep = xrep(1,:);
[reviseddp] = revisedp(xrep);
sysfp_rvs = calPfFun(reviseddp);
differ = gety(xrep)-reviseddp;
betadiffer = sqrt(sum(differ.^2));
fpdiffer = abs(sysfp-sysfp_rvs)/sysfp_rvs;
