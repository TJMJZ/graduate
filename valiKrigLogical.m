function [a]=ValiKrigLogical(dmodelx,valiX, valiZ,bound)
dmodel=dmodelx;
for i=1:length(valiZ) 
    M1(i,1)=(predictor(valiX(i,:),dmodel)>(bound));
    M1(i,2)=valiZ(i,1);
end
a=sum(xor(M1(:,1),M1(:,2)));
