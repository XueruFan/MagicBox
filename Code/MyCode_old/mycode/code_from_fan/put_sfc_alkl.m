clear; clc;
format long

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries/zSFC/1r_10p/']);
cd (strcat(filefolder))

al_mean_all = zeros(400,10);
sl_mean_all = zeros(400,10);
vl_mean_all = zeros(400,10);
al_std_all = zeros(400,10);
sl_std_all = zeros(400,10);
vl_std_all = zeros(400,10);

for s = 1:10;
    
    load(['S',num2str(s),'_3roi.mat'])
    
    al_mean_all(:,s) = mean_al;
    sl_mean_all(:,s) = mean_sl;
    vl_mean_all(:,s) = mean_vl;
    al_std_all(:,s) = std_al;
    sl_std_all(:,s) = std_sl;
    vl_std_all(:,s) = std_vl;
    
end

save ('zSFC_all','al_mean_all','sl_mean_all','vl_mean_all',...
    'al_std_all','sl_std_all','vl_std_all')

clear;clc;

