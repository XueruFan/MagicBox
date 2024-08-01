clear; clc;
format long

% 已有数据：HCP-S1200和ReTest中41个被试已分好400个区的BOLD信号时间序列；
% 第一步：算400个ROI的SFC
% 第二步：画3个ROI的zSFC均值和标准差的脑图
% 第三步：准备好要计算ICC的测量和重测数据
% 第四步：整理算好的ICC并做fisher-z变换
% 第五步：画icc的成分脑图

%% 第一步

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries']);
cd (strcat(filefolder))

sub_id = dlmread('sub_id.csv'); %被试编号文件

for visit = 1:2
    
    for rest = 1:2;
        
        cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
            ,num2str(rest),]));
        
        for sub = 1:41;

            load(['sub',num2str(sub_id(sub,1)),'_rfMRI_REST'...
                ,num2str(rest),'_RL.ptseries.mat']); %打开原始时间序列

            cor = abs(corr(timeseries)); %计算400个分区的相关并取绝对值
            cor = cor-diag(diag(cor)); %把自相关置0
            rank = sort(cor(:)','descend'); %把相关矩阵中所有元素从大到小排列
            cor(find(cor < rank(1,15960)))=0; %将相关值位于10%后的元素置0
            cor(find(cor ~= 0)) = 1; %将相关矩阵变为二则矩阵
            clear timeseries rank  
            
            for step = 1:10;

                sfc = sfcfromzuo(cor,step); %用左老师写的代码算sfc
                sfc = sfc - diag(diag(sfc)); %把对角线置0
                mean_sfc = mean(sfc,2);
                std_sfc = std(sfc,0,2);
                zsfc = (sfc-mean_sfc)./(std_sfc); %sfc每个种子点做标准化
                zsfc(find(isnan(zsfc)==1)) = 0; %zsfc值是NaN的元素变成0
                clear mean_sfc std_sfc
                
                cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
                    ,num2str(rest),'/SFC_1r_10p_RL/']));
                filename = strcat(['sub',num2str(sub_id(sub,2)),...
                    's',num2str(step),'.mat']);
                save(filename,'zsfc','sfc')
                clear zsfc sfc filename
                
            end
            clear cor
        end 
    end
end
clear;clc;
                
%% 第二步-1 选出3个roi的数据

clear;clc

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries']);

for visit = 1:2;
    
    for rest = 1:2
        
        for step = 1:10;
        
            % 每个ROI建好矩阵
            vl = zeros(400,41);
            al = zeros(400,41);
            sl = zeros(400,41);

            for sub = 1:41;

                cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
                    ,num2str(rest),'/SFC_1r_10p_RL']));
                load(['sub',num2str(sub),'s',num2str(step),'.mat'])
                
                %把所有被试的同一ROI的zSFC放在一起
                vl(:,sub) = zsfc(21,:)';  
                al(:,sub) = zsfc(33,:)'; 
                sl(:,sub) = zsfc(59,:)'; 
                clear zsfc              
            end
            
            filename = strcat([filefolder,'/zSFC/1r_10p_RL/S'...
                ,num2str(step),'_R',num2str(rest),...
                '_V',num2str(visit),'_3roi.mat']);
            save(filename,'vl','al','sl')
            clear vl al sl
        end
    end
end
clear;clc

%% 第二步-2 把每步的4次测量拼在一起
clear;clc
filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries/zSFC/1r_10p_RL']);

cd(filefolder)

for step = 1:10;
    
    zSFC_al = zeros(400,164);
    zSFC_sl = zeros(400,164);
    zSFC_vl = zeros(400,164);
    
    visit = 1; rest = 1;
    load(['S',num2str(step),'_R',num2str(rest),'_V',num2str(visit),...
        '_3roi.mat'])
    zSFC_vl(:,1:41) = vl;
    zSFC_al(:,1:41) = al;
    zSFC_sl(:,1:41) = sl;
    clear al sl vl
    
    visit = 1; rest = 2;
    load(['S',num2str(step),'_R',num2str(rest),'_V',num2str(visit),...
        '_3roi.mat'])
    zSFC_vl(:,42:82) = vl;
    zSFC_al(:,42:82) = al;
    zSFC_sl(:,42:82) = sl;
    clear al sl vl

    visit = 2; rest = 1;
    load(['S',num2str(step),'_R',num2str(rest),'_V',num2str(visit),...
        '_3roi.mat'])    
    zSFC_vl(:,83:123) = vl;
    zSFC_al(:,83:123) = al;
    zSFC_sl(:,83:123) = sl;
    clear al sl vl

    visit = 2; rest = 2;
    load(['S',num2str(step),'_R',num2str(rest),'_V',num2str(visit),...
        '_3roi.mat'])        
    zSFC_vl(:,124:164) = vl;
    zSFC_al(:,124:164) = al;
    zSFC_sl(:,124:164) = sl;
    clear al sl vl

    %求每个roi的zsfc均值和标准差
    mean_al = mean(zSFC_al,2);
    mean_sl = mean(zSFC_sl,2);
    mean_vl = mean(zSFC_vl,2);
    std_al = std(zSFC_al,0,2);
    std_sl = std(zSFC_sl,0,2);
    std_vl = std(zSFC_vl,0,2);
    clear zSFC_al zSFC_sl zSFC_vl
    
    filename = strcat([filefolder,'/S',num2str(step),'_3roi.mat']);
    save(filename,'mean_vl','mean_al','mean_sl','std_al','std_vl','std_sl')
    
end

%% 第二步-3 画脑图

clear; clc;
filefolder_sfc = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
   'com~apple~CloudDocs/project/hcp/MasterProject/'...
   'HCP_2visits_400ptseries/']);

cd (strcat(filefolder_sfc))

for s = 1:10;
    
    a = ft_read_cifti(strcat([filefolder_sfc,'Schaefer2018_400Parcels_'...
        '7Networks_order.dscalar.nii']));
    
    cd (strcat([filefolder_sfc,'/zSFC/1r_10p_RL']))
    
    load(strcat(['S',num2str(s),'_3roi.mat']));
    
    vl_mean = a.dscalar;
    vl_std = a.dscalar;
    
    al_mean = a.dscalar;
    al_std = a.dscalar;
     
    sl_mean = a.dscalar;
    sl_std = a.dscalar;

        
    for m = 1:64984;
        for n = 1:400;
            
            if vl_mean(m,1) == n;
                vl_mean(m,1) = mean_vl(n,1);
            end
            
            if al_mean(m,1) == n;
                al_mean(m,1) = mean_al(n,1);
            end
            
            if sl_mean(m,1) == n;
                sl_mean(m,1) = mean_sl(n,1);
            end
            
            
            if vl_std(m,1) == n;
                vl_std(m,1) = std_vl(n,1);
            end
            
            if al_std(m,1) == n;
                al_std(m,1) = std_al(n,1);
            end
            
            if sl_std(m,1) == n;
                sl_std(m,1) = std_sl(n,1);
            end
            
        end
    end
    
    filefolder = strcat([filefolder_sfc,'/zSFC/1r_10p_RL/nii/']);

    a.dscalar = vl_mean;
    ft_write_cifti(strcat([filefolder,'vl_mean_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = vl_std;
    ft_write_cifti(strcat([filefolder,'vl_std_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');
    
    a.dscalar = al_mean;
    ft_write_cifti(strcat([filefolder,'al_mean_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = al_std;
    ft_write_cifti(strcat([filefolder,'al_std_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');
    
    a.dscalar = sl_mean;
    ft_write_cifti(strcat([filefolder,'sl_mean_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = sl_std;
    ft_write_cifti(strcat([filefolder,'sl_std_S',num2str(s),...
        '.nii']),a,'parameter','dscalar');
    
end

%% 第三步 

clear; clc;
filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
   'com~apple~CloudDocs/project/hcp/MasterProject/'...
   'HCP_2visits_400ptseries']);

cd (strcat(filefolder))
templet_1r_2r = dlmread('templet_1r_2r.csv');

cd (strcat(filefolder,'/zSFC/1r_10p_RL'))

for step = 1:10;
    
    % 建好3个roi的存储矩阵
    V1R1 = zeros(1200,41);
    V1R2 = zeros(1200,41);
    V2R1 = zeros(1200,41);
    V2R2 = zeros(1200,41);

    visit = 1; rest = 1;
    load(strcat(['S',num2str(step),'_R',num2str(rest),...
                '_V',num2str(visit),'_3roi.mat']))
            
    V1R1(1:400,:) = vl;
    V1R1(401:800,:) = al;
    V1R1(801:1200,:) = sl;
    clear vl al sl

    visit = 1; rest = 2;
    load(strcat(['S',num2str(step),'_R',num2str(rest),...
                '_V',num2str(visit),'_3roi.mat']))
    V1R2(1:400,:) = vl;
    V1R2(401:800,:) = al;
    V1R2(801:1200,:) = sl;
    clear vl al sl

    visit = 2; rest = 1;
    load(strcat(['S',num2str(step),'_R',num2str(rest),...
                '_V',num2str(visit),'_3roi.mat']))
            
    V2R1(1:400,:) = vl;
    V2R1(401:800,:) = al;
    V2R1(801:1200,:) = sl;
    clear vl al sl

    visit = 2; rest = 2;
    load(strcat(['S',num2str(step),'_R',num2str(rest),...
                '_V',num2str(visit),'_3roi.mat']))
    V2R2(1:400,:) = vl;
    V2R2(401:800,:) = al;
    V2R2(801:1200,:) = sl;
    clear vl al sl
 
    AllRuns = [templet_1r_2r; V1R1 V1R2 V2R1 V2R2];
    clear rest visit V1R1 V1R2 V2R1 V2R2

    filename = strcat([filefolder,'/zSFC/1r_10p_RL/for_cal_icc_S',num2str(step),'.mat']);
    save(filename,'AllRuns')
    
    csvwrite(['LT_S',num2str(step),'.csv'],AllRuns);
end
   
%% 第四步-1

clear; clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/HCP_2visits'...
    '_400ptseries/zSFC/1r_10p_RL']);

cd (strcat(filefolder))

vl_ICC_Step = zeros(400,10);
vl_Sigma_sub2_over_vr_Step = zeros(400,10);
vl_Sigma_sub_vis2_over_vr_Step = zeros(400,10);
vl_Sigma_err2_over_vr_Step = zeros(400,10);

al_ICC_Step = zeros(400,10);
al_Sigma_sub2_over_vr_Step = zeros(400,10);
al_Sigma_sub_vis2_over_vr_Step = zeros(400,10);
al_Sigma_err2_over_vr_Step = zeros(400,10);

sl_ICC_Step = zeros(400,10);
sl_Sigma_sub2_over_vr_Step = zeros(400,10);
sl_Sigma_sub_vis2_over_vr_Step = zeros(400,10);
sl_Sigma_err2_over_vr_Step = zeros(400,10);


for s = 1:10;
    filename = strcat(['zSFC_ICC_LTs',num2str(s),'.csv']);
    zSFCicc = dlmread(filename,',',1,1);

    vl_sigma_sub2_over_vr = zSFCicc(1:400,6);
    vl_sigma_sub_vis2_over_vr = zSFCicc(1:400,7);
    vl_sigma_err2_over_vr = zSFCicc(1:400,8);
    vl_ICC = zSFCicc(1:400,1);

    al_sigma_sub2_over_vr = zSFCicc(401:800,6);
    al_sigma_sub_vis2_over_vr = zSFCicc(401:800,7);
    al_sigma_err2_over_vr = zSFCicc(401:800,8);
    al_ICC = zSFCicc(401:800,1);

    sl_sigma_sub2_over_vr = zSFCicc(801:1200,6);
    sl_sigma_sub_vis2_over_vr = zSFCicc(801:1200,7);
    sl_sigma_err2_over_vr = zSFCicc(801:1200,8);
    sl_ICC = zSFCicc(801:1200,1);


    vl_ICC_Step(:,s) = vl_ICC;
    vl_Sigma_sub2_over_vr_Step(:,s) = vl_sigma_sub2_over_vr;
    vl_Sigma_sub_vis2_over_vr_Step(:,s) = vl_sigma_sub_vis2_over_vr;
    vl_Sigma_err2_over_vr_Step(:,s) = vl_sigma_err2_over_vr;
    
    al_ICC_Step(:,s) = al_ICC;
    al_Sigma_sub2_over_vr_Step(:,s) = al_sigma_sub2_over_vr;
    al_Sigma_sub_vis2_over_vr_Step(:,s) = al_sigma_sub_vis2_over_vr;
    al_Sigma_err2_over_vr_Step(:,s) = al_sigma_err2_over_vr;
    
    sl_ICC_Step(:,s) = sl_ICC;
    sl_Sigma_sub2_over_vr_Step(:,s) = sl_sigma_sub2_over_vr;
    sl_Sigma_sub_vis2_over_vr_Step(:,s) = sl_sigma_sub_vis2_over_vr;
    sl_Sigma_err2_over_vr_Step(:,s) = sl_sigma_err2_over_vr;

end

file = strcat(['LT_icc.mat']);
save(file,'vl_ICC_Step','al_ICC_Step','sl_ICC_Step',...
    'vl_Sigma_sub2_over_vr_Step',...
    'vl_Sigma_sub_vis2_over_vr_Step',...
    'vl_Sigma_err2_over_vr_Step',...
    'al_Sigma_sub2_over_vr_Step',...
    'al_Sigma_sub_vis2_over_vr_Step',...
    'al_Sigma_err2_over_vr_Step',...    
    'sl_Sigma_sub2_over_vr_Step',...
    'sl_Sigma_sub_vis2_over_vr_Step',...
    'sl_Sigma_err2_over_vr_Step')

%% 第四步-2

clear; clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/HCP_2visits'...
    '_400ptseries/zSFC/1r_10p_RL']);

cd (strcat(filefolder))

load('LT_icc')
al_zICC = atanh(al_ICC_Step);
sl_zICC = atanh(sl_ICC_Step);
vl_zICC = atanh(vl_ICC_Step);

save('LT_zICC.mat','al_zICC','sl_zICC','vl_zICC')

csvwrite(['al_LT_zICC.csv'],al_zICC);
csvwrite(['sl_LT_zICC.csv'],sl_zICC);
csvwrite(['vl_LT_zICC.csv'],vl_zICC);


%% 第五步

clear; clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/HCP_2visits'...
    '_400ptseries']);

for s = 1:10;  
    
    cd (strcat(filefolder))
    a = ft_read_cifti(strcat([filefolder,'/Schaefer2018_400Parcels_'...
        '7Networks_order.dscalar.nii']));
    
    cd (strcat([filefolder,'/zSFC/1r_10p_RL']))
    
    load('LT_icc.mat')
    
    vl_icc = a.dscalar;
    vl_sub2 = a.dscalar;
    vl_sub_vis2 = a.dscalar;
    vl_err2 = a.dscalar;

    al_icc = a.dscalar;
    al_sub2 = a.dscalar;
    al_sub_vis2 = a.dscalar;
    al_err2 = a.dscalar;

    sl_icc = a.dscalar;
    sl_sub2 = a.dscalar;
    sl_sub_vis2 = a.dscalar;
    sl_err2 = a.dscalar;


    for m = 1:64984;
        for n = 1:400;

            if vl_icc(m,1) == n;
               vl_icc(m,1) = vl_ICC_Step(n,s);
            end

            if vl_sub2(m,1) == n;
               vl_sub2(m,1) = vl_Sigma_sub2_over_vr_Step(n,s);
            end

            if vl_sub_vis2(m,1) == n;
               vl_sub_vis2(m,1) = vl_Sigma_sub_vis2_over_vr_Step(n,s);
            end

            if vl_err2(m,1) == n;
               vl_err2(m,1) = vl_Sigma_err2_over_vr_Step(n,s);
            end

            
            if al_icc(m,1) == n;
               al_icc(m,1) = al_ICC_Step(n,s);
            end

            if al_sub2(m,1) == n;
               al_sub2(m,1) = al_Sigma_sub2_over_vr_Step(n,s);
            end

            if al_sub_vis2(m,1) == n;
               al_sub_vis2(m,1) = al_Sigma_sub_vis2_over_vr_Step(n,s);
            end

            if al_err2(m,1) == n;
               al_err2(m,1) = al_Sigma_err2_over_vr_Step(n,s);
            end

 
            if sl_icc(m,1) == n;
               sl_icc(m,1) = sl_ICC_Step(n,s);
            end

            if sl_sub2(m,1) == n;
               sl_sub2(m,1) = sl_Sigma_sub2_over_vr_Step(n,s);
            end

            if sl_sub_vis2(m,1) == n;
               sl_sub_vis2(m,1) = sl_Sigma_sub_vis2_over_vr_Step(n,s);
            end
            
            if sl_err2(m,1) == n;
               sl_err2(m,1) = sl_Sigma_err2_over_vr_Step(n,s);
            end

        end
    end


    a.dscalar = vl_icc;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p_RL/nii/vl_icc_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = vl_sub2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/vl_sub2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = vl_sub_vis2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/vl_sub_vis2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = vl_err2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/vl_err2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');
    
    a.dscalar = al_icc;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/al_icc_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = al_sub2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/al_sub2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = al_sub_vis2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/al_sub_vis2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = al_err2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/al_err2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = sl_icc;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/sl_icc_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = sl_sub2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r/nii/sl_sub2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = sl_sub_vis2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r/nii/sl_sub_vis2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

    a.dscalar = sl_err2;
    ft_write_cifti(strcat([filefolder,'/zSFC/1r_10p/nii/sl_err2_LTs',num2str(s),...
        '.nii']),a,'parameter','dscalar');

end

%%
function PR = sfcfromzuo(A,r)

if issymmetric(A)
    D = diag(diag(A^2));
    if r==0
        PR = eye(size(A)); 
    end
    if r==1
        PR = A; 
    end
    if r==2
        PR = A^2 - D;
    end
    if r>2
        PR = A*sfcfromzuo(A,r-1) ...
            - (D-eye(size(A)))*sfcfromzuo(A,r-2);
    end
else
    disp('Currently this function only works for undirected graphs!')
end

end