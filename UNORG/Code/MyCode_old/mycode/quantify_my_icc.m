%% part2 7 networks between

clear;clc;

ICC_mean_7Networks = zeros(28,7);

for s=2:7;
    
    cd (strcat(['/Users/fanxueru/Documents/project/data/hcp/band0/ICC/reshape']));
    load(['S',num2str(s),'.mat']);
    
    a=ICC400;
    c=tril(a,-1)+triu(a',0);
    c(find(isnan(c)==1)) = 0;
    
    
    Visual_Default = c([149:200 362:400],[1:31 201:230]);
    b = Visual_Default;
    n = isnan(Visual_Default);
    b(n) = 0;
    Visual_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_Default = c([149:200 362:400],[32:68 231:270]);
    b = SomMot_Default;
    n = isnan(SomMot_Default);
    b(n) = 0;
    SomMot_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_Default = c([149:200 362:400],[69:91 271:293]);
    b = DorsAttn_Default;
    n = isnan(DorsAttn_Default);
    b(n) = 0;
    DorsAttn_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_Default = c([149:200 362:400],[92:113 294:318]);
    b = SalVentAttn_Default;
    n = isnan(SalVentAttn_Default);
    b(n) = 0;
    SalVentAttn_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_Default = c([149:200 362:400],[114:126 319:331]);
    b =  Limbic_Default;
    n = isnan(Limbic_Default);
    b(n) = 0;
    Limbic_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_Default = c([149:200 362:400],[127:148 332:361]);
    b = Cont_Default;
    n = isnan(Cont_Default);
    b(n) = 0;
    Cont_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_Default = c([149:200 362:400],[149:200 362:400]);
    b = Default_Default;
    n = isnan(Default_Default);
    b(n) = 0;
    Default_Default_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    
    Visual_Cont =  c([127:148 332:361],[1:31 201:230]);
    b = Visual_Cont;
    n = isnan(Visual_Cont);
    b(n) = 0;
    Visual_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_Cont =  c([127:148 332:361],[32:68 231:270]);
    b = SomMot_Cont;
    n = isnan(SomMot_Cont);
    b(n) = 0;
    SomMot_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_Cont =  c([127:148 332:361],[69:91 271:293]);
    b = DorsAttn_Cont;
    n = isnan(DorsAttn_Cont);
    b(n) = 0;
    DorsAttn_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_Cont =  c([127:148 332:361],[92:113 294:318]);
    b = SalVentAttn_Cont;
    n = isnan(SalVentAttn_Cont);
    b(n) = 0;
    SalVentAttn_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_Cont =  c([127:148 332:361],[114:126 319:331]);
    b = Limbic_Cont;
    n = isnan(Limbic_Cont);
    b(n) = 0;
    Limbic_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_Cont =  c([127:148 332:361],[127:148 332:361]);
    b = Cont_Cont;
    n = isnan(Cont_Cont);
    b(n) = 0;
    Cont_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_Cont =  c([127:148 332:361],[149:200 362:400]);
    b = Default_Cont;
    n = isnan(Default_Cont);
    b(n) = 0;
    Default_Cont_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    
    Visual_Limbic = c([114:126 319:331],[1:31 201:230]);
    b = Visual_Limbic;
    n = isnan(Visual_Limbic);
    b(n) = 0;
    Visual_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_Limbic = c([114:126 319:331],[32:68 231:270]);
    b = SomMot_Limbic;
    n = isnan(SomMot_Limbic);
    b(n) = 0;
    SomMot_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_Limbic = c([114:126 319:331],[69:91 271:293]);
    b = DorsAttn_Limbic;
    n = isnan(DorsAttn_Limbic);
    b(n) = 0;
    DorsAttn_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_Limbic = c([114:126 319:331],[92:113 294:318]);
    b = SalVentAttn_Limbic;
    n = isnan(SalVentAttn_Limbic);
    b(n) = 0;
    SalVentAttn_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_Limbic = c([114:126 319:331],[114:126 319:331]);
    b = Limbic_Limbic;
    n = isnan(Limbic_Limbic);
    b(n) = 0;
    Limbic_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_Limbic = c([114:126 319:331],[127:148 332:361]);
    b = Cont_Limbic;
    n = isnan(Cont_Limbic);
    b(n) = 0;
    Cont_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_Limbic = c([114:126 319:331],[149:200 362:400]);
    b = Default_Limbic;
    n = isnan(Default_Limbic);
    b(n) = 0;
    Default_Limbic_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    
    Visual_SalVentAttn = c([92:113 294:318],[1:31 201:230]);
    b = Visual_SalVentAttn;
    n = isnan(Visual_SalVentAttn);
    b(n) = 0;
    Visual_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_SalVentAttn = c([92:113 294:318],[32:68 231:270]);
    b = SomMot_SalVentAttn;
    n = isnan(SomMot_SalVentAttn);
    b(n) = 0;
    SomMot_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_SalVentAttn = c([92:113 294:318],[69:91 271:293]);
    b = DorsAttn_SalVentAttn;
    n = isnan(DorsAttn_SalVentAttn);
    b(n) = 0;
    DorsAttn_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_SalVentAttn = c([92:113 294:318],[92:113 294:318]);
    b = SalVentAttn_SalVentAttn;
    n = isnan(SalVentAttn_SalVentAttn);
    b(n) = 0;
    SalVentAttn_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_SalVentAttn = c([92:113 294:318],[114:126 319:331]);
    b = Limbic_SalVentAttn;
    n = isnan(Limbic_SalVentAttn);
    b(n) = 0;
    Limbic_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_SalVentAttn = c([92:113 294:318],[127:148 332:361]);
    b = Cont_SalVentAttn;
    n = isnan(Cont_SalVentAttn);
    b(n) = 0;
    Cont_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_SalVentAttn = c([92:113 294:318],[149:200 362:400]);
    b = Default_SalVentAttn;
    n = isnan(Default_SalVentAttn);
    b(n) = 0;
    Default_SalVentAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    
    Visual_DorsAttn = c([69:91 271:293],[1:31 201:230]);
    b = Visual_DorsAttn;
    n = isnan(Visual_DorsAttn);
    b(n) = 0;
    Visual_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_DorsAttn = c([69:91 271:293],[32:68 231:270]);
    b = SomMot_DorsAttn;
    n = isnan(SomMot_DorsAttn);
    b(n) = 0;
    SomMot_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_DorsAttn = c([69:91 271:293],[69:91 271:293]);
    b = DorsAttn_DorsAttn;
    n = isnan(DorsAttn_DorsAttn);
    b(n) = 0;
    DorsAttn_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_DorsAttn = c([69:91 271:293],[92:113 294:318]);
    b = SalVentAttn_DorsAttn;
    n = isnan(SalVentAttn_DorsAttn);
    b(n) = 0;
    SalVentAttn_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_DorsAttn = c([69:91 271:293],[114:126 319:331]);
    b = Limbic_DorsAttn;
    n = isnan(Limbic_DorsAttn);
    b(n) = 0;
    Limbic_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_DorsAttn = c([69:91 271:293],[127:148 332:361]);
    b = Cont_DorsAttn;
    n = isnan(Cont_DorsAttn);
    b(n) = 0;
    Cont_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_DorsAttn = c([69:91 271:293],[149:200 362:400]);
    b = Default_DorsAttn;
    n = isnan(Default_DorsAttn);
    b(n) = 0;
    Default_DorsAttn_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    
    Visual_SomMot = c([32:68 231:270],[1:31 201:230]);
    b = Visual_SomMot;
    n = isnan(Visual_SomMot);
    b(n) = 0;
    Visual_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_SomMot = c([32:68 231:270],[32:68 231:270]);
    b = SomMot_SomMot;
    n = isnan(SomMot_SomMot);
    b(n) = 0;
    SomMot_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_SomMot = c([32:68 231:270],[69:91 271:293]);
    b = DorsAttn_SomMot;
    n = isnan(DorsAttn_SomMot);
    b(n) = 0;
    DorsAttn_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_SomMot = c([32:68 231:270],[92:113 294:318]);
    b = SalVentAttn_SomMot;
    n = isnan(SalVentAttn_SomMot);
    b(n) = 0;
    SalVentAttn_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_SomMot = c([32:68 231:270],[114:126 319:331]);
    b = Limbic_SomMot;
    n = isnan(Limbic_SomMot);
    b(n) = 0;
    Limbic_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_SomMot = c([32:68 231:270],[127:148 332:361]);
    b = Cont_SomMot;
    n = isnan(Cont_SomMot);
    b(n) = 0;
    Cont_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_SomMot = c([32:68 231:270],[149:200 362:400]);
    b = Default_SomMot;
    n = isnan(Default_SomMot);
    b(n) = 0;
    Default_SomMot_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Visual_Visual = c([1:31 201:230],[1:31 201:230]);
    b = Visual_Visual;
    n = isnan(Visual_Visual);
    b(n) = 0;
    Visual_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SomMot_Visual = c([1:31 201:230],[32:68 231:270]);
    b = SomMot_Visual;
    n = isnan(SomMot_Visual);
    b(n) = 0;
    SomMot_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    DorsAttn_Visual = c([1:31 201:230],[69:91 271:293]);
    b = DorsAttn_Visual;
    n = isnan(DorsAttn_Visual);
    b(n) = 0;
    DorsAttn_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    SalVentAttn_Visual = c([1:31 201:230],[92:113 294:318]);
    b = SalVentAttn_Visual;
    n = isnan(SalVentAttn_Visual);
    b(n) = 0;
    SalVentAttn_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Limbic_Visual = c([1:31 201:230],[114:126 319:331]);
    b = Limbic_Visual;
    n = isnan(Limbic_Visual);
    b(n) = 0;
    Limbic_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Cont_Visual = c([1:31 201:230],[127:148 332:361]);
    b = Cont_Visual;
    n = isnan(Cont_Visual);
    b(n) = 0;
    Cont_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    Default_Visual = c([1:31 201:230],[149:200 362:400]);
    b = Default_Visual;
    n = isnan(Default_Visual);
    b(n) = 0;
    Default_Visual_mean = sum(sum(b,2))./sum(sum(~n,2));
    
    clear a b c n;
    
    ICC_mean_7Networks(:,s) = [Visual_Visual_mean;
        Visual_SomMot_mean;
        Visual_DorsAttn_mean;
        Visual_SalVentAttn_mean;
        Visual_Limbic_mean;
        Visual_Cont_mean;
        Visual_Default_mean; 
        SomMot_SomMot_mean;
        SomMot_DorsAttn_mean;
        SomMot_SalVentAttn_mean;
        SomMot_Limbic_mean;
        SomMot_Cont_mean;
        SomMot_Default_mean;
        DorsAttn_DorsAttn_mean;
        DorsAttn_SalVentAttn_mean;
        DorsAttn_Limbic_mean;
        DorsAttn_Cont_mean;
        DorsAttn_Default_mean;
        SalVentAttn_SalVentAttn_mean;
        SalVentAttn_Limbic_mean;
        SalVentAttn_Cont_mean;
        SalVentAttn_Default_mean;
        Limbic_Limbic_mean;
        Limbic_Cont_mean;
        Limbic_Default_mean;
        Cont_Cont_mean;
        Cont_Default_mean;
        Default_Default_mean];
end

save(strcat(['ICC_mean_7Networks.mat']));

csvwrite(['ICC_mean_7Networks.mat.csv'],ICC_mean_7Networks);
