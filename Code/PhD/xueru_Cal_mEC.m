% Calculate mean and std of pos and neg EC networks individually
% Xueru 03-May-2022 @Home
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
addpath(genpath('/Users/xuerufan/Toolbox'))
%%
value = {'pos'; 'neg'}; % effect of EC
weight = {'w'; 'uw'}; % weight of edge
phase_encoding = {'LR';'RL'}; % phase-encoding direction
nparcels = 400; % number of parcels
data_path = [xueru_disk, 'HCP_339/Results/']; % data path
%% calculate mean and std
cd ([data_path, 'Group/EC/'])
fn = [num2str(nparcels), 'P_zEC_all_4runs.mat']; load (fn)
for V = 1:2 % effect
    for W = 1:2
        eval (strcat('mean_zEC_', value{V}, '_', weight{W}, " = abs(reshape(mean(zEC_", ...
            value{V}, '_4runs_', weight{W}, ', 2),', num2str(nparcels), ',', ...
            num2str(nparcels), '));'))
        eval (strcat('std_zEC_', value{V}, '_', weight{W}, " = reshape(std(zEC_", ...
            value{V}, '_4runs_', weight{W}, ', 0, 2),', num2str(nparcels), ',', ...
            num2str(nparcels), ');'))
    end
end
fn = [num2str(nparcels), 'P_zEC_group.mat'];
save (fn, 'mean_zEC_pos_w', 'mean_zEC_neg_w', 'mean_zEC_pos_uw', ...
    'mean_zEC_neg_uw', 'std_zEC_pos_w', 'std_zEC_neg_w', 'std_zEC_pos_uw', ...
    'std_zEC_neg_uw')

% plot heatmap with Rstudio
% xueru_Heatmap_EC.R

%% calculate how many times (in total of 4) this edge exists for each subject
cd ([data_path, 'Group/EC/'])
zEC_pos_count = zeros(nparcels^2, 321); % set subject number
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
            '_zEC.mat'); load(fn)
        zpos = sign(zEC_all_pos); zEC_pos_count = zEC_pos_count+zpos;
    end
end
count_pos = zeros(length(zEC_pos_count), 5);
for p = 1:(nparcels^2) % summarize each parcels
    for n = 0:4 % posibilities of sum
    count_pos(p, n+1) = numel(find(zEC_pos_count(p, :) == n))/321; % set sub number
    end
end
pos_neg = count_pos(:, 1)+ count_pos(:, 5); % how many subs have 4 pos/neg EC
pos_neg = reshape(pos_neg, nparcels, nparcels);
pos = reshape(count_pos(:, 5), nparcels, nparcels); % how many subs have 4 pos
neg = reshape(count_pos(:, 1), nparcels, nparcels); % how many subs have 4 neg
fn = [num2str(nparcels), 'P_EC_count.mat'];
save (fn, 'pos_neg', 'pos', 'neg')

% plot heatmap with Rstudio
% xueru_Heatmap_ECcount.R

%% calculate how many subs (in single run) have the same EC direction
count_pos = [];
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
            '_zEC.mat'); load(fn)
        zpos = sign(zEC_all_pos);
        for p = 1:(nparcels^2)
            count(p, 1) = length(find(zpos(p, :)))/321;
        end
        count_pos = [count_pos count];
    end
end
count_4runs_mean = reshape(mean(count_pos, 2), nparcels, nparcels);
count_4runs_std  = reshape(std(count_pos, 0, 2), nparcels, nparcels);
fn = [num2str(nparcels), 'P_EC_count2.mat'];
save (fn, 'count_4runs_mean', 'count_4runs_std')

% plot heatmap and histogram with Rstudio
% xueru_Heatmap_Histogram_ECcount2.R

% for have a small look at the distrubution
breaks = 0.1; % plotting histgram plot
for g = 1:(1/breaks)
    l = (g-1)*breaks; u = g*breaks;
    H(g, 1) = l; H(g, 2) = u;
    H(g, 3) = length(find(count_4runs_mean(:) >= l & count_4runs_mean(:) < u));
    H(g, 4) = H(g, 3)/(nparcels^2); H(g, 5) = 1-H(g, 4);
end