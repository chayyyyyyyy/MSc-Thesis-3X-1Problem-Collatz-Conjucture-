%% =====================================================================
%  File:        serial_10M_no_plot.m
%  Description: Task 2 of the benchmark suite. Sequentially executes the
%               Collatz sequence for 10 million seeds WITHOUT plotting to
%               isolate pure computational cost from graphics rendering
%               overhead. Reproduces Figure 19 in the thesis.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.2)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;

%  number of seeds to process
N = 10000000;

% START TOTAL TIMER
total_tic = tic;

% Loop through seeds
for seed = 1:N
    n = seed;

    while n ~= 1
        if mod(n,2) == 0
            n = n / 2;
        else
            n = 3*n + 1;
        end
    end
end

% STOP TOTAL TIMER
total_time = toc(total_tic);

fprintf('Task 2 (WITHOUT plotting): seeds 1 to %d took %.3f seconds\n', ...
        N, total_time);
