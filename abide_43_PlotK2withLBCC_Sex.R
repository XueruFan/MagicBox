# 画出ASD不分亚型、分性别的34+7个脑指标的发育轨线
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
abideDir <- 'E:/PhDproject/ABIDE'
dataDir <- file.path(abideDir, "Analysis/Cluster")
plotDir <- file.path(abideDir, "Plot/Curve")
date <- "240219"

# define variables
id_group <- c("1", "2") # this code is for 2 clusters
ageRange <- log((seq(6, 18, 0.1)*365.245)+280) # 只看发育阶段的数据

# get variables names 用不分性别的两组亚型数据
exampleFIT <- read.csv(file.path(dataDir, paste0("ASD_pamK2_dev_", date, ".csv")))
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
  
  
  
  studyFIT <- read.csv(file.path(abideDir, "Centile", paste0(volumeName,".csv")))
  studyFIT <- merge(exampleFIT, studyFIT, by = "participant", all.x = T)
  studyFIT <- merge(studyFIT, sex_info, by = "participant", all.x = T)
  
  studyFIT$y_500 <- studyFIT[, ynames[1]]
  studyFIT$y_025 <- studyFIT[, ynames[2]]
  studyFIT$y_975 <- studyFIT[, ynames[3]]
  
  # female
  newFit <- expand.grid(AgeTransformed = ageRange, sex = "Female")
  
  fm_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Female"))
  newFit$y_500 <- predict(fm_500, newdata = newFit, se.fit = F)
  
  fm_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Female"))
  newFit$y_025 <- predict(fm_025, newdata = newFit, se.fit = F)
  
  fm_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Female"))
  newFit$y_975 <- predict(fm_975, newdata = newFit, se.fit = F)
  
  # male
  
  newFit2 <- expand.grid(AgeTransformed = ageRange, sex = "Male")
  
  fm2_500 <- gam(y_500 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Male"))
  newFit2$y_500 <- predict(fm2_500, newdata = newFit2, se.fit = F)
  
  fm2_025 <- gam(y_025 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Male"))
  newFit2$y_025 <- predict(fm2_025, newdata = newFit2, se.fit = F)
  
  fm2_975 <- gam(y_975 ~ s(AgeTransformed, k = 5), data = subset(studyFIT, sex == "Male"))
  newFit2$y_975 <- predict(fm2_975, newdata = newFit2, se.fit = F)
  
  plotData <- rbind(newFit,newFit2)
  ageTicks <- log((c(6,8,10,12,14,16,18)*365.245)+280)
  ageLimits <- log((c(6,18)*365.245)+280)
  colorTable <- c("#E64B35","#4DBBD5")
  
  ggplot(data = plotData, aes(x = AgeTransformed, y = y_500, color = sex, group = sex)) +
    geom_line(lwd = 3) +
    geom_line(data = plotData, aes(x = AgeTransformed, y = y_025, color = sex, group = sex), lwd = .2,
              alpha = .6) +
    geom_line(data = plotData, aes(x = AgeTransformed, y = y_975, color = sex, group = sex), lwd = .2,
              alpha = .6) +

    # 绘制LBCC常模
    geom_line(data = subset(curveDataLong, variable == "PRED.m500.pop"),
              aes(x = AgeTransformed, y = value, group = sex, color = sex), lwd = 2, alpha =.2) +

    theme_cowplot() +
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("6 yr", "8 yr", "10 yr", "12 yr", "14 yr", "16 yr", "18 yr")) +
    xlab("") + ylab("") +
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
          axis.text = element_text(size = 8)) +
    scale_color_manual(values = colorTable) + # 定义了性别对应颜色的手动映射
    theme(legend.position = "None")

  figureName <- paste0(volumeName, ".population.curve.", date,".png")
  figureNameFile <- file.path(plotDir, figureName)
  ggsave(figureNameFile, dpi = 300, width = 10, height = 10, unit = "cm")
  
  # 不画97.5和2.5
  ggplot(data = plotData, aes(x = AgeTransformed, y = y_500, color = sex, group = sex)) + 
    geom_line(lwd = 3) +
    
    # 绘制LBCC常模
    geom_line(data = subset(curveDataLong, variable == "PRED.m500.pop"),
              aes(x = AgeTransformed, y = value, group = sex, color = sex), lwd = 2, alpha =.2) +
    
    theme_cowplot() +
    scale_x_continuous(limits = ageLimits, breaks = ageTicks,
                       label = c("6 yr", "8 yr", "10 yr", "12 yr", "14 yr", "16 yr", "18 yr")) +
    xlab("") + ylab("") + 
    theme(axis.ticks.x = element_blank(), axis.ticks.y = element_blank(),
          axis.text = element_text(size = 8)) +
    scale_color_manual(values = colorTable) + # 定义了性别对应颜色的手动映射
    theme(legend.position = "None")
  
  figureName <- paste0(volumeName, ".population.curve.clean.", date,".png")
  figureNameFile <- file.path(plotDir, figureName)
  ggsave(figureNameFile, dpi = 300, width = 10, height = 10, unit = "cm")
  
}
  
  
  
  