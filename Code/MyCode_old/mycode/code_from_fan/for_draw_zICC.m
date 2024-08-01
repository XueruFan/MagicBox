% clear; clc;
% format long
% 
% filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
%     'com~apple~CloudDocs/project/hcp/MasterProject/'...
%     'HCP_2visits_400ptseries/zSFC']);
% 
% for s = 1:10;
% 
%     zicc_for_draw = zeros(400,12);
% 
%     cd (strcat(filefolder,'/1r_20p'))
%     load('LT_zICC')
%     zicc_for_draw(:,1) = vl_zICC(:,s);
%     zicc_for_draw(:,2) = al_zICC(:,s);
%     zicc_for_draw(:,3) = sl_zICC(:,s);
%     clear LT_zICC
%     
%     cd (strcat(filefolder,'/1r_10p'))
%     load('LT_zICC')
%     zicc_for_draw(:,4) = vl_zICC(:,s);
%     zicc_for_draw(:,5) = al_zICC(:,s);
%     zicc_for_draw(:,6) = sl_zICC(:,s);
%     clear LT_zICC
%     
%     cd (strcat(filefolder,'/2r_20p'))
%     load('LT_zICC')
%     zicc_for_draw(:,7) = vl_zICC(:,s);
%     zicc_for_draw(:,8) = al_zICC(:,s);
%     zicc_for_draw(:,9) = sl_zICC(:,s);
%     clear LT_zICC
%     
%     cd (strcat(filefolder,'/2r_10p'))
%     load('LT_zICC')
%     zicc_for_draw(:,10) = vl_zICC(:,s);
%     zicc_for_draw(:,11) = al_zICC(:,s);
%     zicc_for_draw(:,12) = sl_zICC(:,s);
%     clear LT_zICC
%     
%     cd (filefolder)
%     filename = strcat(['zicc_for_draw_S',num2str(s),]);
%     save (filename, 'zicc_for_draw')
%     
% end

%%
clear; clc;
format long

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries/zSFC']);

for s = 1:10;

    icc_ttest = zeros(400,6);

    cd (strcat(filefolder,'/1r_20p'))
    load('LT_icc')
    icc_ttest(:,1) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    cd (strcat(filefolder,'/1r_10p'))
    load('LT_icc')
    icc_ttest(:,2) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    cd (strcat(filefolder,'/2r_20p'))
    load('LT_icc')
    icc_ttest(:,3) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    cd (strcat(filefolder,'/2r_10p'))
    load('LT_icc')
    icc_ttest(:,4) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    cd (strcat(filefolder,'/4r_20p'))
    load('LT_icc')
    icc_ttest(:,5) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    cd (strcat(filefolder,'/4r_10p'))
    load('LT_icc')
    icc_ttest(:,6) = vl_ICC_Step(:,s)';
    clear LT_icc
    
    mean_icc = mean(icc_ttest);
    
    cd (strcat(filefolder,'/icc_ttest/'))
    filename = strcat(['icc_ttest_S',num2str(s),]);
    save (filename, 'icc_ttest','mean_icc')
    
end
clear;clc;

%%
clear; clc;
format long

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries/zSFC/icc_ttest']);

for s = 1:10;
    
    ttest_result_p = zeros(6,6);
    ttest_result_ci_1 = zeros(6,6);
    ttest_result_ci_2 = zeros(6,6);


    load(strcat(['icc_ttest_S',num2str(s),]))
    
    for i = 1:5;
        for j = i+1:6;
    
        [h, p, ci] = ttest(icc_ttest(:,i), icc_ttest(:,j), 'Alpha', 0.01);

        ttest_result_p(j,i) = p;
        ttest_result_ci_1(j,i) = ci(1);
        ttest_result_ci_2(j,i) = ci(2);
        
        filename = strcat(['ttest_result_S',num2str(s),]);
        save (filename, 'ttest_result_p','ttest_result_ci_1'...
            ,'ttest_result_ci_2')
        end
    end
end

clear;clc;


%%
% %% 
% clear; clc;
% format long
% 
% filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
%     'com~apple~CloudDocs/project/hcp/MasterProject/'...
%     'HCP_2visits_400ptseries/zSFC']);
% 
% icc_mean_draw = zeros(12,10);
% 
% cd (strcat(filefolder,'/1r_20p'))
% load('LT_icc')
% icc_mean_draw(1,:) = mean(vl_ICC_Step);
% icc_mean_draw(2,:) = mean(al_ICC_Step);
% icc_mean_draw(3,:) = mean(sl_ICC_Step);
% 
% cd (strcat(filefolder,'/1r_10p'))
% load('LT_icc')
% icc_mean_draw(4,:) = mean(vl_ICC_Step);
% icc_mean_draw(5,:) = mean(al_ICC_Step);
% icc_mean_draw(6,:) = mean(sl_ICC_Step);
% 
% cd (strcat(filefolder,'/2r_20p'))
% load('LT_icc')
% icc_mean_draw(7,:) = mean(vl_ICC_Step);
% icc_mean_draw(8,:) = mean(al_ICC_Step);
% icc_mean_draw(9,:) = mean(sl_ICC_Step);
% 
% cd (strcat(filefolder,'/2r_10p'))
% load('LT_icc')
% icc_mean_draw(10,:) = mean(vl_ICC_Step);
% icc_mean_draw(11,:) = mean(al_ICC_Step);
% icc_mean_draw(12,:) = mean(sl_ICC_Step);
% 
% cd (filefolder)
% filename = strcat('icc_mean_draw');
% save (filename, 'icc_mean_draw')
