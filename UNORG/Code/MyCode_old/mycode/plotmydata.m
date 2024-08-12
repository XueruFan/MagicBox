%%
% within networks

for s=1:7;
    
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/reshape']));
    load(['S',num2str(s),'.mat']);
   
    a=ICC400;
    c=tril(a,-1)+triu(a',0);
    
    Visual_other=c([1:31 201:230],[1:31 201:230]);
    h = heatmap(Visual_other);
    h.Title = {'Visual_Visual Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Visual_Visual.png')
    
    SomMot_SomMot=c([32:68 231:270],[32:68 231:270]);
    h = heatmap(SomMot_SomMot);
    h.Title = {'SomMot_SomMot Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'SomMot_SomMot.png')
    
    DorsAttn_DorsAttn=c([69:91 271:293],[69:91 271:293]);
    h = heatmap(DorsAttn_DorsAttn);
    h.Title = {'DorsAttn_DorsAttn Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'DorsAttn_DorsAttn.png')
    
    Cont_Cont=c([91:113 294:318],[91:113 294:318]);
    h = heatmap(Cont_Cont);
    h.Title = {'SalVentAttn_SalVentAttn Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'SalVentAttn_SalVentAttn.png')
    
    Cont_Cont=c([114:126 319:331],[114:126 319:331]);
    h = heatmap(Cont_Cont);
    h.Title = {'Limbic_Limbic Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Limbic_Limbic.png')
    
    Cont_Cont=c([127:148 332:361],[127:148 332:361]);
    h = heatmap(Cont_Cont);
    h.Title = {'Cont_Cont Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Cont_Cont.png')
    
    Default_Default=c([149:200 362:400],[149:200 362:400]);
    h = heatmap(Default_Default);
    h.Title = {'Default_Default Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Default_Default.png')
    
end

%%
% between networks

for s=1:7;
    
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/reshape']));
    load(['S',num2str(s),'.mat']);
   
    a=ICC400;
    c=tril(a,-1)+triu(a',0);
    
    Visual_other=c(:,[1:31 201:230]);
    h = heatmap(Visual_other);
    h.Title = {'Visual_other Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 5;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Visual_other.png')
    
    SomMot_other=c([:],[32:68 231:270]);
    h = heatmap(SomMot_other);
    h.Title = {'SomMot_other Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 5;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'SomMot_other.png')
    
    DorsAttn_DorsAttn=c([69:91 271:293],[69:91 271:293]);
    h = heatmap(DorsAttn_DorsAttn);
    h.Title = {'DorsAttn_DorsAttn Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'DorsAttn_DorsAttn.png')
    
    Cont_Cont=c([91:113 294:318],[91:113 294:318]);
    h = heatmap(Cont_Cont);
    h.Title = {'SalVentAttn_SalVentAttn Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'SalVentAttn_SalVentAttn.png')
    
    Cont_Cont=c([114:126 319:331],[114:126 319:331]);
    h = heatmap(Cont_Cont);
    h.Title = {'Limbic_Limbic Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Limbic_Limbic.png')
    
    Cont_Cont=c([127:148 332:361],[127:148 332:361]);
    h = heatmap(Cont_Cont);
    h.Title = {'Cont_Cont Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Cont_Cont.png')
    
    Default_Default=c([149:200 362:400],[149:200 362:400]);
    h = heatmap(Default_Default);
    h.Title = {'Default_Default Network'};
    h.XLabel = '';
    h.YLabel = '';
    h.MissingDataLabel = '';
    h.MissingDataColor = [1 1 1];
    h.Colormap = [1:-0.11:0.01;1:-0.11:0.01;1:-(0.25/9):0.75]';
    h.CellLabelColor = [1 0 1];
    h.ColorbarVisible = 'off'
    h.ColorLimits = [0 1];
    h.GridVisible = 'off';
    h.FontName = 'Cambria';
    h.FontSize = 13;
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/processed/ABS05/ready/icc/fig/S',num2str(s),]));
    saveas(h,'Default_Default.png')
    
end