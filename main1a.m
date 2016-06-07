% hw3main1a.m
%
% graph 2 coloring on N by N chessboard using Simulated Annealing
% Using random seed 10272015
% 
% Max size should be N=15 after test run.(approximately 20 seconds)
%
% @author Yibo Wang 
% 10/27/2015


clear all
clc

rng(10272015);
l = 15;  % size 
xa=0; 
xb=1;

% random initials for x0 
x = zeros(l,l);
for i=1:l
    for j=1:l
        x(i,j) = rand(1,1);
        if x(i,j)>0.5
            x(i,j) = xa;
        else
            x(i,j) = xb;
        end
    end
end

T=100; Ts=0.99; % starting temperature 100, and cooling rate 0.99
xOld = x;
xNew = xOld;

while(getE(xNew)~=0)
    for i=1:l
        for j=1:l
            
            % flip one bit in x to generate x'
            if xNew(i,j) == xa
                xNew(i,j) = xb;
            else
                xNew(i,j) = xa;
            end
            
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
dlmwrite('chessboard01.txt',xNew);
