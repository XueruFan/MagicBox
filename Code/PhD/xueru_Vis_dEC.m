% 可视化全脑dEC值
% Xueru 20-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
tn = strcat('Schaefer2018_', num2str(nparcels), 'Parcels_Kong2022_17Networks_order.dscalar.nii'); 
sm_path = strcat(xueru_disk, 'SM_files/'); % 模板文件路径
vis_path = strcat(xueru_disk, 'Group_level/NII/'); % 设置nii文件的存放路径
value = {'pos'; 'neg'}; % 连接的方向
dir = {'out', 'in'}; % 连接的方向
%% 计算全脑dEC的组水平
% D = 1; V = 2;
cd ([xueru_disk, 'Group_level/'])
fn = strcat(num2str(nparcels), 'P_PCA_dEC_all.mat'); load(fn)
for V = 1:2
    for D = 1:2
        eval (strcat('mean_dEC_', dir{D}, '_', value{V}, ' = mean(dEC_', dir{D}, ...
            '_', value{V}, ', 2);'))
    end
end
cd ([xueru_disk, 'Group_level/'])
fn = strcat(num2str(nparcels), 'P_PCA_dEC_mean.mat');
save (fn, 'mean_dEC_out_pos', 'mean_dEC_out_neg', 'mean_dEC_in_pos', 'mean_dEC_in_neg')
%%
cd ([xueru_disk, 'Group_level/'])
fn = strcat(num2str(nparcels), 'P_PCA_dEC_mean.mat'); load(fn)
for V = 1:2
    for D = 1:2
        eval (['data = mean_dEC_', dir{D}, '_', value{V}, ';'])
        cd (sm_path), temp = ft_read_cifti(tn);  % 导入皮层模版nii文件
        tp = temp.dscalar;
        for n = 1:nparcels
            for m = 1:64984
                if tp(m, 1) == n
                    tp(m, 1) = data(n, 1);
                end
            end
        end
        temp.dscalar = tp; cd (vis_path) % 画种子点的脑图
        fn = strcat(num2str(nparcels), 'P_PCA_dEC_', dir{D}, '_', value{V}, '.nii'); 
        ft_write_cifti(fn, temp, 'parameter', 'dscalar');
    end
end