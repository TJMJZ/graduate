clear
clc
global xmean xsd xcov corrMatrix xr
global codeFolder reviseFolder


ksatcvt = 1.03e-3;
% interface
xmean = [8000 38 1-0.2863 4641 2.00E-05*ksatcvt];  
xsd = [4000 6 0.065 8808 1.55E-05*ksatcvt];

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
valikrig_percent = 0.1;
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
input_flac = unique(input_flac,'rows', 'stable' );


% a to b convert
% a b relationship a = 1-b is in original(which is x) space
xmean(:,APOSITION) = 1-xmean(:,APOSITION);
input_flac(:,APOSITION) = 1-input_flac(:,APOSITION);

% process data: 
% convert mechratio to fail-nofail logical
% convert para from orignal space(x-space) to y-space
% isolate IO:para and result

% [screened_ipt,krigbeta_ub,krigbeta_lb] = betascreen_krig(input_flac,mech_thresh,beta_offset);
screened_ipt = input_flac;

[krig_num,ipt_dim] = size(screened_ipt);
screened_ipt(find(screened_ipt(:,ipt_dim)>mech_thresh),ipt_dim) = 1;
screened_ipt(find(screened_ipt(:,ipt_dim)<=mech_thresh),ipt_dim) = 0;

valikrig_num = floor(valikrig_percent*krig_num);

for t = 1:10
  tpointer = (t-1)*valikrig_num;
  crossvali_set{t,1} = screened_ipt((tpointer+1):(tpointer+valikrig_num),:);
end

%q0=ones(1,paradim);
  temp=xsd.^2;
  q0=1./temp;
lb=ones(1,paradim)/1e5;
ub=1e5*ones(1,paradim);

for t = 1:10
  iocal = [];
  for i = 1:10
    if(i-t)
      iocal = [iocal;crossvali_set{i,1}];
      
    else
      ioval = crossvali_set{i,1};
    end
  end
  ical = iocal(:,1:(ipt_dim-1));
  ival = ioval(:,1:(ipt_dim-1));
  ocal = iocal(:,ipt_dim);
  oval = ioval(:,ipt_dim);

  [kMtemp, perf0]=dacefit(ical,ocal,@regpoly2,@correxp,q0,lb,ub);
  valikrig_result=valiKrigLogical(kMtemp,ival, oval,logical_thresh)/valikrig_num;
  kmlist{t,1} = kMtemp;
  kmlist{t,2} = valikrig_result;
end


