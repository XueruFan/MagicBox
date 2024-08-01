%% 皮层分区
xueru_Parcel_PCA
% 用Kong2022的gMS-HBM模板，用PCA提取特征值
% 计算同时记录Kong分区中不存在的被试，记录在文件'hcp339_nonKong.txt'里
% 生成新的被试编号文件'hcp321txt'，共321人，以后重算不需要这两步，直接用新被试列表

% 生成个体文件，路径/Volumes/Xueru/HCP_339/Results/Individual/PCA
% 每个被试都有4个文件，每个文件内包含变量'PCA'
% 100206_400P_R1_LR_PCA.mat
% 100206_400P_R1_RL_PCA.mat
% 100206_400P_R2_LR_PCA.mat
% 100206_400P_R2_RL_PCA.mat

%% 计算rDCM
xueru_Cal_EC
% 用tpas工具包，计算rDCM时用的是原始rDCM，没有sparsity

% 生成个体文件，路径/Volumes/Xueru/HCP_339/Results/Individual/EC
% 每个被试都有4个文件, 包含变量'EC'
% 100206_400P_R1_LR_EC.mat
% 100206_400P_R1_RL_EC.mat
% 100206_400P_R2_LR_EC.mat
% 100206_400P_R2_RL_EC.mat