%% =====================================================================
%  File:        parfor_1_worker.m
%  Description: Reference baseline experiment - parfor restricted to a
%               single worker. Used to compare against multi-worker
%               configurations and isolate the parfor overhead.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.5)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

delete(gcp('nocreate'));

tic
parfor (seed = 1:10000000, 1)    % the "1" here = use 1 worker
    n = seed;
    steps = 0;
    while n ~= 1
        if mod(n, 2) == 0
            n = n / 2;
        else
            n = 3 * n + 1;
        end
        steps = steps + 1;
    end
end
elapsed_time = toc;
fprintf('parfor with 1 worker: %.4f seconds\n', elapsed_time);
