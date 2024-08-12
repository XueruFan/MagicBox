rm(list=ls())

# load packages
library(lme4)
library(R.matlab)
library(reshape2)

# define filefolder
dataDir <- 'C:/系统文件/工作管理/文章投稿/ScientificData/数据文件'

# load in model
setwd(dataDir)
qc <- read.csv("ccnpqc.csv")[, c(2,4)]
colnames(qc) <- c("rater1", "rater2")
qc$id <- seq(1, nrow(qc), 1)
qc_long <- melt(qc, id = "id") #变为长数据
####################################################################################################

# 设置数据类型
Rater <- as.factor(qc_long$variable)
Rate <- as.numeric(qc_long$value)
ID <- as.character(qc_long$id)
QC <- data.frame(ID, Rater, Rate)
### 
mymodel <- lmer(Rate ~ (1 | ID), data = QC)
output <- summary(mymodel)

df_var <- data.frame(output$varcor)
a <- df_var[1,4]
b <- df_var[2,4]
t <- a + b
icc <- a/t
