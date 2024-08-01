% 可视化8个ROI分区的位置
% Xueru 11-Mar-2022 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
seed = {'do', 'au', 'so', 'vi', 'de', 'la', 'co', 've'}; nseed = numel(seed); % 确定要可视化的种子点
% 118:  17networks_LH_DorsAttnA_SPL_1         Dorsal Attention
% 144:  17networks_LH_Aud_ST_6                Auditory
% 165:  17networks_LH_SomMotB_3               Somatomotor
% 176:  17networks_LH_VisualA_ExStr_5         Visual
% 201:  17networks_RH_DefaultA_IPL_1          Default Mode
% 239:  17networks_RH_Language_PFCl_1         Language
% 266:  17networks_RH_ContB_PCC_1             Cognitive Control
% 286:  17networks_RH_SalVenAttnA_FrMed_2     Ventral Attention
% 确定种子点是哪个分区
do = 118; au = 144; so = 165; vi = 176; de = 201; la = 239; co = 266; ve = 286;
ROI = [do; au; so; vi; de; la; co; ve];
tn = strcat('Schaefer2018_', num2str(nparcels), 'Parcels_Kong2022_17Networks_order.dscalar.nii'); 
sm_path = strcat(xueru_disk, 'SM_files/'); % 模板文件路径
vis_path = strcat(xueru_disk, 'Group_level/NII/'); % 设置nii文件的存放路径
%% 画单独ROI
% s = 1;
for s = 1:nseed % 种子点循环
    cd (sm_path), a = ft_read_cifti(tn); temp = a.dscalar; % 导入皮层模版nii文件
    cd (vis_path) % 画种子点的脑图
    for m = 1:64984
        if temp(m,1) == ROI(s)
            temp(m,1) = -1;
        else
            temp(m,1) = 0;
        end
    end
    a.dscalar = temp; fn = strcat(num2str(nparcels), 'P_Kong2022_', seed{s},'.nii'); 
    ft_write_cifti(fn, a, 'parameter', 'dscalar');
end
%% 画所有ROI
% s = 1;
cd (sm_path), a = ft_read_cifti(tn); temp = a.dscalar; % 导入皮层模版nii文件
cd (vis_path) % 画种子点的脑图
for m = 1:64984
    if temp(m,1) == do
        temp(m,1) = 0.1;
    elseif temp(m,1) == au
        temp(m,1) = 0.2;
    elseif temp(m,1) == so
        temp(m,1) = 0.3;
    elseif temp(m,1) == vi
        temp(m,1) = 0.4;
    elseif temp(m,1) == de
        temp(m,1) = 0.5;
    elseif temp(m,1) == la
        temp(m,1) = 0.6;
    elseif temp(m,1) == co
        temp(m,1) = 0.7;
    elseif temp(m,1) == ve
        temp(m,1) = 0.8;
    else
        temp(m,1) = 0;
    end
end
a.dscalar = temp; fn = strcat(num2str(nparcels), 'P_Kong2022_8roi.nii'); 
ft_write_cifti(fn, a, 'parameter', 'dscalar');