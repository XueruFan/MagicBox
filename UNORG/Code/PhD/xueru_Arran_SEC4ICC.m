% 整合所有zSEC和SEC值便于导入到R计算ICC以及计算组水平
% Xueru 20-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 设置硬盘路径
phase_encoding = {'LR';'RL'}; % 相位编码方向
%%
% T = 1; R = 1; D = 1;
cd (strcat(xueru_disk, 'Group_level/')) 
for S = 1:8
    zSECp = []; SECp = []; zSECn = []; SECn = [];
    for T = 1:2 % 扫描轮次
        for R = 1:2 % 静息态 
            for D = 1:2 % 相位方向
                fn = strcat(num2str(nparcels), 'P_T', num2str(T), '_R', num2str(R),'_', ...
                    phase_encoding{D}, '_PCA_SEC_S', num2str(S), '.mat'); load (fn)
                Mp = SEC_pos_all_subs; SECp = [SECp Mp];
                Mn = SEC_neg_all_subs; SECn = [SECn Mn];
                Zp = zSEC_pos_all_subs; zSECp = [zSECp Zp];
                Zn = zSEC_neg_all_subs; zSECn = [zSECn Zn];
            end
        end
    end
    fn = strcat(num2str(nparcels), 'P_PCA_zSEC_S', num2str(S), '_all.mat'); 
    save (fn, 'zSECp', 'SECp', 'zSECn', 'SECn')
end