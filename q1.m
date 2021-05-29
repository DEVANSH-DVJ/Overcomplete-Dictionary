clc;
clear;
close all;

rng(0);

n = 256;

% DCT matrix
dctmat = dctmtx(n);
% Over-complete dictionary for cosine + spikes
A = [dctmat eye(n)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Varying sigma %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;

sigmas = zeros(100,1);
error1 = zeros(100,1);
error2 = zeros(100,1);

s = 25;
ind1 = randi(n, s, 1);
coeff1 = zeros(n,1);
coeff1(ind1) = rand(s,1)*100;
ind2 = randi(n, s, 1);
coeff2 = zeros(n,1);
coeff2(ind2) = rand(s,1)*100;

f1 = dctmat*coeff1;
f2 = coeff2;
f = f1 + f2;

for i=1:100
    sigma = 0.001 * i * abs(mean(f));
    f = f + randn(n,1)*sigma;

    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1:n);
    coeff2_recon = x(n+1:2*n);

    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    sigmas(i) = 0.001 * i;
    error1(i) = norm(f1_recon - f1)/norm(f1);
    error2(i) = norm(f2_recon - f2)/norm(f2);
end

% Error plot for f_1
figure;
plot(sigmas, error1, 'b');
xlabel("\sigma");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying \sigma keeping sparsity level as 25");
saveas(gcf, "plots/error1_sigma.jpg");

% Error plot for f_2
figure;
plot(sigmas, error2, 'r');
xlabel("\sigma");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying \sigma keeping sparsity level as 25");
saveas(gcf, "plots/error2_sigma.jpg");

toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% Varying sparsity level %%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;

ss = zeros(100,1);
error1 = zeros(100,1);
error2 = zeros(100,1);

for i=1:100
    s = i;
    ind1 = randi(n, s, 1);
    coeff1 = zeros(n,1);
    coeff1(ind1) = rand(s,1)*100;
    ind2 = randi(n, s, 1);
    coeff2 = zeros(n,1);
    coeff2(ind2) = rand(s,1)*100;

    f1 = dctmat*coeff1;
    f2 = coeff2;
    f = f1 + f2;

    sigma = 0.01 * abs(mean(f));
    f = f + randn(n,1)*sigma;

    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1:n);
    coeff2_recon = x(n+1:2*n);

    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    ss(i) = s;
    error1(i) = norm(f1_recon - f1)/norm(f1);
    error2(i) = norm(f2_recon - f2)/norm(f2);
end

% Error plot for f_1
figure
plot(ss, error1, 'b');
xlabel("sparsity level");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying sparsity level keeping \sigma=0.01*mean(f_1+f_2)");
saveas(gcf, "plots/error1_sparsity.jpg");

% Error plot for f_2
figure
plot(ss, error2, 'r');
xlabel("sparsity level");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying sparsity level keeping \sigma=0.01*mean(f_1+f_2)");
saveas(gcf, "plots/error2_sparsity.jpg");

toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%% Varying magnitude ratio %%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;

ss = zeros(100,1);
error1 = zeros(100,1);
error2 = zeros(100,1);

for k=1:100
    s = 25;
    ind1 = randi(n, s, 1);
    coeff1 = zeros(n,1);
    coeff1(ind1) = rand(s,1)*100;
    ind2 = randi(n, s, 1);
    coeff2 = zeros(n,1);
    coeff2(ind2) = rand(s,1)*100*k;

    f1 = dctmat*coeff1;
    f2 = coeff2;
    f = f1 + f2;

    sigma = 0.01 * abs(mean(f));
    f = f + randn(n,1)*sigma;

    x = omp(A, f, 9*n*sigma^2);
    coeff1_recon = x(1:n);
    coeff2_recon = x(n+1:2*n);

    f1_recon = dctmat*coeff1_recon;
    f2_recon = coeff2_recon;

    ss(k) = k;
    error1(k) = norm(f1_recon - f1)/norm(f1);
    error2(k) = norm(f2_recon - f2)/norm(f2);
end

% Error plot for f_1
figure
plot(ss, error1, 'b');
xlabel("k");
ylabel("$$||\hat{f_1} - f1||/||f1||$$", 'interpreter', 'latex');
title("Varying magnitude of f_2 w.r.t f_1 (ratio = k)");
saveas(gcf, "plots/error1_k.jpg");

% Error plot for f_2
figure
plot(ss, error2, 'r');
xlabel("k");
ylabel("$$||\hat{f_2} - f_2||/||f_2||$$", 'interpreter', 'latex');
title("Varying magnitude of f_2 w.r.t f_1 (ratio = k)");
saveas(gcf, "plots/error2_k.jpg");

toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
