%% =====================================================================
%  File:        serial_1M_with_plot.m
%  Description: Task 1 of the benchmark suite. Sequentially executes
%               the Collatz sequence for 1 million starting seeds, records
%               per-seed execution time, then plots execution time vs seed.
%               Establishes the serial baseline for parallel comparisons.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.2)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear;
clc;
close all;

% Number of starting values (seeds)
N = 1000000;

% Array to store execution time for each seed
execution_time = zeros(N,1);

% START TOTAL TIMER
total_tic = tic;

% Loop through seeds
for seed = 1:N

    n = seed;
    tic;

    % Collatz loop
    while n ~= 1
        if mod(n,2) == 0
            n = n / 2;
        else
            n = 3*n + 1;
        end
    end

    % Stores per-seed execution time
    execution_time(seed) = toc;

end

% STOP TOTAL TIMER
total_time = toc(total_tic);

% Display total execution time in Command Window
fprintf('Total execution time for seeds 1 to %d: %.3f seconds\n', ...
        N, total_time);

% Plot results
figure;
plot(1:N, execution_time);
xlabel('Seed value');
ylabel('Execution time (seconds)');
title('Task 1: Execution time to reach 1 (3x + 1)');
grid on;
