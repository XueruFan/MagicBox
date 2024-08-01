% 用thrEC计算1-8步SEC(CCS工具包旧代码)
% Xueru 18-Dec-2021 @BNU
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
% N = 1; T = 1; R = 1; D = 1; v =1; S = 1;
for N = 1:nsubs % 被试
    sub = subID_Kong(N,1); % 导入被试用PCA计算好分区的文件
    for T = 1:2 % 扫描轮次
        cd (strcat(data_path, num2str(sub), '/Test', num2str(T), '/'))
        for R = 1:2 % 静息态
            for D = 1:2 % 相位方向     
                fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
                    '_PCA_thrEFC.mat'); load(fn) % 导入thrEC文件
                [pos, neg] = xueru_sm_decompose(sign(thr_EC));  neg = abs(neg); % 分解正负子图
                for S = 1:8 % 分别计算1-8步 
                    for v = 1:2
                        eval(strcat('SEC_', value{v}, '= ccs_core_graphwalk_old(', value{v},", S, 'normal');"))
                        % 对SEC值进行标准化
                        eval(['mean_', value{v}, '= mean(SEC_', value{v}, ',2);'])
                        eval(['std_', value{v}, '= std(SEC_', value{v}, ',0,2);'])
                        eval(['zSEC_', value{v}, '= (SEC_', value{v}, '-mean_', value{v}, ')./(std_', value{v}, '); '])
                        %zsfc值是NaN的元素变成0
                        eval(['zSEC_', value{v}, '(find(isnan(zSEC_', value{v}, ') == 1)) = 0;'])      
                    end
                    fn = strcat(num2str(nparcels), 'P_R', num2str(R),'_', phase_encoding{D}, ...
                        '_PCA_SFC_S', num2str(S), '.mat'); 
                    save (fn, 'SEC_pos', 'SEC_neg', 'zSEC_pos', 'zSEC_neg')                    
                end
            end
        end
    end
end