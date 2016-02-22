function [y] = getE(x)

[l,~]=size(x);
getE = 0;
for i=1:l-1
    for j=1:l
        if x(i,j) == x(i+1,j)
            getE = getE+1;
        end
    end
end
for j=1:l-1
    for i=1:l
        if x(i,j) == x(i,j+1)
            getE = getE+1;
        end
    end
end

y = getE;