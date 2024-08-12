# 绘制全脑17个网络的zEC和弦图
# Xueru 14-Dec-2021 @BNU

rm(list=ls())
library(circlize)
library(R.matlab)
library(ggplot2)

######
#注意修改以下参数
parcel <- 400; # number of parcels
t <- "pos"; # type of EC

#####
# set up file path
filepath <- "/Volumes/Xueru/Group_level/"
setwd(filepath)
# load mat file
mn <- paste0(parcel, "P_PCA_zEC_mean_17net.mat")
databag <- readMat(mn)
fn <- paste0("zEC.17net.", t)
data <- databag[[fn]];

#name parcels
parcelnames <- c("DefaultMode", "Language", "CognitiveControl", "VentralAttention", 
                  "DorsalAttention", "Auditory", "Somatomotor", "Visual");
dimnames(data) <- list(parcelnames);
colnames(data) <- parcelnames;

# reshape to adjacency list
df = data.frame(from = rep(rownames(data), times = ncol(data)), #起始对象
                to = rep(colnames(data), each = nrow(data)), #终止对象
                value = as.vector(data),#起始对象与终止对象之间的相互作用强度
                stringsAsFactors = FALSE)
# head(df) # check if it is correct
circos.clear()
# plot 注意修改图片题目
circos.par(clock.wise = TRUE, start.degree = 90, gap.after = 2)
chordDiagram(df,
             directional = 1, target.prop.height = 0.02,
             grid.col = c(DefaultMode = "red", Language = "#1200F4", CognitiveControl = "#ffa500",
                          VentralAttention = "#ff00ff", DorsalAttention = "#008000", 
                          Auditory = "#fffacd", Somatomotor = "#1e90ff",Visual = "#9400d3"), 
             transparency = 0.45,
             #title(main = "Negative Effective Connectivity", line = 0.02),
             annotationTrack = c("name", "grid"), annotationTrackHeight = c(0.04, 0.02),
             col = c(DefaultMode = "red", Language = "#1200F4", CognitiveControl = "#ffa500",
                     VentralAttention = "#ff00ff", DorsalAttention = "#008000", 
                     Auditory = "#fffacd", Somatomotor = "#1e90ff",Visual = "#9400d3"), 
             order = parcelnames)
# finish plotting otherelse it will add more layers on the plot
circos.clear()
  
