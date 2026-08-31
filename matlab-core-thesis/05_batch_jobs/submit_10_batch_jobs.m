%% =====================================================================
%  File:        submit_10_batch_jobs.m
%  Description: Submits 10 independent MATLAB batch jobs covering a
%               combined 10 million seed range (1M seeds per job).
%               Each job runs Collatz sequences serially on its assigned
%               range and reports elapsed time.
%
%               Designed to be run on both the personal laptop and the
%               TU Dublin Server to compare batch scheduling efficiency
%               across hardware platforms.
%
%               Results collected by collect_batch_results.m
%               Reproduces Figures 22 and 23 in the thesis.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.4)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear; clc;

c = parcluster;

totalSeeds = 10000000;
numJobs = 10;

seedsPerJob = floor(totalSeeds/numJobs);

jobs = parallel.Job.empty(numJobs,0);

for k = 1:numJobs
    startSeed = (k-1)*seedsPerJob + 1;

    if k < numJobs          % safety step
        endSeed = k*seedsPerJob;
    else
        endSeed = totalSeeds;
    end


    jobs(k) = batch(c, @batch_worker, 1, {startSeed, endSeed}, 'Pool', 0);

    fprintf('Submitted Job %d: seeds %d to %d\n', k, startSeed, endSeed);
end

disp('All 10 batch jobs submitted. They will run/queue based on available workers.');

function elapsed = batch_worker(startSeed, endSeed)
% BATCH_WORKER  Worker function executed by each batch job.
% Iterates the Collatz sequence over the assigned seed range and returns
% the elapsed wall-clock time.

tStart = tic;

for seed = startSeed:endSeed
    n = seed;

    while n ~= 1
        if mod(n,2) == 0
            n = n/2;
        else
            n = 3*n + 1;
        end
    end
end

elapsed = toc(tStart);
end
