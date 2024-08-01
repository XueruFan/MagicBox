clear;clc;

xueru_usb = '/Volumes/HCP_Xueru/';
hcp_filefolder = '/Volumes/LaCie_1/HCP/1200/';
%addpath(xueru_usb);
%addpath(hcp_filefolder);

% load subject ID 
cd(xueru_usb);
subID = csvread('SubjectID.csv');

% find and copy hcp data i need
for N = 1:42
    sub = subID(N,1);
    mkdir(num2str(sub));
    
    mypath = strcat(xueru_usb,num2str(sub),'/');
    
    %%cd(hcp_filefolder);
    %rest_filepath = strcat([hcp_filefolder,'/',num2str(sub),...
    %    '/MNINonLinear/Results/']);
   
    %cd(strcat(rest_filepath,'rfMRI_REST1_LR/'))
    %copyfile('rfMRI_REST1_LR.nii.gz', mypath)
    %cd(strcat(rest_filepath,'rfMRI_REST1_RL/'))
    %copyfile('rfMRI_REST1_RL.nii.gz', mypath)
    %cd(strcat(rest_filepath,'rfMRI_REST2_LR/'))
    %copyfile('rfMRI_REST2_LR.nii.gz', mypath)
    %cd(strcat(rest_filepath,'rfMRI_REST2_RL/'))
    %copyfile('rfMRI_REST2_RL.nii.gz', mypath)
    
    
    fix_filepath = strcat([hcp_filefolder,'/',num2str(sub),...
        '/MNINonLinear/Results/']);
        
    cd(strcat(fix_filepath,'rfMRI_REST1_LR/'))
    copyfile('rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii', mypath)
    cd(strcat(fix_filepath,'rfMRI_REST1_RL/'))
    copyfile('rfMRI_REST1_RL_Atlas_hp2000_clean.dtseries.nii', mypath)
    cd(strcat(fix_filepath,'rfMRI_REST2_LR/'))
    copyfile('rfMRI_REST2_LR_Atlas_hp2000_clean.dtseries.nii', mypath)
    cd(strcat(fix_filepath,'rfMRI_REST2_RL/'))
    copyfile('rfMRI_REST2_RL_Atlas_hp2000_clean.dtseries.nii', mypath)
    
    cd(xueru_usb);
end
    
    
