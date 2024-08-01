% Discompose EC networks, do z-transfer then arrange into groups
% Xueru 03-May-2022 @Home
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
addpath(genpath('/Users/xuerufan/Toolbox'))
%%
nparcels = 400; % number of parcels
phase_encoding = {'LR';'RL'}; % phase-encoding direction
data_path = [xueru_disk, 'HCP_339/Results/']; % data path
cd ([xueru_disk, 'SM_files/']); % sm files path
load ('hcp321.txt'); nsubs = numel(hcp321); % subject list
%% discopose and z-transfer individulally
% N = 1; R = 1; D = 1;
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        for N = 1:nsubs % subject
            sub = hcp321(N,1);
            cd ([data_path, 'Individual/EC/'])
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_EC.mat'); load (fn)       
            [EC_pos, EC_neg] = xueru_sm_decompose(EC);
            EC_pos = EC_pos - diag(diag(EC_pos)); % assign diagonal to zero
            EC_neg = EC_neg - diag(diag(EC_neg));
            zEC_pos = atanh(EC_pos); zEC_neg = atanh(EC_neg); % z tansfer
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zEC.mat');
            save (fn, 'EC_pos', 'EC_neg', 'zEC_pos', 'zEC_neg')
        end            
    end
end
%% arrange into group for single run
% N = 1; R = 1; D = 1;
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        zEC_all_pos = []; zEC_all_neg = [];
        for N = 1:nsubs % subject
            sub = hcp321(N,1);
            cd ([data_path, 'Individual/EC/'])
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zEC.mat'); load (fn);
            zEC_all_pos(:, N) = zEC_pos(:); zEC_all_neg(:, N) = zEC_neg(:);
        end
        cd ([data_path, 'Group/EC/'])
        fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
            phase_encoding{D}, '_zEC.mat');
        save (fn, 'zEC_all_pos', 'zEC_all_neg')
    end
end
%% arrange all runs into one file and transfer EC network into unweighted network
%  R = 1; D = 1;
cd ([data_path, 'Group/EC/'])
zEC_pos_4runs_w = []; zEC_neg_4runs_w = [];
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
            fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
                phase_encoding{D}, '_zEC.mat'); load (fn)
            zpos = zEC_all_pos; zEC_pos_4runs_w = [zEC_pos_4runs_w zpos];
            zneg = zEC_all_neg; zEC_neg_4runs_w = [zEC_neg_4runs_w zneg];
    end
end
zEC_pos_4runs_uw = sign(zEC_pos_4runs_w); % set non-zero value to one
zEC_neg_4runs_uw = abs(sign(zEC_neg_4runs_w));
fn = [num2str(nparcels), 'P_zEC_all_4runs.mat']; 
save (fn, 'zEC_pos_4runs_w', 'zEC_neg_4runs_w', 'zEC_pos_4runs_uw', 'zEC_neg_4runs_uw')