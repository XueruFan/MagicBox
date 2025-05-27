# Combine all the cluster ID of ABIDE and CABIC 
# Xue-Ru Fan, 7 MAY 2025 @BNU
###################################################

rm(list=ls())
packages <- c("ggplot2", "ggseg", "ggridges", "tidyr", "do", "dplyr", "Cairo", "openxlsx")
# sapply(packages, install.packages, character.only = TRUE)
sapply(packages, require, character.only = TRUE)

all <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_240610.csv")
all <- all[, c(2,1)]
colnames(all) <- c("Participant", "ClusterIndex")

all_509 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/ABIDE_ClusterID_AgeRange_509_513.csv")
all_509 <- all_509[, c(1,2)]
colnames(all_509)[2] <- "ClusterIndex_5~8.9"

all_610 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/ABIDE_ClusterID_AgeRange_610_513.csv")
all_610 <- all_610[, c(1,2)]
colnames(all_610)[2] <- "ClusterIndex_6~9.9"

all_711 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/ABIDE_ClusterID_AgeRange_711_513.csv")
all_711 <- all_711[, c(1,2)]
colnames(all_711)[2] <- "ClusterIndex_7~10.9"

all_812 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/ABIDE_ClusterID_AgeRange_812_513.csv")
all_812 <- all_812[, c(1,2)]
colnames(all_812)[2] <- "ClusterIndex_8~11.9"

all_913 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/ABIDE_ClusterID_AgeRange_913_513.csv")
all_913 <- all_913[, c(1,2)]
colnames(all_913)[2] <- "ClusterIndex_9~12.9"

all_NYU <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_NYU_only_240610.csv")
all_NYU <- all_NYU[, c(2,1)]
colnames(all_NYU) <- c("Participant", "ClusterIndex_NYU")

GMM <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/GMM513/Cluster_240610.csv")
GMM <- GMM[, c(2,1)]
colnames(GMM) <- c("Participant", "ClusterIndex_GMM")


all <- merge(all, all_509, by = "Participant", all.x = T)
all <- merge(all, all_610, by = "Participant", all.x = T)
all <- merge(all, all_711, by = "Participant", all.x = T)
all <- merge(all, all_812, by = "Participant", all.x = T)
all <- merge(all, all_913, by = "Participant", all.x = T)
all <- merge(all, all_NYU, by = "Participant", all.x = T)
all <- merge(all, GMM, by = "Participant", all.x = T)

all[, 2:9] <- lapply(all[, 2:9], function(x) {
  x[x == 1] <- "L"
  x[x == 2] <- "H"
  x
})

write.csv(all, "E:/Documents/Work/文章投稿/ASD/辅助材料/ABIDE_ClusterID.csv", row.names = FALSE)
