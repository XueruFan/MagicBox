% Xueru PhD Project Protocol
%% 这俩代码没有维护
PhD_calEC
% 皮层分区
% 计算rDCM
%%
PhD_cleEC
% 分离正负子图，做z变换后整合所有被试
% 分pos和neg计算zEC网络的Mean和Std，并可视化，做统计分析

%% Step3A xueru_Arran_EC
% Option1: 正负值在一起卡阈值
% 在个体水平上卡OMST阈值并整合单次测量所有被试
% (topological_filtering_networks工具包)
% 生成个体文件'100206_400P_R1_LR_zEC.mat'，包含变量'z_EC'
% 生成个体文件'100206_400P_R1_LR_zthrEC.mat'，包含变量'thrEC', 'z_thrEC'
% 生成组文件'400P_R1_LR_zEC.mat'，包含变量'zEC_pos', 'zEC_neg', 'EC_all_z'
% 生成组文件'400P_R1_LR_zthrEC.mat'，包含变量'zthrEC_pos', 'zthrEC_neg', 'EC_all_zthr'

% 整合所有测量被试用于画全脑EC的组平均水平，并且用于到R中计算ICC
% 生成组文件'400P_zthrEC_all.mat'，包含变量'zthrEC_pos_all', 'zthrEC_neg_all'
% 生成组文件'400P_zEC_all.mat'，包含变量'zEC_pos_all', 'zEC_neg_all'

% PS:不卡阈值整合时，先把EC的对角线置为0；
%    卡绝对值的OMST阈值，不考虑对角线的连接系数(代码中会先把对角线置为0)，之后再赋回系数的正负性，即连接方向；
%    卡完阈值后，带着方向在个体水平上做了z变换；
%    在组水平上，提取出所有被试连接矩阵的+-值子图;
%    合并的顺序是R1LR-R1RL-R2LR-R2RL;
%    把pos和neg分开计算，会有很多0，会不会影响GLM模型拟合？？？

% ——————————————————————————————————————

% Option2：正负值分开卡阈值
% 生成个体文件'100206_400P_R1_LR_zthrEC_sepa.mat.mat'，
% 包含变量'thrEC_pos', 'z_thrEC_pos', 'thrEC_neg', 'z_thrEC_neg'
% 生成组文件'400P_R1_LR_zthrEC_sepa.mat'
% 包含变量'EC_all_zthr_pos_sepa', 'EC_all_zthr_neg_sepa'
% 生成组文件'400P_zthrEC_all_sepa_w.mat'，包含变量'zthrEC_pos_all', 'zthrEC_neg_all'
% 生成组文件'400P_zthrEC_all_sepa_uw.mat'，包含变量'zthrEC_pos_all', 'zthrEC_neg_all'

%% Step4A xueru_Vis_EC
% 计算全脑zthrEC的均值
% 生成组文件'400P_zthrEC_mean.mat'
% 包含变量'mean_zthrEC_pos', 'mean_zthrEC_neg'

% 提取出感兴趣的ROI
% 生成ROI数据文件'400P_zthrEC_mean_au_pos.mat'
% 包含变量'au_out_pos', 'au_in_pos'

% (如果想要用Prism画种子点zthrEC值的散点图，可以生成以下文件
% 生成ROI数据文件'400P_zthrEC_mean_8roi.mat'')

% 生成组文件'400P_zthrEC_mean_17net.mat'
% 包含变量'zthrEc_17net_pos', 'zthrEc_17net_neg'

% PS: 第一个文件用R来画全脑zthrEC值的热图(pos和neg分开画)；
%     第二个文件可以用Workbench画种子点的zthrEC值分布图；
%     (第三个文件用Prism来画8个种子点zthrEC值的提琴图，按照每个种子点out-in的顺序合并;)
%     第四个文件按照17网络整合zthrEC值在网络内的均值，用于R画和弦图

%% Step4B xueru_Vis_EC_spea     ################### 这里 ############################
% 计算全脑zthrEC的均值和标准差，这里分开计算边加权和不加劝两种结果
% 生成组文件'400P_zthrEC_spea_w_mean.mat'
% 包含变量'mean_zthrEC_pos', 'mean_zthrEC_neg', 'std_zthrEC_pos', 'std_zthrEC_neg'
% 
%% Step4SM
%SM1 
xueru_Heatmap_EC.R 
% 画全脑EC的热图（均值和标准差都画），注意这里用不加劝的数据spea_uw画图
% 生成png文件'400P_PCA_zEC_mean_pos.png'
% 内容变量'zEC'

%SM2
xueru_Chordplot_EC.R % 画全脑zEC在17个网络内的均值和弦图
% 生成png文件'400P_PCA_zEC_mean_17net_pos.png'
% 内容变量'zEC_17net_pos'

%% Step5
% 用R构建GLM模型计算zEC的ICC

xueru_Cal_ICC4EC.R

% 生成组文件'400P_PCA_zEC_ICC.mat'
% 内容变量'icc','vr'

% PS:由于卡阈值影响GLM模型拟合效果，这里用没卡阈值的zEC值计算ICC；
%    模型中加入了(1 | NewID / Test) 做为随机变量, PhaseDir作为固定效应

%% Step5SM
% 可视化zEC的ICC

xueru_Vis_ICC4EC % 绘制八个种子点的脑图

% 生成nii文件'400P_PCA_zEC_ICC_do_out.dscalar.nii'
% 内容变量'种子点的icc'

% PS:这里reshape了上一步的'icc'和'vr'成分区*分区
%     用Prism画icc的频数分布图

% PS:选择8个左老师之前画图用的种子点显示；
%    每一个种子点分别绘制出连入和连出的icc分布，生成两个文件

% 201:  17networks_RH_DefaultA_IPL_1          Default Mode
% 239:  17networks_RH_Language_PFCl_1         Language
% 266:  17networks_RH_ContB_PCC_1             Cognitive Control
% 286:  17networks_RH_SalVenAttnA_FrMed_2     Ventral Attention
% 118:  17networks_LH_DorsAttnA_SPL_1         Dorsal Attention
% 144:  17networks_LH_Aud_ST_6                Auditory
% 165:  17networks_LH_SomMotB_3               Somatomotor
% 176:  17networks_LH_VisualA_ExStr_5         Visual

% 生成组文件'400P_PCA_zEC_ICC_17net.mat'
% 内容变量'aud_in'等

% PS:用Prism绘制全脑17个网络ICC均值的线箱图

xueru_Heatmap_ICC.R % 画全脑ICC的热图

% 生成png文件'400P_PCA_zEC_ICC.png'
% 内容变量'icc'

%% Step6 xueru_Cal_dEC
% 计算dEC度的组水平

% 生成个体文件'400P_R1_LR_PCA_dEC.mat'
% 包含变量'dEC_pos_out', 'dEC_pos_in', 'dEC_neg_out', 'dEC_neg_in'

% 生成个体文件'400P_R1_LR_PCA_zdEC.mat'
% 包含变量'zdEC_pos_out', 'zdEC_pos_in', 'zdEC_neg_out', 'zdEC_neg_in'

% 生成组文件'400P_T1_R1_LR_PCA_dEC.mat'
% 包含变量'dEC_all_subs_pos_out', 'dEC_all_subs_pos_in', 'dEC_all_subs_neg_out', ...
%        'dEC_all_subs_neg_in'

% 生成组文件'400P_T1_R1_LR_PCA_zdEC.mat'
% 包含变量'zdEC_all_subs_pos_out', 'zdEC_all_subs_pos_in', 'zdEC_all_subs_neg_out', ...
%        'zdEC_all_subs_neg_in'

% PS: 用卡完阈值后的thrEC值计算dEC，连入和连出分开计算
%     计算zdEC用减均值除以标准差的计算公式

%% Step7 可视化全脑dEC值

xueru_Vis_dEC

% 生成组文件'400P_PCA_dEC_mean.mat'
% 包含变量'mean_dEC_out_pos', 'mean_dEC_out_neg', 'mean_dEC_in_pos', 'mean_dEC_in_neg'

% 生成nii文件'400P_PCA_dEC_in_neg.dscalar.nii'
% 内容变量'全脑dEC' 

% 按照网络整理dEC值用于画图

xueru_Arran_dEC4Net

% 生成组文件'400P_PCA_dEC_17net.mat'
% 包含变量'neg_in_sal'等

% PS:把mean_dEC按照17个网络（实际8个）进行分组

%% Step8 整合所有dEC值便于导入到R计算ICC

xueru_Aggan_dEC4ICC

% 生成组文件'400P_PCA_dEC_all.mat'
% 包含变量'dEC_out_pos', 'dEC_out_neg', 'dEC_in_pos', 'dEC_in_neg'

% 生成组文件'400P_PCA_zdEC_all.mat'
% 包含变量'zdEC_out_pos', 'zdEC_out_neg', 'zdEC_in_pos', 'zdEC_in_neg'

%% Step9 用R构建GLM模型计算dEC的ICC

xueru_Cal_ICC4dEC.R

% 生成组文件'400P_PCA_zdEC_out_pos_ICC.mat'
% 内容变量'icc','vr'

% PS:这里用卡过阈值的dEC值的标准化zdEC值计算ICC；
%    模型中加入了(1 | NewID / Test) 做为随机变量, PhaseDir作为固定效应

%% Step10 可视化全脑zdEC的ICC值

xueru_Vis_ICC4dEC

% 生成组文件'400P_PCA_zdEC_ICC_all.mat'
% 包含变量'ICC'

% 生成nii文件'400P_PCA_zdEC_out_pos_ICC.nii'
% 包含变量'ICC'

% PS:用Prism来画4个zdEC的ICC的线箱图，按照pos_out pos_in neg_out neg_in的顺序合并
%     用Prism画icc的频数分布直方图

%% 用thrEC计算1-8步SEC(CCS工具包旧代码)

xueru_Cal_SEC

% 生成个体文件'400P_R1_LR_PCA_SFC_S1.mat'
% 包含变量 'SEC_pos', 'SEC_neg', 'zSEC_pos', 'zSEC_neg'

% PS:注意这里用的是CCS旧代码，新的不能算有向图？
%     文件名写的SFC不是SEC；
%     pos和neg分开计算

%% 整合所有被试单词测量的zSEC和SEC值

xueru_Arran_SEC

% 生成组文件'400P_T1_R1_LR_PCA_SEF_S1.mat'
% 包含变量'zSEC_pos_all_subs', 'zSEC_neg_all_subs', 'SEC_pos_all_subs', 'SEC_neg_all_subs'

%% 整合所有zSEC和SEC值便于导入到R计算ICC以及计算组水平

xueru_Arran_SEC4ICC

% 生成组文件'400P_PCA_zSEC_S1_all.mat'
% 包含变量'zSECp', 'SECp', 'zSECn', 'SECn'

% PS:合并的顺序是T1R1LR-T1R1RL-T1R2LR-T1R2RL-T2R1LR-T2R1RL-T2R2LR-T2R2RL;

%% 用R构建GLM模型计算zSEC的ICC

xueru_Cal_ICC4SEC.R

% 生成组文件'400P_zSECp_S1_ICC.mat'
% 内容变量'icc','vr'

%% 可视化8个种子点的全脑zSEC值

xueru_Vis_SEC

% 生成组文件'400P_PCA_zSEC_S1_mean.mat'
% 包含变量'mean_zSECn', 'mean_zSECp'

% 生成nii文件'400P_PCA_zSEC_S1p_do.dscalar.nii'
% 包含变量'种子点的zSEC'
 