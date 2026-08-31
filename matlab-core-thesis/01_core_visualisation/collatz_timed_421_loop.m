%% =====================================================================
%  File:        collatz_timed_421_loop.m
%  Description: Times how long the Collatz sequence takes to reach the
%               canonical 4-2-1 loop for any input integer. Detects cycles,
%               stores the trajectory, and plots on a log10 scale. Useful
%               for measuring stopping time of individual seeds.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     3 — Core Collatz Visualisation
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

n = input('Enter any integer (positive or negative): ');

sequence = n;
visited = n;   % store visited values to detect cycles

tic   % START TIMER

reached421 = false;
time_to_421 = NaN;

while true
    if n == 1
        break
    end

    if mod(n,2) == 0
        n = n / 2;
    else
        n = 3*n + 1;
    end

    % Store sequence
    sequence = [sequence n];
    visited = [visited n];

    % Check if 4-2-1 loop is reached
    if ~reached421 && ismember(n, [4 2 1]) && ...
            all(ismember([4 2 1], visited))
        time_to_421 = toc;   % STOP TIMER
        reached421 = true;
    end

    % Stop if a cycle is detected
    if numel(unique(visited)) < numel(visited)
        disp('Cycle detected, stopping iteration.');
        break
    end
end

disp(sequence)

% Number of steps
steps = 0:length(sequence)-1;

% Log10 of absolute values
log_values = log10(abs(sequence));

% Plot
figure
plot(steps, log_values, 'r.', 'MarkerSize', 15)
grid on
xlabel('Number of steps')
ylabel('log_{10} |values|')
title('Log10 Plot (Including Negative Seed)')

% Display execution time
if ~isnan(time_to_421)
    fprintf('Execution time to reach the 4-2-1 loop: %.6f seconds\n', time_to_421);
else
    disp('4-2-1 loop was not reached.');
end
