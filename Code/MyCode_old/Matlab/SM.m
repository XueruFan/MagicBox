% 一些分析过程中写的小代码
% Xueru Fan #23-Nov-2021 @BNU

%% 把PCA和Mean整理成DCM中的格式mat
clear, clc
xueru_disk = '/Volumes/HCP_Xueru/'; %
data_folder = 'S1200TRT'; %
phase_encoding = 'LR'; %

cd (xueru_disk)
subID = xlsread('SubjectID.xlsx'); %
load (strcat(xueru_disk, '/fakefile/pindex.mat'))
load (strcat(xueru_disk, '/fakefile/voi_demo.mat'))
nsubs = numel(subID);

data_path = strcat(xueru_disk, data_folder, '/');
cd (data_path)

for N = 1:nsubs
    sub = subID(N,1);
    for T = 1:2 %
        cd (strcat(num2str(sub),'/Test', num2str(T), '/'))
        for R = 1:2
            mkdir (strcat('PCA_REST', num2str(R)))
            mkdir (strcat('Mean_REST', num2str(R)))
            load (strcat('REST', num2str(R), '_', phase_encoding, '_ptseries.mat'))
            for P = 1:400
                % 复写xY的参数
                xY.name = parcelslabel(P,1);
                xY.name = xY.name{1,1};
                xY.xyz = pcoordinates(P,:);
                xY.spec = [];
                xY.str = strcat('image mask: ..\_', xY.name, '\_mask.nii');
                xY.XYZmm = xY.xyz';
                xY.X0 = [];
                y = PCA(P,:)';
                [v,s,v] = svd(y'*y);
                s = diag(s);
                v = v(:,1);
                u = y*v/sqrt(s(1));
                d = sign(sum(v));
                u = u*d;
                v = v*d;
                Y = u*sqrt(s(1));
                xY.y = y;
                xY.u = Y;
                xY.v = v;
                xY.s = s;
%                 Y = PCA(P,:)';
                file = strcat('VOI_P',num2str(P),'_1');
                cd (strcat('PCA_REST', num2str(R)))
                save (file, 'xY', 'Y')
                
                cd (strcat(data_path, num2str(sub),'/Test', num2str(T), '/'))
                
                xY.name = parcelslabel(P,1);
                xY.name = xY.name{1,1};
                xY.xyz = pcoordinates(P,:);
                xY.spec = [];
                xY.str = strcat('image mask: ..\_', xY.name, '\_mask.nii');
                xY.XYZmm = xY.xyz';
                xY.X0 = [];
                y = Mean(P,:)';
                [v,s,v] = svd(y'*y);
                s = diag(s);
                v = v(:,1);
                u = y*v/sqrt(s(1));
                d = sign(sum(v));
                u = u*d;
                v = v*d;
                Y = u*sqrt(s(1));
                xY.y = y;
                xY.u = Y;
                xY.v = v;
                xY.s = s;
%                 Y = Mean(P,:)';
                file = strcat('VOI_P',num2str(P),'_1');
                cd (strcat('Mean_REST', num2str(R)))
                save (file, 'xY', 'Y')

                cd (strcat(data_path, num2str(sub),'/Test', num2str(T), '/'))
            end
        end
        cd (data_path)
    end
    cd (data_path)
end

clear, clc

%% 把空SPM文件存入每个数据文件下
clear, clc
xueru_disk = '/Volumes/HCP_Xueru/'; %
data_folder = 'S1200TRT'; %
phase_encoding = 'LR'; %

cd (xueru_disk)
subID = xlsread('SubjectID.xlsx'); %
nsubs = numel(subID);

data_path = strcat(xueru_disk, data_folder, '/');

for N = 1:nsubs
    sub = subID(N,1);
    for T = 1:2 %
        for R = 1:2
            cd (strcat(data_path, num2str(sub),'/Test', num2str(T), '/PCA_REST', num2str(R)))
            mkdir ('DCM')
            aimfolder = strcat(data_path, num2str(sub),'/Test', ...
                num2str(T), '/PCA_REST', num2str(R),'/DCM/');
            cd (xueru_disk)
            copyfile('SPM.mat', aimfolder)
            cd (strcat(data_path, num2str(sub),'/Test', num2str(T), '/Mean_REST', num2str(R)))
            mkdir ('DCM')
            aimfolder = strcat(data_path, num2str(sub),'/Test', ...
                num2str(T), '/Mean_REST', num2str(R),'/DCM/');
            cd (xueru_disk)
            copyfile('SPM.mat', aimfolder)
        end
    end
end


%% SM：给400个parcel改下名字

for P = 1:200
    parcelslabel{P,1} = erase(parcelslabel{P,1},'7Networks_');
    parcelslabel{P,1} = erase(parcelslabel{P,1},'_');
end
save ('pindex.mat', 'parcelslabel','pcoordinates')

%% SM: 删掉一些文件

for N = 1:nsubs
    sub = subID(N,1);
    cd (strcat(data_path, num2str(sub), '/'))
    rmdir('SEFC','s')
    rmdir('SFC','s')
    for T = 1:2
        cd (strcat(data_path, num2str(sub), '/Test', num2str(T), '/'))
        delete *.mat
    end
end

%% make fake DCM_400p.mat file
clear, clc
xueru_disk = '/Volumes/HCP_Xueru/'; %
data_folder = 'S1200TRT'; %
phase_encoding = 'LR'; %

cd (xueru_disk)
subID = xlsread('SubjectID.xlsx'); %

load (strcat(xueru_disk, '/fakefile/pindex.mat'))
load (strcat(xueru_disk, '/fakefile/voi_demo.mat'))
load (strcat(xueru_disk, '/fakefile/DCM_fake.mat'))
nsubs = numel(subID);

data_path = strcat(xueru_disk, data_folder, '/');
cd (data_path)

for N = 1:nsubs
    sub = subID(N,1);
    for T = 1:2 %
        cd (strcat(num2str(sub),'/Test', num2str(T), '/'))
        for R = 1:2
            cd (strcat(data_path, num2str(sub),'/Test', ...
                num2str(T), '/Mean_REST', num2str(R)))
            DCM.a = ones(400,400);
            DCM.b = zeros(400,400);
            DCM.c = zeros(400,1);
            DCM.Y.name = parcelslabel';
            DCM.Y.Q(1,1:400) = DCM.Y.Q(1,1);
            for P = 1:400    
                load (strcat('VOI_P',num2str(P),'_1.mat'))
                DCM.Y.y(:,P) = xY.u;
                DCM.xY(P).name = parcelslabel(P,1);
                DCM.xY(P).Ic = NaN;
                DCM.xY(P).Sess = 1;
                DCM.xY(P).xyz = pcoordinates(P,:);
                DCM.xY(P).def = 'mask';
                DCM.xY(P).spec = NaN;
                DCM.xY(P).str = strcat('image mask: ..\_', DCM.xY(P).name, '\_mask.nii');
                DCM.xY(P).XYZmm = DCM.xY(P).xyz;
                DCM.xY(P).X0 = [];
                DCM.xY(P).y = xY.u;
                DCM.xY(P).u = xY.u;
                DCM.xY(P).v = 1;
                DCM.xY(P).s = xY.s;
            end
            DCM.n = 400;
            DCM.delays = zeros(400,1);
            cd DCM
            save DCM_400p.mat DCM
        end
        cd (data_path)
    end
end

%% make fake DCM_test.mat

w = 5; %选多少个parcels

DCM.a = [];
DCM.a = ones(w,w);
DCM.b = [];
DCM.b = zeros(w,w);
DCM.c = [];
DCM.c = zeros(w,1);
DCM.Y.y(:,w+1:400) = [];
x = w+1;
DCM.Y.name = DCM.Y.name';
DCM.Y.name(x:400) = [];
DCM.Y.name = DCM.Y.name';
DCM.Y.Q = DCM.Y.Q';
DCM.Y.Q(x:400) = [];
DCM.Y.Q = DCM.Y.Q';
DCM.xY(x:400) = [];
DCM.n = w;
DCM.delays = [];
DCM.delays = zeros(w,1);
clear m w x
clc

%% SFC test

A_pos = [0 1 1 0 0 0 0
    0 0 0 0 1 0 0
    1 0 0 0 0 1 0 
    0 1 0 0 0 0 1
    0 1 0 1 0 0 0
    0 0 0 0 0 0 0
    0 0 0 1 0 1 0];
A_neg = [0 0 0 0 0 0 0
    1 0 0 1 0 0 0
    0 0 0 1 0 0 0
    0 0 1 0 1 0 0
    0 0 0 0 0 0 1
    0 0 1 0 0 0 1
    0 0 0 0 1 0 0];

B = [0 1 0 0 1 1 0 1
    0 0 1 0 0 0 0 0
    0 0 0 1 1 0 0 0
    0 0 0 0 1 0 0 1
    0 0 0 0 0 0 1 0
    0 0 0 0 1 0 0 0 
    0 0 1 0 0 1 0 0
    0 0 0 1 0 0 1 0]
S2 = ccs_core_graphwalk(B,2,'nbtw')
S3 = ccs_core_graphwalk(B,3,'nbtw')
S4 = ccs_core_graphwalk(B,4,'nbtw')
S5 = ccs_core_graphwalk(B,5,'nbtw')
S6 = ccs_core_graphwalk(B,6,'nbtw')


%%
            % 把向量复原成矩阵
            cd (strcat(xueru_disk, 'group/')) 
            load (strcat(num2str(p), 'p_T', num2str(T), '_R', ...
                num2str(R), '_pca_rDCM.mat'))
            mean_EpA_pos_reshap = reshape(mean_EpA_pos, p, p);
            mean_EpA_neg_reshap = reshape(mean_zSFC_neg, p, p);
            std_EpA_pos_reshap = reshape(std_zSFC_pos, p, p);
            std_EpA_neg_reshap = reshape(std_zSFC_neg, p, p);
            
                        % 保存复原的矩阵文件
            fn = strcat(num2str(p), 'p_T', num2str(T), '_R', ...
                num2str(R), '_pca_rDCM_reshape.mat');
            save (fn, 'mean_EpA_pos_reshap', 'mean_EpA_neg_reshap', ...
                'std_EpA_pos_reshap', 'std_EpA_neg_reshap')
