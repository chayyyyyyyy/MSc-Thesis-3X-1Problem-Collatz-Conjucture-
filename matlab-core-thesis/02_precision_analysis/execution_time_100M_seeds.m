%% =====================================================================
%  File:        execution_time_100M_seeds.m
%  Description: Benchmarks Collatz sequence execution under double
%               precision arithmetic across 100 million sequential seeds.
%               Used to establish a serial-execution baseline for the
%               cross-platform performance comparison in Chapter 5.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     4 — Numerical Precision Analysis
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;

N = 100000000;   % total seeds

total_tic = tic;

for seed = 1:N

    n = (seed);

    while n ~= 1
        if mod(n,2) == 0
            n = n/2;
        else
            n = 3*n + 1;
        end
    end

end

total_time = toc(total_tic);

fprintf('double precision execution time for seeds 1..%d = %.3f seconds\n', ...
        N, total_time);
