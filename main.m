clc;
clear;
close all;

%% Set Seed
rng(0);

%% Constants
% Dimension of signal
n = 256;
% Number of experiments
nexp = 100;

%% Initialize Overcomplete Dictionary
% DCT matrix
dctmat = dctmtx(n);
% Over-complete dictionary for cosine + spikes
A = [dctmat eye(n)];

%% Varying sigma
tic;

% Initialize experiment results
sigmas = zeros(nexp, 1);
error1 = zeros(nexp, 1);
error2 = zeros(nexp, 1);

% Fixed sparsity
s = 25;

% Get the sparse code
ind1 = randi(n, s, 1);
coeff1 = zeros(n, 1);
coeff1(ind1) = rand(s, 1)*100;
ind2 = randi(n, s, 1);
coeff2 = zeros(n, 1);
coeff2(ind2) = rand(s, 1)*100;

% Generate the signal
f1 = dctmat * coeff1;
f2 = coeff2;
f = f1 + f2;

% For each experiment
for i=1:nexp
    % Set standard deviation of Gaussian Noise
    sigma = 0.001*i * abs(mean(f));
    % Add Gaussian Noise
    f = f + randn(n, 1)*sigma;

    % Perform Orthogonal Matching Pursuit to obtain the coefficients
    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1 : n);
    coeff2_recon = x(n+1 : 2*n);

    % Reconstruct signals using coefficients
    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    % Save experiment's result
    sigmas(i) = 0.001*i;
    error1(i) = norm(f1_recon - f1) / norm(f1);
    error2(i) = norm(f2_recon - f2) / norm(f2);
end

% Error plot for f_1 wrt sigma
figure;
plot(sigmas, error1, 'b');
xlabel("\sigma");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying \sigma keeping sparsity level as 25");
saveas(gcf, "plots/error1_sigma.jpg");

% Error plot for f_2 wrt sigma
figure;
plot(sigmas, error2, 'r');
xlabel("\sigma");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying \sigma keeping sparsity level as 25");
saveas(gcf, "plots/error2_sigma.jpg");

toc;

%% Varying sparsity level
tic;

% Initialize experiment results
ss = zeros(nexp, 1);
error1 = zeros(nexp, 1);
error2 = zeros(nexp, 1);

% For each experiment
for i=1:nexp
    % Set sparsity
    s = i;

    % Get the sparse code
    ind1 = randi(n, s, 1);
    coeff1 = zeros(n, 1);
    coeff1(ind1) = rand(s, 1)*100;
    ind2 = randi(n, s, 1);
    coeff2 = zeros(n, 1);
    coeff2(ind2) = rand(s, 1)*100;

    % Generate the signal
    f1 = dctmat * coeff1;
    f2 = coeff2;
    f = f1 + f2;

    % Set standard deviation of Gaussian Noise
    sigma = 0.01 * abs(mean(f));
    % Add Gaussian Noise
    f = f + randn(n, 1)*sigma;

    % Perform Orthogonal Matching Pursuit to obtain the coefficients
    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1 : n);
    coeff2_recon = x(n+1 : 2*n);

    % Reconstruct signals using coefficients
    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    % Save experiment's result
    ss(i) = s;
    error1(i) = norm(f1_recon - f1) / norm(f1);
    error2(i) = norm(f2_recon - f2) / norm(f2);
end

% Error plot for f_1 wrt sparsity
figure
plot(ss, error1, 'b');
xlabel("sparsity level");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying sparsity level keeping \sigma=0.01*mean(f_1+f_2)");
saveas(gcf, "plots/error1_sparsity.jpg");

% Error plot for f_2 wrt sparsity
figure
plot(ss, error2, 'r');
xlabel("sparsity level");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying sparsity level keeping \sigma=0.01*mean(f_1+f_2)");
saveas(gcf, "plots/error2_sparsity.jpg");

toc;

%% Varying magnitude ratio
tic;

% Initialize experiment results
ss = zeros(nexp, 1);
error1 = zeros(nexp, 1);
error2 = zeros(nexp, 1);

% For each experiment
for k=1:nexp
    % Set sparsity
    s = 25;

    % Get the sparse code
    ind1 = randi(n, s, 1);
    coeff1 = zeros(n, 1);
    coeff1(ind1) = rand(s, 1)*100;
    ind2 = randi(n, s, 1);
    coeff2 = zeros(n, 1);
    coeff2(ind2) = rand(s, 1)*100*k;

    % Generate the signal
    f1 = dctmat * coeff1;
    f2 = coeff2;
    f = f1 + f2;

    % Set standard deviation of Gaussian Noise
    sigma = 0.01 * abs(mean(f));
    % Add Gaussian Noise
    f = f + randn(n, 1)*sigma;

    % Perform Orthogonal Matching Pursuit to obtain the coefficients
    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1 : n);
    coeff2_recon = x(n+1 : 2*n);

    % Reconstruct signals using coefficients
    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    % Save experiment's result
    ss(k) = k;
    error1(k) = norm(f1_recon - f1) / norm(f1);
    error2(k) = norm(f2_recon - f2) / norm(f2);
end

% Error plot for f_1 wrt magnitude ratio
figure
plot(ss, error1, 'b');
xlabel("k");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying magnitude of f_2 w.r.t f_1 (ratio = k)");
saveas(gcf, "plots/error1_k.jpg");

% Error plot for f_2 wrt magnitude ratio
figure
plot(ss, error2, 'r');
xlabel("k");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying magnitude of f_2 w.r.t f_1 (ratio = k)");
saveas(gcf, "plots/error2_k.jpg");

toc;
