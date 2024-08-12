% 整合所有被试单词测量的zSEC和SEC值
% Xueru 19-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
phase_encoding = {'LR';'RL'}; % 相位编码方向
%% 
data_path = strcat(xueru_disk, 'HCP_TRT/'); % 数据路径
sm_path = strcat(xueru_disk, 'SM_files/'); cd (sm_path);% 模板文件路径
load ('HCP_TRT_subID_Kong.mat'); nsubs = numel(subID_Kong); % 导入要计算的被试编号，计算被试个数
%% 合并所有被试
% N = 1; T = 1; R = 1; D = 1; v =1; S = 1;%%
for S = 1:8 % 步数循环
    for T = 1:2 % 扫描轮次循环
        for R = 1:2 % 静息态循环    
            for D = 1:2 % 相位方向
                zSEC_pos_all_subs = zeros(nparcels^2, nsubs);
                zSEC_neg_all_subs = zeros(nparcels^2, nsubs); 
                SEC_pos_all_subs = zeros(nparcels^2, nsubs);
                SEC_neg_all_subs = zeros(nparcels^2, nsubs);  
                for N = 1:nsubs % 被试
                    sub = subID_Kong(N,1); % 导入被试计算好rDCM的文件              
                    cd (strcat(data_path, num2str(sub), '/Test', num2str(T), '/'))
                    fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
                        '_PCA_SFC_S', num2str(S), '.mat');  load (fn)                    
                    zSEC_pos_all_subs(:, N) = zSEC_pos(:);  
                    zSEC_neg_all_subs(:, N) = zSEC_neg(:); 
                    SEC_pos_all_subs(:, N) = SEC_pos(:);  
                    SEC_neg_all_subs(:, N) = SEC_neg(:); 
                end                
                cd (strcat(xueru_disk, 'Group_level/')) 
                fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', num2str(R),'_', ...
                    phase_encoding{D}, '_PCA_SEC_S', num2str(S), '.mat');
                save (fn, 'zSEC_pos_all_subs', 'zSEC_neg_all_subs', 'SEC_pos_all_subs', 'SEC_neg_all_subs')                
            end
        end
    end
end