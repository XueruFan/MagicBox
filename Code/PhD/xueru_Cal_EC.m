% Calculate rDCM with TPAS toolbox
% Xueru 16-Dec-2021 @BNU
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
addpath(genpath('/Users/xuerufan/Toolbox/tapas-master'))
%%
nparcels = 400; % number of parcels
TR = 0.72; % TR
phase_encoding = {'LR';'RL'}; % phase-encoding direction
data_path = strcat(xueru_disk, 'HCP_339/'); % data path
sm_path = strcat(xueru_disk, 'SM_files/'); cd (sm_path);% sm files path
load ('hcp321.txt'); nsubs = numel(hcp321); % subject list 
%%
% N = 1; R = 1; D = 1; 
for N = 1:nsubs % subject
    sub = hcp321(N,1); 
    for R = 1:2 % rest-fMRI
        for D = 1:2 % phase-encoding direction
            cd (strcat(data_path, '/Results/Individual/PCA/'))
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_PCA.mat'); load(fn)
            % calculate rDCM，attention! classic rDCM here, without sparsity
            Y.dt = TR; Y.y = PCA; % y is N*R matrix, N=timepoints, R=parcels
            DCM = tapas_rdcm_model_specification(Y, [], []);
            rDCM = tapas_rdcm_estimate(DCM, 'r', [], 1);
            EC = rDCM.Ep.A;
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', ...
                num2str(R),'_', phase_encoding{D}, '_ECwithSparsity.mat'); 
            cd (strcat(data_path, '/Results/Individual/EC/'))
            save(fn,'EC')
        end
    end
end