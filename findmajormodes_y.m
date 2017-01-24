%% functionname: function description
function [xrep,minbeta,minbetaCor] = findmajormodes_y(DP,thresh)

global xmean xcov xsd corrMatrix
DPbackup = DP;
dpbeta = sqrt(sum((DP.^2),2));
%sort
[dpbeta,DP,OldInd]=sortbeta(dpbeta,DP);
%oldint is the original number of the ranked beta&design point

%intersection angle
for i=1:length(dpbeta)
DP2(i,:)=DP(i,:)/dpbeta(i);
end
R=DP2*transpose(DP2);
clear DP2;

R1=R;
beta1=dpbeta;
DP1=DP;
stopcriteria=0;
j=0;

%find representative point
while stopcriteria==0
    j=j+1;
    [beta1,DP]=sortbeta(beta1,DP1);
    minbeta(j,1)=beta1(1);
 
    clear Ind
    Ind=find(R1(1,:)<thresh);
    size(Ind);
    size(beta1);
    max(Ind);
    beta2=beta1(Ind);
    DP2=DP1(Ind,:);
    R2=R1(Ind,Ind);
    clear beta1 DP1 R1 ;
    beta1=beta2;
    DP1=DP2;
    R1=R2;
    clear beta2 DP2 R2;
    if min(size(Ind))==0
        stopcriteria=1;
    end
    
end


for i=1:length(minbeta)
  [betaind(i),temp]=find(dpbeta==minbeta(i));
end
minbetaCor=R(betaind,betaind);
betaind=OldInd(betaind);
%here beta index is the same as those in FOSdata
xrep=DPbackup(betaind,:);


