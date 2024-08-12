rm(list=ls())

# LOAD DATA -----

# 需要修改文件夹、子文件夹和文件名

library(R.matlab) # 加载Matlab编辑包

filefolder <- print("/Users/fanxueru/Documents/OneDrive/xueru/PhD/PhDproject/");
subffolder <- print("");
fname <- print("example.mat"); # 注意文件是.mat格式

workdir <- print(paste0(filefolder,subffolder));
setwd(workdir);
raw_data <- readMat(fname, header = FALSE);
raw_data <- raw_data[[names(raw_data)]]; # 注意：这里的数据需要把sample（每个时间序列）作为行，variable（每个体素）作为列

# 从原始数据中提取出ROI内的体素
roi_data <- raw_data[,166:189]; #  这里需要补充提取体素的代码

# 命名行和列
colnames(roi_data) <- c(paste0("voxel",1:(ncol(roi_data))));
rownames(roi_data) <- c(1:(nrow(roi_data))); # 时间点直接用数字命名
                              

# PCA -----

library(ggplot2)

pca_roi <- prcomp(roi_data, scale = TRUE);
summary(pca_roi); #方差解释度
plot(pca_roi$x[,1],pca_roi$x[,2]); # 绘制前两个主成分的分布图
eigenvalues <- (pca_roi$sdev)^2; # 计算特征值
pca_var_per <- round(eigenvalues/sum(eigenvalues)*100,2); #计算每个成分对数据差异的贡献
# 上一行最后的2表示保留2位小数
barplot(pca_var_per, main = "Scree Plot", xlab = "Principal Component", 
        ylab = "Percent Variation"); # 绘制每个成分解释变异的百分比

# 绘制pac计算结果前两个成分的样本得分
pca_data <- data.frame(Sample = rownames(pca_roi$x),
                       X = pca_roi$x[,1],  # 第一特征值对应的时间序列
                       Y = pca_roi$x[,2]);
ggplot(data = pca_data, aes(x = X, y = Y, label = Sample))+
  # geom_text(size = 3)  显示点表示的voxel名 
  geom_point(colour = 'gold', size = 0.3) +
  xlab(paste0("PC1 - ", pca_var_per[1], "%")) +
  ylab(paste0("PC1 - ", pca_var_per[2], "%")) +
  theme_bw() +  # 设定图的背景是白色
  ggtitle("PCA Garph")

