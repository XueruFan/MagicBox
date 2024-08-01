# this script is used to visualize 2 ABIDE ASD subgroups model compare with LBCC
# 可视化脑形态测量指标对于聚类的贡献
# Xue-Ru Fan 09 Jan 2024 @BNU

rm(list=ls())

# load packages
source("E:/PhDproject/LBCC/lbcc/920.calc-novel-wo-subset-function.r")
source("E:/PhDproject/LBCC/lbcc/R_rainclouds.R")
packages <- c("tidyverse", "mgcv", "stringr", "reshape2", "magrittr", "ggplot2", "dplyr", "readxl",
              "stringr", "ggseg", "patchwork", "effectsize", "pwr", "neuroCombat", "cowplot",
              "readr", "ggridges", "ggsci", "tidyr", "rgl")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
abideDir <- 'E:/PhDproject/ABIDE'
dataDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot")
date <- "240109"

# define variables
id_group <- c("1", "2") # this code is for 2 clusters

# get variables names
Centile <- read.csv(file.path(dataDir, paste0("ASD_pamK2_dev_", date, ".csv")))
MeasureRank <- read.csv(file.path(dataDir, paste0("ASD_pamK2_dev_Rank_", date, ".csv")))
volumeNames <- names(Centile)[c(3:43)]

RankName <- MeasureRank[1:3, 1] # cluster1前三个脑区的名字
Plot_centile <- subset(Centile, select = c("clusterID", RankName))


####################### Part 1: Plop 3 measurements ################################################
# 画出对ASD聚类贡献最大的三个脑区的3D图

# 计算每个点与(0.5, 0.5, 0.5)的欧几里得距离
distances = sqrt((Plot_centile$Ventricles - 0.5)^2 + 
                   (Plot_centile$meanCT2 - 0.5)^2 + 
                   (Plot_centile$pericalcarine - 0.5)^2)

size_factor = 2 # size_factor 是一个可以调整的参数，用于控制点的大小范围
sizes = size_factor * distances # 设置点的大小。距离越远，点的大小越大


################################# 画第一个动画 ##################################
figureName <- "Measure3D.K2.view1.png"
figureNameFile <- file.path(plotDir, figureName)

open3d()
par3d(windowRect = c(0, 0, 1181, 1181))


plot3d(Plot_centile$Ventricles, Plot_centile$meanCT2, Plot_centile$pericalcarine, axes = FALSE,
       xlab = "Ventricles", ylab = "meanCT", zlab = "Pericalcarine",
       col = ifelse(Plot_centile$cluster == 1, "#7570B3", "#D95F02"), size = sizes, type = "s")
axes3d(edges = "bbox", xlab = "", ylab = "", zlab = "", font = 2, cex.axis = 10)

# # 添加 X-Y 平面阴影
# planes3d(0, 0, 1, 0, alpha = 0.2, col = "grey")
# # 添加 X-Z 平面阴影
# planes3d(0, 1, 0, 0, alpha = 0.4, col = "grey")
# # 添加 Y-Z 平面阴影
# planes3d(1, 0, 0, 0, alpha = 0.2, col = "grey")
# 添加光源和材质以增强视觉效果
light3d(theta = 0, phi = 0,
        ambient = "gray20", diffuse = "grey", specular = "white", viewpoint.rel = T)


# 保存一个动画
setwd(file.path(plotDir, "Measure3D"))

movie3d(spin3d(axis = c(0, 0, -1), rpm = 5), movie = "my3Danimation1", 
        duration = 3, dir = getwd(), frames = 2, 
        type = "gif", clean = FALSE)
# 
# # 使用 ImageMagick 的 convert 命令将图片转换为动画
# system("convert -delay 20 -loop 0 my3Danimation*.png my3Danimation.gif")



################################# 保存一个截图 ##################################
# 设置视图角度
view3d(theta = 45, phi = 30)
setwd(plotDir)
# 保存为PNG文件
rgl.snapshot(figureNameFile)


####################### Part 2: Plop 2 dimension projections  ######################################
# 画出上面那个三维图的3个2维平面投影

# XY
Plot_centile <- Plot_centile %>%
  mutate(Distance = sqrt((Ventricles - 0.5)^2 + (meanCT2 - 0.5)^2))

# 绘制 Ventricles (X轴) 和 meanCT2 (Y轴) 的投影
ggplot(Plot_centile, aes(x = Ventricles, y = meanCT2, size = Distance, color = factor(clusterID))) + 
  geom_point(alpha = 0.6) + 
  coord_fixed(ratio = 1) +
  theme_minimal() +
  theme(plot.title = element_blank(),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold")) +
  labs(x = "Ventricles", y = "meanCT", color = "Cluster") +
  scale_size_continuous(range = c(1, 5)) +
  scale_color_manual(values = c("#7570B3", "#D95F02")) +
  scale_x_continuous(label = c("", "25%", "50%", "75%", "100%")) +
  scale_y_continuous(label = c("0", "25%", "50%", "75%", "100%"))

figureName <-"Measure3D.K2.XYplane.png"
figureNameFile <- file.path(plotDir, figureName)
ggsave(figureNameFile, dpi = 300, width = 12, height = 10, unit = "cm")


# XZ
Plot_centile <- Plot_centile %>%
  mutate(Distance = sqrt((Ventricles - 0.5)^2 + (pericalcarine - 0.5)^2))
ggplot(Plot_centile, aes(x = Ventricles, y = pericalcarine, size = Distance,
                         color = factor(clusterID))) + 
  geom_point(alpha = 0.6) + 
  coord_fixed(ratio = 1) +
  theme_minimal() +
  theme(plot.title = element_blank(),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold")) +
  labs(x = "Ventricles", y = "Pericalcarine", color = "Cluster") +
  scale_size_continuous(range = c(1, 5)) +
  scale_color_manual(values = c("#7570B3", "#D95F02")) +
  scale_x_continuous(label = c("", "25%", "50%", "75%", "100%")) +
  scale_y_continuous(label = c("0", "25%", "50%", "75%", "100%"))

figureName <-"Measure3D.K2.XZplane.png"
figureNameFile <- file.path(plotDir, figureName)
ggsave(figureNameFile, dpi = 300, width = 12, height = 10, unit = "cm")


# YZ
Plot_centile <- Plot_centile %>%
  mutate(Distance = sqrt((meanCT2 - 0.5)^2 + (pericalcarine - 0.5)^2))
ggplot(Plot_centile, aes(x = meanCT2, y = pericalcarine, size = Distance,
                         color = factor(clusterID))) + 
  geom_point(alpha = 0.6) + 
  coord_fixed(ratio = 1) +
  theme_minimal() +
  theme(plot.title = element_blank(),
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        axis.text.x = element_text(face = "bold"),
        axis.text.y = element_text(face = "bold")) +
  labs(x = "meanCT", y = "Pericalcarine", color = "Cluster") +
  scale_size_continuous(range = c(1, 5)) +
  scale_color_manual(values = c("#7570B3", "#D95F02")) +
  scale_x_continuous(label = c("", "25%", "50%", "75%", "100%")) +
  scale_y_continuous(label = c("0", "25%", "50%", "75%", "100%"))

figureName <-"Measure3D.K2.YZplane.png"
figureNameFile <- file.path(plotDir, figureName)
ggsave(figureNameFile, dpi = 300, width = 12, height = 10, unit = "cm")
