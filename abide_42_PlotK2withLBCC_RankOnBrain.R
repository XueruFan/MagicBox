# 可视化脑形态测量指标对于聚类的贡献的脑图（34个脑区）
# Xue-Ru Fan 20 Feb 2024 @BNU

rm(list=ls())

# load packages
source("E:/PhDproject/LBCC/lbcc/920.calc-novel-wo-subset-function.r")
source("E:/PhDproject/LBCC/lbcc/R_rainclouds.R")
packages <- c("tidyverse", "mgcv", "stringr", "reshape2", "magrittr", "ggplot2", "dplyr", "readxl",
              "stringr", "ggseg", "patchwork", "effectsize", "pwr", "neuroCombat", "cowplot",
              "readr", "ggridges", "ggsci", "tidyr", "rgl", "ggseg3d")
# sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
abideDir <- 'E:/PhDproject/ABIDE'
dataDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot")
date <- "240219"

dx_group <- c("ASD", "CN")
sex_group <- c("Male", "Female")


########################## Part 1：单独看不同性别ASD和NC各自的排序 #################################

for (dx in dx_group){
  for (sex in sex_group){
    # dx <- "ASD"
    # sex <- "Male"
    eval(parse(text = paste0("rank <- read.csv(file.path(dataDir, '", dx, "_pamK2_", sex,
                             "_dev_Rank_", date, ".csv'))")))
    rank34 <- data.frame(rank$Cluster.1)
    colnames(rank34) <- "label"
    # 删掉里面的全局测量
    rank34 <- rank34 %>% filter(!label %in% c("GMV", "sGMV", "TCV", "WMV", "Ventricles",
                                                  "meanCT2", "totalSA2"))
    rank34$Rank <- seq(34,1)
    rank34$label <- paste0("lh_", rank34$label)
    
    Rank <- as.numeric(rank34$Rank)
    label <- as.character(rank34$label)
    
    # plot
    ggseg(.data = rank34, mapping = aes(fill = Rank), color = "black", atlas = dk,
          position = "stacked", hemisphere = "left") +
      theme_void() +
      theme(legend.title = element_blank(), legend.position = "right",
            legend.key.width = unit(0.7, "cm")) +
      scale_fill_viridis_c(option = "inferno", breaks = c(1, 34), labels = NULL) +
      guides(fill = guide_colourbar(frame.colour = "black", frame.linewidth = 1, ticks = FALSE))
      
    name <- file.path(plotDir, paste0(dx, "_pamK2_", sex, "_dev_Rank_", date, ".png"))
    ggsave(name, width = 7, height = 2, units = "in", dpi = 500)
  }
}



########################## Part 2：看不同性别ASD与NC排序的差异 #################################

for (sex in sex_group){
    # sex <- "Male"
    eval(parse(text = paste0("rank_asd <- read.csv(file.path(dataDir, 'ASD_pamK2_", sex,
                             "_dev_Rank_", date, ".csv'))")))
    eval(parse(text = paste0("rank_nc <- read.csv(file.path(dataDir, 'CN_pamK2_", sex,
                             "_dev_Rank_", date, ".csv'))")))
    rank34_asd <- data.frame(rank_asd$Cluster.1)
    colnames(rank34_asd) <- "label"
    rank34_asd <- rank34_asd %>% filter(!label %in% c("GMV", "sGMV", "TCV", "WMV", "Ventricles",
                                              "meanCT2", "totalSA2"))
    rank34_asd$Rank <- seq(34,1)

    rank34_nc <- data.frame(rank_nc$Cluster.1)
    colnames(rank34_nc) <- "label"
    rank34_nc <- rank34_nc %>% filter(!label %in% c("GMV", "sGMV", "TCV", "WMV", "Ventricles",
                                                      "meanCT2", "totalSA2"))
    rank34_nc$Rank <- seq(34,1)

    
    rank34 <- merge(rank34_asd, rank34_nc, by = "label")
    rank34$diff <- abs(rank34$Rank.x - rank34$Rank.y)
    
    rank_diff_real <- data.frame(rank34$label, (rank34$Rank.x - rank34$Rank.y))
    colnames(rank_diff_real) <- c("label", "diff")
    rank_diff_real <-  arrange(rank_diff_real, desc(abs(diff)))
    eval(parse(text = paste0("write.csv(rank_diff_real, file.path(dataDir, 'Diff_pamK2_", sex,
                             "_dev_", date, ".csv'), row.names = F)")))

    rank34$label <- paste0("lh_", rank34$label)
    rank34 <- rank34[, -2:-3]

    diff <- as.numeric(rank34$diff)
    label <- as.character(rank34$label)

    ggseg(.data = rank34, mapping = aes(fill = diff), color = "black", atlas = dk,
          position = "stacked", hemisphere = "left") +
      theme_void() +
      theme(legend.title = element_blank(), legend.position = "right",
            legend.key.width = unit(0.7, "cm")) +
      scale_fill_gradient(low = "white", high = "#a52a2a",  # 从白色到红色的渐变
                          limits = c(0, 29), breaks = c(0, 29), labels = NULL) +
      guides(fill = guide_colourbar(frame.colour = "black", frame.linewidth = 1, ticks = FALSE))


    name <- file.path(plotDir, paste0("Diff_pamK2_", sex, "_dev_Rank_", date, ".png"))
    ggsave(name, width = 7, height = 2, units = "in", dpi = 500)
}
