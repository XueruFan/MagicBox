# 本代码用来制作旅行者们每次MRI扫描的采集详细情况表
# 范雪如 Xue-Ru Fan 2025/5/27 @ Beijing Normal University

############################## 加载必要的包和数据文件 ##############################################
rm(list=ls())
library(ggplot2)
library(dplyr)
library(lubridate)
library(patchwork)
library(do)
library(tidyr)

filefolder <- "E:/PhDproject/3RB2/DataAnalysis"
setwd(filefolder)
MRIdetailInfo <- read.csv("MRIdetailInfo.csv")
detail <- MRIdetailInfo[, c(-2,-5:-8,-10:-13)]

detail <- detail[order(detail$Rank, decreasing = TRUE), ]

detail$Site_Interval <- paste(detail$Site, "(", detail$Interval_days, "):4", sep = "")
detail <- detail[, c(-2,-4)]

detail_wide <- detail %>%
  pivot_wider(
    id_cols = P,                # 以 P 列作为行标识
    names_from = MT,            # 将 MT 的值作为新列名
    values_from = Site_Interval, # 用 Site_Interval 填充单元格）
    names_prefix = "S"        # 为列名添加前缀（可选）
  )

detail_wide <- detail_wide %>%
  mutate(PN = 1:40, .after = "P")  # .after 指定插入位置

############################## 保存处理好的表格 ####################################################
write.csv(detail_wide, file.path(filefolder, "DataAcquiredDetail.csv"), row.names = F)
