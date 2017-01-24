function [M1,rM]=ValiKrigModel(dmodelx,valiX, valiZ)
dmodel=dmodelx;
for i=1:length(valiZ) 
    M1(i,1)=predictor(valiX(i,:),dmodel);
    M1(i,2)=valiZ(i,1);
end
a=M1(:,1)./M1(:,2);
plot(M1(:,1),M1(:,2),'.')
%axis([-0.3 0 -0.3 0])
xlabel('Predicted')
ylabel('Actual')
hold off
M1
rM0=corrcoef(M1(:,1),M1(:,2))

rM=rM0(2,2);