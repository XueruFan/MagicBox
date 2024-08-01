% 本脚本用来实现：
% 可视化SEC的ICC
% Xueru 20-Dec-2021 @BNU
%% 设置环境 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %%
clear, clc
cal_type = 'PCA'; % 计算PCA还是Mean
xueru_disk = '/Volumes/Xueru/'; % 设置硬盘路径
data_folder = 'S1200TRT'; % 设置数据文件夹
data_path = strcat(xueru_disk, data_folder, '/'); % 设置数据路径
sm_path = '/Volumes/Xueru/sm/'; % 设置模板文件路径
phase_encoding = 'LR'; % 设置相位编码方向 
nparcels = 400; % 要计算的分区个数
cd (sm_path) % 导入被试编号文件
subID = xlsread('SubjectID.xlsx'); 
nsubs = numel(subID); % 计算被试个数
%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %%
for p = nparcels % 分区个数

    % 导入皮层模版nii文件
    cd (templet_path)
    tn = strcat('Schaefer2018_', num2str(p), ...
        'Parcels_7Networks_order.dscalar.nii');
    a = ft_read_cifti(tn);
    
    % 设置步数循环
    for S = 8

        cd (strcat(xueru_disk, 'group/')) 

        fn = strcat(num2str(p), 'P_LR_zSEFC_Step', num2str(S),...
            '_4runs.mat'); 
        load (fn)

        mean_zSFC_pos = mean (zSFC_pos_4runs, 2);
        std_zSFC_pos = std (zSFC_pos_4runs, 0, 2);
        mean_zSFC_neg = mean (zSFC_neg_4runs, 2);
        std_zSFC_neg = std (zSFC_neg_4runs, 0, 2);

        % 把向量复原成矩阵
        mean_zSFC_pos = reshape(mean_zSFC_pos, p, p);
        mean_zSFC_neg = reshape(mean_zSFC_neg, p, p);
        std_zSFC_pos = reshape(std_zSFC_pos, p, p);
        std_zSFC_neg = reshape(std_zSFC_neg, p, p);

        % 画左、右半球视觉、听觉和体感运动种子点在全脑的EC分布
        vl_mean_pos = mean_zSFC_pos(21,:)';
        vl_mean_neg = mean_zSFC_neg(21,:)';
        vl_std_pos = std_zSFC_pos(21,:)';
        vl_std_neg = std_zSFC_neg(21,:)';

        al_mean_pos = mean_zSFC_pos(33,:)';
        al_mean_neg = mean_zSFC_neg(33,:)';
        al_std_pos = std_zSFC_pos(33,:)';
        al_std_neg = std_zSFC_neg(33,:)';

        sl_mean_pos = mean_zSFC_pos(59,:)';
        sl_mean_neg = mean_zSFC_neg(59,:)';
        sl_std_pos = std_zSFC_pos(59,:)';
        sl_std_neg = std_zSFC_neg(59,:)';

        vlmp = a.dscalar;
        vlmn = a.dscalar;
        vlsp = a.dscalar;
        vlsn = a.dscalar;
        almp = a.dscalar;
        almn = a.dscalar;
        alsp = a.dscalar;
        alsn = a.dscalar;
        slmp = a.dscalar;
        slmn = a.dscalar;
        slsp = a.dscalar;
        slsn = a.dscalar;

        cd (vis_path)
        mkdir (strcat(num2str(p), 'p_S', num2str(S)))
        cd (strcat(vis_path, '/', num2str(p), 'p_S', num2str(S)))

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% vlmp
        for n = 1:p
            for m = 1:64984
                if vlmp(m,1) == n
                vlmp(m,1) = vl_mean_pos(n,1);
                end
            end
        end
        a.dscalar = vlmp;
        ft_write_cifti('vlmp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% vlmn
        for n = 1:p
            for m = 1:64984
                if vlmn(m,1) == n
                vlmn(m,1) = vl_mean_neg(n,1);
                end
            end
        end
        a.dscalar = vlmn;
        ft_write_cifti('vlmn.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% vlsp
        for n = 1:p
            for m = 1:64984
                if vlsp(m,1) == n
                vlsp(m,1) = vl_std_pos(n,1);
                end
            end
        end
        a.dscalar = vlsp;
        ft_write_cifti('vlsp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% vlsn
        for n = 1:p
            for m = 1:64984
                if vlsn(m,1) == n
                vlsn(m,1) = vl_std_neg(n,1);
                end
            end
        end
        a.dscalar = vlsn;
        ft_write_cifti('vlsn.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% almp
        for n = 1:p
            for m = 1:64984
                if almp(m,1) == n
                almp(m,1) = al_mean_pos(n,1);
                end
            end
        end
        a.dscalar = almp;
        ft_write_cifti('almp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% almn
        for n = 1:p
            for m = 1:64984
                if almn(m,1) == n
                almn(m,1) = al_mean_neg(n,1);
                end
            end
        end
        a.dscalar = almn;
        ft_write_cifti('almn.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% alsp
        for n = 1:p
            for m = 1:64984
                if alsp(m,1) == n
                alsp(m,1) = al_std_pos(n,1);
                end
            end
        end
        a.dscalar = alsp;
        ft_write_cifti('alsp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% alsn
        for n = 1:p
            for m = 1:64984
                if alsn(m,1) == n
                alsn(m,1) = al_std_neg(n,1);
                end
            end
        end
        a.dscalar = alsn;
        ft_write_cifti('alsn.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% slmp
        for n = 1:p
            for m = 1:64984
                if slmp(m,1) == n
                slmp(m,1) = sl_mean_pos(n,1);
                end
            end
        end
        a.dscalar = slmp;
        ft_write_cifti('slmp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% slmn
        for n = 1:p
            for m = 1:64984
                if slmn(m,1) == n
                slmn(m,1) = sl_mean_neg(n,1);
                end
            end
        end
        a.dscalar = slmn;
        ft_write_cifti('slmn.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% slsp
        for n = 1:p
            for m = 1:64984
                if slsp(m,1) == n
                slsp(m,1) = sl_std_pos(n,1);
                end
            end
        end
        a.dscalar = slsp;
        ft_write_cifti('slsp.nii',a,'parameter','dscalar');
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% slsn
        for n = 1:p
            for m = 1:64984
                if slsn(m,1) == n
                slsn(m,1) = sl_std_neg(n,1);
                end
            end
        end
        a.dscalar = slsn;
        ft_write_cifti('slsn.nii',a,'parameter','dscalar');        
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
        
        cd (strcat(xueru_disk, 'group/'))
        fn = strcat(num2str(p), 'P_LR_zSEFC_Step', num2str(S),...
            '_average.mat'); 
        save (fn, 'mean_zSFC_pos', 'std_zSFC_pos', 'mean_zSFC_neg',...
        'std_zSFC_neg')
        
    end
end

%% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - %
% 找出画图时colourbar的最大值和最小值

cd (strcat(xueru_disk, 'group/')) 

% 设置要计算的分区个数
for p = 400 
    
    max_min = zeros(10,4);
    
    for S = 1:10
        
        fn = strcat(num2str(p), 'P_LR_zSEFC_Step', num2str(S),...
            '_average.mat'); 
        load (fn)
        
        max_min(S, 1) = max(max(mean_zSFC_pos([21 33 9], :)'));
        max_min(S, 2) = min(min(mean_zSFC_pos([21 33 9], :)'));
        max_min(S, 3) = max(max(mean_zSFC_neg([21 33 9], :)'));
        max_min(S, 4) = min(min(mean_zSFC_neg([21 33 9], :)'));
        
    end
    
    maxvalue = max(max(max_min(:, [1 3])));
    minvalue = min(min(max_min(:, [2 4])));
end
        
        
