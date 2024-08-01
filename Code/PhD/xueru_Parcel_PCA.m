% 用Kong2022的gMS-HBM模板进行PCA皮层分区
% Xueru 16-Dec-2021 @BNU
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
%%
nparcels = 400; % 要计算的分区个数
time_points = 1200; % 时间点个数
phase_encoding = {'LR';'RL'}; % 相位编码方向
data_path = strcat(xueru_disk, 'HCP_339/'); % 原始CIFTI数据路径
sm_path = strcat(xueru_disk, 'SM_files/'); cd (sm_path);% 模板文件路径
load (strcat('HCP_1029sub_', num2str(nparcels), ...
    'Parcels_Kong2022_gMSHBM.mat')); % 导入体素的Kong2022分区编号
load ('HCP_subject_list.mat'); load ('hcp339.txt'); % 导入Kong的被试列表和要计算的被试编号
nsubs = numel(hcp339); % 计算被试个数
%%
% N = 1; R = 1; D = 1; P = 1; L = 1;
% non_sub = [];
for N = 339%:nsubs % 被试
    sub = hcp339(N,1); 
    % 定位该被试在Kong被试列表中的位置，提取出该被试所有体素的分区编号
    where = find(HCP_subject_list == sub); % 该被试在Kong列表的位置
    if isempty(where) % 如果Kong分区的被试列表里没有这个被试，就记录编号进行下一个被试
        non_sub = [non_sub; sub];
        continue
    end
    index = [lh_labels_all(:, where); rh_labels_all(:, where)]; % 提取出该被试的分区编号 
    for R = 2 % 静息态
        for D = 1:2 % 相位方向 
            cd (strcat(data_path, '/ICA-FIX/', num2str(sub), '/MNINonLinear/Results/rfMRI_REST', ...
                num2str(R), '_', phase_encoding{D}, '/'))
            sub_data = ft_read_cifti(strcat('rfMRI_REST', num2str(R), '_', ...
                phase_encoding{D}, '_Atlas_MSMAll_hp2000_clean.dtseries.nii')); % 导入ICA-FIX时间序列文件
            PCA = ones(time_points, nparcels) * NaN; % 建立待存入数据的空矩阵
            for P = 1:nparcels % 设置分区循环
                id = find(index == P); % 找位出每个分区包含的体素
                nvoxels = length(id);
                % 按照每个分区所含的体素个数建立空时间序列矩阵待存入数据
                tseries = ones(size(sub_data.dtseries,2), nvoxels) * NaN; 
                for L = 1:nvoxels % 体素循环
                    % 将属于该分区的体素时间序列逐个写入
                    tseries(:, L) = sub_data.dtseries(id(L),:)'; 
                end
                % [coeff, score, latent, tsquared, explained, mu]
                [~, score, ~, ~, ~, ~] = pca(tseries); 
                PCA(:, P) = score(:,1); % 计算保存PCA第一主成分的时间序列转换值
             end
            fn = strcat(num2str(sub), '_', num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, '_PCA.mat');
            cd (strcat(data_path, '/Results/Individual/PCA/'))
            save(fn, 'PCA')
        end
    end
end
%% 把Kong皮层分区里没有的被试编号导出来，导出实际存在的被试编号
cd (sm_path); save ('hcp339_nonKong.txt', 'non_sub', '-ascii')
hcp321 = setdiff(hcp339, hcp339_nonKong); % setsiff取补集
save ('hcp321.txt', 'hcp321', '-ascii') % 保存为txt文件