% 整合所有dEC值便于导入到R计算ICC
% Xueru 13-Mar-2022 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 设置硬盘路径
phase_encoding = {'LR';'RL'}; % 相位编码方向
value = {'pos'; 'neg'}; % 连接的方向
%% 整合dEC
% T = 1; R = 1; D = 1; V = 1;
cd (strcat(xueru_disk, 'Group_level/')) 
dEC_out_pos = []; dEC_out_neg = []; dEC_in_pos = []; dEC_in_neg = [];
for T = 1:2 % 扫描轮次
    for R = 1:2 % 静息态 
        for D = 1:2 % 相位方向
            fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', ...
                num2str(R),'_', phase_encoding{D}, '_PCA_dEC.mat'); load (fn)
            for V = 1:2
                eval (['Zo = dEC_all_subs_', value{V}, '_out;'])
                eval (['Zi = dEC_all_subs_', value{V}, '_in;'])
                eval (['dEC_out_', value{V},' = [dEC_out_', value{V}, ' Zo];'])
                eval (['dEC_in_', value{V}, ' = [dEC_in_', value{V}, ' Zi];'])
            end
        end
    end
end
fn = strcat(num2str(nparcels), 'P_PCA_dEC_all.mat');
save (fn, 'dEC_out_pos', 'dEC_out_neg', 'dEC_in_pos', 'dEC_in_neg')
%% 整合zdEC
% T = 1; R = 1; D = 1; V = 1;
cd (strcat(xueru_disk, 'Group_level/')) 
zdEC_out_pos = []; zdEC_out_neg = []; zdEC_in_pos = []; zdEC_in_neg = [];
for T = 1:2 % 扫描轮次
    for R = 1:2 % 静息态 
        for D = 1:2 % 相位方向
            fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', ...
                num2str(R),'_', phase_encoding{D}, '_PCA_zdEC.mat'); load (fn)
            for V = 1:2
                eval (['Zo = zdEC_all_subs_', value{V}, '_out;'])
                eval (['Zi = zdEC_all_subs_', value{V}, '_in;'])
                eval (['zdEC_out_', value{V},' = [zdEC_out_', value{V}, ' Zo];'])
                eval (['zdEC_in_', value{V}, ' = [zdEC_in_', value{V}, ' Zi];'])
            end
        end
    end
end
fn = strcat(num2str(nparcels), 'P_PCA_zdEC_all.mat');
save (fn, 'zdEC_out_pos', 'zdEC_out_neg', 'zdEC_in_pos', 'zdEC_in_neg')