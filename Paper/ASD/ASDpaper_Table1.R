rm(list=ls())

packages <- c("openxlsx", "dplyr")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)


########### Norm Distribution
norm_test_all <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Centile_NormTest_513_240610.csv")
norm_test_1 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_1_Centile_NormTest_240610.csv")
norm_test_2 <- read.csv("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_2_Centile_NormTest_240610.csv")
colnames(norm_test_all) <- c("region", "NormTestAll_P")
colnames(norm_test_1) <- c("region", "NormTest1_P")
colnames(norm_test_2) <- c("region", "NormTest2_P")


########### Centile
centile_all <- read.xlsx("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_Centile_240610.xlsx")
centile_1 <- read.xlsx("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_1_Centile_240610.xlsx")
centile_2 <- read.xlsx("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_2_Centile_240610.xlsx")
colnames(centile_all) <- c("region", "CentileAll_Median")
colnames(centile_1) <- c("region", "Centile1_Median")
colnames(centile_2) <- c("region", "Centile2_Median")
centile_all$region <- gsub("lh_", "", centile_all$region)
centile_1$region <- gsub("lh_", "", centile_1$region)
centile_2$region <- gsub("lh_", "", centile_2$region)


########### Ab
Ab <- read.xlsx("E:/PhDproject/ABIDE/Analysis/Cluster/Spect513/Cluster_AbPerc_240610.xlsx")[, 1:5]
colnames(Ab)[3:5] <- c("region", "L_ab", "H_ab")


########### Median Difference


############################ combine
# 首先合并前两个数据框
all <- merge(norm_test_all, norm_test_1, by = "region")
all <- merge(all, norm_test_2, by = "region")
all <- merge(all, centile_all, by = "region")
all <- merge(all, centile_1, by = "region")
all <- merge(all, centile_2, by = "region")
all <- merge(all, Ab, by = "region")

en_labels <- c("superiorfrontal", "rostralmiddlefrontal", "caudalmiddlefrontal",
               "parsopercularis", "parstriangularis", "parsorbitalis", "frontalpole",
               "lateralorbitofrontal", "medialorbitofrontal",
               "rostralanteriorcingulate", "caudalanteriorcingulate",
               "precentral", "paracentral", "postcentral",
               "supramarginal", "posteriorcingulate", "isthmuscingulate",
               "precuneus", "superiorparietal", "inferiorparietal",
               "transversetemporal", "bankssts",
               "superiortemporal", "middletemporal", "inferiortemporal",
               "fusiform", "parahippocampal", "entorhinal", "temporalpole",
               "lateraloccipital", "lingual", "pericalcarine", "cuneus",
               "insula")

# 将 'region' 列转换为因子，并按照 en_labels 中的顺序定义因子级别
all$region <- factor(all$region, levels = en_labels)

# 根据 region 列的因子顺序对数据框进行排序
all <- all %>% arrange(region)


all <- all[, c(9, 2, 5, 3, 6, 4, 7, 10, 11)]

all[, 2:9] <- lapply(all[, 2:9], function(x) as.numeric(as.character(x)))

# 使用 sprintf 格式化数值，保留两位小数
all[, 2:9] <- sprintf("%.2f", as.numeric(unlist(all[, 2:9])))

#################

all$latex <- paste0(all$FullName, " & ", all$NormTestAll_P, " & ", all$CentileAll_Median, " & ",
                    all$NormTest1_P, " & ", all$Centile1_Median, " & ", all$NormTest2_P, " & ",
                    all$Centile2_Median, " & ", all$L_ab, " & ", all$H_ab, " \\\\ ")
write.csv(all, "E:/Documents/Work/文章投稿/ASD/制表/Table1.csv", row.names = F)
