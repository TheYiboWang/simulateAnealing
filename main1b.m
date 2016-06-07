% hw3main1b.m

% graph k=4 coloring on N by N chessboard using Simulated Annealing
% Using random seed 10272015

% Max size should be N=22 after test run.(approximately 60 seconds)

%@author Yibo Wang 
% 10/27/2015


clear all
clc

rng(10272015);
k=4; %  number of colors
for i=k:-1:1
    values(i)=i-1;
end

l = 22; 

% random initials x 
x = zeros(l,l);
for i=1:l
    for j=1:l
        x(i,j) = rand(1,1);
        if x(i,j)>3/4
            x(i,j) = values(4);
        else
            if x(i,j)<= 3/4 && x(i,j)>1/2
            x(i,j) = values(3);
            else
                if x(i,j)<=1/2 && x(i,j)>0.25
                    x(i,j) = values(2);
               else
                   x(i,j) = values(1);
                end
            end
        end
    end
end

T=100; Ts=0.99;
xOld = x;
xNew = xOld;

while(getE(xNew)~=0)
    for i=1:l
        for j=1:l
            % flip one bit in x to generate x'
            r = randi(k);
            while xNew(i,j) == values(r)
                r = randi(k);
            end
                xNew(i,j) = values(r);
            
            % Metropolis method
            deltaE = getE(xNew) - getE(xOld);
            if deltaE <= 0
                xOld = xNew;
            else
                q = exp(-deltaE/T);
                if q > rand(1)
                    xOld = xNew;
                else
                    xNew = xOld;
                end
            end
 
        end
    end
    T=T*Ts;
end
dlmwrite('chessboard0123.txt',xNew);
