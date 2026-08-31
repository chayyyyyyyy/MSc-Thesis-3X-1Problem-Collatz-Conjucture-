%% =====================================================================
%  File:        collect_batch_results.m
%  Description: Collects results from the 10 batch jobs submitted via
%               submit_10_batch_jobs.m. Waits for each job to complete,
%               fetches its elapsed-time output, and plots a bar chart
%               comparing per-job execution time.
%
%               Run this AFTER submit_10_batch_jobs.m on the same MATLAB
%               session and cluster.
%
%               Key finding: TU Dublin Server completes all 10 jobs in
%               80.94 seconds vs 127.54 seconds on the personal laptop -
%               a 36.5% reduction in total execution time.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     6 — Benchmark Testing (Section 6.4)
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear; clc; close all;

% Finds all jobs on the cluster
c = parcluster;
allJobs = c.Jobs;

if isempty(allJobs)
    error('No jobs found. Run the submit script first.');
end

% Takes the most recent 10 jobs
numJobs = 10;
if numel(allJobs) < numJobs
    error('Fewer than 10 jobs exist. Found %d jobs.', numel(allJobs));
end

jobs = allJobs(end-numJobs+1:end);

jobTimes = zeros(numJobs,1);

for k = 1:numJobs
    wait(jobs(k));                 % wait for job completion
    out = fetchOutputs(jobs(k));   % get outputs
    jobTimes(k) = out{1};          % elapsed seconds returned by worker

    fprintf('Job %d finished in %.3f seconds\n', k, jobTimes(k));
end

% Plot
figure;
bar(jobTimes);
xlabel('Batch Job Number');
ylabel('Execution time (seconds)');
title('Task 4: Execution time for 10 batch jobs');
grid on;

% Optional: print summary
fprintf('\nSummary:\n');
fprintf('Min time: %.3f s\n', min(jobTimes));
fprintf('Max time: %.3f s\n', max(jobTimes));
fprintf('Mean time: %.3f s\n', mean(jobTimes));
