% 可视化全脑zdEC的ICC值
% Xueru 21-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
dir = {'out'; 'in'}; value = {'pos'; 'neg'};
%%
ICC = [];
for v = 1:2
    for d = 1:2
        fn = ([num2str(nparcels), 'P_PCA_zdEC_', dir{d}, '_', value{v}, '_ICC.mat']); load(fn)
        ICC = [ICC icc];
    end
end
fn = ([num2str(nparcels), 'P_PCA_zdEC_ICC_all.mat']); save (fn, 'ICC')
%% 画zdEC的ICC脑图
sm_path = strcat(xueru_disk, 'SM_files/'); % 模板文件路径
vis_path = strcat(xueru_disk, 'Group_level/NII/'); % 设置nii文件的存放路径
tn = strcat('Schaefer2018_', num2str(nparcels), 'Parcels_Kong2022_17Networks_order.dscalar.nii'); 
cd ([xueru_disk, 'Group_level/'])
for V = 1:2
    for D = 1:2
        fn = strcat(num2str(nparcels), 'P_PCA_zdEC_', dir{D}, '_', value{V}, '_ICC.mat'); load(fn)
        cd (sm_path), temp = ft_read_cifti(tn);  % 导入皮层模版nii文件
        tp = temp.dscalar;
        for n = 1:nparcels
            for m = 1:64984
                if tp(m, 1) == n
                    tp(m, 1) = icc(n, 1);
                end
            end
        end
        temp.dscalar = tp; cd (vis_path) % 画种子点的脑图
        fn = strcat(num2str(nparcels), 'P_PCA_zdEC_', dir{D}, '_', value{V}, '_ICC.nii'); 
        ft_write_cifti(fn, temp, 'parameter', 'dscalar');
    end
end
%% 用Prism画ICC的频数分布图
icc = icc(:);