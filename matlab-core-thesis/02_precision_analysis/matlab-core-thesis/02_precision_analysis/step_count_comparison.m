%% =====================================================================
%  File:        step_count_comparison.m
%  Description: Compares the step count (stopping time) of the Collatz
%               sequence under single and double precision arithmetic.
%               Demonstrates that rounding errors in single precision can
%               truncate the trajectory by hundreds of steps - producing
%               a faster but mathematically incorrect result.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     4 — Numerical Precision Analysis
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

% Double precision step count
n = 670617279; stepsD = 0;
while n ~= 1
  if mod(n,2) == 0, n = n/2; else, n = 3*n+1; end
  stepsD = stepsD + 1;
end

% Single precision step count
n = single(723496987); stepsS = 0;
while n ~= 1
  if mod(n,2) == 0, n = n/2; else, n = 3*n+1; end
  stepsS = stepsS + 1;
end

fprintf("steps double=%d, steps single=%d\n", stepsD, stepsS);
