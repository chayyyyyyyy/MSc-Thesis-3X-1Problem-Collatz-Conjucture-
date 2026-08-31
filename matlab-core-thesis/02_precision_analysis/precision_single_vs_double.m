%% =====================================================================
%  File:        precision_single_vs_double.m
%  Description: Demonstrates the fundamental difference between single
%               (32-bit) and double (64-bit) precision arithmetic by
%               computing 1/3 in both formats and showing the difference.
%               Serves as the introductory experiment for the precision
%               analysis chapter.
%
%  Thesis:      Investigation and visualisation of the 3X+1 Problem
%  Chapter:     4 — Numerical Precision Analysis
%  Author:      Sai Vidya Chaitanya Penta (A00047206)
%  Supervisor:  Dr Kevin Berwick
%  Institution: Technological University Dublin
%  ===================================================================== %%

clear; clc;

format long

x_double = 1/3;                 % double (default)
x_single = single(1)/single(3); % single

disp('Double precision 1/3:'); disp(x_double);
disp('Single precision 1/3:'); disp(x_single);

disp('Difference (double - single):');
disp(x_double - double(x_single));
