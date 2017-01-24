function [LB,UB]=SysRelBound(b,r)
size(b)
size(r)

N=max(size(b));
D=ones(N,1)*b;
for i=1:N
    for j=1:N
        if i==j
            H(i,j)=normcdf(-D(i,j));
        else
             if r(i,j)>1-1e-9
                 r(i,j)=1-1e-9;
             end
            tempD=(D(j,i)-r(i,j)*D(i,j))/sqrt(1-(r(i,j))^2);

  
            H(i,j)=normcdf(-D(i,j))*normcdf(-tempD);
        end
    end       
end

for i=1:N
    for j=1:N
         S(i,j)=max([H(i,j),H(j,i)]);
         if i==j
            T(i,j)=H(i,j);
        else
            T(i,j)=H(i,j)+H(j,i);
        end
    end
end

for i=1:N
    if i==1
        P1(i)=S(i,i);
        P2(i)=T(i,i);
    else
        P1(i)=S(i,i)-max(S(1:i-1,i));
        P2(i)=max([T(i,i)-sum(T(1:i-1,i)),0]);
    end
end
UB=sum(P1);
LB=sum(P2);

    
        