% 可视化zEC的ICC
% Xueru 20-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
sm_path = strcat(xueru_disk, 'SM_files/'); % 模板文件路径
vis_path = strcat(xueru_disk, 'Group_level/NII/'); % 设置nii文件的存放路径
%% 绘制八个种子点的脑图
% s = 1;
seed = {'do', 'au', 'so', 'vi', 'de', 'la', 'co', 've'}; nseed = numel(seed); % 确定要可视化的种子点
% 确定种子点是哪个分区
do = 118; au = 144; so = 165; vi = 176; de = 201; la = 239; co = 266; ve = 286;
tn = strcat('Schaefer2018_', num2str(nparcels), 'Parcels_Kong2022_17Networks_order.dscalar.nii'); 
cd ([xueru_disk, 'Group_level/'])
fn = strcat(num2str(nparcels), 'P_PCA_zEC_ICC.mat'); load(fn)
icc = reshape(icc, nparcels, nparcels); vr = reshape(vr, nparcels, nparcels);
save (fn, 'icc', 'vr')
for s = 1:nseed % 种子点循环
    cd (sm_path), out = ft_read_cifti(tn); in = out; % 导入皮层模版nii文件
    temp_out = out.dscalar; temp_in = in.dscalar;
    eval (strcat(seed{s}, '_out_icc = icc(', seed{s}, ", :)';"))
    eval (strcat(seed{s}, "_in_icc = icc(:, ", seed{s}, ");"))
    cd (vis_path) % 画种子点的脑图
    for n = 1:nparcels
        for m = 1:64984
            if temp_out(m, 1) == n
            eval (strcat("temp_out(m, 1) = ", seed{s}, '_out_icc(n, 1);'))
            eval (strcat("temp_in(m, 1) = ", seed{s}, '_in_icc(n, 1);'))
            end
        end
    end
    out.dscalar = temp_out; in.dscalar = temp_in;
    fn = strcat(num2str(nparcels), 'P_PCA_zEC_ICC_', seed{s},'_out.nii'); 
    ft_write_cifti(fn, out, 'parameter', 'dscalar');
    fn = strcat(num2str(nparcels), 'P_PCA_zEC_ICC_', seed{s},'_in.nii'); 
    ft_write_cifti(fn, in, 'parameter', 'dscalar');
end
%% 绘制全脑17个网络的线箱图
netname = {'def','lan', 'con', 'sal', 'dor', 'aud', 'som', 'vis'}; networks = numel(netname); 
dir = {'out'; 'in'}; 
cd ([xueru_disk, 'Group_level/'])
fn = strcat(num2str(nparcels), 'P_PCA_zEC_ICC.mat'); load(fn)
Ls = [1, 42, 52, 85, 109, 137, 147, 172];
Le = [41, 51, 84, 108, 136, 146, 171, 200];
Rs = [201, 237, 245, 285, 313, 336, 345, 369];
Re = [236, 344, 284, 312, 335, 344, 368, 400]; 

for s = 1:networks % 网络  
    eval (strcat(netname{s}, '_out = icc([Ls(', num2str(s), '):Le(',  num2str(s), ') Rs(', ...
        num2str(s), '):Re(', num2str(s), ')], :);'))
    eval(strcat(netname{s}, '_out = ', netname{s}, '_out(:);'))
    eval (strcat(netname{s}, '_in = icc(:, [Ls(', num2str(s), '):Le(',  num2str(s), ') Rs(', ...
        num2str(s), '):Re(', num2str(s), ')]);'))
    eval(strcat(netname{s}, '_in = ', netname{s}, '_in(:);'))
        eval (strcat(netname{s}, ' = icc([Ls(', num2str(s), '):Le(',  num2str(s), ') Rs(', ...
        num2str(s), '):Re(', num2str(s), ')], [Ls(', num2str(s), '):Le(',  num2str(s), ') Rs(', ...
        num2str(s), '):Re(', num2str(s), ')]);'))
    eval(strcat(netname{s}, ' = ', netname{s}, '(:);'))
end

fn = ([num2str(nparcels), 'P_PCA_zEC_ICC_17net.mat']);
save (fn, 'def_out', 'def_in', 'lan_out', 'lan_in', 'con_out', 'con_in', 'sal_out', 'sal_in', ...
    'dor_out', 'dor_in', 'aud_out', 'aud_in', 'som_out', 'som_in', 'vis_out', 'vis_in', ...
    'def', 'lan', 'con', 'sal', 'dor', 'aud', 'som', 'vis')

%% 用Prism画ICC的频数分布图
icc = icc(:);