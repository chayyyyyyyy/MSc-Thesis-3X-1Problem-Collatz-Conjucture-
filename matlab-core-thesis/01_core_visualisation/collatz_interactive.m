%% =====================================================================
%  File:        collatz_interactive.m
%  Description: Interactive Collatz sequence generator with cycle detection
%               and logarithmic visualisation. Accepts any integer (positive
%               or negative), iterates the 3X+1 transformation, detects
%               cycles, and plots the trajectory on a log10 scale.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     3 — Core Collatz Visualisation
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%               School of Electrical and Electronics Engineering
%  MATLAB:      R2024a
%  Date:        2025-2026
%  ===================================================================== %%

n = input('Enter any integer (positive or negative): ');

sequence = n;
visited = n;   % store visited values to detect cycles

while true
    if n == 1
        break
    end

    if mod(n,2) == 0
        n = n / 2;
    else
        n = 3*n + 1;
    end

    % Stop if a cycle is detected
    if ismember(n, visited)
        sequence = [sequence n];
        disp('Cycle detected, stopping iteration.');
        break
    end

    sequence = [sequence n];
    visited = [visited n];
end

disp(sequence)

% Number of steps
steps = 0:length(sequence)-1;

% Log10 of absolute values (log of negative numbers is invalid)
log_values = log10(abs(sequence));

% Plot
figure
plot(steps, log_values, 'r.', 'MarkerSize', 15)
grid on
xlabel('Number of steps')
ylabel('log_{10} |values|')
title('Log10 Plot')
