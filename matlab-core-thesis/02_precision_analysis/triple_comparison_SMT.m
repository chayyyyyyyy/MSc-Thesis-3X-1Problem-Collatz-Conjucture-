%% =====================================================================
%  File:        triple_comparison_SMT.m
%  Description: Three-way comparison of Single (32-bit), Double (64-bit),
%               and Symbolic Math Toolbox (arbitrary precision) arithmetic
%               for the Collatz sequence using seed 723,496,987.
%               Generates a 3-panel bar chart comparing execution time,
%               stopping time, and maximum hailstone value reached.
%
%               Key finding: Single precision returns 177 steps (wrong,
%               due to rounding), while Double and SMT both return 252
%               steps (correct). SMT is ~270x slower than Double.
%
%               Reproduces Figure 15 in the thesis.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     4 — Numerical Precision Analysis (Section 4.3)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;
close all;

seed = 723496987;

%% DOUBLE PRECISION
tic
n = seed;
stepsD = 0;
maxD = n;

while n ~= 1
    if mod(n,2)==0
        n = n/2;
    else
        n = 3*n+1;
    end
    stepsD = stepsD + 1;
    maxD = max(maxD,n);
end
timeD = toc;

%% SINGLE PRECISION
tic
n = single(seed);
stepsS = 0;
maxS = n;

while n ~= 1
    if mod(n,2)==0
        n = n/2;
    else
        n = 3*n+1;
    end
    stepsS = stepsS + 1;
    maxS = max(maxS,n);
end
timeS = toc;

%% SYMBOLIC (SMT)
tic
n = sym(seed);
stepsSym = 0;
maxSym = n;

while n ~= 1
    if mod(n,2)==0
        n = n/2;
    else
        n = 3*n+1;
    end
    stepsSym = stepsSym + 1;
    maxSym = max(maxSym,n);
end
timeSym = toc;

%% Data arrays
times = [timeS timeD timeSym];
steps = [stepsS stepsD stepsSym];
maxValues = [double(maxS) double(maxD) double(maxSym)];

labels = {'Single','Double','SMT'};

%% Plot comparison figure

figure

subplot(1,3,1)
bar(times)
set(gca,'XTickLabel',labels)
title('Execution Time')
ylabel('Seconds')
grid on

subplot(1,3,2)
bar(steps)
set(gca,'XTickLabel',labels)
title('Stopping Time')
ylabel('Steps')
grid on

subplot(1,3,3)
bar(maxValues)
set(gca,'XTickLabel',labels)
title('Maximum Hailstone Value')
ylabel('Value')
grid on

sgtitle('Comparison of Numerical Precision Methods')
