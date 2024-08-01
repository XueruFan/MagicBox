#############################################

# calculate zSFC icc 

rm(list=ls())
library(lme4)
threshold <- "PROP20";
slow <- "Slow4";

filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/",slow,"/",sep = ""));
workdir <- print(paste(filefolder,'csv/',sep = ""));
setwd(workdir)

# Long Term
  step <- c(1:7);
  for (s in step){
    file <- print(paste("s",s,".csv",sep = ""))
    fname <- paste0(workdir, file)
    zsfc <- read.csv(fname,header = FALSE)
    
    mydata <- t(zsfc);    
    colnames(mydata)=mydata[1,];
    mydata <- mydata[-1,-1];
    mydata <- as.data.frame(mydata);
    colnames(mydata)[7:2406] <- c(1:2400);
    
    idnew <- as.character(mydata$idnew);
    age <- as.numeric(as.character(mydata$age));
    gender <- as.factor(mydata$gender);
    TestRetestInterval <- as.numeric(as.character(mydata$TestRetestInterval));
    visit <- as.factor(mydata$visit);
    
    ICC <- matrix(0,nrow=2400,ncol=1);
    Vr <- matrix(0,nrow=2400,ncol=1);
    sigmaP2 <- matrix(0,nrow=2400,ncol=1);
    sigmaPV2 <- matrix(0,nrow=2400,ncol=1);
    sigmaE2 <- matrix(0,nrow=2400,ncol=1);
    sigmaP2_over_Vr <- matrix(0,nrow=2400,ncol=1);
    sigmaPV2_over_Vr <- matrix(0,nrow=2400,ncol=1);
    sigmaE2_over_Vr <- matrix(0,nrow=2400,ncol=1);
    
    for (i in 7:2406){
      i <- as.character(i-6);
      sfc <- mydata[, i];
      newdata <- data.frame(idnew, age, gender, TestRetestInterval, visit, sfc);
      newdata$sfc <- as.numeric(as.character(newdata$sfc));
      vr <- var(newdata$sfc);
      #find outliers
      outliers <- newdata$sfc %in% boxplot.stats(newdata$sfc)$out
      #exclude outliers
      newdata <- newdata[!outliers,]
      options(warn = 2)
      
      T <- try({ mymodel <- lmer(sfc ~ age * gender + TestRetestInterval + (1 | idnew/visit), data=newdata, REML=FALSE) });
      if ("try-error" %in% class(T))
      {
        next
      }
      
      output <- summary(mymodel);
      df_var <- data.frame(output$varcor);
      a <- df_var[1,4];
      b <- df_var[2,4];
      c <- df_var[3,4];
      d <- a + b + c;
      icc <- b/d;
      i <- as.numeric(i);
      ICC[i,1] <- icc;
      Vr[i,1] <- vr;
      sigmaP2[i,1] <- b;
      sigmaPV2[i,1] <- a;
      sigmaE2[i,1] <- c;
      sigmaP2_over_Vr[i,1] <- b/vr;
      sigmaPV2_over_Vr[i,1] <- a/vr;
      sigmaE2_over_Vr[i,1] <- c/vr;
      
    }
    
    zSFCicc <- data.frame(ICC,Vr,sigmaP2,sigmaPV2,sigmaE2,sigmaP2_over_Vr,sigmaPV2_over_Vr,sigmaE2_over_Vr);
    iccfile <- print(paste(filefolder,"icc/zSFC_ICC_LTs",s,".csv",sep = ""));
    write.csv (zSFCicc, file =iccfile)
  }

################################################################################
# Short Term

rm(list=ls())
library(lme4)
threshold <- "PROP20";
slow <- "Slow4";

filefolder <- print(paste("/Users/fanxueru/Library/Mobile Documents/com~apple~CloudDocs/project/hcp/",threshold,"/",slow,"/",sep = ""));
workdir <- print(paste(filefolder,'csv/',sep = ""));
setwd(workdir)

ST <- c(1:2);
step <- c(1:7);
for (v in ST){
  for (s in step){
    file <- print(paste("v",v,"s",s,".csv",sep = ""))
    fname <- paste0(workdir, file)
    zsfc <- read.csv(fname,header = FALSE)
    
    mydata <- t(zsfc);    
    colnames(mydata)=mydata[1,];
    mydata <- mydata[-1,-1];
    mydata <- as.data.frame(mydata);
    colnames(mydata)[7:2406] <- c(1:2400);
    
    idnew <- as.character(mydata$idnew);
    age <- as.numeric(as.character(mydata$age));
    gender <- as.factor(mydata$gender);
    
    ICC <- matrix(0,nrow=2400,ncol=1);
    Vr <- matrix(0,nrow=2400,ncol=1);
    sigmaP2 <- matrix(0,nrow=2400,ncol=1);
    sigmaE2 <- matrix(0,nrow=2400,ncol=1);
    sigmaP2_over_Vr <- matrix(0,nrow=2400,ncol=1);
    sigmaE2_over_Vr <- matrix(0,nrow=2400,ncol=1);
    
    for (i in 7:2406){
      i <- as.character(i-6);
      sfc <- mydata[, i];
      newdata <- data.frame(idnew, age, gender, sfc);
      newdata$sfc <- as.numeric(as.character(newdata$sfc));
      vr <- var(newdata$sfc);
      #find outliers
      outliers <- newdata$sfc %in% boxplot.stats(newdata$sfc)$out
      #exclude outliers
      newdata <- newdata[!outliers,]
      options(warn = 2)
      
      T <- try({ mymodel <- lmer(sfc ~ age * gender + (1 | idnew), data=newdata, REML=FALSE) });
      if ("try-error" %in% class(T))
      {
        next
      }
      
      output <- summary(mymodel);
      df_var <- data.frame(output$varcor);
      a <- df_var[1,4];
      b <- df_var[2,4];
      d <- a + b;
      icc <- a/d;
      i <- as.numeric(i);
      ICC[i,1] <- icc;
      Vr[i,1] <- vr;
      sigmaP2[i,1] <- a;
      sigmaE2[i,1] <- b;
      sigmaP2_over_Vr[i,1] <- a/vr;
      sigmaE2_over_Vr[i,1] <- b/vr;
      
    }
    zSFCicc <- data.frame(ICC,Vr,sigmaP2,sigmaE2,sigmaP2_over_Vr,sigmaE2_over_Vr);
    iccfile <- print(paste(filefolder,'icc/zSFC_ICC_ST',v,"s",s,".csv",sep = ""));
    write.csv (zSFCicc, file =iccfile)
  }
}