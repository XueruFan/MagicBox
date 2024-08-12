clear; clc;
filefolder_sfc = strcat(['/Users/fanxueru/Library/Mobile Documents'...
    '/com~apple~CloudDocs/project/MasterProject/HCP_2visits_400ptseries']);

cd (strcat(filefolder_sfc))

    
a = ft_read_cifti(strcat([filefolder_sfc,'/Schaefer2018_400Parcels_'...
    '7Networks_order.dscalar.nii']));

cd (strcat([filefolder_sfc,'/zSFC/1r_10p']))

load(strcat(['S3_3roi.mat']));

pick_parcels = a.dscalar;
sfc = zeros(400,1);

sfc(14,1) = mean_vl(14,1);
sfc(35,1) = mean_vl(35,1);
sfc(49,1) = mean_vl(49,1);
sfc(78,1) = mean_vl(78,1);
sfc(124,1) = mean_vl(124,1);
sfc(216,1) = mean_vl(216,1);
sfc(217,1) = mean_vl(217,1);
sfc(219,1) = mean_vl(219,1);
sfc(220,1) = mean_vl(220,1);
sfc(281,1) = mean_vl(281,1);
sfc(284,1) = mean_vl(284,1);
sfc(321,1) = mean_vl(321,1);
sfc(385,1) = mean_vl(385,1);
sfc(393,1) = mean_vl(393,1);
sfc(399,1) = mean_vl(399,1);


for m = 1:64984;
    for n = 1:400;

        if pick_parcels(m,1) == n;
           pick_parcels(m,1) = sfc(n,1);
        end

    end
end

filefolder = strcat([filefolder_sfc,'/zSFC/1r_10p/nii/']);

a.dscalar = pick_parcels;
ft_write_cifti(strcat([filefolder,'high_icc_parcel.nii']),a,'parameter','dscalar');
