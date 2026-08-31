%% =====================================================================
%  File:        one_worker_reference.m
%  Description: Reference experiment using parfor with the worker count
%               argument set to 2 - serves as a comparison point for
%               other worker configurations in the scalability analysis.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.5)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

delete(gcp('nocreate'));

tic
parfor (seed = 1:10000000, 2)
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
