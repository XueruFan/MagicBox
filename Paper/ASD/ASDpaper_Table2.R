rm(list=ls())

packages <- c("mclust", "ggplot2", "cluster", "tseries", "openxlsx")
# sapply(packages,instcombined_df.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)


abide_h_gamm <- read.xlsx("E:/PhDproject/ABIDE/Analysis/Statistic/Spect513/gamm_Centile_240610.xlsx")
cabic_h_gamm <- read.xlsx("E:/PhDproject/CABIC/result/pred/513/gamm_Centile_240928.xlsx")

abide_h_gamm <- subset(abide_h_gamm, VolumeName == "isthmuscingulate" | VolumeName == "transversetemporal" |
                         VolumeName == "inferiortemporal")
cabic_h_gamm <- subset(cabic_h_gamm, VolumeName == "isthmuscingulate" | VolumeName == "transversetemporal" |
                         VolumeName == "inferiortemporal")
abide_h_gamm <- subset(abide_h_gamm, ClusterID == 2)
cabic_h_gamm <- subset(cabic_h_gamm, ClusterID == 2)

abide_h_gamm$source <- "ABIDE"
cabic_h_gamm$source <- "CABIC"

# 
# # 找到 cabic_h_gamm 和 abide_h_gamm 中 name 和 cog 相同的行
# cabic_subset <- cabic_h_gamm %>%
#   semi_join(abide_h_gamm, by = c("VolumeName", "ClusterID")) %>%
#   mutate(source = "CABIC")  # 增加来源标记
# 
# abide_subset <- abide_h_gamm %>%
#   semi_join(cabic_h_gamm, by = c("VolumeName", "ClusterID")) %>%
#   mutate(source = "ABIDE")  # 增加来源标记


# 使用 rbind() 合并两个数据框
combined_df <- rbind(abide_h_gamm, cabic_h_gamm)
combined_df <- combined_df[c(3,6,1,5,2,4),]
combined_df[, 2:12] <- sprintf("%.2f", as.numeric(unlist(combined_df[, 2:12])))
combined_df[7,] <- colnames(combined_df)


#################

combined_df$latex <- paste0(combined_df$VolumeName, " & ", combined_df$source, " & ", combined_df$`R²`, " & ",
                            combined_df$估计值, " & ", combined_df$标准误, " & ",
                            combined_df$t值, " & ", combined_df$p值, " & ", 
                            combined_df$有效自由度, " & ",combined_df$剩余自由度, " & ",
                            combined_df$F值, " & ", combined_df$平滑项p值, " \\\\ ")
write.xlsx(combined_df, "E:/Documents/Work/文章投稿/ASD/制表/Table2.xlsx")


