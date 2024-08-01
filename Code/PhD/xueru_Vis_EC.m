% Visualize group-level whole-brian zthrEC distrubution 
% Xueru 21-Dec-2021 @BNU
clear, clc
%% set environment for the hard drive
xueru_disk = '/Volumes/Xueru/'; 
addpath(genpath(xueru_disk))
addpath(genpath('/Users/xuerufan/Toolbox'))
%%
value = {'pos'; 'neg'}; % effect of EC
nparcels = 400; % number of parcels
data_path = [xueru_disk, 'HCP_339/Results/Group/EC'];
%% take out zthrEC values for ROIs (and arrange to plot in Prism, if need)
% s = 1; V = 1;
% ROIs which I want to visualize
seed = {'de', 'la', 'co', 've', 'do', 'au', 'so', 'vi'}; nseed = numel(seed); 
% parcel numbers of these ROIs
do = 118; au = 144; so = 165; vi = 176; de = 201; la = 239; co = 266; ve = 286;
cd (data_path)
fn = strcat(num2str(nparcels), 'P_zthrEC_mean.mat'); load(fn)
roi_path = [data_path, '/ROI']; cd (roi_path)
%roi_neg = []; roi_pos = []; % if plot these values with prism then do this
for V = 1:2 % value
    for s = 1:nseed % seed
        eval (strcat(seed{s}, '_out_', value{V}, " = mean_zthrEC_", ...
            value{V}, '(', seed{s}, ", :)';"))
        eval (strcat(seed{s}, '_in_', value{V}, " = mean_zthrEC_", ...
            value{V}, '(:, ', seed{s}, ");"))
        fn = [num2str(nparcels), 'P_zthrEC_mean_', seed{s}, '_', value{V}, '.mat'];
        eval (strcat("save (fn, '",seed{s}, '_out_', value{V}, "', '",seed{s}, '_in_', value{V}, "')"))
        % if plot these values with prism then do next line
%         eval (strcat('roi_', value{V}, " = [roi_", value{V}, " ", seed{s}, '_out_', value{V}, ...
%             " ", seed{s}, '_in_', value{V}, '];'))
    end
end
%     rn = [num2str(nparcels), 'P_zthrEC_mean_8roi.mat'];
%     save (rn, 'roi_pos', 'roi_neg')
%% Arrange zthrEC values into 17 nets (calculate mean) for chordplot with R
cd (data_path)
fn = strcat(num2str(nparcels), 'P_zthrEC_mean.mat'); load(fn)
netname = {'defA'; 'defB'; 'defC'; 'lan'; 'conA'; 'conB'; 'conC'; 'salA'; 'salB'; ...
    'dorA'; 'dorB'; 'aud'; 'somA'; 'somB'; 'visA'; 'visB'; 'visC'};
Ls = [1 15 31 42 52 64 76 85 96 109 125 137 147 160 172 185 197];
Le = [14 30 41 51 63 75 84 95 108 124 136 146 159 171 184 196 200];
Rs = [201 215 226 237 245 258 271 285 298 313 324 336 345 358 369 384 397];
Re = [214 225 236 244 257 270 284 297 312 323 335 344 357 368 383 396 400];
% if arrange into 8 networks
% netname = {'def'; 'lan'; 'con'; 'sal'; 'dor'; 'aud'; 'som'; 'vis'}; 
% Ls = [1, 42, 52, 85, 109, 137, 147, 172];
% Le = [41, 51, 84, 108, 136, 146, 171, 200];
% Rs = [201, 237, 245, 285, 313, 336, 345, 369];
% Re = [236, 344, 284, 312, 335, 344, 368, 400]; 
networks = numel(netname); 
% n = 1; n_str = 2; n_end = 3; v = 1;
for n = 1:networks
    eval (strcat(netname{n}, " = [Ls(", num2str(n), "):Le(", num2str(n), ") Rs(", ...
        num2str(n), "):Re(", num2str(n), ")];"))
end
for v = 1:2
    eval(['zthrEC_17net_', value{v}, '= [];']) 
    for n_str = 1:networks
        for n_end = 1:networks
            eval (strcat(netname{n_str}, '_', netname{n_end}, " = mean(mean_zthrEC_", ...
                value{v}, '(', netname(n_str), ", ", netname(n_end), "), 'all');"))
            eval (strcat('zthrEC_17net_', value{v}, '(n_str, n_end) = ', netname{n_str}, ...
                '_', netname{n_end}, ';'))
        end
    end
end
fn = '400P_zthrEC_mean_17net.mat'; save(fn, 'zthrEC_17net_pos', 'zthrEC_17net_neg')