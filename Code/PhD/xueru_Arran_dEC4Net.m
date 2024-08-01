% 按照网络整理dEC值用于画图
% Xueru 21-Dec-2021 @BNU
clear, clc
%%
nparcels = 400; % 要计算的分区个数
xueru_disk = '/Volumes/Xueru/'; % 数据硬盘路径
netname = {'def','lan', 'con', 'sal', 'dor', 'aud', 'som', 'vis'}; networks = numel(netname); % 要计算的网络个数
dir = {'out'; 'in'}; value = {'pos'; 'neg'};
%% 
% v= 1; d = 1; s = 1;
cd (strcat(xueru_disk, 'Group_level/')) 
fn = strcat(num2str(nparcels), 'P_PCA_dEC_mean.mat'); load(fn)
% Ls = [1, 15, 31, 42, 52, 64, 76, 85, 96, 109, 125, 137, 147, 160, 172, 185, 197];
% Le = [14, 30, 41, 51, 63, 75, 84, 95, 108, 124, 136, 146, 159, 171, 184, 196, 200];
% Rs = [201, 215, 226, 237, 245, 258, 271, 285, 298, 313, 324, 336, 345, 358, 369, 384, 397];
% Re = [214, 225, 236, 344, 257, 270, 284, 297, 312, 323, 335, 344, 357, 368, 383, 396, 400]; 
Ls = [1, 42, 52, 85, 109, 137, 147, 172];
Le = [41, 51, 84, 108, 136, 146, 171, 200];
Rs = [201, 237, 245, 285, 313, 336, 345, 369];
Re = [236, 344, 284, 312, 335, 344, 368, 400]; 
for v = 1:2
    for d = 1:2
        for s = 1:networks % 网络  
            eval (strcat(value{v}, '_', dir{d}, '_', netname{s}, '= mean_dEC_', dir{d}, ...
                '_', value{v}, '([Ls(', num2str(s), '):Le(', num2str(s), ') Rs(', num2str(s), ...
                '):Re(', num2str(s), ')], 1);'))
        end
    end
end
clear nparcels value dir netname xueru_disk networks Ls Le Rs Re fn v s d mean_dEC_in_pos ...
    mean_dEC_out_pos mean_dEC_in_neg mean_dEC_out_neg
save '400P_PCA_dEC_17net'
%% 准备画和弦图的文件