% 本脚本用来实现：
% 分析PCA的第一主元能解释的方差占比的组平均水平
% Xueru 16-Dec-2021 @BNU
%% 设置环境 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %%
clear, clc
xueru_disk = '/Volumes/Xueru/'; % 设置硬盘路径
data_folder = 'S1200TRT'; % 设置数据文件夹
data_path = strcat(xueru_disk, data_folder, '/'); % 设置数据路径
sm_path = '/Volumes/Xueru/sm/'; % 设置模板文件路径
phase_encoding = 'LR'; % 设置相位编码方向 
nparcels = 100:100:1000; % 要计算的分区个数
% 导入被试编号文件
cd (sm_path)
subID = xlsread('SubjectID.xlsx'); 
% 计算被试个数
nsubs = numel(subID);
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %%  
% 分区循环
for p = nparcels    
    % 扫描轮次循环
    for T = 1:2 
        % 静息态循环
        for R = 1:2             
            % 新建空文件待存入数据
            Exp_all_subs = [];           
            % 被试循环
            for N = 1:nsubs 
                sub = subID(N,1);               
                % 导入被试的计算好PCA和Mean的文件
                cd (strcat(data_path, num2str(sub), '/Test', ...
                    num2str(T), '/'))
                fn = strcat(num2str(p), 'P_R', num2str(R), '_LR_cal.mat');
                load (fn)                
                Exp_all_subs(:,N) = Exp_pca(:,1);                
            end            
            % 求所有被试PCA第一主成分方差贡献度的组平均水平
            mean_exp_pca = mean(Exp_all_subs, 2);            
            % 设置存放组水平结果的文件夹地址并保存计算结果
            cd (strcat(xueru_disk, 'Group/')) 
            fn = strcat(num2str(p), 'p_T', num2str(T), '_R', ...
                num2str(R), '_pca.mat');
            save (fn, 'mean_exp_pca')            
        end
    end
end 