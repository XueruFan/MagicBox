%% 算功能连接 ini 10p 20p

clear;clc;

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
                ,num2str(rest),'_LR.ptseries.mat']); %打开原始时间序列

            cor = abs(corr(timeseries)); %计算400个分区的相关并取绝对值
            cor = cor-diag(diag(cor)); %把自相关置0
            
            cor_ini_trans = cor;            
            
            rank = sort(cor(:)','descend'); %把相关矩阵中所有元素从大到小排列
            
            cor_10p = cor;
            cor_20p = cor;
            
            cor_10p(find(cor_10p < rank(1,15960)))=0; 
            cor_20p(find(cor_20p < rank(1,31920)))=0;
            
            cor_10p_trans = cor_10p;
            cor_20p_trans = cor_20p;
            
            clear timeseries rank 
            
            cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
                ,num2str(rest),'/com_threshold/']));

            filename = strcat(['sub',num2str(sub_id(sub,2)),'.mat']);
            save(filename,'cor','cor_10p','cor_20p')
        end
    end
end

%% 算组平均

clear;clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries']);
cd (strcat(filefolder))

for visit = 1:2
    
    for rest = 1:2;
        
        cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
            ,num2str(rest),'/com_threshold/']));
        
        COR = zeros(400,400);
        COR_10p = zeros(400,400);
        COR_20p = zeros(400,400);
        
        for sub = 1:41;

            load(['sub',num2str(sub),'.mat']);
            
            COR = COR + cor;
            COR_10p = COR_10p + cor_10p;
            COR_20p = COR_20p + cor_20p;
            
        end
        
        avr_cor = COR/41;
        avr_cor_10p = COR_10p/41;
        avr_cor_20p = COR_20p/41;

        filename = strcat(['V',num2str(visit),'R',num2str(rest),'_group.mat']);
        save(filename, 'avr_cor','avr_cor_10p','avr_cor_20p')
    end
end
            
%% 算4次测量的平均

clear;clc;

filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries']);
cd (strcat(filefolder))

Avr_cor = zeros(400,400);
Avr_cor_10p = zeros(400,400);
Avr_cor_20p = zeros(400,400);

for visit = 1:2
    
    for rest = 1:2;
        
        cd (strcat([filefolder,'/Visit',num2str(visit),'/Rest'...
            ,num2str(rest),'/com_threshold/']));
        load(['V',num2str(visit),'R',num2str(rest),'_group.mat'])
        
        Avr_cor = Avr_cor + avr_cor;
        Avr_cor_10p = Avr_cor_10p + avr_cor_10p;
        Avr_cor_20p = Avr_cor_20p + avr_cor_20p;
        
    end
end

average_cor = Avr_cor/4;
average_cor_10p = Avr_cor_10p/4;
average_cor_20p = Avr_cor_20p/4;

average_cor_trans = average_cor;
average_cor_10p_trans = average_cor_10p;
average_cor_20p_trans = average_cor_20p;

average_cor_trans(find(average_cor_trans ~= 0)) = 1;
average_cor_10p_trans(find(average_cor_10p_trans ~= 0)) = 1;
average_cor_20p_trans(find(average_cor_20p_trans ~= 0)) = 1;

cd (strcat(filefolder))
filename = 'Visual_threshold';
save(filename, 'average_cor','average_cor_10p','average_cor_20p',...
    'average_cor_trans','average_cor_10p_trans','average_cor_20p_trans')
