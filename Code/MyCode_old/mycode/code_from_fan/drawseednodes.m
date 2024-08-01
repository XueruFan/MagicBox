
clear; clc;

a = ft_read_cifti('/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/Parcellations/HCP/fslr32k/cifti/Schaefer2018_400Parcels_7Networks_order.dscalar.nii');

d = a.dscalar;
for m = 1:64984; 
    if d(m,1) == 59;
        d(m,1) = 1;
    else
        d(m,1) = 0;
    end
end
a.dscalar = d;
filefolder = strcat(['/Users/fanxueru/Library/Mobile Documents/'...
    'com~apple~CloudDocs/project/hcp/MasterProject/'...
    'HCP_2visits_400ptseries']);
cd (strcat(filefolder))
ft_write_cifti(strcat([filefolder,'/SomLeftSeed.nii']),a,'parameter','dscalar');
clear;clc;