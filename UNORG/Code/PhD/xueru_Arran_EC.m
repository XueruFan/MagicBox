% Filter EC values with OMST and arrange to calculate ICC
% Xueru 19-Dec-2021 @BNU
% thresholding the positive and negative values together 
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
addpath(genpath('/Users/xuerufan/Toolbox'))
%%
nparcels = 400; % number of parcels
phase_encoding = {'LR';'RL'}; % phase-encoding direction
data_path = strcat(xueru_disk, 'HCP_339/'); % data path
sm_path = strcat(xueru_disk, 'SM_files/'); cd (sm_path);% sm files path
load ('hcp321.txt'); nsubs = numel(hcp321); % subject list 
%% Option1: calculate single OMST (positive and negative together) and z-transfer
% N = 1; R = 1; D = 1;
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        for N = 1:nsubs % subject
            sub = hcp321(N,1);
            cd (strcat(data_path, '/Results/Individual/EC/'))
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_EC.mat'); load (fn)           
            EC_uw = sign(EC); % get the dierction of EC values
            % z-transfer without threshold
            EC = EC - diag(diag(EC)); % assign diagonal to zero
            z_EC = atanh(EC);
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zEC.mat');
            save (fn, 'z_EC')
            % z-transfer with OMST threshold
            [nCIJtree,thrEC,mdeg,globalcosteffmax,costmax,E]=...
                threshold_omst_gce_wd(abs(EC),[]);
            thrEC = thrEC.*EC_uw; % put back direction
            z_thrEC = atanh(thrEC);
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zthrEC.mat');
            save (fn, 'thrEC', 'z_thrEC')
        end            
    end
end
%% arrange into group for single run
% N = 1; R = 1; D = 1;
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        EC_all_zthr = []; EC_all_z = [];
        for N = 1:nsubs % subject
            sub = hcp321(N,1);
            cd (strcat(data_path, '/Results/Individual/EC/'))
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zEC.mat'); load (fn);
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zthrEC.mat'); load (fn);
                        % save EC values for all subs
            EC_all_zthr(:, N) = z_thrEC(:); EC_all_z(:, N) = z_EC(:);
        end
        % decompose zEC values into pos and neg ones
        [zthrEC_pos, zthrEC_neg] = xueru_sm_decompose(EC_all_zthr);
        [zEC_pos, zEC_neg] = xueru_sm_decompose(EC_all_z);
        cd (strcat(data_path, '/Results/Group/EC/'))
        fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
            phase_encoding{D}, '_zthrEC.mat');
        save (fn, 'zthrEC_pos', 'zthrEC_neg', 'EC_all_zthr')
        fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
            phase_encoding{D}, '_zEC.mat');
        save (fn, 'zEC_pos', 'zEC_neg', 'EC_all_z')
    end
end
%% arrange all session into one for plotting EC and calculating ICC in R
%  R = 1; D = 1;
cd (strcat(data_path, '/Results/Group/EC/'))
zthrEC_pos_all = []; zEC_pos_all = []; zthrEC_neg_all = []; zEC_neg_all = [];
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
            fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
                phase_encoding{D}, '_zthrEC.mat'); load (fn)
            zthrpos = zthrEC_pos; zthrEC_pos_all = [zthrEC_pos_all zthrpos];
            zthrneg = zthrEC_neg; zthrEC_neg_all = [zthrEC_neg_all zthrneg];
            fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', ...
                phase_encoding{D}, '_zEC.mat'); load (fn)
            zpos = zEC_pos; zEC_pos_all = [zEC_pos_all zpos];
            zneg = zEC_neg; zEC_neg_all = [zEC_neg_all zneg];
    end
end
fn = strcat(num2str(nparcels), 'P_zthrEC_all.mat'); 
save (fn, 'zthrEC_pos_all', 'zthrEC_neg_all')
fn = strcat(num2str(nparcels), 'P_zEC_all.mat'); 
save (fn, 'zEC_pos_all', 'zEC_neg_all')

%% --------------------------------------------------------------------------------------------------------------- %
% Option2: thresholding the positive and negative value separately
% N = 1; R = 1; D = 1;
for R = 1:2 % rest-fMRI
    for D = 1:2 % phase-encoding direction
        for N = 1:nsubs % subject
            sub = hcp321(N,1);
            cd (strcat(data_path, '/Results/Individual/EC/'))
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_EC.mat'); load (fn)   
            [EC_pos, EC_neg] = xueru_sm_decompose(EC);
            % z-transfer with OMST threshold
            [nCIJtree,thrEC_pos,mdeg,globalcosteffmax,costmax,E]=...
                threshold_omst_gce_wd(EC_pos,[]);
            [nCIJtree,thrEC_neg,mdeg,globalcosteffmax,costmax,E]=...
                threshold_omst_gce_wd(abs(EC_neg),[]);
            z_thrEC_pos = atanh(thrEC_pos);
            z_thrEC_neg = atanh(thrEC_neg);
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_zthrEC_sepa.mat');
            save (fn, 'thrEC_pos', 'z_thrEC_pos', 'thrEC_neg', 'z_thrEC_neg')
        end            
    end
end