clear; clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/HCP_2visits'...
    '_400ptseries/zSFC/2r_10p']);

cd (strcat(filefolder))

vl_Sigma_sub2_Step = zeros(400,10);
vl_Sigma_sub_vis2_Step = zeros(400,10);
vl_Sigma_err2_Step = zeros(400,10);
vl_Vr_Step = zeros(400,10);
vl_ICC_Step = zeros(400,10);

for s = 1:10;
    filename = strcat(['zSFC_ICC_LTs',num2str(s),'v_2.csv']);
    zSFCicc = dlmread(filename,',',1,1);

    vl_icc = zSFCicc(1:400,1);
    vl_sigma_sub2 = zSFCicc(1:400,2);
    vl_sigma_sub_vis2 = zSFCicc(1:400,3);
    vl_sigma_err2 = zSFCicc(1:400,4);
    vl_vr = zSFCicc(1:400,5);
    
    vl_ICC_Step(:,s) = vl_icc;
    vl_Sigma_sub2_Step(:,s) = vl_sigma_sub2;
    vl_Sigma_sub_vis2_Step(:,s) = vl_sigma_sub_vis2;
    vl_Sigma_err2_Step(:,s) = vl_sigma_err2;
    vl_Vr_Step(:,s) = vl_vr;
    
end
file = strcat(['LT_icc_para_raw_2.mat']);
save(file,'vl_Sigma_sub2_Step',...
    'vl_Sigma_sub_vis2_Step',...
    'vl_Sigma_err2_Step',...
    'vl_Vr_Step','vl_ICC_Step')
clear;clc

