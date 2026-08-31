%% =====================================================================
%  File:        scalability_7_workers.m
%  Description: Worker scalability data point - parfor with 7 parallel
%               workers on a 10 million seed Collatz workload. Used to
%               populate the worker scalability sweep that produces
%               Figure 24 of the thesis.
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
delete(gcp('nocreate'))
numWorkers = 7;      % choose workers here
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
