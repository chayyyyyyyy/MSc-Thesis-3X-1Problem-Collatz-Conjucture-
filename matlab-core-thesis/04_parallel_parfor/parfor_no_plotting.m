%% =====================================================================
%  File:        parfor_no_plotting.m
%  Description: Task 3B of the benchmark suite. Parallel parfor execution
%               of 10 million Collatz computations WITHOUT plotting,
%               isolating the pure parallel computation time. On the
%               TU Dublin Server with 16 workers, this completes in
%               ~6.144 seconds (vs ~70s serial baseline).
%               Reproduces Figure 21 in the thesis.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.3)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;

% --- SAFE pool start ---
p = gcp('nocreate');
if isempty(p)
    parpool;
end

N = 10000000;

% start total timer
total_tic = tic;

% PARALLEL LOOP (no plotting)
parfor seed = 1:N
    n = seed;

    while n ~= 1
        if mod(n,2) == 0
            n = n / 2;
        else
            n = 3*n + 1;
        end
    end
end

% stop total timer
total_time = toc(total_tic);

fprintf('Task 3B (Parallel WITHOUT plotting): seeds 1..%d took %.3f seconds\n', ...
        N, total_time);
