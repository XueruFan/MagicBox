# 画出由谱聚类的方法分类的ASD男性两个亚性的34+7个脑指标的发育轨线
# Xue-Ru Fan 04 Jan 2024 @BNU

rm(list=ls())

# load packages
source("E:/PhDproject/LBCC/lbcc/920.calc-novel-wo-subset-function.r")
source("E:/PhDproject/LBCC/lbcc/R_rainclouds.R")
packages <- c("tidyverse", "mgcv", "stringr", "reshape2", "magrittr", "ggplot2", "dplyr", "readxl",
              "stringr", "ggseg", "patchwork", "effectsize", "pwr", "neuroCombat", "cowplot",
              "readr", "ggridges", "ggsci", "tidyr")
#sapply(packages,install.packages,character.only=TRUE)
sapply(packages, require, character.only = TRUE)

# define filefolder
# abideDir <- '/Volumes/Xueru/PhDproject/ABIDE' # mac
abideDir <- 'E:/PhDproject/ABIDE' # windows
# phenoDir <- file.path(abideDir, "Preprocessed")
clustDir <- file.path(abideDir, "Analysis/Cluster/Cluster_A/SpectralCluster")
# statiDir <- file.path(clustDir, "GAMLSS")
plotDir <- file.path(abideDir, "Plot/Cluster/Cluster_A/SpectralCluster/GAMLSS")
resDate <- "240315"

# define variables
id_group <- c("1", "2") # this code is for 2 clusters
ageRange <- log((seq(6, 18, 0.1)*365.245)+280) # 只看发育阶段的数据

# get variables names
name <- paste0("abide_A_asd_male_dev_Spectral_Cluster_", resDate, ".csv")
cluster <- read.csv(file.path(clustDir, name))

exampleFIT <- read.csv(file.path(dataDir, paste0("ASD_pamK2_Male_dev_Cluster_", date, ".csv")))
volumeNames <- names(exampleFIT)[c(3:43)]

# load lbcc
lifeSpanDir <- "E:/PhDproject/LBCC/lbcc"
setwd(lifeSpanDir)
source("100.common-variables.r")
source("101.common-functions.r")
source("300.variables.r")
source("301.functions.r")


sex_info <- read.csv(file.path(abideDir, "Preprocessed/abide_centile_dev.csv"))[, c(1,5)]

for (volumeName in volumeNames){
  # volumeName <- "TCV"
  
  FIT <- readRDS(paste0("Model/FIT_",volumeName,".rds"))
  ynames <- paste0(volumeName, c("Transformed.m500.wre", "Transformed.l025.wre",
                                 "Transformed.u975.wre"))
  
  
  ############################### load lbcc curve data
  
  POP.CURVE.LIST <- list(AgeTransformed = seq(log(120), log((365.25*86)), length.out = 2^8),
                         sex = c("Female","Male"))
  POP.CURVE.RAW <- do.call(what = expand.grid, args = POP.CURVE.LIST)
  CURVE <- Apply.Param(NEWData = POP.CURVE.RAW, FITParam = FIT$param)
  CURVE$age <- (exp(CURVE$AgeTransformed) - 280) / 365.25
  curveData <- CURVE %>% dplyr::select(AgeTransformed, age, sex, PRED.l025.pop, PRED.l250.pop,
                                       PRED.m500.pop,PRED.u750.pop, PRED.u975.pop)
  curveDataLong <- melt(curveData, id = c("AgeTransformed", "age", "sex"),
                        measure.vars = c("PRED.l025.pop", "PRED.l250.pop", "PRED.m500.pop",
                                         "PRED.u750.pop", "PRED.u975.pop"))
  curveDataLongMale <- curveDataLong %>% filter(sex == 'Male')
  curveDataLongFemale <- curveDataLong %>% filter(sex == 'Female')
  
  
  ############################### cluster 1
  
  studyFIT1 <- read.csv(file.path(abideDir, "Centile", paste0(volumeName,".csv")))
  studyFIT1 <- merge(exampleFIT, studyFIT1, by = "participant", all.x = T)
  studyFIT1 <- merge(studyFIT1, sex_info, by = "participant", all.x = T)
  studyFIT1 <- subset(studyFIT1, clusterID == "1")

  studyFIT1$y_500 <- studyFIT1[, ynames[1]]
  studyFIT1$y_025 <- studyFIT1[, ynames[2]]
  studyFIT1$y_975 <- studyFIT1[, ynames[3]]
  
  
  # female
  newFit <- expand.grid(AgeTransformed = ageRange, sex = "Female", cluster = "1")
  
  fm_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Female"))
  newFit$y_500 <- predict(fm_500, newdata = newFit, se.fit = F)

  fm_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Female"))
  newFit$y_025 <- predict(fm_025, newdata = newFit, se.fit = F)
  
  fm_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Female"))
  newFit$y_975 <- predict(fm_975, newdata = newFit, se.fit = F)
  
  # male
  
  newFit2 <- expand.grid(AgeTransformed = ageRange, sex = "Male", cluster = "1")
  
  fm2_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Male"))
  newFit2$y_500 <- predict(fm2_500, newdata = newFit2, se.fit = F)
  
  fm2_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Male"))
  newFit2$y_025 <- predict(fm2_025, newdata = newFit2, se.fit = F)
  
  fm2_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT1, sex == "Male"))
  newFit2$y_975 <- predict(fm2_975, newdata = newFit2, se.fit = F)
  

  C1_PlotData <- rbind(newFit, newFit2)
  

  
  ############################### cluster 2
  
  studyFIT2 <- read.csv(file.path(abideDir, "Centile", paste0(volumeName,".csv")))
  studyFIT2 <- merge(exampleFIT, studyFIT2, by = "participant", all.x = T)
  studyFIT2 <- merge(studyFIT2, sex_info, by = "participant", all.x = T)
  studyFIT2 <- subset(studyFIT2, clusterID == "2")
  
  studyFIT2$y_500 <- studyFIT2[, ynames[1]]
  studyFIT2$y_025 <- studyFIT2[, ynames[2]]
  studyFIT2$y_975 <- studyFIT2[, ynames[3]]
  
  
  # female
  newFit <- expand.grid(AgeTransformed = ageRange, sex = "Female", cluster = "2")
  
  fm_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Female"))
  newFit$y_500 <- predict(fm_500, newdata = newFit, se.fit = F)
  
  fm_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Female"))
  newFit$y_025 <- predict(fm_025, newdata = newFit, se.fit = F)
  
  fm_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Female"))
  newFit$y_975 <- predict(fm_975, newdata = newFit, se.fit = F)
  
  # male
  
  newFit2 <- expand.grid(AgeTransformed = ageRange, sex = "Male", cluster = "2")
  
  fm2_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Male"))
  newFit2$y_500 <- predict(fm2_500, newdata = newFit2, se.fit = F)
  
  fm2_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Male"))
  newFit2$y_025 <- predict(fm2_025, newdata = newFit2, se.fit = F)
  
  fm2_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT2, sex == "Male"))
  newFit2$y_975 <- predict(fm2_975, newdata = newFit2, se.fit = F)
  
  
  C2_PlotData <- rbind(newFit, newFit2)
  

  ############################### prepare for plot  

  plotData <- rbind(C1_PlotData, C2_PlotData)
  plotData_Male <- subset(plotData, sex == "Male")
  plotData_Female <- subset(plotData, sex == "Female")
  C1_PlotData_Male <- subset(C1_PlotData, sex == "Male")
  C1_PlotData_Female <- subset(C1_PlotData, sex == "Female")
  C2_PlotData_Male <- subset(C2_PlotData, sex == "Male")
  C2_PlotData_Female <- subset(C2_PlotData, sex == "Female")
  
  ageTicks <- log((c(6,8,10,12,14,16,18)*365.245)+280)
  ageLimits <- log((c(6,18)*365.245)+280)

  
  # ############################### plot both sex
  # 
  # ggplot(plotData, aes(x = AgeTransformed, y = y_500, color = paste0(cluster, sex),
  #                      group = paste0(cluster, sex))) + 
  #   # cluster 1
  #   geom_line(data = C1_PlotData, lwd = 3, alpha = .6, color = "#7570B3", aes(linetype = sex)) +
  #   # geom_line(data = C1_PlotData, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = 1,
  #   #           alpha = .3, color = "#7570B3") +
  #   # geom_line(data = C1_PlotData, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = 1,
  #   #           alpha = .3, color = "#7570B3") +
  #   
  #   
  #   # cluster 2
  #   geom_line(data = C2_PlotData, lwd = 3, alpha = .6, color = "#D95F02", aes(linetype = sex)) +
  #   # geom_line(data = C2_PlotData, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = 0.6,
  #   #           alpha = .3, color = "#D95F02") +
  #   # geom_line(data = C2_PlotData, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = 0.6,
  #   #           alpha = .3, color = "#D95F02") +
  #   
  #   
  #   # 绘制LBCC常模
  #   geom_line(data = subset(curveDataLong, variable == "PRED.m500.pop"), color = "gray",
  #             lwd = 2, alpha = .5, aes(x = AgeTransformed, y = value, group = sex, linetype = sex)) +
  #   
  #   scale_linetype_manual(values = c("Male" = "solid", "Female" = "dashed")) +
  #   # scale_color_manual(values = c("Male" = "#A6CEE3", "Female" = "#FB9A99"))
  #   theme_cowplot() +
  #   scale_x_continuous(limits = ageLimits, breaks = ageTicks,
  #                      label = c("6 yr", "8 yr", "10 yr", "12 yr", "14 yr", "16 yr", "18 yr")) +
  #   xlab("") + ylab("") + 
  #   theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
  #         axis.text = element_text(size = 8)) +
  #   theme(legend.position = "None")
  # 
  # 
  # figureName <- paste0(volumeName,".population.curve.K2.Both.", date,".png")
  # figureNameFile <- file.path(plotDir, figureName)
  # ggsave(figureNameFile, dpi = 300, width = 10, height = 10, unit = "cm")
  # 
  # 
  # 
  # ############################### plot female
  # 
  # lbcc_female <- subset(curveDataLong, variable == "PRED.m500.pop")
  # lbcc_female <- subset(lbcc_female, sex == "Female")
  # 
  # ggplot(plotData_Female, aes(x = AgeTransformed, y = y_500, color = paste0(cluster, sex),
  #                             group = paste0(cluster, sex))) + 
  #   # cluster 1
  #   geom_line(data = C1_PlotData_Female, lwd = 3, alpha = .6, color = "#7570B3", aes(linetype = sex)) +
  #   geom_line(data = C1_PlotData_Female, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = .8,
  #             alpha = .6, color = "#7570B3") +
  #   geom_line(data = C1_PlotData_Female, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = .8,
  #             alpha = .6, color = "#7570B3") +
  #   
  #   
  #   # cluster 2
  #   geom_line(data = C2_PlotData_Female, lwd = 3, alpha = .6, color = "#D95F02", aes(linetype = sex)) +
  #   geom_line(data = C2_PlotData_Female, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = .8,
  #             alpha = .6, color = "#D95F02") +
  #   geom_line(data = C2_PlotData_Female, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = .8,
  #             alpha = .6, color = "#D95F02") +
  #   
  #   
  #   # 绘制LBCC常模
  #   geom_line(data = lbcc_female, color = "gray",
  #             lwd = 2, alpha = .5, aes(x = AgeTransformed, y = value, group = sex, linetype = sex)) +
  #   
  #   scale_linetype_manual(values = c("Male" = "solid", "Female" = "dashed")) +
  #   # scale_color_manual(values = c("Male" = "#A6CEE3", "Female" = "#FB9A99"))
  #   theme_cowplot() +
  #   scale_x_continuous(limits = ageLimits, breaks = ageTicks,
  #                      label = c("6 yr", "8 yr", "10 yr", "12 yr", "14 yr", "16 yr", "18 yr")) +
  #   xlab("") + ylab("") + 
  #   theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
  #         axis.text = element_text(size = 8)) +
  #   theme(legend.position = "None")
  # 
  # 
  # figureName <- paste0(volumeName,".population.curve.K2.Female.", date,".png")
  # figureNameFile <- file.path(plotDir, figureName)
  # ggsave(figureNameFile, dpi = 300, width = 10, height = 10, unit = "cm")
  
  
  ############################### plot male
  
  lbcc_male <- subset(curveDataLong, variable == "PRED.m500.pop")
  lbcc_male <- subset(lbcc_male, sex == "Male")
  
  
  ggplot(plotData_Male, aes(x = AgeTransformed, y = y_500, color = paste0(cluster, sex),
                              group = paste0(cluster, sex))) + 
    # cluster 1
    geom_line(data = C1_PlotData_Male, lwd = 3, alpha = .6, color = "#7570B3", aes(linetype = sex)) +
    geom_line(data = C1_PlotData_Male, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = .8,
              alpha = .6, color = "#7570B3") +
    geom_line(data = C1_PlotData_Male, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = .8,
              alpha = .6, color = "#7570B3") +
    
    
    # cluster 2
    geom_line(data = C2_PlotData_Male, lwd = 3, alpha = .6, color = "#D95F02", aes(linetype = sex)) +
    geom_line(data = C2_PlotData_Male, aes(x = AgeTransformed, y = y_025, linetype = sex), lwd = .8,
              alpha = .6, color = "#D95F02") +
    geom_line(data = C2_PlotData_Male, aes(x = AgeTransformed, y = y_975, linetype = sex), lwd = .8,
              alpha = .6, color = "#D95F02") +
    
    
    # 绘制LBCC常模
    geom_line(data = lbcc_male, color = "gray", lwd = 2, alpha = .5,
              aes(x = AgeTransformed, y = value, group = sex, linetype = sex)) +
    
    
    scale_linetype_manual(values = c("Male" = "solid", "Female" = "dashed")) +
    # scale_color_manual(values = c("Male" = "#A6CEE3", "Female" = "#FB9A99"))
    theme_cowplot() +
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("6 yr", "8 yr", "10 yr", "12 yr", "14 yr", "16 yr", "18 yr")) +
    xlab("") + ylab("") + 
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
          axis.text = element_text(size = 8)) +
    theme(legend.position = "None")
  
  
  figureName <- paste0(volumeName,".population.curve.K2.Male.", date,"_NEW.png")
  figureNameFile <- file.path(plotDir, figureName)
  ggsave(figureNameFile, dpi = 300, width = 10, height = 10, unit = "cm")
  
}