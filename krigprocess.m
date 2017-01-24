
input = load('fosList.dat');
thresh = 1e-3;
input(:,1) = [];
dim = 5;
[m,n] = size(input);

% [b,input(:,1:n-1)] = getn(input(:,1:n-1),xmean,xsd,corrMatrix)
input(:,3) = 1-input(:,3);

input(find(input(:,n)>thresh),n) = 1;
input(find(input(:,n)<=thresh),n) = 0;

[ibeta,input_cvt] = getn(input(:,1:(n-1)),xmean,xsd,corrMatrix);
input_cvt = [input_cvt,input(:,n)]
input_modify = input_cvt(intersect(find(ibeta>2.5),find(ibeta<5)),:);
[m1,n1] = size(input_modify);
ipt = input_modify(:,1:(n-1));
opt = logical(input_modify(:,n));
% opt = input(:,n);
num = 1500;
ical = ipt(1:num,:);
ival = ipt((num+1):m1,:);
ocal = opt(1:num,:);
oval = opt((num+1):m1,:);

q0=ones(1,dim);
	%temp=xsd.^2;
    %q0=1./temp;
	lb=ones(1,dim)/1e5;
	ub=1e5*ones(1,dim);

	[kM000100, perf0]=dacefit(ical,ocal,@regpoly2,@correxp,q0,lb,ub);
    a=valiKrigLogical(kM000100,ival, oval,0.5);