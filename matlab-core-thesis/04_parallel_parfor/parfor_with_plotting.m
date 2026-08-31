%% =====================================================================
%  File:        parfor_with_plotting.m
%  Description: Task 3A of the benchmark suite. Uses MATLAB's Parallel
%               Computing Toolbox (parfor) to distribute 10 million
%               Collatz computations across worker pool. Stores per-seed
%               execution time and plots results.
%
%               Each Collatz trajectory is independent of all others,
%               making this an embarrassingly parallel problem.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.3)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;
close all;

% pool start
p = gcp('nocreate');
if isempty(p)
    parpool;
end

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

fprintf('Task 3A (Parallel Task 1): seeds 1..%d took %.3f seconds\n', ...
        N, total_time);

figure;
plot(1:N, execution_time);
xlabel('Seed value');
ylabel('Execution time (seconds)');
title('Task 3A: Parallel execution time to reach 1 vs seed');
grid on;
