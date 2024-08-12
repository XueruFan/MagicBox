clear;clc;

% 找到画脑图colorbar的最大值和最小值

Max = zeros(2,10);
Min = zeros(2,10);

for s=1:10;
    
    load(['S',num2str(s),'_3roi.mat']);
    
    MAX=[max(max(mean_al)) max(max(mean_sl)) max(max(mean_vl))
    max(max(std_al)) max(max(std_sl)) max(max(std_vl))];

    MIN=[min(min(mean_al)) min(min(mean_sl)) min(min(mean_vl))
    min(min(std_al)) min(min(std_sl)) min(min(std_vl))];

    X=max(MAX')';
    Y=min(MIN')';
    
    Max(:,s) = X;
    Min(:,s) = Y;
    
    clearvars -except Max Min
    
end

value=[max(Max')' min(Min')'];

