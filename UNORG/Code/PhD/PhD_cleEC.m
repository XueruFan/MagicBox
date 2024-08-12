%% 分离正负子图，做z变换后整合所有被试
xueru_Arran_rawEC.m

% 先把原始EC图分解为pos和neg两个子图，对角置零之后分别做了z变换
% 生成个体文件，路径/Volumes/Xueru/HCP_339/Results/Individual/EC
% 每个被试都有4个文件, 包含变量'EC_pos', 'EC_neg', 'zEC_pos', 'zEC_neg'
% 100206_400P_R1_LR_zEC.mat
% 100206_400P_R1_RL_zEC.mat
% 100206_400P_R2_LR_zEC.mat
% 100206_400P_R2_RL_zEC.mat

% 整合单个run的所有被试
% 生成组文件，路径/Volumes/Xueru/HCP_339/Results/Group/EC
% 有4个文件，包含变量'zEC_all_pos', 'zEC_all_neg'
% 400P_R1_LR_zEC.mat
% 400P_R1_RL_zEC.mat
% 400P_R2_LR_zEC.mat
% 400P_R2_RL_zEC.mat

% 整合4个run的所有被试，并转换为不加劝图
% 生成组文件，路径/Volumes/Xueru/HCP_339/Results/Group/EC
% 有1个文件，包含变量'zEC_pos_4runs_w', 'zEC_neg_4runs_w', 'zEC_pos_4runs_uw'
% 和'zEC_neg_4runs_uw'
% 400P_zEC_all_4runs

%% 分pos和neg计算zEC网络的Mean和Std，并可视化，做统计分析
xueru_Cal_mEC.m

% 分别计算了加权和不加劝的组水平，并且把neg值都变为了绝对值
% 生成组文件，路径/Volumes/Xueru/HCP_339/Results/Group/EC
% 有1个文件，包含变量'mean_zEC_pos_w', 'mean_zEC_neg_w', 'mean_zEC_pos_uw',
% 'mean_zEC_neg_uw', 'std_zEC_pos_w', 'std_zEC_neg_w', 'std_zEC_pos_uw'和
% 'std_zEC_neg_uw'
% 400P_zEC_group.mat

% 统计4次测量里，全是pos和/或全是neg连接的被试占比多大，用R画热图
% 生成组文件，路径/Volumes/Xueru/HCP_339/Results/Group/EC
% 有1个文件，包含变量'pos_neg', 'pos', 'neg'
% 400P_EC_count.mat

% 统计平均单次测量，pos或neg的被试占比多大，用R画热图和频率分布直方图
% 生成组文件，路径/Volumes/Xueru/HCP_339/Results/Group/EC
% 有1个文件，包含变量'count_4runs_mean', 'count_4runs_std'
% 400P_EC_count2.mat