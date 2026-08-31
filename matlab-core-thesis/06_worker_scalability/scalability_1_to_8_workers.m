%% =====================================================================
%  File:        scalability_1_to_8_workers.m
%  Description: Full worker scalability benchmark. Measures total
%               execution time for the same 10 million seed Collatz
%               workload using parfor with worker counts ranging from
%               1 to 8, plus a serial-loop baseline.
%
%               Saves results to laptop_results.mat and plots execution
%               time vs worker count with the serial baseline overlaid.
%               Reproduces Figure 24 in the thesis.
%
%               Key finding: Diminishing returns observed beyond 6
%               workers due to parallel overhead and workload
%               distribution limits on the laptop hardware.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.5)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clc; clear; close all;

worker_counts = 1:8;                % test 1, 2, 3, ..., 8 workers
times = zeros(size(worker_counts));
seed_range = 1:10000000;            % 10 million seeds

fprintf('=== LAPTOP BENCHMARK ===\n');
fprintf('Seed range: 1 to %d\n\n', length(seed_range));

% First measure the serial baseline (no parfor)
delete(gcp('nocreate'));
tic
for seed = seed_range
    n = seed;
    while n ~= 1
        if mod(n, 2) == 0
            n = n / 2;
        else
            n = 3 * n + 1;
        end
    end
end
serial_time = toc;
fprintf('Serial for loop: %.2f seconds\n\n', serial_time);

% Now measure parfor with different worker counts
for i = 1:length(worker_counts)
    w = worker_counts(i);

    delete(gcp('nocreate'));
    parpool('local', w);

    tic
    parfor seed = seed_range
        n = seed;
        while n ~= 1
            if mod(n, 2) == 0
                n = n / 2;
            else
                n = 3 * n + 1;
            end
        end
    end
    times(i) = toc;

    fprintf('Workers: %d, Time: %.2f seconds\n', w, times(i));
end

delete(gcp('nocreate'));

% Save the results
save('laptop_results.mat', 'worker_counts', 'times', 'serial_time');
fprintf('\nResults saved to laptop_results.mat\n');

% Quick plot
figure;
plot(worker_counts, times, '-o', 'LineWidth', 2, 'MarkerSize', 8);
hold on; yline(serial_time, '--', 'Serial baseline');
xlabel('Number of Workers'); ylabel('Execution Time (s)');
title('Laptop Worker Scalability'); grid on;
