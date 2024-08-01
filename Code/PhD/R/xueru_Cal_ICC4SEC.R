rm(list=ls())
library(lme4)
library(R.matlab)

# 下列参数注意查看调整
p <- 400
value <- c("p", "n")

###########
filepath <- "/Volumes/Xueru/Group_level/"
setwd("/Volumes/Xueru/SM_files/CSV/") # 设置被试信息存放路径
s <- read.csv("SubInfo.csv",header = TRUE) # 读入被试信息文件

subinfo <- rbind(s, s, s, s, s, s, s, s); rm(s) # 复制8遍
subinfo$Test <- c(rep(1, times = 156), rep(2, times = 156)) # 补充测试轮次
subinfo$PhaseDir <- c(rep(1, times = 39), rep(2, times = 39), 
                      rep(1, times = 39), rep(2, times = 39),
                      rep(1, times = 39), rep(2, times = 39), 
                      rep(1, times = 39), rep(2, times = 39)) # 补充Phase Encoding Dir
subinfo$NewID <- c(1:39, 1:39, 1:39, 1:39)

# 设置数据类型
NewID <- as.character(subinfo$NewID)
Age_in_Yrs <- as.numeric(as.character(subinfo$Age_in_Yrs))
Gender <- as.factor(subinfo$Gender)
TestRetestInterval <- as.numeric(as.character(subinfo$TestRetestInterval))
Test <- as.factor(subinfo$Test)
PhaseDir <- as.factor(subinfo$PhaseDir)
# s = 1; v = 'p', i = 1;
for (s in 1:8){
  for (v in value){
    setwd(filepath) # 设置路径
    fn <- paste(p, "P_PCA_zSEC_S", s, "_all.mat",sep = "")
    file <- paste0("zSEC", v)
    ec <- as.data.frame(t(readMat(fn)[[file]])); rm(file)
    colnames(ec)[1:(p^2)] <- c(1:(p^2)); # 给分区命名
    #建好待存入数据的矩阵
    ICC <- matrix(0,nrow=(p^2),ncol=1)
    Vr <- matrix(0,nrow=(p^2),ncol=1)
  # 设置建模GLM的分区循环
    for (i in 1:(p^2)){
      i <- as.character(i)
      ec_p <- ec[, i]
      newdata <- data.frame(NewID, Age_in_Yrs, Gender, TestRetestInterval, Test, PhaseDir, ec_p)
      newdata$ec_p <- as.numeric(as.character(newdata$ec_p))
      vr <- var(newdata$ec_p)
      #find outliers
      outliers <- newdata$ec_p %in% boxplot.stats(newdata$ec_p)$out
      #exclude outliers
      newdata <- newdata[!outliers,]
      options(warn = 2)
      T <- try({ mymodel <- lmer(ec_p ~ Age_in_Yrs * Gender + TestRetestInterval  + PhaseDir + (1 | NewID / Test), 
                                 data = newdata, REML=FALSE) })
      if ("try-error" %in% class(T))
      {
        next
      }
      W <- try ({output <- summary(mymodel)})
      if ("try-error" %in% class(W))
      {
        next
      }
      df_var <- data.frame(output$varcor)
      a <- df_var[1,4]
      b <- df_var[2,4]
      c <- df_var[3,4]
      t <- a + b + c
      icc <- b/t
      i <- as.numeric(i)
      ICC[i,1] <- icc
      Vr[i,1] <- vr
    }
    iccfile <- paste0(p, "P_PCA_zSEC", v, "_S", s, "_ICC.mat")
    writeMat(iccfile, icc = ICC, vr = Vr)
  }
}