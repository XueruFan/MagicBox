% 可视化8个种子点的全脑zSEC值
% Xueru 16-Mar-2022 @BNU
clear, clc
%% 
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
cd ([xueru_disk, 'Group_level/'])
%% 求组平均水平
for S = 1:8 % 分别计算1-8步 
    fn = strcat(num2str(nparcels), 'P_PCA_zSEC_S', num2str(S), '_all.mat'); load(fn)
    mean_zSECn = reshape(mean(zSECn, 2), nparcels, nparcels);
    mean_zSECp = reshape(mean(zSECp, 2), nparcels, nparcels);
    fn = strcat(num2str(nparcels), 'P_PCA_zSEC_S', num2str(S), '_mean.mat');
    save (fn, 'mean_zSECn', 'mean_zSECp')
end
%% 画8个种子点zSEC的脑图
value = {'p'; 'n'};
sm_path = strcat(xueru_disk, 'SM_files/'); % 模板文件路径
vis_path = strcat(xueru_disk, 'Group_level/NII/'); % 设置nii文件的存放路径
tn = strcat('Schaefer2018_', num2str(nparcels), 'Parcels_Kong2022_17Networks_order.dscalar.nii'); 
cd ([xueru_disk, 'Group_level/'])
seed = {'do', 'au', 'so', 'vi', 'de', 'la', 'co', 've'}; nseed = numel(seed); % 确定要可视化的种子点
% 确定种子点是哪个分区
do = 118; au = 144; so = 165; vi = 176; de = 201; la = 239; co = 266; ve = 286;
%% 
% s = 1; S = 1; v = 1;
for S = 1:8
     fn = strcat(num2str(nparcels), 'P_PCA_zSEC_S', num2str(S), '_mean.mat'); load(fn)
     for v = 1:2
        for s = 1:nseed % 种子点循环
            cd (sm_path), temp = ft_read_cifti(tn); tp = temp.dscalar; % 导入皮层模版nii文件
            eval (strcat(seed{s}, '_SEC = mean_zSEC', value{v}, '(', seed{s}, ", :)';"))
            for n = 1:nparcels
                for m = 1:64984
                    if tp(m, 1) == n
                        eval(['tp(m, 1) = ', seed{s}, '_SEC(n, 1);'])
                    end
                end
            end
            temp.dscalar = tp; cd (vis_path) % 画种子点的脑图
            fn = strcat(num2str(nparcels), 'P_PCA_zSEC_S', num2str(S), value{v}, '_', seed{s}, '.nii'); 
            ft_write_cifti(fn, temp, 'parameter', 'dscalar');
        end
     end
end