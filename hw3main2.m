% hw3main2.m
%
% Simulated Annealing for continuous values
%
% a random seed is used. Temperature starts at 100 and cooling rate is 0.99
% the stopping criteria is T<0.001
% test function is 
% getE2 = 0.5*(x(1)^2 + x(2)^2) + 0.5*(x(1)+x(2)-1)^2 - (x(1)+2*x(2));
%
%@author Yibo Wang
% 10/27/2015

clear all
clc

getE2 = @(x) 0.5*(x(1)^2 + x(2)^2) + 0.5*(x(1)+x(2)-1)^2 - (x(1)+2*x(2));

rng(10272015);
dim=2;
sample = 50;
xall = rand(1,dim*sample)*1000-500;
for iii=1:2:dim*sample-1 
    tstart = tic;
    x = [xall(1),xall(2)];
    
    xOld = x;
    [~,l] = size(xOld);
    sT = 1;
    T = 100; Ts=0.99;
    
    a = zeros(l);
    s = zeros(l);
    for i=1:l
        a(i)=1; % acceptance ratios
        s(i)=sT; % step sizes
    end
    Nc=500;
    xNew=xOld;
    
    count=0;
    while T>0.001 % stopping criteria is T<0.001
        
        for k=1:Nc
            for kk=1:l % increase one step for each dimension of x
                r = rand(1,1)*2-1; % r is random between (-1 1);
                xNew(kk) = xNew(kk) + r*s(kk);
                
                % Metropolis method to decide accept or reject
                deltaE = getE2(xNew) - getE2(xOld);
                if deltaE <= 0
                    xOld = xNew;
                    a(kk) = a(kk)+1/Nc;
                 else
                    q = exp(-deltaE/T);
                    if q > rand(1)
                        xOld = xNew;
                        a(kk) = a(kk)+1/Nc;
                        
                    else
                         xNew = xOld;
                        a(kk) = a(kk)-1/Nc;
                    end
                end
                
                count=count+1;
            end
        end
        
        % adjust step size after each Nc
        for i=1:l
            if a(i)>0.6
                gai = 1 + 2*(a(i)-0.6)/0.4;
                s(i) = gai * s(i);
            else if a(i)<0.4
                    gai = 1/(1+2*(0.4-a(i))/0.4);
                    s(i) = gai * s(i);
                end
            end
        end
        
        T=T*Ts;
    end
    
    t(iii) = toc(tstart);
    
    % record all the results
    for ii=1:2
        xresult(iii+ii-1) = xNew(ii);
    end
    toe(iii) = count;
    fresult(iii) = getE2(xNew);
    
    iii
end



%
% mathematical analysis 
%
sumX1=0; sumX2=0; sumF=0; sumToe=0; sumT=0; sumDis=0;
optimum = -11/6;
for i=1:2:dim*sample-1
    sumX1 = sumX1+xresult(i);
    sumX2 = sumX2+xresult(i+1);
    sumF = sumF+fresult(i);
    sumToe = sumToe+toe(i);
    sumT = sumT+t(i);
    sumDis = sumDis + abs(fresult(i) - optimum);
end
avrX1 = sumX1/sample;
avrX2 = sumX2/sample;
avrF = sumF/sample;
avrToe = sumToe/sample;
avrT = sumT/sample;
avrDis = sumDis/sample;

varX1=0; varX2=0; varF=0; varToe=0; varT=0; varDis=0;
for i=1:2:dim*sample-1
    varX1 = varX1 + (xresult(i)-avrX1)^2;
    varX2 = varX2 + (xresult(i+1)-avrX2)^2;
    varF = varF +(fresult(i)-avrF)^2;
    varToe = varToe + (toe(i)-avrToe)^2;
    varT = varT + (t(i)-avrT)^2;
    varDis = varDis + (abs(fresult(i)-optimum)-avrDis)^2;
end
varX1 = varX1/(sample-1);
varX2 = varX2/(sample-1);
varF = varF/(sample-1);
varToe = varToe/(sample-1);
varT = varT/(sample-1);
varDis = varDis/(sample-1);

ebX1 = sqrt(varX1);
ebX2 = sqrt(varX2);
ebF = sqrt(varF);
ebToe = sqrt(varToe);
ebT = sqrt(varT);
ebDis = sqrt(varDis);


% save the results to file saCont.txt
fid = fopen('saCont.txt','wt'); 
fprintf(fid,'the average of x1 is %.15e\n',avrX1);  
fprintf(fid,'the variance of x1 is %.15e\n',varX1);  
fprintf(fid,'the error bar of x1 is %.15e\n',ebX1);

fprintf(fid,'the average of x2 is %.15e\n',avrX2);
fprintf(fid,'the variance of x2 is %.15e\n',varX2); 
fprintf(fid,'the error bar of x2 is %.15e\n',ebX2);  

fprintf(fid,'the average of f is %.15e\n',avrF);
fprintf(fid,'the variance of f is %.15e\n',varF);
fprintf(fid,'the error bar of f is %.15e\n',ebF);

fprintf(fid,'the average of times of evaluation is %.15e\n',avrToe);
fprintf(fid,'the variance of times of evaluation is %.15e\n',varToe);
fprintf(fid,'the error bar of times of evaluation is %.15e\n',ebToe);

fprintf(fid,'the average of running time is %.15e\n',avrT);
fprintf(fid,'the variance of running time is %.15e\n',varT);
fprintf(fid,'the error bar of running time is %.15e\n',ebT);

fprintf(fid,'the average of relative distance is %.15e\n',avrDis);
fprintf(fid,'the variance of relative distance is %.15e\n',varDis);
fprintf(fid,'the error bar of relative distance is %.15e\n',ebDis);

fclose(fid);

