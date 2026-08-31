%% =====================================================================
%  File:        parfor_2_workers.m
%  Description: Worker scalability experiment with 2 parallel workers
%               on a 10 million seed range. Measures per-seed timing and
%               total elapsed time. Used in the worker scalability sweep
%               (1 to 8 workers) to characterise speed-up behaviour.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.5)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;
close all;

numWorkers = 2;      % choose workers here
parpool(numWorkers); % start pool

N = 10000000;
execution_time = zeros(N,1);

total_tic = tic;

parfor seed = 1:N
    n = seed;
    t = tic;

    while n ~= 1
        if mod(n,2) == 0
            n = n / 2;
        else
            n = 3*n + 1;
        end
    end

    execution_time(seed) = toc(t);
end

total_time = toc(total_tic);

fprintf('Task 3A: workers=%d, seeds 1..%d took %.3f seconds\n', ...
        numWorkers, N, total_time);
