% 本代码用来整理从zls那里拷来的HCP数据，把两次测量、每次4个run的数据整理到单个被试名下
% 范雪如 2021年11月23日

clear;clc;

xueru_usb = '/Volumes/HCP_Xueru/';

% load subject ID 
cd(xueru_usb)
subID = csvread('SubjectID.csv');

% 把test1的数据整理到一起
for N = 1:42
    sub = subID(N,1);
    cd (strcat(xueru_usb,num2str(sub),'/'))
    mkdir Test1
    newpath = strcat(xueru_usb,num2str(sub),'/Test1/');

    movefile('rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii', newpath)
    movefile('rfMRI_REST1_RL_Atlas_hp2000_clean.dtseries.nii', newpath)
    movefile('rfMRI_REST2_LR_Atlas_hp2000_clean.dtseries.nii', newpath)
    movefile('rfMRI_REST2_RL_Atlas_hp2000_clean.dtseries.nii', newpath)
    
    cd(xueru_usb)
end

%% 把test2的数据解压出来再整理到被试名下去
clear N sub

for N = 2:42
    sub = subID(N,1);
    cd (strcat(xueru_usb,num2str(sub),'/'))
    mkdir Test2
    
    cd (strcat(xueru_usb,'TRT/rsfMRI/fix/'))
    unzip (strcat(num2str(sub), '_3T_rfMRI_REST_fix.zip'))
    filepath = strcat(xueru_usb,'TRT/rsfMRI/fix/',num2str(sub),'/MNINonLinear/Results/');
    newpath = strcat(xueru_usb,num2str(sub),'/Test2/');
    
    cd (strcat(filepath,'/rfMRI_REST1_LR/'))
    movefile('rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii', newpath)
    
    cd (strcat(filepath,'/rfMRI_REST1_RL/'))
    movefile('rfMRI_REST1_RL_Atlas_hp2000_clean.dtseries.nii', newpath)
    
    cd (strcat(filepath,'/rfMRI_REST2_LR/'))
    movefile('rfMRI_REST2_LR_Atlas_hp2000_clean.dtseries.nii', newpath)
    
    cd (strcat(filepath,'/rfMRI_REST2_RL/'))
    movefile('rfMRI_REST2_RL_Atlas_hp2000_clean.dtseries.nii', newpath)
    
    cd (strcat(xueru_usb,'TRT/rsfMRI/fix/'))
    rmdir (strcat(num2str(sub)), 's')
    delete (strcat(num2str(sub), '_3T_rfMRI_REST_fix.zip'))
    
end