# 查看排名前三的分类指标的分类准确性有多大
# 雪如 2024年3月7日于北师大

rm(list=ls())
packages <- c("ggplot2", "ggseg", "ggridges", "tidyr", "do", "dplyr")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # mac
abideDir <- 'E:/PhDproject/ABIDE' # winds
dataDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot/DensityAfterPAM")
date <- "240225"

# id_group <- c("1", "2")

pam_result <- read.csv(file.path(dataDir, paste0("ASD_pamK2_Male_dev_Cluster_", date, ".csv")))

# 使用条件索引来筛选数据
subset_pam <- subset(pam_result, TCV < 0.5 & totalSA2 < 0.5 & GMV < 0.5)

# 使用dplyr计算比例
proportion <- subset_pam %>%
  summarise(Proportion = mean(clusterID == 1)) %>%
  pull(Proportion)
proportion


pam_result <- read.csv(file.path(dataDir, paste0("abide_1_ASD_pamK2_Male_dev_Cluster_", date, ".csv")))

# 使用条件索引来筛选数据
subset_pam <- subset(pam_result, TCV < 0.5 & totalSA2 < 0.5 & GMV < 0.5)

# 使用dplyr计算比例
proportion <- subset_pam %>%
  summarise(Proportion = mean(clusterID == 2)) %>%
  pull(Proportion)
proportion


pam_result <- read.csv(file.path(dataDir, paste0("abide_2_ASD_pamK2_Male_dev_Cluster_", date, ".csv")))

# 使用条件索引来筛选数据
subset_pam <- subset(pam_result, TCV < 0.5 & totalSA2 < 0.5 & GMV < 0.5)

# 使用dplyr计算比例
proportion <- subset_pam %>%
  summarise(Proportion = mean(clusterID == 1)) %>%
  pull(Proportion)
proportion
