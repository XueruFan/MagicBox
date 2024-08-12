% 计算dEC度的组水平
% Xueru 21-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
phase_encoding = {'LR';'RL'}; % 相位编码方向
value = {'pos'; 'neg'}; % 连接的方向
%% 
data_path = strcat(xueru_disk, 'HCP_TRT/'); % 数据路径
sm_path = strcat(xueru_disk, 'SM_files/'); cd (sm_path);% 模板文件路径
load ('HCP_TRT_subID_Kong.mat'); nsubs = numel(subID_Kong); % 导入要计算的被试编号，计算被试个数
%%
% N = 1; T = 1; R = 1; D = 1; V = 1;
for T = 1:2 % 扫描轮次
    for R = 1:2 % 静息态 
        for D = 1:2 % 相位方向
            dEC_all_subs_pos_out = zeros(nparcels, nsubs);
            dEC_all_subs_pos_in = zeros(nparcels, nsubs);
            dEC_all_subs_neg_out = zeros(nparcels, nsubs);
            dEC_all_subs_neg_in = zeros(nparcels, nsubs);
            zdEC_all_subs_pos_out = zeros(nparcels, nsubs);
            zdEC_all_subs_pos_in = zeros(nparcels, nsubs);
            zdEC_all_subs_neg_out = zeros(nparcels, nsubs);
            zdEC_all_subs_neg_in = zeros(nparcels, nsubs);
            for N = 1:nsubs % 被试
                sub = subID_Kong(N,1); 
                cd (strcat(data_path, num2str(sub), '/Test', num2str(T), '/'))
                fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
                    '_PCA_thrEFC.mat'); load(fn) % 导入thrEC文件
                [dEC_pos, dEC_neg] = xueru_sm_decompose(thr_EC);
                for V = 1:2 % 正负连接
                    eval (['dEC_', value{V}, '_out = sum(abs(sign(dEC_', value{V}, ')), 2);'])
                    eval (strcat('dEC_', value{V}, '_in = sum(abs(sign(dEC_', value{V}, ")))';"))
                end
                fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
                    '_PCA_dEC.mat');
                save (fn, 'dEC_pos_out', 'dEC_pos_in', 'dEC_neg_out', 'dEC_neg_in')
              
                zdEC_pos_out = (dEC_pos_out - mean(dEC_pos_out))/std(dEC_pos_out);
                zdEC_pos_in = (dEC_pos_in - mean(dEC_pos_in))/std(dEC_pos_in);
                zdEC_neg_out = (dEC_neg_out - mean(dEC_neg_out))/std(dEC_neg_out);
                zdEC_neg_in = (dEC_neg_in - mean(dEC_neg_in))/std(dEC_neg_in);

                dEC_all_subs_pos_out(:, N) = dEC_pos_out(:);
                dEC_all_subs_pos_in(:, N) = dEC_pos_in(:);
                dEC_all_subs_neg_out(:, N) = dEC_neg_out(:);
                dEC_all_subs_neg_in(:, N) = dEC_neg_in(:);
                                
                zdEC_all_subs_pos_out(:, N) = zdEC_pos_out(:);
                zdEC_all_subs_pos_in(:, N) = zdEC_pos_in(:);
                zdEC_all_subs_neg_out(:, N) = zdEC_neg_out(:);
                zdEC_all_subs_neg_in(:, N) = zdEC_neg_in(:);
            end
            cd (strcat(xueru_disk, 'Group_level/')) 
            fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', num2str(R),'_', ...
                    phase_encoding{D}, '_PCA_dEC.mat');
            save (fn, 'dEC_all_subs_pos_out', 'dEC_all_subs_pos_in', ...
                'dEC_all_subs_neg_out', 'dEC_all_subs_neg_in')
            fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', num2str(R),'_', ...
                    phase_encoding{D}, '_PCA_zdEC.mat');
            save (fn, 'zdEC_all_subs_pos_out', 'zdEC_all_subs_pos_in', ...
                'zdEC_all_subs_neg_out', 'zdEC_all_subs_neg_in')
        end
    end
end